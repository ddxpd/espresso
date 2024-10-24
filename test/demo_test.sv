class demo_test extends uvm_test;
  `uvm_component_utils(demo_test)

          esp_host       host;
          nvme_dut       DUT; 
          host_memory    host_mem;
  virtual host_intf      hvif;

          esp_host_mgr   mgr;

  extern function        new(string name, uvm_component parent);
  extern function void   build_phase(uvm_phase phase);
  extern function void   connect_phase(uvm_phase phase);
  extern task            main_phase(uvm_phase phase);

endclass



function demo_test::new (string name, uvm_component parent);
  super.new(name,parent);
endfunction



function void demo_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  host       = esp_host::type_id::create("host", this);
  DUT        = nvme_dut::type_id::create("DUT", this);
  host_mem   = new();
  if(!uvm_config_db#(virtual host_intf)::get(this, "*" ,"host_vif", hvif))
    `uvm_fatal(get_name(), $sformatf("Can not get the interface")) 
  `uvm_info(get_name(), $sformatf("got the interface" ), UVM_LOW)  
endfunction



function void demo_test::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  host.host_mem     = host_mem;
  host.DUT          = DUT;
  host.hvif         = hvif;
  DUT.hvif          = hvif;
  hvif.host_mem     = host_mem;
endfunction



task demo_test::main_phase(uvm_phase phase);
  nvme_cmd     cmd;
  nvme_cmd     cmd_q[$];
  int          num_cmd_send, num_cmd_done, cmd_all_send;
  int          fid = 3;
  U64          baddr[], size[];
  U32          rdata[], wdata[];
  S_CSTS       csts;
  S_CC         cc;

  phase.raise_objection(this); //rasing objection


  //Set pcie ranges. BAR0 is for CAP
  //When set_host_ranges is called, the corresponding mgr is created.
  baddr = new[5];
  size = new[5];
  foreach (baddr[bar]) begin
    baddr[bar] = fid * 64'h1000_0000 + bar * 64'h10_0000;
    size[bar]  = 64'h1_0000;
  end
  host.set_host_ranges(fid, baddr, size, mgr);

  //Let interface now the pcie ranges, so DUT can get it.
  foreach (mgr.bar_range[bar]) begin
    hvif.pcie_range_baddr[mgr.fid][bar] = mgr.bar_range[bar].baddr;
    hvif.pcie_range_size[mgr.fid][bar]  = mgr.bar_range[bar].size;
  end

  //A flag to let DUT know pcie ranges have been set.
  hvif.pcie_enum_done = 1;
  #10ns;

  //Read CAP
  host.read_nvme_cap(fid, CAP_CAP, 2, rdata);
  host.read_nvme_cap(fid, CAP_VERSION, 1, rdata);

  //CSTS.RDY should be 0
  do begin
    host.read_nvme_cap(fid, CAP_CSTS, 1, rdata);
    csts = rdata[0];
    #1ns;
  end while (csts.RDY != 0);

  //Allocate ASQ/ACQ, temp qsize is set to 0x100

  //Set CC.EN
  cc.EN = 1;
  wdata = new[1];
  wdata[0] = cc;
  host.write_nvme_cap(fid, CAP_CC, wdata);
  `uvm_info(get_name(), $sformatf("mgr %0d Host writes CC.EN=1", fid), UVM_NONE)

  //Wait CSTS.RDY to be 1
  do begin
    host.read_nvme_cap(fid, CAP_CSTS, 1, rdata);
    csts = rdata[0];
    #1ns;
  end while (csts.RDY == 0);
  `uvm_info(get_name(), $sformatf("mgr %0d Controller writes CSTS.RDY=1", fid), UVM_NONE)


  phase.drop_objection(this);  //droping objection
endtask
