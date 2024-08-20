class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  esp_host       host;
  nvme_dut       DUT; 
  host_memory    host_mem;


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
endfunction



function base_test::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  host.host_mem = host_mem;
  host.DUT      = DUT;
  DUT.host_mem  = host_mem;
endfunction



task base_test::main_phase(uvm_phase phase);
  super.main_phase(phase);
  
endtask
