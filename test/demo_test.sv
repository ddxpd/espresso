class demo_test extends uvm_test;
  `uvm_component_utils(demo_test)

          esp_host       host;
          nvme_dut       DUT; 
          host_memory    host_mem;
  virtual host_intf      hvif;

          esp_host_mgr   mgrs[];

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
  nvme_cmd  cmd;
  nvme_cmd  cmd_q[$];
  int       num_cmd_send, num_cmd_done, cmd_all_send;
  phase.raise_objection(this); //rasing objection

  mgrs = new[3];

  foreach (mgrs[i]) begin
    bit [63:0] baddr[], size[];
    baddr = new[5];
    size = new[5];
    foreach (baddr[bar]) begin
      baddr[bar] = i * 64'h1000_0000 + bar * 64'h10_0000;
      size[bar]  = 64'h1_0000;
    end
    host.set_host_ranges(i, baddr, size, mgrs[i]);
  end

  foreach (mgrs[i]) begin
    foreach (mgrs[i].bar_range[bar]) begin
      hvif.pcie_range_baddr[mgrs[i].fid][bar] = mgrs[i].bar_range[bar].baddr;
      hvif.pcie_range_size[mgrs[i].fid][bar]  = mgrs[i].bar_range[bar].size;
    end
  end
  hvif.pcie_enum_done = 1;
  #10ns;

  foreach (mgrs[i]) begin
    U32 rdata[], wdata[];
    S_CSTS csts;
    S_CC   cc;
    host.read_nvme_cap(i, CAP_CAP, 2, rdata);
    host.read_nvme_cap(i, CAP_VERSION, 1, rdata);

    do begin
      host.read_nvme_cap(i, CAP_CSTS, 1, rdata);
      csts = rdata[0];
      #1ns;
    end while (csts.RDY != 0);

    cc.EN = 1;
    wdata = new[1];
    wdata[0] = cc;
    host.write_nvme_cap(i, CAP_CC, wdata);
    `uvm_info(get_name(), $sformatf("mgr %0d Host writes CC.EN=1", i), UVM_NONE)

    do begin
      host.read_nvme_cap(i, CAP_CSTS, 1, rdata);
      csts = rdata[0];
      #1ns;
    end while (csts.RDY == 0);
    `uvm_info(get_name(), $sformatf("mgr %0d Controller writes CSTS.RDY=1", i), UVM_NONE)
  end


  phase.drop_objection(this);  //droping objection
endtask
