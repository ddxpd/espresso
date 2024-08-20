class nvme_dut extends uvm_object;
  `uvm_object_utils(nvme_dut)

  host_memory    host_mem; 
  
  int            sq_tail;
  int            sq_head;
  int            cur_sq_head;
  bit[63:0]      sq_base_addr;

   
  int            cq_tail;
  int            cq_head;
  bit[63:0]      cq_base_addr;

  bit[63:0]      msix_addr;
  bit[63:0]      msix_data;

  nvme_cmd       cmd_q[$];
  
  


  extern function new(string name="nvme_dut"); 
  extern function set_sq_tail(string name="nvme_dut"); 
  extern task     forever_monitor_doorbell(); 
  extern task     forever_handle_cmd();
  extern task     send_cqe(nvme_cmd cmd);
  extern task     cmd_handle(nvme_cmd cmd);

endclass


task nvme_dut::forever_monitor_doorbell();
  forever begin
    if(sq_head != sq_tail)begin
      bit[31:0]   SQE[16];
      nvme_cmd   cmd;
      cmd = nvme_cmd::type_id::create("cmd", this);
      //read SQ Entry
      read_sqe(SQE);
      foreach(SQE[i])
        cmd.SQE_DW[i] = SQE[i];
      cmd_q.push_back(cmd); 
      #100ns;
    end
    #100ns;
  end
endtask



task nvme_dut::forever_handle_cmd();
  forever begin
    wait(cmd_q.size() > 0);
    cmd_handle(cmd_q.pop_front())
  end
endtask



function nvme_dut::set_sq_tail(int ta);
  sq_tail = ta;
endfunction



task nvme_dut::read_sqe(ref bit[31:0] DW[]);
  bit[63:0]  cur_addr = sq_base_addr + cur_head;
  host_mem.take_data_group_by_dw(cur_addr, DW);
  cur_head++; //TODO
endtask



task nvme_dut::cmd_handle(nvme_cmd cmd);
  bit[63:0] prp = {cmd.SQE_DW[7], cmd.SQE_DW[6]}; 
  int       cmd_size;
  bit[7:0]  data[];
  
  data = new[cmd_size];
  
  //if need, Get cmd prp/prp list
  //get_prp();
  //calculate cmd size
  read_data(prp, cmd_size);
  print_data(data);
  send_cqe(cmd);
endtask



task nvme_dut::send_cqe(nvme_cmd cmd);
  if(cq_tail != cq_head - 1)begin//TODO
    nvme_cpl_entry  cpl;
    bit[63:0]       cpl_addr;

    cpl = nvme_cpl_entry::type_id::create("cpl", this);
    //generate the cpl entry
    cpl_addr = cq_base_addr + cq_head*4;
    host_mem.take_data_group_by_dw(cpl_addr, cpl.CQE_DW); 
    //send MSIX interrupt
     
  end
endtask
