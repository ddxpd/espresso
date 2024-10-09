class nvme_cpl_entry extends uvm_object;

  `uvm_object_utils_begin(nvme_cpl_entry)
  `uvm_object_utils_end

       U32     CQE_DW[];

  extern function         new(string name="nvme_cpl_entry");
  extern function U16     get_sqid();
  extern function U16     get_cid();

endclass


function nvme_cpl_entry::new(string name="nvme_cpl_entry");
  super.new(name);
  CQE_DW = new[NUM_DW_CDE];
endfunction



function U16 nvme_cpl_entry::get_sqid();
  return CQE_DW[2][31:16];
endfunction



function U16 nvme_cpl_entry::get_cid();
  return CQE_DW[3][15:0];
endfunction



//function void nvme_cpl_entry::();
//
//endfunction

