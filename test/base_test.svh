class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  esp_host       host;
  nvme_dut       DUT; 
  host_memory    host_mem;


  extern function new (string name, uvm_component parent);
endclass


function base_test::new (string name, uvm_component parent);
  super.new(name,parent);
  `uvm_info(get_name(), "******************INIT_TEST PASS******************", UVM_NONE)
endfunction



function base_test::build_phase();
  super.build_phase();
  host       = esp_host::type_id::create("host", this);
  DUT        = nvme_dut::type_id::create("DUT", this);
  host_mem   = host_memory::type_id::create("host_mem", this);
endfunction



function base_test::connect_phase();
  super.connect_phase();
  host.host_mem = host_mem;
  host.DUT      = DUT;
  DUT.host_mem  = host_mem;
endfunction



task base_test::connect_phase();
endtask
