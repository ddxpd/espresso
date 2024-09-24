class nvme_namespace extends uvm_object;
  
  bit [31:0]    nsid;             //Namespace id    
  //bit [7:0]     num_lba;          // Number of LBA Formats (NLBAF)
  bit [7:0]     lba_data_size;    //LBA Data Size (LBADS)
  bit [15:0]    meta_data_size;   //Metadata Size (MS)

  bit           is_active;
      

  `uvm_object_utils(nvme_namespace)

  //`uvm_object_utils_begin(nvme_cmd)
  //  `uvm_field_int      (addr, UVM_ALL_ON)
  //  `uvm_field_queue_int(data, UVM_ALL_ON)
  //  `uvm_field_object   (ext,  UVM_ALL_ON)
  //  `uvm_field_string   (str,  UVM_ALL_ON)
  //`uvm_object_utils_end


endclass

