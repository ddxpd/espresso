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


  
  extern function        new(string name="nvme_dut", uvm_component parent);
  extern task            main_phase(uvm_phase phase);
  extern task            forever_monitor_doorbell();
  extern task            forever_handle_cmd();
  extern function        set_sq_tail(int ta);
  extern task            read_sqe(ref U32 DW[]);
  extern task            cmd_handle(nvme_cmd cmd);
  extern task            read_data(U64 addr, ref U8 data[]);
  extern function        print_data(ref U8 data[]);
  extern task            send_cqe(nvme_cmd cmd);
  extern task            send_MSIX_intr();



endclass



function nvme_dut::new(string name="nvme_dut", uvm_component parent);
  super.new(name, parent);
endfunction



task nvme_dut::main_phase(uvm_phase phase);
   fork
     begin
       forever_monitor_doorbell();
     end
     begin
       forever_handle_cmd();
     end
   join
endtask



task nvme_dut::forever_monitor_doorbell();
  forever begin
    if(sq_head != sq_tail)begin
      U32   SQE[];
      nvme_cmd   cmd;
      SQE = new[NUM_DW_SQE];
      `uvm_info(get_name(), $sformatf("sq_head = %0h, sq_tail = %0h", sq_head, sq_tail), UVM_LOW)
      cmd = nvme_cmd::type_id::create("cmd", this);
      //read SQ Entry
      read_sqe(SQE);
      foreach(SQE[i])begin
        cmd.SQE_DW[i] = SQE[i];
      end
      cmd_q.push_back(cmd); 
      #100ns;
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



task nvme_dut::read_sqe(ref U32 DW[]);
  U64  cur_addr = sq_base_addr + sq_head;

  `uvm_info(get_name(), $sformatf("cur_addr = %0h, sq_base_addr = %0h, sq_head = %0h", cur_addr, sq_base_addr, sq_head), UVM_LOW) 
  hvif.take_dw_data_group_direct(cur_addr, DW);
  sq_head++; //TODO
endtask



task nvme_dut::cmd_handle(nvme_cmd cmd);
  U64    prp = {cmd.SQE_DW[7], cmd.SQE_DW[6]}; 
  int    data_size = 64;
  U8     data[];
  
  data = new[data_size];
  
  //if need, Get cmd prp/prp list
  //get_prp();
  //calculate cmd size
  read_data(prp, data);
  print_data(data);
  send_cqe(cmd);
  send_MSIX_intr();
endtask



task nvme_dut::read_data(U64 addr, ref U8 data[]);
  //U32  data_temp[];
  int  size = data.size();
  //data_temp = new[size];
  hvif.take_byte_data_group_direct(addr, data); 
  //foreach(data[i])
  //  data[i] = data_temp[i];
endtask



function nvme_dut::print_data(ref U8 data[]);
  int size = data.size();
  foreach(data[i])
    `uvm_info(get_name(), $sformatf("DUT got data[%0d] = %0h", i, data[i]), UVM_NONE)
endfunction




task nvme_dut::send_cqe(nvme_cmd cmd);
  //if(cq_tail != cq_head - 1)begin//TODO
    nvme_cpl_entry  cpl;
    U64             cpl_addr;

    cpl = nvme_cpl_entry::type_id::create("cpl", this);
    //generate the cpl entry
    cpl.CQE_DW[0] = 'h0;
    cpl.CQE_DW[1] = 'h0;
    cpl.CQE_DW[2] = {16'h1, sq_head};   //TODO
    cpl.CQE_DW[3] = {15'h0, 1'h1, 16'h0}; //TODO
    cpl_addr = cq_base_addr + cq_tail*16;
    `uvm_info(get_name(), $sformatf("cpl_addr = %0h, cq_base_addr = %0h cq_tail = %0h", cpl_addr, cq_base_addr, cq_tail), UVM_LOW) 
    foreach(cpl.CQE_DW[i])
      `uvm_info(get_name(), $sformatf("cpl.CQE_DW[%0d] = %0h", i, cpl.CQE_DW[i]), UVM_LOW) 
    hvif.fill_dw_data_group_direct(cpl_addr, cpl.CQE_DW); 
    
    cq_tail++;
    `uvm_info(get_name(), $sformatf("cpl_addr = %0h, cq_base_addr = %0h cq_tail = %0h", cpl_addr, cq_base_addr, cq_tail), UVM_LOW)
  //end
endtask



task nvme_dut::send_MSIX_intr();
  wait(hvif.msix_intr_happens == 0);
  
  `uvm_info(get_name(), $sformatf("send MSIX"), UVM_LOW) 
  hvif.fill_dw_data_direct('h00000001, 'h12345678); 
  #10ns;
endtask





