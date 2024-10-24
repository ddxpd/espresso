class nvme_cpl_entry extends uvm_object;

       U32     CQE_DW[];
       int     fid = -1;

  `uvm_object_utils_begin(nvme_cpl_entry)
    `uvm_field_int      (fid, UVM_ALL_ON)
  `uvm_object_utils_end

  extern function            new(string name="nvme_cpl_entry");
  extern function U16        get_sqid();
  extern function U16        get_cid();
  extern function bit[14:0]  get_status();

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



function bit[14:0] nvme_cpl_entry::get_status();
  return CQE_DW[3][31:16];
endfunction

