module top;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import misc_pkg::*;
  import bfm_pkg::*;
  import test_pkg::*;

  host_intf     host_if();

  initial begin
    uvm_config_db #(virtual host_intf)::set(null, "uvm_test_top.*", "host_vif", host_if);
    run_test();
  end
endmodule
