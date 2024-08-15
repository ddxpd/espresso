class init_test extends uvm_test;
  `uvm_component_utils(init_test)

  extern function new (string name, uvm_component parent);
endclass


function init_test::new (string name, uvm_component parent);
  super.new(name,parent);
  `uvm_info(get_name(), "******************INIT_TEST PASS******************", UVM_NONE)
endfunction

