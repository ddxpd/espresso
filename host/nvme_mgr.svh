class esp_func_manager extends uvm_object;

  `uvm_object_utils_begin(esp_func_manager)
  `uvm_object_utils_end
  
  //subq   sub_q[int];

  int    fid;
  int    num_sq_support;
  int    num_cq_support; 
  nvme_namespace  active_ns[U32];    // KEY is namespace id

  esp_host_sq     SQ[int];           // KEY is sqid
  esp_host_cq     CQ[int];           // KEY is cqid

  extern function new(string name="esp_func_manager");

endclass


function esp_func_manager::new(string name="esp_func_manager");
  super.new(name);
endfunction



