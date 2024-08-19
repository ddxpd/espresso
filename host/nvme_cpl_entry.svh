class nvme_cpl_entry extends uvm_object;
  `uvm_object_utils(nvme_cpl_entry)

       bit [31:0]     CQE_DW[NUM_DW_CDE];


  extern function new(string name="nvme_cpl_entry");

  
endclass


function new nvme_cpl_entry::(string name="nvme_cpl_entry");
endfunction



function void nvme_cpl_entry::();

endfunction
