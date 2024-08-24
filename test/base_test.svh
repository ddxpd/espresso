class base_test extends uvm_test;
  `uvm_component_utils(base_test)

          esp_host       host;
          nvme_dut       DUT; 
          host_memory    host_mem;
  virtual host_intf      hvif;


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
  host_mem   = new();
  uvm_config_db#(int)::get(this, "*" ,"host_vif", hvif);
  
endfunction



function void base_test::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  host.host_mem     = host_mem;
  host.DUT          = DUT;
  DUT.hvif          = hvif;
  hvif.host_mem     = host_mem;
endfunction



task base_test::main_phase(uvm_phase phase);
  nvme_cmd  cmd;
  phase.raise_objection(this); //rasing objection
  super.main_phase(phase);
  cmd = nvme_cmd::type_id::create("cmd", this);
  cmd.sqid = 1;
  host.post_cmd(cmd); 
  phase.drop_objection(this);  //droping objection
endtask
