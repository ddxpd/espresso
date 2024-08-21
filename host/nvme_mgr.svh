class nvme_function_manager extends uvm_object;

  `uvm_object_utils(nvme_function_manager)

  extern function new(string name="nvme_function_manager");

endclass


function void nvme_function_manager::new();
  super.new(name);
endfunction
