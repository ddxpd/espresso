class esp_host_callback extends uvm_callback;

  `uvm_object_utils(esp_host_callback)

  function new(string name = "esp_host_callback");
    super.new(name);
  endfunction

  extern virtual function void host_init_before_cc_en(esp_host_mgr mgr);
endclass


