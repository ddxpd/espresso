class esp_host extends uvm_component;
  `uvm_component_utils(esp_host)

  host_memory           host_mem;
  host_memory_manager   mem_mgr;
  nvme_dut              DUT;
  nvme_cmd              cmd_waiting_q[$];
  host_vif              hvif;
  nvme_cmd              host_cmd_map[int];     //KEY is unique ID

  esp_printer           printer;

  //For temporary
  int                   msix_id_2_func[int];   


  esp_host_mgr           mgrs[U32];     // KEY is function id

  extern function        new(string name="esp_host", uvm_component parent); 
  extern task            main_phase(uvm_phase phase);

  extern task            post_cmd(nvme_cmd cmd, esp_host_mgr mgr = null);
  extern function void   pick_rand_mgr(nvme_cmd cmd);
 
  extern function void   malloc_memory_space(nvme_cmd cmd);
  extern function void   fill_data_to_host_mem(nvme_cmd cmd);
  extern function void   fill_cmd_to_SQ(nvme_cmd cmd);
  extern task            ring_doorbell(nvme_cmd cmd, esp_host_mgr mgr);
  extern task            forever_monitor_interrupt();
  extern function int    get_cq_tail(esp_host_cq cq);
  extern task            get_one_cqe(esp_host_cq cq, nvme_cpl_entry nvme_cpl);
  
     
  extern function int    find_related_cmd(int fid, int sqid, int cid); 
  extern function int    rand_pick_cq(nvme_cmd cmd);

  //Process before submission(pbs)
  extern task            pbs_admin_indentify(nvme_cmd cmd);
  extern task            pbs_io_write(nvme_cmd cmd);
  extern task            pbs_admin_delete_sq(nvme_cmd cmd);
  extern task            pbs_admin_create_sq(nvme_cmd cmd);
  extern task            pbs_admin_delete_cq(nvme_cmd cmd);
  extern task            pbs_admin_create_cq(nvme_cmd cmd);

  extern task            process_cmd_when_completion(int uid, bit[14:0] status);
  //Process when compeletion(pwc)
  extern task            pwc_admin_indentify(int uid);
  extern task            pwc_io_write(int uid);
  extern task            pwc_admin_delete_sq(int uid);
  extern task            pwc_admin_create_sq(int uid);
  extern task            pwc_admin_delete_cq(int uid);
  extern task            pwc_admin_create_cq(int uid);

  extern task            pwc_identify_cns_0(int uid);

  extern function void   set_host_ranges(int fid, bit [63:0] baddr[], bit [63:0] size[], ref esp_host_mgr mgr);
  extern task            write_nvme_cap(int fid, int start_dw, U32 data[]);
  extern task            read_nvme_cap(int fid, int start_dw, int num_dw, ref U32 data[]);
endclass



function esp_host::new(string name="esp_host", uvm_component parent);
  nvme_namespace    ns;
  esp_host_mgr  mgr;
  esp_host_sq       sq;
  esp_host_cq       cq;
  nvme_msix_vector  msix;

  super.new(name, parent);

  mgr = esp_host_mgr::type_id::create("mgr");  //TODO name should be execlsively
  mgr.fid = 8; //random pick
  
  ns = nvme_namespace::type_id::create("ns");
  ns.lba_ds  = 4096;
  ns.meta_ds = 16;
  ns.meta_in_extended = 1;
  ns.nsid = 1;
  mgr.active_ns[ns.nsid] = ns;
  mgrs[mgr.fid] = mgr;

  //Temporary Admin CQ creating
  cq = esp_host_cq::type_id::create("cq");
  cq.set_qid(0);  
  cq.set_continuous(1);  
  cq.set_base_addr('h1000);
  cq.set_num_entry(5);
  cq.reset_ptr();
  mgrs[mgr.fid].register_cq(cq);

  //Temporary Admin SQ creating
  sq = esp_host_sq::type_id::create("sq");
  sq.set_qid(0);
  sq.set_continuous(1);
  sq.set_base_addr('h2000);
  sq.set_num_entry(5);
  sq.reset_ptr();
  sq.add_cq(cq);
  mgrs[mgr.fid].register_sq(sq);

  //Temporary MSIX Vector
  msix = nvme_msix_vector::type_id::create("msix");
  msix.vid = 0;
  msix.addr = 'h00000001;
  msix.data = 'h10000001;
  mgrs[mgr.fid].msix_vector[0] = msix;
  msix_id_2_func[0] = mgr.fid;

  msix = nvme_msix_vector::type_id::create("msix");
  msix.vid = 1;
  msix.addr = 'h00000002;
  msix.data = 'h20000002;
  mgrs[mgr.fid].msix_vector[1] = msix;
  msix_id_2_func[1] = mgr.fid;
  
  printer = esp_printer::type_id::create("printer", this);
endfunction



task esp_host::post_cmd(nvme_cmd cmd, esp_host_mgr mgr = null);

  `uvm_info(get_name(), $sformatf("Host is processing cmd %s", cmd.esp_opc.name()), UVM_LOW) 
  if(mgr == null)begin
    pick_rand_mgr(cmd);
  end
  else begin
    cmd.mgr = mgr;
  end
  `uvm_info("", $sformatf("Assign cmd to fid = %0h", cmd.mgr.fid), UVM_LOW) 

  //SQE_DW is not packed yet
  cmd.stage_0_process_user_ctrl();
  cmd.stage_1_basic_process();
  cmd.stage_2_fill_sqe();
  cmd.stage_3_detail_process();
  //check which Q the cmd belongs to
  
  case(cmd.esp_opc)
    ESP_IDENTIFY:   pbs_admin_indentify(cmd);
    ESP_WRITE:      pbs_io_write(cmd);
    ESP_DELETE_SQ:  pbs_admin_delete_sq(cmd);
    ESP_CREATE_SQ:  pbs_admin_create_sq(cmd);
    ESP_DELETE_CQ:  pbs_admin_delete_cq(cmd);
    ESP_CREATE_CQ:  pbs_admin_create_cq(cmd);
  endcase

  cmd.stage_4_pack_SQE_DW();
  `uvm_info(get_name(), $sformatf("cmd sqid = %0d", cmd.sqid), UVM_LOW) 
  fill_cmd_to_SQ(cmd);
  ring_doorbell(cmd, cmd.mgr);
  host_cmd_map[cmd.uid] = cmd;

endtask




function void esp_host::pick_rand_mgr(nvme_cmd cmd);
  esp_host_mgr   mgr_q[$];
  if(mgrs.size() == 0)
    `uvm_error(get_name(), $sformatf("There is no function manager could be chosen."))
 
  foreach(mgrs[i])
    mgr_q.push_back(mgrs[i]);
  mgr_q.shuffle();
  cmd.mgr = mgr_q[0];
endfunction



task esp_host::pbs_admin_create_sq(nvme_cmd cmd);
  esp_host_sq  sq; //Register for VIP
  bit    pc    = cmd.sdw11_adm.create_iosq.PC;//Physically Contiguous
  int    qsize = cmd.sdw10_adm.create_iosq.QSIZE; 
  int    remain_size;
  int    page_sz = 4096;
  int    fid, sqid, cqid;
  bit    suc;
  U64    addr;
  int    num_page_need;  
  
  fid = cmd.get_fid();
  //check if sqid is already assigned
  //TODO
  //sqid
  sqid = cmd.sdw10_adm.create_iosq.QID;

  if(cmd.sdw11_adm.create_iosq.CQID == 0)begin
    cqid = rand_pick_cq(cmd);
    cmd.sdw11_adm.create_iosq.CQID = cqid;
  end
  
  sq = esp_host_sq::type_id::create("sq");
  mgrs[fid].SQ[sqid] = sq;
  sq.state = QUEUE_CREATING;
  sq.set_continuous(pc);
  sq.set_qid(sqid);
  sq.set_num_entry(qsize+1);
  sq.add_cq(mgrs[fid].CQ[cqid]);
  mgrs[fid].CQ[cqid].add_sq(sq);
  
  if(pc)begin
    mem_mgr.malloc(qsize, addr, suc);
    if(suc)begin
      sq.set_base_addr(addr);
      cmd.sprp1 = addr; 
    end
    else begin
      `uvm_error(get_name(), $sformatf("Could not find enough space for SQ. Timeout is 10000 ns.")) 
    end
  end
  else begin
    remain_size = qsize + 1;
    if(remain_size <= page_sz)begin
      mem_mgr.malloc(remain_size, addr, suc);
      if(suc)begin
        sq.set_base_addr(addr);
        cmd.sprp1 = addr;
      end
    end
    else begin
      sq.is_prplist = 1;
      do begin
        prplist  prplist_h;
        prplist_h = new();
        //Last prp list
        if(remain_size <= page_sz/8*page_sz)begin
          mem_mgr.malloc(page_sz, addr, suc);
          if(suc)
	    prplist_h.base_addr = addr;
	  else
	    `uvm_error(get_name(), $sformatf("Prplist base addr malloc failed!")) 
          
	  num_page_need = remain_size/page_sz + (remain_size%page_sz > 0 ? 1 : 0);
	  for(int i = 0; i < num_page_need; i++)begin
            mem_mgr.malloc(page_sz, addr, suc);
            if(suc)
	      prplist_h.prps.push_back(addr);
	    else
	      `uvm_error(get_name(), $sformatf("Prplist malloc failed!")) 
	  end
	  sq.prp_list.push_back(prplist_h);
	  remain_size = 0;
	end
	//Not last prp list
	else begin
          mem_mgr.malloc(page_sz, addr, suc);
	  if(suc)
	    prplist_h.base_addr = addr;
	  else
	    `uvm_error(get_name(), $sformatf("Prplist base addr malloc failed!")) 
          
	  num_page_need = page_sz/8 - 1;
	  for(int i = 0; i < num_page_need; i++)begin
            mem_mgr.malloc(page_sz, addr, suc);
            if(suc)
	      prplist_h.prps.push_back(addr);
	    else
	      `uvm_error(get_name(), $sformatf("Prplist malloc failed!")) 
	  end
	  sq.prp_list.push_back(prplist_h);
	  remain_size = page_sz * (page_sz/8-1);
	end
      end while(remain_size > 0);
      
      addr = sq.prp_list[0].base_addr;
      sq.set_base_addr(addr);
      cmd.sprp1 = addr;

      foreach(sq.prp_list[z])begin
        U8    prps_U8[$];
        addr = sq.prp_list[z].base_addr;
	turn_bit64_queue_2_bit8_queue(sq.prp_list[z].prps, prps_U8);
        host_mem.fill_byte_data_queue_direct(addr, prps_U8.size(), prps_U8);	
	if(sq.prp_list[z+1] != null)begin
	  for(int i = 0; i < 8; i++)begin
            host_mem.fill_byte_data_direct(addr + page_sz - (8-i), sq.prp_list[z+1].base_addr[i*8+:8]);
	  end
	end
      end

    end
    
  end
endtask



task esp_host::pbs_admin_create_cq(nvme_cmd cmd);
  esp_host_cq  cq; //Register for VIP
  bit    pc    = cmd.sdw11_adm.create_iocq.PC;//Physically Contiguous
  int    qsize = cmd.sdw10_adm.create_iocq.QSIZE;
  int    remain_size;
  int    page_sz = 4096;
  int    fid, sqid, cqid;
  bit    suc;
  U64    addr;
  int    num_page_need;  
  
  fid = cmd.get_fid();
  //check if cqid is already assigned
  //TODO
  //cqid
  cqid = cmd.sdw10_adm.create_iocq.QID;

  cq = esp_host_cq::type_id::create("cq");
  mgrs[fid].CQ[cqid] = cq;
  cq.state = QUEUE_CREATING;
  cq.set_base_addr(addr);
  cq.set_continuous(pc);
  cq.set_qid(cqid);
  cq.set_num_entry(qsize+1);
  
  if(pc)begin
    mem_mgr.malloc(qsize, addr, suc);
    if(suc)begin
      cq.set_base_addr(addr);
      cmd.sprp1 = addr; 
    end
    else begin
      `uvm_error(get_name(), $sformatf("Could not find enough space for CQ. Timeout is 10000 ns.")) 
    end
  end
  else begin
    remain_size = qsize + 1;
    if(remain_size <= page_sz)begin
      mem_mgr.malloc(remain_size, addr, suc);
      if(suc)begin
        cq.set_base_addr(addr);
        cmd.sprp1 = addr;
      end
    end
    else begin
      cq.is_prplist = 1;
      do begin
        prplist  prplist_h;
        prplist_h = new();
	//Last prp list
        if(remain_size <= page_sz/8*page_sz)begin
	  mem_mgr.malloc(page_sz, addr, suc);
	  if(suc)
	    prplist_h.base_addr = addr;
	  else
	    `uvm_error(get_name(), $sformatf("Prplist base addr malloc failed!")) 
          
	  num_page_need = remain_size/page_sz + (remain_size%page_sz > 0 ? 1 : 0);
	  for(int i = 0; i < num_page_need; i++)begin
            mem_mgr.malloc(page_sz, addr, suc);
            if(suc)
	      prplist_h.prps.push_back(addr);
	    else
	      `uvm_error(get_name(), $sformatf("Prplist malloc failed!")) 
	  end
	  cq.prp_list.push_back(prplist_h);
	  remain_size = 0;
	end
	//Not last prp list
	else begin
          mem_mgr.malloc(page_sz, addr, suc);
	  if(suc)
	    prplist_h.base_addr = addr;
	  else
	    `uvm_error(get_name(), $sformatf("Prplist base addr malloc failed!")) 
          
	  num_page_need = page_sz/8 - 1;
	  for(int i = 0; i < num_page_need; i++)begin
            mem_mgr.malloc(page_sz, addr, suc);
            if(suc)
	      prplist_h.prps.push_back(addr);
	    else
	      `uvm_error(get_name(), $sformatf("Prplist malloc failed!")) 
	  end
	  cq.prp_list.push_back(prplist_h);
	  remain_size = page_sz * (page_sz/8-1);
	end
      end while(remain_size > 0);
      
      addr = cq.prp_list[0].base_addr;
      cq.set_base_addr(addr);
      cmd.sprp1 = addr;


      foreach(cq.prp_list[z])begin
        U8    prps_U8[$];
        addr = cq.prp_list[z].base_addr;
	turn_bit64_queue_2_bit8_queue(cq.prp_list[z].prps, prps_U8);
        host_mem.fill_byte_data_queue_direct(addr, prps_U8.size(), prps_U8);	
	if(cq.prp_list[z+1] != null)begin
	  for(int i = 0; i < 8; i++)begin
            host_mem.fill_byte_data_direct(addr + page_sz - (8-i), cq.prp_list[z+1].base_addr[i*8+:8]);
	  end
	end
      end

    end
    
  end

endtask 



function int esp_host::rand_pick_cq(nvme_cmd cmd);
  int  found_q[$];
  int  cqid;
  int  fid;

  fid = cmd.get_fid();

  found_q = mgrs[fid].CQ.find_index(x) with (x.qid != 0);
  if(found_q.size() > 0)begin
    found_q.shuffle();
    cqid = found_q[0];
  end
  else begin
    `uvm_error(get_name(), $sformatf("There is no available CQ for SQ to attach with.")) 
  end
endfunction



task esp_host::pbs_io_write(nvme_cmd cmd);
  malloc_memory_space(cmd);
  fill_data_to_host_mem(cmd);
endtask



function void esp_host::malloc_memory_space(nvme_cmd cmd);
  bit[HOST_AXI_WIDTH-1:0] addr;
  //malloc_space(cmd.data_size, addr);
  //temp assign
  addr = 'h8_0000;
  cmd.SQE_DW[6] = addr[31:0];
  cmd.SQE_DW[7] = addr[63:32];
  //PRP and SGL
  
  if(cmd.get_psdt() == NVME_PRP)begin
    

  end
  else begin

  end

     
endfunction


function void esp_host::fill_data_to_host_mem(nvme_cmd cmd);
  bit[HOST_AXI_WIDTH-1:0] addr;
  int       size;

  size = cmd.data.size();
  addr = {cmd.SQE_DW[7], cmd.SQE_DW[6]};
  `uvm_info(get_name(), $sformatf("cmd size = %0d", size), UVM_LOW) 
  for(int i = 0; i < size; i++)begin
    `uvm_info(get_name(), $sformatf("cmd.data[%0h] = %0h", i, cmd.data[i]), UVM_LOW) 
    host_mem.fill_byte_data_direct(addr+i, cmd.data[i]);
  end
endfunction



function void esp_host::fill_cmd_to_SQ(nvme_cmd cmd);
  bit[HOST_AXI_WIDTH-1:0] addr;
  int  fid = cmd.mgr.fid;
  int  sqid = cmd.sqid;
  `uvm_info(get_name(), $sformatf("sqid = %0d", sqid), UVM_LOW) 
  
  addr = mgrs[fid].SQ[sqid].get_tail_addr();
  `uvm_info(get_name(), $sformatf("fid = %0h, sqid = %0h, sq_base_addr = %0h, sq_head_addr = %0h, sq_tail_ptr = %0h", fid, sqid, mgrs[fid].SQ[sqid].get_base_addr(), mgrs[fid].SQ[sqid].get_head_addr(), mgrs[fid].SQ[sqid].get_tail_addr()), UVM_LOW) 
  foreach(cmd.SQE_DW[i])begin
    `uvm_info(get_name(), $sformatf("cmd.SQE_DW[%0d] = %0h", i, cmd.SQE_DW[i]), UVM_LOW) 

  end
  host_mem.fill_dw_data_array_direct(addr, cmd.SQE_DW);
  mgrs[fid].SQ[sqid].update_tail(); //TODO: should be mutually exclusive??
  `uvm_info(get_name(), $sformatf("Now tail of Function %0h SQ %0h is %0d", fid, sqid, mgrs[fid].SQ[sqid].tail), UVM_LOW) 
endfunction



task esp_host::ring_doorbell(nvme_cmd cmd, esp_host_mgr mgr);
  int fid, sqid;
  U16 sq_tail;
  
  fid  = mgr.fid;
  sqid = cmd.sqid;
   
  sq_tail = mgr.SQ[sqid].get_tail();
  DUT.set_sq_tail(fid, sqid, sq_tail); 
endtask



task esp_host::main_phase(uvm_phase phase);
  fork
    begin
      forever_monitor_interrupt();
    end
  join 
endtask



task esp_host::forever_monitor_interrupt();
  nvme_cpl_entry   nvme_cpl;
  int              fq[$];
  bit              suc;
  int              fid, sqid, cid;
  int              iv;
  int              uid;
  bit[14:0]        status;
  int              cq_tail, cq_head;
  

  forever begin
    `uvm_info(get_name(), $sformatf("start to wait MSIX"), UVM_LOW) 
    wait(hvif.msix_intr_happens == 1);
    
    fq = hvif.intr_triggered.find_index(x) with (x == 1);
    if(fq.size() > 0)begin
      iv = fq[0];
      fid = msix_id_2_func[iv];
      `uvm_info(get_name(), $sformatf("MSIX for function %0h is triigered", fid), UVM_LOW) 
      fq.delete();

      fq = mgrs[fid].CQ.find_index(x) with (x.iv == iv);
      foreach(fq[cqid])begin
        esp_host_cq   cq;
        cq = mgrs[fid].CQ[cqid];
        cq_tail = get_cq_tail(cq);  //TODO check the phase bit in CQE
        cq_head = cq.get_head();   
        while(cq_tail != cq_head) begin
          nvme_cpl = nvme_cpl_entry::type_id::create("nvme_cpl");
          get_one_cqe(cq, nvme_cpl);
          //suc = do_host_cpl_compare();

          suc  = 1;
          if(suc)begin
            status = nvme_cpl.get_status();
            sqid = nvme_cpl.get_sqid();
            cid  = nvme_cpl.get_cid();
            uid  = find_related_cmd(fid, sqid, cid);
            process_cmd_when_completion(uid, status);
            host_cmd_map[uid].state = CMD_DONE;
            `uvm_info(get_name(), "******************INIT_TEST PASS******************", UVM_NONE)
          end
        end
      end
      

      
        
      hvif.msix_intr_happens = 0;
      `uvm_info(get_name(), $sformatf("Handle msix_intr_happens Done"), UVM_LOW)
    end
    #100ns;
    
  end
  
endtask



function int esp_host::get_cq_tail(esp_host_cq cq);
  U64        addr = cq.get_base_addr();
  bit        phase_bit;
  bit        ptr;
  U32        data[];
  int        cur_tail;
  bit        target_phase_bit;

  data = new[NUM_DW_CDE];
  target_phase_bit = 1;//TEMP TODO
  do begin
    `uvm_info(get_name(), $sformatf("========Check the CQE of addr %0h========", addr), UVM_LOW) 
    host_mem.take_dw_data_array_direct(addr, data); 
    phase_bit = data[3][16];
    `uvm_info(get_name(), $sformatf("phase_bit = %0d", phase_bit), UVM_LOW) 
    if(phase_bit == target_phase_bit)begin
      cur_tail++;
      addr += 16;
    end
    else begin
      `uvm_info(get_name(), $sformatf("cur_tail = %0d", cur_tail), UVM_LOW) 
      return cur_tail;
    end
  end while(phase_bit == target_phase_bit);
endfunction




task esp_host::get_one_cqe(esp_host_cq cq, nvme_cpl_entry nvme_cpl);
  U64  addr = cq.get_head_addr(); 
  U32  data[];
  data = new[NUM_DW_CDE];
  host_mem.take_dw_data_array_direct(addr, data);
  foreach(nvme_cpl.CQE_DW[i])
    nvme_cpl.CQE_DW[i] = data[i];
  cq.update_head();
  `uvm_info(get_name(), $sformatf("Update the cq_head_ptr = %0h", cq.head), UVM_LOW) 
endtask



function int esp_host::find_related_cmd(int fid, int sqid, int cid);
  int  fq[$];
  
  fq = host_cmd_map.find_index(x) with (x.fid == fid && x.sqid == sqid && x.cid == cid && x.state != CMD_DONE);
  if(fq.size() == 1)
    return fq[0];
  else if(fq.size() == 0)begin
    `uvm_error(get_name(), $sformatf("Not find any matched cmd {fid, sqid, cid} = {%0h,%0h,%0h}", fid, sqid, cid)) 
    return -1;
  end
  else begin
    `uvm_error(get_name(), $sformatf("Find %0d matched cmd {fid, sqid, cid} = {%0h,%0h,%0h}", fq.size(), fid, sqid, cid)) 
    return -1;
  end
endfunction



task esp_host::process_cmd_when_completion(int uid, bit[14:0] status);
  nvme_cmd    cmd;
  
  cmd = host_cmd_map[uid];
  host_cmd_map[uid].status = status;
  if(cmd.status == 'h0)begin  //TODO
    case(cmd.esp_opc)
      //ADMIN CMD
      ESP_IDENTIFY:   pwc_admin_indentify(uid);
      ESP_DELETE_SQ:  pwc_admin_delete_sq(uid);
      ESP_CREATE_SQ:  pwc_admin_create_sq(uid);
      ESP_DELETE_CQ:  pwc_admin_delete_cq(uid);
      ESP_CREATE_CQ:  pwc_admin_create_cq(uid);
      //IO CMD
      ESP_WRITE:      pwc_io_write(uid);
    endcase
  end
endtask



task esp_host::pwc_admin_indentify(int uid);
  
  case(host_cmd_map[uid].cns)
    NS_DATA:begin
              pwc_identify_cns_0(uid);
            end
   
  endcase
endtask



task esp_host::pwc_identify_cns_0(int uid);
  nvme_cmd    cmd;
  U8          data[];
  int         data_size;
  int         data_addr;
  U32         nsid;
  int         fid;

  data = new[4096];

  cmd          = host_cmd_map[uid];
  data_addr    = cmd.get_prp1();
  nsid         = cmd.nsid;
  fid          = cmd.get_fid();
  
  host_mem.take_byte_data_array_direct(data_addr, data);   

  //TODO lots of field
  mgrs[fid].active_ns[nsid].lba_ds = data[130];
  mgrs[fid].active_ns[nsid].meta_ds = {data[129], data[128]};

  
endtask



task esp_host::pwc_admin_delete_sq(int uid);
  
endtask



task esp_host::pwc_admin_create_sq(int uid);
  
endtask



task esp_host::pwc_admin_delete_cq(int uid);
  
endtask



task esp_host::pwc_admin_create_cq(int uid);
  
endtask



task esp_host::pwc_io_write(int uid);
  

endtask

//task esp_host::get_intr_func();
//  
//endtask


task esp_host::pbs_admin_indentify(nvme_cmd cmd);
endtask



task esp_host::pbs_admin_delete_sq(nvme_cmd cmd);
endtask



task esp_host::pbs_admin_delete_cq(nvme_cmd cmd);
endtask


function void esp_host::set_host_ranges(int fid, bit [63:0] baddr[], bit [63:0] size[], ref esp_host_mgr mgr);
  string s = "\n";
  if (mgr == null) begin
    mgr = esp_host_mgr::type_id::create("mgr");
  end

  mgr.fid = fid;
  mgr.num_of_bar  = baddr.size();
  mgr.bar_range = new[mgr.num_of_bar];
  for (int i = 0; i < mgr.num_of_bar; i++) begin
    mgr.bar_range[i].baddr  = baddr[i];
    mgr.bar_range[i].size   = size[i];
    s = {s, $sformatf("    mgr-%0d pcie range bar[%0d] {0x%16x:0x%16x}\n", fid, i, baddr[i], baddr[i]+size[i]-1)};
  end
  `uvm_info(get_name(), s, UVM_LOW)
  mgr.state = ST_SET_PCIE_RANGE;

  if (mgrs.exists(fid)) begin
    `uvm_fatal(get_name(), $sformatf("mgr-%0d exists. Please check if it has been deleted.", fid))
  end else begin
    mgrs[fid] = mgr;
  end
endfunction


task esp_host::write_nvme_cap(int fid, int start_dw, U32 data[]);
  U64 baddr, addr;
  int num_bt;
  U8  data_bt[];

  if (!mgrs.exists(fid)) begin
    `uvm_error(get_name(), $sformatf("mgr-%0d does not exist in mgrs", fid))
  end else begin
    baddr = mgrs[fid].bar_range[0].baddr;
    addr  = baddr + start_dw * 4;
  end

  num_bt = data.size() * 4;
  data_bt = new[num_bt];

  foreach (data[i]) begin
    data_bt[4*i+0] = data[i][ 7: 0];
    data_bt[4*i+1] = data[i][15: 8];
    data_bt[4*i+2] = data[i][23:16];
    data_bt[4*i+3] = data[i][31:24];
  end

  hvif.send_wr_trans(addr, data_bt);
  printer.print_cap("write", fid, start_dw, data);
  mgrs[fid].update_cap(start_dw, data.size(), data);
endtask


task esp_host::read_nvme_cap(int fid, int start_dw, int num_dw, ref U32 data[]);
  U64 baddr, addr;
  int num_bt;
  U8  data_bt[];

  if (!mgrs.exists(fid)) begin
    `uvm_error(get_name(), $sformatf("mgr-%0d does not exist in mgrs", fid))
  end else begin
    baddr = mgrs[fid].bar_range[0].baddr;
    addr  = baddr + start_dw * 4;
  end

  data = new[num_dw];
  num_bt = num_dw * 4;
  data_bt = new[num_bt];

  hvif.send_rd_trans(addr, data_bt);

  foreach (data_bt[i]) begin
    case(i%4)
      0: begin
           data[i/4][ 7: 0] = data_bt[i];
         end
      1: begin
           data[i/4][15: 8] = data_bt[i];
         end
      2: begin
           data[i/4][23:16] = data_bt[i];
         end
      3: begin
           data[i/4][31:24] = data_bt[i];
         end
    endcase
  end
  printer.print_cap("read", fid, start_dw, data);
  mgrs[fid].update_cap(start_dw, data.size(), data);
endtask

