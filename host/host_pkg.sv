package host_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import misc_pkg::*;
  import bfm_pkg::*;
  import host_mem_pkg::*;
  import nvme_trans_lib_pkg::*;

  typedef struct {
    bit [63:0]  baddr;
    bit [63:0]  size;
  } S_BAR_RANGE;

  typedef enum {
    ST_RESET,
    ST_SET_PCIE_RANGE,
    ST_DONE
  } E_CTRLER_STATE;

  `include "esp_host_mgr.svh"
  `include "base_q.svh"
  `include "nvme_msix_vector.svh"
  `include "nvme_namespace.svh"
  `include "nvme_cmd.svh"
  //`include "esp_host_sq.svh"
  `include "nvme_cpl_entry.svh"
  `include "dut.svh"
  `include "esp_host_software.svh"
  
  
endpackage

