class esp_host extends uvm_component;
  `uvm_component_utils(esp_host)

  host_memory    host_mem;
  host_memory_manager   mem_mgr;
  nvme_dut       DUT;
  nvme_cmd       cmd_waiting_q[$];
  host_vif       hvif;
  nvme_cmd       host_cmd_map[int];     //KEY is unique ID

  int            cur_phase_bit;
  U64            cq_base_addr = 'h5_0000;
  U16            cq_head_ptr; 
  U16            cq_tail_ptr; 

  U64            sq_base_addr = 'h6_0000;
  U16            sq_head_ptr; 
  U16            sq_tail_ptr;

  //For temp
  int            msix_2_func[U64];   


  esp_func_manager    mgrs[U32];     // KEY is function id


  extern function        new(string name="esp_host", uvm_component parent); 
  extern task            main_phase(uvm_phase phase);

  extern task            post_cmd(esp_func_manager mgr = null, ref nvme_cmd cmd);
  extern function        pick_rand_mgr(ref nvme_cmd cmd);
 
  extern function        malloc_memory_space(nvme_cmd cmd);
  extern function        fill_data_to_host_mem(nvme_cmd cmd);
  extern function        fill_cmd_to_SQ(nvme_cmd cmd);
  extern task            ring_doorbell(nvme_cmd cmd, esp_func_manager mgr);
  extern task            forever_monitor_interrupt();
  extern function int    get_cq_tail();
  extern task            get_one_cqe(ref nvme_cpl_entry nvme_cpl);
  
     
  extern function int    find_related_cmd(int fid, int sqid, int cid); 
  extern function int    rand_pick_cq(ref nvme_cmd cmd);

  //Process before submission(pbs)
  extern task            pbs_admin_indentify(ref nvme_cmd cmd);
  extern task            pbs_io_write(ref nvme_cmd cmd);
  extern task            pbs_admin_delete_sq(ref nvme_cmd cmd);
  extern task            pbs_admin_create_sq(ref nvme_cmd cmd);
  extern task            pbs_admin_delete_cq(ref nvme_cmd cmd);
  extern task            pbs_admin_create_cq(ref nvme_cmd cmd);

  extern task            process_cmd_when_completion(int uid, bit[14:0] status);
  //Process when compeletion(pwc)
  extern task            pwc_admin_indentify(int uid);
  extern task            pwc_io_write(int uid);
  extern task            pwc_admin_delete_sq(int uid);
  extern task            pwc_admin_create_sq(int uid);
  extern task            pwc_admin_delete_cq(int uid);
  extern task            pwc_admin_create_cq(int uid);

  extern task            pwc_identify_cns_0(int uid);


endclass



function esp_host::new(string name="esp_host", uvm_component parent);
  nvme_namespace    ns;
  esp_func_manager  func_mgr;
  super.new(name, parent);
  func_mgr = esp_func_manager::type_id::create("func_mgr");  //TODO name should be execlsively
  func_mgr.fid = 8; //random pick
  
  ns = nvme_namespace::type_id::create("ns");
  ns.lba_ds  = 4096;
  ns.meta_ds = 16;
  ns.meta_in_extended = 1;
  ns.nsid = 1;
  func_mgr.active_ns[ns.nsid] = ns;
  mgrs[func_mgr.fid] = func_mgr;

  msix_2_func['h00000001] = 'h1;
endfunction



task esp_host::post_cmd(esp_func_manager mgr = null, ref nvme_cmd cmd);

  if(mgr == null)begin
    pick_rand_mgr(cmd);
  end
  else begin
    cmd.mgr = mgr;
  end
  `uvm_info("", $sformatf("cmd.mgr.fid = %0h", cmd.mgr.fid), UVM_LOW) 

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

  fill_cmd_to_SQ(cmd);
  ring_doorbell(cmd, cmd.mgr);
  host_cmd_map[cmd.uid] = cmd;

endtask




function esp_host::pick_rand_mgr(ref nvme_cmd cmd);
  esp_func_manager   mgr_q[$];
  if(mgrs.size() == 0)
    `uvm_error(get_name(), $sformatf("There is no function manager could be chosen."))
 
  foreach(mgrs[i])
    mgr_q.push_back(mgrs[i]);
  mgr_q.shuffle();
  cmd.mgr = mgr_q[0];
endfunction



task esp_host::pbs_admin_create_sq(ref nvme_cmd cmd);
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
  sq.set_q_size(qsize);
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
	turn_bit64_queue_2_bit8_queue(sq.prp_list[z].prps, prps_U8)
        host_mem.fill_byte_data_queue_direct(addr, prp_U8.size(), prps_U8);	
	if(sq.prp_list[z+1] != null)begin
	  for(int i = 0; i < 8; i++)begin
            host_mem.fill_byte_data_direct(addr + page_sz - (8-i), sq.prp_list[z+1].base_addr[i*8+:8]);
	  end
	end
      end

    end
    
  end
endtask



task esp_host::pbs_admin_create_cq(ref nvme_cmd cmd);
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
  cq.set_q_size(qsize);
  
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
	turn_bit64_queue_2_bit8_queue(cq.prp_list[z].prps, prps_U8)
        host_mem.fill_byte_data_queue_direct(addr, prp_U8.size(), prps_U8);	
	if(cq.prp_list[z+1] != null)begin
	  for(int i = 0; i < 8; i++)begin
            host_mem.fill_byte_data_direct(addr + page_sz - (8-i), cq.prp_list[z+1].base_addr[i*8+:8]);
	  end
	end
      end

    end
    
    
  end

endtask 



function int esp_host::rand_pick_cq(ref nvme_cmd cmd);
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



task esp_host::pbs_io_write(ref nvme_cmd cmd);
  malloc_memory_space(cmd);
  fill_data_to_host_mem(cmd);
endtask



function esp_host::malloc_memory_space(nvme_cmd cmd);
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


function esp_host::fill_data_to_host_mem(nvme_cmd cmd);
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



function esp_host::fill_cmd_to_SQ(nvme_cmd cmd);
  bit[HOST_AXI_WIDTH-1:0] addr;
  int  fid = cmd.mgr.fid;
  int  sqid = cmd.sqid;
  
  addr = mgrs[fid].SQ[sqid].get_tail_addr();
  `uvm_info(get_name(), $sformatf("fid = %0h, sqid = %0h, sq_base_addr = %0h, sq_head_addr = %0h, sq_tail_ptr = %0h"fid, sqid, mgrs[fid].SQ[sqid].get_base_addr(), mgrs[fid].SQ[sqid].get_head_addr(), mgrs[fid].SQ[sqid].get_tail_addr()), UVM_LOW) 
  foreach(cmd.SQE_DW[i])begin
    `uvm_info(get_name(), $sformatf("cmd.SQE_DW[%0d] = %0h", i, cmd.SQE_DW[i]), UVM_LOW) 

  end
  host_mem.fill_dw_data_array_direct(addr, cmd.SQE_DW);
  mgrs[fid].SQ[sqid].update_tail();
endfunction



task esp_host::ring_doorbell(nvme_cmd cmd, esp_func_manager mgr);
 
  int sq_id;
  U16 sq_tail;
  
  sq_tail = sq_tail_ptr;//mgr.get_sq_tail(sqid);
  `uvm_info(get_name(), $sformatf("sq_tail = %0h", sq_tail), UVM_LOW) 
  DUT.set_sq_tail(sq_tail); 
    
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
  bit              suc;
  int              fid, sqid, cid;
  int              uid;
  bit[14:0]        status;
  

  forever begin
    `uvm_info(get_name(), $sformatf("start to wait MSIX"), UVM_LOW) 
    wait(hvif.msix_intr_happens == 1);
    

    //fid = get_intr_func();
    `uvm_info(get_name(), $sformatf("msix_intr_happens"), UVM_LOW)
    //got the corresponding IV
    
    cq_tail_ptr = get_cq_tail(); //TODO check the phase bit in CQE
    do begin
      nvme_cpl = nvme_cpl_entry::type_id::create("nvme_cpl");
      get_one_cqe(nvme_cpl);
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
    end while(cq_tail_ptr != cq_head_ptr);  
    hvif.msix_intr_happens = 0;
    `uvm_info(get_name(), $sformatf("Handle msix_intr_happens Done"), UVM_LOW)
    #100ns;
  end
  
endtask



function int esp_host::get_cq_tail();
  U64        addr = cq_base_addr;
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




task esp_host::get_one_cqe(ref nvme_cpl_entry nvme_cpl);
  U64  addr = cq_base_addr + 16*cq_head_ptr; 
  U32  data[];
  data = new[NUM_DW_CDE];
  host_mem.take_dw_data_array_direct(addr, data);
  foreach(nvme_cpl.CQE_DW[i])
    nvme_cpl.CQE_DW[i] = data[i];
  cq_head_ptr++;
  `uvm_info(get_name(), $sformatf("Update the cq_head_ptr = %0h", cq_head_ptr), UVM_LOW) 
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


task esp_host::pbs_admin_indentify(ref nvme_cmd cmd);
endtask



task esp_host::pbs_admin_delete_sq(ref nvme_cmd cmd);
endtask



task esp_host::pbs_admin_delete_cq(ref nvme_cmd cmd);
endtask



