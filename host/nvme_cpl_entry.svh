class nvme_cpl_entry extends uvm_object;

  `uvm_object_utils_begin(nvme_cpl_entry)
  `uvm_object_utils_end

       U32     CQE_DW[NUM_DW_CDE];

  extern function new(string name="nvme_cpl_entry");

  
endclass


function nvme_cpl_entry::new(string name="nvme_cpl_entry");
  super.new(name);
endfunction



//function void nvme_cpl_entry::();
//
//endfunction
