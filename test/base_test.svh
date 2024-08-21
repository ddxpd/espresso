class base_test extends uvm_test;
  `uvm_component_utils(base_test)

          esp_host       host;
          nvme_dut       DUT; 
          host_memory    host_mem;
  virtual host_intf      host_vif;


  extern function new(string name, uvm_component parent);
  extern function build_phase(uvm_phase phase);
  extern function connect_phase(uvm_phase phase);
  extern function main_phase(uvm_phase phase);

endclass



function base_test::new (string name, uvm_component parent);
  super.new(name,parent);
endfunction



function base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  host       = esp_host::type_id::create("host", this);
  DUT        = nvme_dut::type_id::create("DUT", this);
  host_mem   = host_memory::type_id::create("host_mem", this);
  uvm_config_db#(int)::get(this, "*" ,"host_vif", host_vif);
  
endfunction



function base_test::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  host.host_mem     = host_mem;
  host.DUT          = DUT;
  DUT.host_vif      = host_vif;
  host_vif.host_mem = host_mem;
endfunction



task base_test::main_phase(uvm_phase phase);
  phase.raise_objection(); //rasing objection
  super.main_phase(phase);
  nvme_cmd  cmd;
  cmd = nvme_cmd::type_id::create("cmd", this);
  cmd.sqid = 1;
  host.post_cmd(cmd); 
  phase.drop_objection();  //droping objection
endtask
