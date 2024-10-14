class nvme_namespace extends uvm_object;
  
  bit [31:0]    nsid;             //Namespace id    
  //namespace size
  //
  //bit [7:0]     num_lba;        // Number of LBA Formats (NLBAF)
  bit [7:0]     lba_ds;           //LBA Data Size (LBADS)
  bit [15:0]    meta_ds;          //Metadata Size (MS)
  
  bit           meta_in_extended; //Metadata Transferred as Extended LBA (MTELBA)
  bit           pi_position;      //Protection Information Position (PIP)
  bit           pi_type;          //Protection Information Type (PIT)
                                  //000b Protection information is not enabled
                                  //001b Type 1 protection information is enabled
                                  //010b Type 2 protection information is enabled
                                  //011b Type 3 protection information is enabled
  
                //supt: support
  bit           supt_meta_in_separate; //Metadata Transferred as Separate Buffer Support(MTSBS)
  bit           supt_meta_in_extended; //Metadata Transferred as Extended LBA Support(MTELBAS):
  bit           supt_pi_in_lb;         //Protection Information In Last Bytes (PIILB)
  bit           supt_pi_in_fb;         //Protection Information In First Bytes (PIIFB)
  bit           supt_pi_type3;         //Protection Information Type 3 Supported (PIT3S)
  bit           supt_pi_type2;         //Protection Information Type 2 Supported (PIT2S)
  bit           supt_pi_type1;         //Protection Information Type 1 Supported (PIT1S):

  bit           is_active;
      

  `uvm_object_utils(nvme_namespace)

  //`uvm_object_utils_begin(nvme_cmd)
  //  `uvm_field_int      (addr, UVM_ALL_ON)
  //  `uvm_field_queue_int(data, UVM_ALL_ON)
  //  `uvm_field_object   (ext,  UVM_ALL_ON)
  //  `uvm_field_string   (str,  UVM_ALL_ON)
  //`uvm_object_utils_end


endclass

