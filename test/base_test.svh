class base_test extends uvm_test;
  `uvm_component_utils(base_test)

          esp_host       host;
          nvme_dut       DUT; 
          host_memory    host_mem;
          host_memory_manager   mem_mgr;
  virtual host_intf      hvif;

          esp_host_mgr   mgrs[];

  extern function        new(string name, uvm_component parent);
  extern function void   build_phase(uvm_phase phase);
  extern function void   connect_phase(uvm_phase phase);
  extern task            main_phase(uvm_phase phase);

endclass



function base_test::new (string name, uvm_component parent);
  super.new(name,parent);
endfunction



function void base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  host       = esp_host::type_id::create("host", this);
  DUT        = nvme_dut::type_id::create("DUT", this);
  mem_mgr    = host_memory_manager::type_id::create("mem_mgr", this);
  host_mem   = new();
  if(!uvm_config_db#(virtual host_intf)::get(this, "*" ,"host_vif", hvif))
    `uvm_fatal(get_name(), $sformatf("Can not get the interface")) 
  `uvm_info(get_name(), $sformatf("got the interface" ), UVM_LOW)  
  hvif.add_msix_vector(0, 'h00000001, 'h10000001); 
  hvif.add_msix_vector(1, 'h00000002, 'h20000002); 
endfunction



function void base_test::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  host.host_mem     = host_mem;
  host.mem_mgr      = mem_mgr;
  host.DUT          = DUT;
  host.hvif         = hvif;
  DUT.hvif          = hvif;
  hvif.host_mem     = host_mem;
  mem_mgr.host_mem  = host_mem;
  mem_mgr.init();
endfunction



task base_test::main_phase(uvm_phase phase);
  nvme_cmd  cmd;
  nvme_cmd  cmd_q[$];
  int       num_cmd_send, num_cmd_done, cmd_all_send;
  phase.raise_objection(this); //rasing objection

  mgrs = new[3];

  foreach (mgrs[i]) begin
    bit [63:0] baddr[], size[];
    baddr = new[5];
    size = new[5];
    foreach (baddr[bar]) begin
      baddr[bar] = i * 64'h1000_0000 + bar * 64'h10_0000;
      size[bar]  = 64'h1_0000;
    end
    host.set_host_ranges(i, baddr, size, mgrs[i]);
    host.create_admin_sq_cq(i, 'h100, 'h100);

  end
 
  foreach(host.mgrs[i])
    `uvm_info(get_name(), $sformatf("create mgr[%0h] fid = %0h", i, host.mgrs[i].fid), UVM_LOW) 

  cmd = nvme_cmd::type_id::create("cmd", this);
  if(!cmd.randomize with {
    cmd.esp_opc   == ESP_CREATE_CQ;
    cmd.sdw10_adm.create_iocq.QID   == 1;
    cmd.sdw10_adm.create_iocq.QSIZE == 'hF;
    cmd.sdw11_adm.create_iocq.PC    == 1;
    cmd.sdw11_adm.create_iocq.IV    == 1;
    cmd.sqid == 0;
  }) `uvm_error(get_name(), $sformatf("cmd randomize failed!")) 
  host.post_cmd(cmd, host.mgrs[8]); 
  cmd.wait_done();

  cmd = nvme_cmd::type_id::create("cmd", this);
  if(!cmd.randomize with {
    cmd.esp_opc   == ESP_CREATE_SQ;
    cmd.sdw10_adm.create_iosq.QID   == 1;
    cmd.sdw10_adm.create_iosq.QSIZE == 'hF;
    cmd.sdw11_adm.create_iosq.PC    == 1;
    cmd.sdw11_adm.create_iosq.CQID  == 1;
    cmd.sqid == 0;
  }) `uvm_error(get_name(), $sformatf("cmd randomize failed!")) 
  host.post_cmd(cmd, host.mgrs[8]); 
  cmd.wait_done();

  fork
    begin
      cmd = nvme_cmd::type_id::create("cmd", this);
      if(!cmd.randomize with {
        cmd.esp_opc   == ESP_WRITE;
	cmd.sqid      == 1;
        cmd.sdw1.NSID == 1;
	cmd.sdw12_io.write.NLB == 1;
      }) `uvm_error(get_name(), $sformatf("cmd randomize failed!")) 
      host.post_cmd(cmd, host.mgrs[8]); 

      num_cmd_send++;
      cmd_q.push_back(cmd);
      #3000ns;
      cmd_all_send = 1;
      `uvm_info(get_name(), $sformatf("All cmd has sent"), UVM_LOW)
    end
    begin
      while (!(num_cmd_send == num_cmd_done && cmd_all_send == 1)) begin
        num_cmd_done = 0;
        foreach(cmd_q[i])begin
          if(cmd_q[i].state == CMD_DONE)begin
            num_cmd_done++;
          end
        end
        `uvm_info(get_name(), $sformatf("%0d cmd is already done", num_cmd_done), UVM_LOW)
        #1000ns; 
      end 
    end
  join
  phase.drop_objection(this);  //droping objection
endtask
