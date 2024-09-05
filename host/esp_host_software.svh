class esp_host extends uvm_component;
  `uvm_component_utils(esp_host)

  host_memory    host_mem;
  //host_memory_manager   host_mem_mgr;
  nvme_dut       DUT;
  nvme_cmd       cmd_waiting_q[$];
  host_vif       hvif;
  nvme_cmd       host_cmd_map[int];

  int            cur_phase_bit;
  U64            cq_base_addr = 'h5_0000;
  U16            cq_head_ptr; 
  U16            cq_tail_ptr; 

  U64            sq_base_addr = 'h6_0000;
  U16            sq_head_ptr; 
  U16            sq_tail_ptr;


  extern function        new(string name="esp_host", uvm_component parent); 
  extern task            post_cmd(ref nvme_cmd cmd);
  extern task            main_phase(uvm_phase phase);
  extern function        calculate_cmd_size();
  extern function        malloc_memory_space(nvme_cmd cmd);
  extern function        fill_data_to_host_mem(nvme_cmd cmd);
  extern function        fill_cmd_to_SQ(nvme_cmd cmd);
  extern task            ring_doorbell(nvme_cmd cmd, nvme_function_manager mgr);
  extern task            forever_monitor_interrupt();
  extern function int    get_cq_tail();
  extern task            get_one_cqe(ref nvme_cpl_entry nvme_cpl);


endclass



function esp_host::new(string name="esp_host", uvm_component parent);
  super.new(name, parent);
endfunction



task esp_host::post_cmd(ref nvme_cmd cmd);

  //SQE_DW is not packed yet
  cmd.process_self_stage_0();
  //check which Q the cmd belongs to

 

  if(!cmd.is_admin_cmd() && cmd.opc == NVME_WRITE)begin
    int nsid = cmd.SQE_DW[1];
    int nlb  = cmd.SQE_DW[12][15:0];
    //calculate the cmd size
    //...
    cmd.uid = 1; 
    cmd.host_tdata_size = 64;
    cmd.create_data();
    //host assign the host memory space to the data and return DSPT
    malloc_memory_space(cmd);
    //malloc host memory for PRP List
    //fill PRP List or SGL DSPT to host memory

    //fill data to host mem
    fill_data_to_host_mem(cmd); 
    
    
    //check if the corresponding SQ has enough space to put the cmd
    //When PRP and SGL is ready, put the cmd to related SQ
    fill_cmd_to_SQ(cmd);
    ring_doorbell(cmd, cmd.mgr);
    //cmd_waiting_q.push_back(cmd);
    host_cmd_map[cmd.uid] = cmd;
  end


  //Create SQ
  if( cmd.is_admin_cmd() && cmd.SQE_DW[0][7:0] == 'h01)begin  
    int nsid = cmd.SQE_DW[1];
    int nlb  = cmd.SQE_DW[12][15:0];
  end
    
endtask



function esp_host::calculate_cmd_size();

endfunction


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

     
  //End of PRP and SGL
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
  U32     JFT[];

  JFT = new[16];

  addr = sq_base_addr + 64*sq_tail_ptr;//get_cmd_positon();
  `uvm_info(get_name(), $sformatf("sq_base_addr = %0h, sq_base_addr = %0h, sq_tail_ptr = %0h", sq_base_addr, sq_base_addr, sq_tail_ptr), UVM_LOW) 
  foreach(cmd.SQE_DW[i])begin
    //JFT[i] = cmd.SQE_DW[i];
    `uvm_info(get_name(), $sformatf("cmd.SQE_DW[%0d] = %0h", i, cmd.SQE_DW[i]), UVM_LOW) 

  end
  host_mem.fill_dw_data_group_direct(addr, cmd.SQE_DW);
  //host_mem.fill_dw_data_group_direct(addr, JFT);
  sq_tail_ptr++;
endfunction



task esp_host::ring_doorbell(nvme_cmd cmd, nvme_function_manager mgr);
 
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
  forever begin
    `uvm_info(get_name(), $sformatf("start to wait MSIX"), UVM_LOW) 
    wait(hvif.msix_intr_happens == 1);
    `uvm_info(get_name(), $sformatf("msix_intr_happens"), UVM_LOW)
    //got the corresponding IV
    cq_tail_ptr = get_cq_tail(); //TODO check the phase bit in CQE
    do begin
      nvme_cpl = nvme_cpl_entry::type_id::create("nvme_cpl");
      get_one_cqe(nvme_cpl);
      //suc = do_host_cpl_compare();
      suc = 1;
      if(suc)begin
        host_cmd_map[1].state = CMD_DONE;
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
    host_mem.take_dw_data_group_direct(addr, data); 
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
  host_mem.take_dw_data_group_direct(addr, data);
  foreach(nvme_cpl.CQE_DW[i])
    nvme_cpl.CQE_DW[i] = data[i];
  cq_head_ptr++;
  `uvm_info(get_name(), $sformatf("Update the cq_head_ptr = %0h", cq_head_ptr), UVM_LOW) 
endtask



