class esp_host_mgr extends uvm_object;

  int             mgr_id;
  int             num_of_bar; 
  S_BAR_RANGE     bar_range[];
  E_CTRLER_STATE  state = ST_RESET;

  `uvm_object_utils(esp_host_mgr)

  extern function new(string name="esp_host_mgr");

endclass


function esp_host_mgr::new(string name="esp_host_mgr");
  super.new(name);
endfunction



