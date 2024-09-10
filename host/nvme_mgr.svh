class nvme_function_manager extends uvm_object;

  `uvm_object_utils_begin(nvme_function_manager)
  `uvm_object_utils_end
  
  //subq   sub_q[int];

  int    fid;
  int    num_sq_support;
  int    num_cq_support; 
  nvme_namespace  active_ns[U32];    // KEY is namespace id

  extern function new(string name="nvme_function_manager");

endclass


function nvme_function_manager::new(string name="nvme_function_manager");
  super.new(name);
endfunction



