class nvme_dut extends uvm_component;
  `uvm_component_utils(nvme_dut)

  typedef struct packed{
    U64    addr;
    U64    data;
  } S_MSIX_VECTOR;

          S_MSIX_VECTOR  msix_vector[int];   //TODO temporary

          nvme_cmd       unhandle_cmd_q[$];

          host_vif       hvif;

	  nvme_namespace ns[U32];         //KEY is namespace ID
	  esp_host_sq    host_sq[int][int];   //KEY is function ID and host SQ ID
	  esp_host_cq    host_cq[int][int];   //KEY is function ID and host CQ ID

  
  extern function        new(string name="nvme_dut", uvm_component parent);
  extern function void   build_phase(uvm_phase phase);
  extern function void   connect_phase(uvm_phase phase);
  extern task            main_phase(uvm_phase phase);

  extern task            forever_monitor_doorbell();
  extern task            forever_handle_cmd();
  extern task            forever_send_MSIX_intr();

  extern task            cap_init(int mgr_id);
  extern function void   set_sq_tail(int fid, int sqid, int tail);
  extern task            read_sqe(esp_host_sq sq, ref U32 DW[]);
  extern task            cmd_handle(nvme_cmd cmd);
  extern task            read_data(XFR_INFO  xfr_q[$], ref U8 data[$]);
  extern function void   print_data(ref U8 data[$]);
  extern task            send_cqe(nvme_cmd cmd);
  

  extern task            io_write_handling(nvme_cmd cmd);
  extern task            io_read_handling(nvme_cmd cmd);

  extern task            admin_delete_sq_handling(nvme_cmd cmd);
  extern task            admin_create_sq_handling(nvme_cmd cmd);
  extern task            admin_delete_cq_handling(nvme_cmd cmd);
  extern task            admin_create_cq_handling(nvme_cmd cmd);
  extern task            admin_identify_handling(nvme_cmd cmd);


  extern function void   get_prp(nvme_cmd cmd, XFR_INFO xfr_q[$]);
endclass



function nvme_dut::new(string name="nvme_dut", uvm_component parent);
  super.new(name, parent);
endfunction



function void nvme_dut::build_phase(uvm_phase phase);
  esp_host_sq       sq;
  esp_host_cq       cq;
  bit [7:0]     lba_data_size;    
  bit [15:0]    meta_data_size; 
 

  `uvm_info(get_name(), $sformatf("Config controller unique namespace..."), UVM_NONE) 
  for(int i = 0; i < 512; i++)begin
    nvme_namespace     ns_temp;
    ns_temp = nvme_namespace::type_id::create($sformatf("ns_%0d", i));
    ns[i] = ns_temp;
    if (!std::randomize(lba_data_size) with {
      lba_data_size inside {9, 12};
    }) `uvm_error(get_name(), "lba_data_size randomization failed")
    if (!std::randomize(meta_data_size) with {
      meta_data_size inside {0, 8, 16};
    }) `uvm_error(get_name(), "meta_data_size randomization failed")
    $display("lba_data_size = %0d, meta_data_size = %0d", lba_data_size, meta_data_size);
    ns[i].lba_ds = lba_data_size;
    ns[i].meta_ds = meta_data_size;
    $display("namespace[%0d] lba_data_size = %0d, meta_data_size = %0d", i, 2**ns[i].lba_ds, ns[i].meta_ds); 
  end

  //Temporary Admin CQ creating
  cq = esp_host_cq::type_id::create("cq");
  cq.set_qid(0);  
  cq.set_continuous(1);  
  cq.set_base_addr('h1000);
  cq.set_num_entry(5);
  cq.set_iv(0);
  cq.reset_ptr();
  host_cq[8][0] = cq;

  //Temporary Admin SQ creating
  sq = esp_host_sq::type_id::create("sq");
  sq.set_qid(0);
  sq.set_continuous(1);
  sq.set_base_addr('h2000);
  sq.set_num_entry(5);
  sq.reset_ptr();
  sq.add_cq(cq);
  host_sq[8][0] = sq;

  msix_vector[0].addr = 'h00000001; 
  msix_vector[0].data = 'h10000001; 

  msix_vector[1].addr = 'h00000002;
  msix_vector[1].data = 'h20000002; 

endfunction



function void nvme_dut::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction

task nvme_dut::cap_init(int mgr_id);
  U64        cap_addr = hvif.pcie_range_baddr[mgr_id][0];
  S_CAP      cap      = 0;
  S_VERSION  vs       = 0;
  S_CSTS     csts     = 0;
  S_CC       cc       = 0;


  cap.MPSMIN = 0;
  cap.MPSMAX = 5;
  cap.DSTRD  = 6;
  cap.CQR    = 0;
  cap.MQES   = 'hff;

  vs.MJR     = 2;

  hvif.fill_dw_data_direct(cap_addr+CAP_CAP*4,     cap[31:0]);
  hvif.fill_dw_data_direct(cap_addr+(CAP_CAP+1)*4, cap[31:0]);
  hvif.fill_dw_data_direct(cap_addr+CAP_VERSION*4, vs);
  hvif.fill_dw_data_direct(cap_addr+CAP_CC*4,      cc);
  hvif.fill_dw_data_direct(cap_addr+CAP_CSTS*4,    csts);

  do begin
    hvif.take_dw_data_direct(cap_addr+CAP_CC*4, cc);
    #1ns;
  end while (cc.EN == 0);
  `uvm_info(get_name(), $sformatf("mgr %0d DUT gets CC.EN=1", mgr_id), UVM_NONE)

  csts.RDY = 1;
  hvif.fill_dw_data_direct(cap_addr+CAP_CSTS*4, csts);
  `uvm_info(get_name(), $sformatf("mgr %0d DUT writes csts.RDY=1", mgr_id), UVM_NONE)

endtask


task nvme_dut::main_phase(uvm_phase phase);
   fork
     begin
       wait (hvif.pcie_enum_done == 1);
       foreach (hvif.pcie_range_baddr[mgr_id]) begin
         cap_init(mgr_id);
       end
     end
     begin
       forever_monitor_doorbell();  //TODO controller doorbell
     end
     begin
       forever_handle_cmd();
     end
     begin
       forever_send_MSIX_intr();
     end
   join
endtask



task nvme_dut::forever_monitor_doorbell();
  esp_host_sq  sq;
  int     fq[$];
  int     fid;
  int     sqid;

  forever begin
    fq = host_sq.find_index(x) with ( x.size() > 0 );
    if(fq.size() > 0)begin
      fq.shuffle();
      `uvm_info(get_name(), $sformatf("fq q size = %0d", fq.size()), UVM_LOW) 
      fid = fq[0];
      fq = host_sq[fid].find_index(x) with ( x != null );
      if(fq.size() > 0)begin
        fq.shuffle();
        sqid = fq[0];
        `uvm_info(get_name(), $sformatf("doorbell fid = %0h, sqid = %0h", fid, sqid), UVM_LOW) 
        sq = host_sq[fid][sqid];

        if(sq.head != sq.tail)begin
          U32        SQE[];
          nvme_cmd   cmd;

          SQE = new[NUM_DW_SQE];
          cmd = nvme_cmd::type_id::create("cmd", this);

          `uvm_info(get_name(), $sformatf("Now fetching the SQ(fid, sqid) =(%0h, %0h), sq_head = %0h, sq_tail = %0h", 
                                           fid, sqid, sq.head, sq.tail), UVM_LOW)
          //read SQ Entry
          read_sqe(sq, SQE);
          cmd.SQE_DW = SQE;
          //*******CMD Pre process*************
          if(sq.if_admin_sq())
            cmd.is_admin = 1;
          cmd.fid = fid;
          cmd.sqid = sqid;
          cmd.unpack_dws();
          cmd.parse_opc();
          //***********************************
          unhandle_cmd_q.push_back(cmd); 
        end
      end
    end
    #100ns;
  end
endtask



task nvme_dut::forever_handle_cmd();
  forever begin
    wait(unhandle_cmd_q.size() > 0);
    cmd_handle(unhandle_cmd_q.pop_front());
  end
endtask



function void nvme_dut::set_sq_tail(int fid, int sqid, int tail);
  host_sq[fid][sqid].set_tail(tail);
endfunction



task nvme_dut::read_sqe(esp_host_sq sq, ref U32 DW[]);
  U64  addr = sq.get_head_addr();

  `uvm_info(get_name(), $sformatf("Current cmd addr = %0h", addr), UVM_LOW) 
  hvif.take_dw_data_array_direct(addr, DW);
  sq.update_head();
endtask



task nvme_dut::cmd_handle(nvme_cmd cmd);
  case(cmd.esp_opc)
    ESP_WRITE:          io_write_handling(cmd);
    ESP_READ:           io_read_handling(cmd);
    ESP_DELETE_SQ:      admin_delete_sq_handling(cmd);
    ESP_CREATE_SQ:      admin_create_sq_handling(cmd);
    ESP_DELETE_CQ:      admin_delete_cq_handling(cmd);
    ESP_CREATE_CQ:      admin_create_cq_handling(cmd);
    ESP_IDENTIFY:       admin_identify_handling(cmd);
  endcase

  send_cqe(cmd);
endtask



task nvme_dut::read_data(XFR_INFO  xfr_q[$], ref U8 data[$]);
  U8        temp[$];
  U64       addr;
  int       size;
  XFR_INFO  xfr;

  while(xfr_q.size() > 0)begin
    temp.delete();
    xfr  = xfr_q.pop_front();
    addr = xfr.addr;
    size = xfr.size;
    hvif.take_byte_data_queue_direct(addr, size, temp); 
    foreach(temp[i])
      data.push_back(temp[i]);
  end
endtask



function void nvme_dut::print_data(ref U8 data[$]);
  int size = data.size();
  foreach(data[i])
    `uvm_info(get_name(), $sformatf("DUT got data[%0d] = %0h", i, data[i]), UVM_NONE)
endfunction




task nvme_dut::send_cqe(nvme_cmd cmd);
  int   try_cnt = 100;
  int   fid  = cmd.fid;
  U16   sqid = cmd.sqid;
  int   cqid = host_sq[fid][sqid].cqid;
  U16   cid  = cmd.sdw0.CID;
  U16   sq_head;
  U64   cqe_addr;
  bit   suc;
  esp_host_cq   cq;

  cq = host_cq[fid][cqid];
  do begin
    if(cq.tail != cq.head - 1)begin//TODO
      nvme_cpl_entry  cpl;

      cpl = nvme_cpl_entry::type_id::create("cpl", this);
      //generate the cpl entry
      sq_head = host_sq[fid][sqid].head;
      cpl.CQE_DW[0] = 'h0;
      cpl.CQE_DW[1] = 'h0;
      cpl.CQE_DW[2] = {sqid, sq_head};   //TODO
      cpl.CQE_DW[3] = {15'h0, 1'h1, cid}; //TODO phase tag
      cqe_addr = cq.get_tail_addr();
      `uvm_info(get_name(), $sformatf("cpe_addr = %0h, cq_base_addr = %0h tail = %0h, head = %0h", cqe_addr, cq.base_addr, cq.tail, cq.head), UVM_LOW) 
      foreach(cpl.CQE_DW[i])
        `uvm_info(get_name(), $sformatf("cpl.CQE_DW[%0d] = %0h", i, cpl.CQE_DW[i]), UVM_LOW) 
      hvif.fill_dw_data_array_direct(cqe_addr, cpl.CQE_DW); 
      cq.update_tail();
      suc = 1;
      `uvm_info(get_name(), $sformatf("After update tail cpe_addr = %0h, cq_base_addr = %0h cq_tail = %0h, head = %0h", cqe_addr, cq.base_addr, cq.tail, cq.head), UVM_LOW)
    end
    else begin
      `uvm_info(get_name(), $sformatf("Function %0h, CQ %0h is full now, try later.", fid, cqid), UVM_NONE) 
      suc = 0;
      try_cnt--;
    end

    if(!suc)
      #1000ns;
  end while(try_cnt > 0 && suc == 0);

  if(suc == 0)
    `uvm_error(get_name(), $sformatf("Try 100 times, CQE is still not able to send to host CQ")) 
endtask



task nvme_dut::forever_send_MSIX_intr();
  esp_host_cq  cq;
  int     fq[$];
  int     fid, cqid;

  wait(hvif.msix_intr_happens == 0);

  fq = host_cq.find_index(x) with ( x.size() > 0 );
  if(fq.size() > 0)begin
    fq.shuffle();
    fid = fq[0];
    fq = host_cq[fid].find_index(x) with ( x != null );
    if(fq.size() > 0)begin
      fq.shuffle();
      cqid = fq[0];
      `uvm_info(get_name(), $sformatf("Send MSIX fid = %0h, cqid = %0h", fid, cqid), UVM_LOW) 
      cq = host_cq[fid][cqid];

      if(cq.head != cq.tail)begin
        U64 iv_addr = msix_vector[cq.iv].addr; 
        U64 iv_data = msix_vector[cq.iv].data; 
        hvif.fill_dw_data_direct(iv_addr, iv_data);
      end
    end
  end
  #100ns;
endtask







task nvme_dut::io_write_handling(nvme_cmd cmd);
  U8        data[$];
  XFR_INFO  xfr_q[$];

  if(cmd.psdt == NVME_PRP)begin
    get_prp(cmd, xfr_q);
  end
  else if(cmd.psdt == NVME_SGL0)begin

  end
  else if(cmd.psdt == NVME_SGL1)begin

  end
  
  //read data from host memory
  read_data(xfr_q, data);
  print_data(data);
endtask



task nvme_dut::io_read_handling(nvme_cmd cmd);
  U8        data[$];
  XFR_INFO  xfr_q[$];

  if(cmd.psdt == NVME_PRP)begin
    get_prp(cmd, xfr_q);
  end
  else if(cmd.psdt == NVME_SGL0)begin

  end
  else if(cmd.psdt == NVME_SGL1)begin

  end
  
  //read data from host memory
  //read_data(xfr_q, data);
  print_data(data);
endtask



function void nvme_dut::get_prp(nvme_cmd cmd, XFR_INFO xfr_q[$]);
  int    mps     = 12; //TODO
  int    page_sz = 2**(mps);
  int    nsid    = cmd.nsid;
  U64    prp1    = cmd.sprp1; 
  U64    prp2    = cmd.sprp2; 
  U64    mptr    = cmd.mptr; 
  int    nlb     = cmd.sdw12_io.write.NLB;
  int    lba_ds  = 512**ns[nsid].lba_ds;
  int    meta_ds = ns[nsid].meta_ds;
  int    meta_in_ext = ns[nsid].meta_in_extended;

  int    hdata_size_tt;  //host side data in total
  XFR_INFO  xfr;


  if(meta_in_ext)
    hdata_size_tt = (nlb+1) * (lba_ds+meta_ds);
  else
    hdata_size_tt = (nlb+1) * lba_ds;
  
  if(hdata_size_tt <= page_sz - prp1%page_sz)begin
    //prp2 should not be used
    xfr.addr = prp1;
    xfr.size = hdata_size_tt;
    xfr_q.push_back(xfr);
  end
  else if(hdata_size_tt <= 2*page_sz - prp1%page_sz)begin
    //prp2 should be a page address
    xfr.addr = prp1;
    xfr.size = page_sz - prp1%page_sz;
    xfr_q.push_back(xfr);
    xfr.addr = prp2;
    xfr.size = hdata_size_tt - (page_sz - prp1%page_sz);
    xfr_q.push_back(xfr);
    `uvm_info(get_name(), $sformatf("xfr_q size = %0d", xfr_q.size()), UVM_NONE) 
  end
  else begin
    int    remain_size, curr_size;    
    int    num_extra_prp_need;
    int    num_remain_extra_prp;
    U64    prplist_baddr;
    U8     U8_arry_temp[];
    U64    U64_arry_temp[];
    U64    prp_list[$];

    remain_size          = hdata_size_tt - (page_sz - prp1%page_sz);
    num_extra_prp_need   = remain_size/page_sz + (remain_size%page_sz > 0 ? 1 : 0);
    num_remain_extra_prp = num_extra_prp_need;
    prplist_baddr        = prp2;

    // Only one prpList needed
    if(num_remain_extra_prp <= (page_sz-prp2%page_sz)/8)begin  //Could not be so accuate
      curr_size     = num_remain_extra_prp*8;
      U8_arry_temp  = new[curr_size];
      U64_arry_temp = new[curr_size/8];

      hvif.take_byte_data_array_direct(prplist_baddr, U8_arry_temp);
      turn_bit8_array_2_bit64_array(U8_arry_temp, U64_arry_temp);
      foreach(U64_arry_temp[i])
        prp_list.push_back(U64_arry_temp[i]);
    end 
    // More than one prpList needed
    else begin
      curr_size     = page_sz-prp2%page_sz;
      U8_arry_temp  = new[curr_size];
      U64_arry_temp = new[curr_size/8];

      hvif.take_byte_data_array_direct(prplist_baddr, U8_arry_temp);
      turn_bit8_array_2_bit64_array(U8_arry_temp, U64_arry_temp);
      foreach(U64_arry_temp[i])
        prp_list.push_back(U64_arry_temp[i]);

      num_remain_extra_prp -= (page_sz-prp2%page_sz) / 8;
      
      //If there are more prps needed.
      while(num_remain_extra_prp > 0)begin
        prplist_baddr = prp_list.pop_back();
        if(num_remain_extra_prp <= page_sz/8)begin
          U8_arry_temp.delete();
          U64_arry_temp.delete();
          curr_size     = num_remain_extra_prp*8;
          U8_arry_temp  = new[curr_size];
          U64_arry_temp  = new[curr_size/8];
          hvif.take_byte_data_array_direct(prplist_baddr, U8_arry_temp);
          turn_bit8_array_2_bit64_array(U8_arry_temp, U64_arry_temp);
	  
          foreach(U64_arry_temp[i])
            prp_list.push_back(U64_arry_temp[i]);

	  num_remain_extra_prp = 0;
	end
	else begin
          U8_arry_temp.delete();
          U64_arry_temp.delete();
          curr_size     = page_sz;
          U8_arry_temp  = new[curr_size];
          U64_arry_temp  = new[curr_size/8];
          hvif.take_byte_data_array_direct(prplist_baddr, U8_arry_temp);
          turn_bit8_array_2_bit64_array(U8_arry_temp, U64_arry_temp);
	  
          foreach(U64_arry_temp[i])
            prp_list.push_back(U64_arry_temp[i]);

	  num_remain_extra_prp -= page_sz/8;
	end
      end
    end

    //Get the AXI transfer information
    xfr.addr = prp1;
    xfr.size = page_sz - prp1%page_sz;
    xfr_q.push_back(xfr);
    remain_size = hdata_size_tt - xfr.size;

    while(remain_size > 0) begin
      if(remain_size <= page_sz)begin
        xfr.addr = prp_list.pop_front();
        xfr.size = remain_size;
	xfr_q.push_back(xfr);
	if(prp_list.size() != 0)
	  `uvm_error(get_name(), $sformatf("Num of PRP here should be 0. Now the remain prp = %0d", prp_list.size())) 
	remain_size = 0;
      end
      else begin
        xfr.addr = prp_list.pop_front();
        xfr.size = page_sz;
	xfr_q.push_back(xfr);
        remain_size -= page_sz;
      end
    end
  end

endfunction



task nvme_dut::admin_delete_sq_handling(nvme_cmd cmd);
endtask



task nvme_dut::admin_create_sq_handling(nvme_cmd cmd);
endtask



task nvme_dut::admin_delete_cq_handling(nvme_cmd cmd);
endtask



task nvme_dut::admin_create_cq_handling(nvme_cmd cmd);
  esp_host_cq       cq;
  int  fid = cmd.fid;
  int  qid = cmd.sdw10_adm.create_iocq.QID;
  int  num_entry = cmd.sdw10_adm.create_iocq.QSIZE + 1; //QSIZE is 0 based.
  bit  pc = cmd.sdw11_adm.create_iocq.PC;
  int  iv = cmd.sdw11_adm.create_iocq.IV;
  //TODO IVEN


  cq = esp_host_cq::type_id::create("cq");
  if(pc)begin
    cq.qid        = qid;
    cq.num_entry  = num_entry; 
    cq.continuous = pc;
    cq.base_addr  = cmd.sprp1;
    cq.iv         = iv;
    `uvm_info(get_name(), $sformatf("Create cq qid = %0h, cq size = %0d, cq base addr = %0h", cq.qid, cq.num_entry, cq.base_addr), UVM_LOW) 
    host_cq[fid][cq.qid] = cq;
  end
  else begin


  end
endtask



task nvme_dut::admin_identify_handling(nvme_cmd cmd);
endtask



