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
  uvm_config_db#(virtual host_intf)::get(this, "*" ,"host_vif", hvif);
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
  `uvm_info(get_name(), $sformatf("test here 1" ), UVM_LOW)  
  phase.raise_objection(this); //rasing objection
  `uvm_info(get_name(), $sformatf("test here 2" ), UVM_LOW)  
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
      `uvm_info(get_name(), $sformatf("cmd all send" ), UVM_LOW)
    end
    begin
      while (!(num_cmd_send == num_cmd_done && cmd_all_send == 1)) begin
        num_cmd_done = 0;
        foreach(cmd_q[i])begin
          if(cmd_q[i].state == CMD_DONE)begin
            num_cmd_done++;
            `uvm_info(get_name(), $sformatf("cmd done %0d", num_cmd_done), UVM_LOW) 
          end
        end
        #1000ns; 
        //`uvm_info(get_name(), $sformatf("state2 num_cmd_send = %0d num_cmd_done = %0d, cmd_all_send = %0d", num_cmd_send, num_cmd_done, cmd_all_send), UVM_LOW)
      end 
    end
  join
  `uvm_info(get_name(), $sformatf("test before finish"), UVM_LOW) 
  phase.drop_objection(this);  //droping objection
endtask
