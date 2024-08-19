

class esp_host extends uvm_object;
  `uvm_object_utils(esp_host)

  host_memory    host_mem;
  nvme_dut       DUT;
  nvme_cmd       cmd_waiting_q[$];


  extern function new(string name="esp_host"); 
  extern task post_cmd(nvme_cmd cmd);

endclass


task esp_host::post_cmd(nvme_cmd cmd);
  //bit[7:0]    ;   
  bit        is_admin;

  //check which Q the cmd belongs to
  if(cmd.sqid == 0)begin
    is_admin = 1;
  end
  else begin
    is_admin = 0;
  end

 

  if(is_admin == 0 && cmd.SQE_DW[0][7:0] == 'h01)begin
    int nsid = cmd.SQE_DW[1];
    int nlb  = cmd.SQE_DW[12][15:0];
    int cmd_size;
    //calculate the cmd size
    //...
    //calculate_cmd_size();
    cmd_size = nlb * nlb_size;
    //host assign the host memory space to the data and return DSPT
    malloc_memory_space(cmd);
    //malloc host memory for PRP List
    //fill PRP List or SGL DSPT to host memory

           

    //create data for cmd
    cmd.create_data(cmd_size, data_pattern); 
    //fill data to host mem
    fill_data_to_host_mem(cmd); 
    
    
    //check if the corresponding SQ has enough space to put the cmd
    //When PRP and SGL is ready, put the cmd to related SQ
    fill_cmd_to_SQ(cmd);
    ring_doorbell(cmd, mgr);
    cmd_waiting_q.push_back(cmd);
  end
    
endtask



function esp_host::calculate_cmd_size();

endfunction


function esp_host::malloc_memory_space(nvme_cmd cmd);
  bit[HOST_AXI_WIDTH-1:0] addr;
  malloc_space(cmd.cmd_size, addr);
  cmd.SQE_DW[6] = addr[31:0];
  cmd.SQE_DW[7] = addr[63:32];
  //PRP and SGL
endfunction


function esp_host::fill_data_to_host_mem(cmd);
  bit[HOST_AXI_WIDTH-1:0] addr;
  bit       size;

  size = cmd.data.size();
  addr = {cmd.SQE_DW[7], cmd.SEQ_DW[6]};
  for(int i; i < size; i++)
  host_mem.fill_data_by_byte(addr+i, cmd.data[i]);
endfunction



function esp_host::fill_cmd_to_SQ(cmd);
  bit[HOST_AXI_WIDTH-1:0] addr;
  bit       size;

  addr = get_cmd_positon();
  host_mem.fill_data_group_by_dw(addr, cmd.SQE_DW);
endfunction



task esp_host::ring_doorbell(nvme_cmd cmd, nvme_function_manager mgr);
 
  int sq_id;
  int sq_tail;
  
  sq_tail = mgr.get_sq_tail(sqid);
  DUT.set_sq_tail(sq_tail); 
    
endtask



task esp_host::forever_monitor_interrupt();
  forever begin
    if()
    //got the corresponding IV
    
    get_cq_tail(); //TODO check the phase bit in CQE
    if(cq_tail != cq_head)begin
      get_cqe(nvme_cpl);
    end   
  end
endtask








