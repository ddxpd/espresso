class base_test extends uvm_test;
  `uvm_component_utils(base_test)

          esp_host       host;
          nvme_dut       DUT; 
          host_memory    host_mem;
  virtual host_intf      hvif;


  extern function        new(string name, uvm_component parent);
  extern function void   build_phase(uvm_phase phase);
  extern function void   connect_phase(uvm_phase phase);
  extern task            main_phase(uvm_phase phase);

endclass



function base_test::new (string name, uvm_component parent);
  super.new(name,parent);
endfunction



function void base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  host       = esp_host::type_id::create("host", this);
  DUT        = nvme_dut::type_id::create("DUT", this);
  host_mem   = new();
  if(!uvm_config_db#(virtual host_intf)::get(this, "*" ,"host_vif", hvif))
    `uvm_fatal(get_name(), $sformatf("Can not get the interface")) 
  `uvm_info(get_name(), $sformatf("got the interface" ), UVM_LOW)  
endfunction



function void base_test::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  host.host_mem     = host_mem;
  host.DUT          = DUT;
  host.hvif         = hvif;
  DUT.hvif          = hvif;
  hvif.host_mem     = host_mem;
endfunction



task base_test::main_phase(uvm_phase phase);
  nvme_cmd  cmd;
  nvme_cmd  cmd_q[$];
  int       num_cmd_send, num_cmd_done, cmd_all_send;
  phase.raise_objection(this); //rasing objection
  fork
    begin
      cmd = nvme_cmd::type_id::create("cmd", this);
      cmd.sqid = 1;
      cmd.opc = NVME_WRITE;
      host.post_cmd(cmd); 
      num_cmd_send++;
      cmd_q.push_back(cmd);
      #3000ns;
      cmd_all_send = 1;
      `uvm_info(get_name(), $sformatf("All cmd has sent"), UVM_LOW)
    end
    begin
      while (!(num_cmd_send == num_cmd_done && cmd_all_send == 1)) begin
        num_cmd_done = 0;
        foreach(cmd_q[i])begin
          if(cmd_q[i].state == CMD_DONE)begin
            num_cmd_done++;
          end
        end
        `uvm_info(get_name(), $sformatf("%0d cmd is already done", num_cmd_done), UVM_LOW)
        #1000ns; 
      end 
    end
  join
  phase.drop_objection(this);  //droping objection
endtask
