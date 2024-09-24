class esp_user_ctrl extends uvm_object;

  `uvm_object_utils_begin(esp_user_ctrl)
  `uvm_object_utils_end
  
  int   sqid;
  int   cqid;
  int   cid;

  extern function new(string name="esp_user_ctrl");

endclass



