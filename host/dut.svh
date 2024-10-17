class nvme_dut extends uvm_component;
  `uvm_component_utils(nvme_dut)

  
          U16            sq_tail;
          U16            sq_head;
          U16            cur_sq_head;
          U64            sq_base_addr = 'h6_0000;
           
          U16            cq_tail;
          U16            cq_head;
          U64            cq_base_addr = 'h5_0000;
          
          U64            msix_addr;
          U64            msix_data;

          nvme_cmd       cmd_q[$];

          host_vif       hvif;
          
	  nvme_namespace     ns[U32];         //KEY is namespace ID
	  esp_host_sq        hsq[int][int];   //KEY is function ID and host SQ ID
	  esp_host_cq        hcq[int][int];   //KEY is function ID and host CQ ID

  
  extern function        new(string name="nvme_dut", uvm_component parent);
  extern function void   build_phase(uvm_phase phase);
  extern function void   connect_phase(uvm_phase phase);
  extern task            main_phase(uvm_phase phase);

  extern task            forever_monitor_doorbell();
  extern task            forever_handle_cmd();
  extern function        set_sq_tail(int ta);
  extern task            read_sqe(esp_host_sq sq, ref U32 DW[]);
  extern task            cmd_handle(nvme_cmd cmd);
  extern task            read_data(XFR_INFO  xfr_q[$], ref U8 data[$]);
  extern function        print_data(ref U8 data[$]);
  extern task            send_cqe(nvme_cmd cmd);
  extern task            send_MSIX_intr();

  extern task            io_write_handling(nvme_cmd cmd);
  extern task            io_read_handling(nvme_cmd cmd);

  extern function        get_prp(nvme_cmd cmd, XFR_INFO xfr_q[$]);
endclass



function nvme_dut::new(string name="nvme_dut", uvm_component parent);
  super.new(name, parent);
endfunction



task nvme_dut::main_phase(uvm_phase phase);
   fork
     begin
       forever_monitor_doorbell();  //TODO controller doorbell
     end
     begin
       forever_handle_cmd();
     end
   join
endtask



task nvme_dut::forever_monitor_doorbell();
  esp_host_sq  sq;
  int     fq[$];
  int     fid;
  int     sqid;

  forever begin
    fq = hsq.find_index(x) with ( x.size() > 0 );
    if(fq.size() > 0)begin
      fq.shuffle();
      `uvm_info(get_name(), $sformatf("fq q size = %0d", fq.size()), UVM_LOW) 
      fid = fq[0];
      fq = hsq[fid].find_index(x) with ( x != null );
      fq.shuffle();
      sqid = fq[0];
      `uvm_info(get_name(), $sformatf("doorbell fid = %0h, sqid = %0h", fid, sqid), UVM_LOW) 
      sq = hsq[fid][sqid];

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
        //****** TODO should be in a function
        if(sq.if_admin_sq())
          cmd.set_admin();
        cmd.unpack_dws();
        cmd.parse_opc();
        //***********************************
        cmd_q.push_back(cmd); 
        #100ns;
      end
    end
    #100ns;
  end
endtask



task nvme_dut::forever_handle_cmd();
  forever begin
    wait(cmd_q.size() > 0);
    cmd_handle(cmd_q.pop_front());
  end
endtask



function nvme_dut::set_sq_tail(int ta);
  sq_tail = ta;
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
  endcase

  send_cqe(cmd);
  send_MSIX_intr();
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



function nvme_dut::print_data(ref U8 data[$]);
  int size = data.size();
  foreach(data[i])
    `uvm_info(get_name(), $sformatf("DUT got data[%0d] = %0h", i, data[i]), UVM_NONE)
endfunction




task nvme_dut::send_cqe(nvme_cmd cmd);
  int   try_cnt = 100;
  int   fid  = cmd.fid;
  U16   sqid = cmd.sqid;
  int   cqid = cmd.cqid;
  U16   cid  = cmd.cid;
  U16   sq_head;
  U64   cqe_addr;
  bit   suc;
  esp_host_cq   cq;

  cq = hcq[fid][cqid];
  do begin
    if(cq.tail != cq.head - 1)begin//TODO
      nvme_cpl_entry  cpl;

      cpl = nvme_cpl_entry::type_id::create("cpl", this);
      //generate the cpl entry
      sq_head = hsq[fid][sqid].head;
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



task nvme_dut::send_MSIX_intr();
  wait(hvif.msix_intr_happens == 0);
  
  `uvm_info(get_name(), $sformatf("send MSIX"), UVM_LOW) 
  hvif.fill_dw_data_direct('h00000001, 'h12345678); 
  #10ns;
endtask



function void nvme_dut::build_phase(uvm_phase phase);
  bit [7:0]     lba_data_size;    
  bit [15:0]    meta_data_size; 
 

  `uvm_info(get_name(), $sformatf("Config controller unique namespace..."), UVM_NONE) 
  for(int i = 0; i < 512; i++)begin
    nvme_namespace     ns_temp;
    ns_temp = nvme_namespace::type_id::create($sformatf("ns_%0d", i));
    ns[i] = ns_temp;
    std::randomize(lba_data_size) with {
      lba_data_size inside {9, 12};
    };
    std::randomize(meta_data_size) with {
      meta_data_size inside {0, 8, 16};
    };
    $display("lba_data_size = %0d, meta_data_size = %0d", lba_data_size, meta_data_size);
    ns[i].lba_ds = lba_data_size;
    ns[i].meta_ds = meta_data_size;
    $display("namespace[%0d] lba_data_size = %0d, meta_data_size = %0d", i, 2**ns[i].lba_ds, ns[i].meta_ds); 
  end
endfunction



function void nvme_dut::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction



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



function nvme_dut::get_prp(nvme_cmd cmd, XFR_INFO xfr_q[$]);
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
    XFR_INFO  xfr;
    xfr.addr = prp1;
    xfr.size = hdata_size_tt;
    xfr_q.push_back(xfr);
  end
  else if(hdata_size_tt <= 2*page_sz - prp1%page_sz)begin
    //prp2 should be a page address
    XFR_INFO  xfr;
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
        XFR_INFO  xfr;
        xfr.addr = prp_list.pop_front();
        xfr.size = remain_size;
	xfr_q.push_back(xfr);
	if(prp_list.size() != 0)
	  `uvm_error(get_name(), $sformatf("Num of PRP here should be 0. Now the remain prp = %0d", prp_list.size())) 
	remain_size = 0;
      end
      else begin
        XFR_INFO  xfr;
        xfr.addr = prp_list.pop_front();
        xfr.size = page_sz;
	xfr_q.push_back(xfr);
        remain_size -= page_sz;
      end
    end
  end

endfunction
