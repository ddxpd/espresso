class nvme_msix_vector extends uvm_object;

  `uvm_object_utils_begin(nvme_msix_vector)
  `uvm_object_utils_end

  int   vid;
  U64   addr;
  U64   data;

  function new(string name="nvme_msix_vector");
    super.new(name);
  endfunction

endclass




