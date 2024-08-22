class esp_host extends uvm_object;
  `uvm_object_utils(esp_host)

  host_memory    host_mem;
  nvme_dut       DUT;
  nvme_cmd       cmd_waiting_q[$];
  host_intf      host_vif;

  int            cur_phase_bit;
  U64            cq_base_addr = 'h5000_0000;
  U16            cq_head_ptr; 
  U16            cq_tail_ptr; 

  U64            sq_base_addr = 'h6000_0000;
  U16            sq_head_ptr; 
  U16            sq_tail_ptr;


  extern function        new(string name="esp_host"); 
  extern task            post_cmd(nvme_cmd cmd);
  extern task            main_phase(uvm_phase phase);
  extern function        calculate_cmd_size();
  extern function        malloc_memory_space(nvme_cmd cmd);
  extern function        fill_data_to_host_mem(cmd);
  extern function        fill_cmd_to_SQ(cmd);
  extern task            ring_doorbell(nvme_cmd cmd, nvme_function_manager mgr);
  extern task            main_phase(uvm_phase phase);
  extern task            forever_monitor_interrupt();
  extern function int    get_cq_tail();
  extern task            get_one_cqe(ref nvme_cpl_entry nvme_cpl);


endclass



function esp_host::new(string name="esp_host");
  super.new(name);
endfunction



task esp_host::post_cmd(nvme_cmd cmd);
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
    int data_size;
    //calculate the cmd size
    //...
    //calculate_cmd_size();
    data_size = nlb * nlb_size;
    cmd.data_size = 64;
    //host assign the host memory space to the data and return DSPT
    malloc_memory_space(cmd);
    //malloc host memory for PRP List
    //fill PRP List or SGL DSPT to host memory

           

    //create data for cmd
    cmd.create_data(data_size); 
    //fill data to host mem
    fill_data_to_host_mem(cmd); 
    
    
    //check if the corresponding SQ has enough space to put the cmd
    //When PRP and SGL is ready, put the cmd to related SQ
    fill_cmd_to_SQ(cmd);
    ring_doorbell(cmd, mgr);
    //cmd_waiting_q.push_back(cmd);
  end
    
endtask



function esp_host::calculate_cmd_size();

endfunction


function esp_host::malloc_memory_space(nvme_cmd cmd);
  bit[HOST_AXI_WIDTH-1:0] addr;
  //malloc_space(cmd.data_size, addr);
  addr = 'h8000_0000;
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

  addr = sq_base_addr + 64*sq_tail_ptr;//get_cmd_positon();
  host_mem.fill_data_group_by_dw(addr, cmd.SQE_DW);
  sq_tail_ptr++;
endfunction



task esp_host::ring_doorbell(nvme_cmd cmd, nvme_function_manager mgr);
 
  int sq_id;
  U16 sq_tail;
  
  sq_tail = sq_tail_ptr;//mgr.get_sq_tail(sqid);
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
    wait(host_vif.msix_intr_happens == 1);

    //got the corresponding IV
    
    cq_tail = get_cq_tail(); //TODO check the phase bit in CQE
    do begin
      nvme_cpl = nvme_cpl_entry::type_id::create("nvme_cpl", this);
      get_one_cqe(nvme_cpl);
      suc = do_host_cpl_compare();
      if(suc)
        `uvm_info(get_name(), "******************INIT_TEST PASS******************", UVM_NONE)
    end while(cq_tail_ptr != cq_head_ptr);  

  end
  host_vif.msix_intr_happens = 0;
endtask



function int esp_host::get_cq_tail();
  U64  addr = cq_base_addr;
  bit        phase_bit;
  bit        ptr;
  U32  data[NUM_DW_CDE];
  int        cur_tail;

  target_phase_bit = 1;//TEMP TODO
  do begin
    host_mem.take_data_group_by_dw(addr, data); 
    phase_bit = data[3][16];
    if(phase_bit == target_phase_bit)begin
      cur_tail++;
      addr += 16;
    end
    else begin
      return cur_tail;
    end
  end while(phase_bit == target_phase_bit);
endfunction




task esp_host::get_one_cqe(ref nvme_cpl_entry nvme_cpl);
  U64  addr = cq_base_addr + 16*cq_head_ptr; 
  U32  data[NUM_DW_CDE];
  host_mem.take_data_group_by_dw(addr, data);
  foreach(nvme_cpl.CQE_DW[i])
    nvme_cpl.CQE_DW[i] = data[i];
  cq_head_ptr++;
endtask



