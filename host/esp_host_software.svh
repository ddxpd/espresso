parameter  NUM_DW_SQE = 16;

class esp_host extends uvm_object;
  `uvm_object_utils(esp_host)

  extern task post_cmd(cmd_entry cmd);

endclass


task esp_host::post_cmd(cmd_entry cmd);
  //bit[7:0]    ;   
  bit        is_admin;

  //check which Q the cmd belongs to
  if(cmd.sqid == 0)begin
    is_admin = 1;
  end
  else begin
    is_admin = 0;
  end

  //check if the corresponding SQ has enough space to put the cmd

  if(is_admin == 0 && cmd.SQE_DW[0][7:0] == 'h01)begin
    int nsid = cmd.SQE_DW[1];
    int nlb  = cmd.SQE_DW[12][15:0];
    int cmd_size;
    //calculate the cmd size
    //...
    cmd_size = nlb * nlb_size;
    cmd.create_data(cmd_size, data_pattern); 
  end
    
  
endtask







class cmd_entry extends uvm_object;
  `uvm_object_utils(cmd_entry)

       bit [31:0]     SQE_DW[NUM_DW_SQE];
  rand bit [7:0]      opc;
       bit [7:0]      data[];

  extern function new(string name="cmd_entry");
  extern function void create_data(int size, string dp = "INCR");

  
endclass


function void cmd_entry::create_data(int size, string dp = "INCR");
  case(dp)
    "INCR":begin
             
           end
  endcase
endfunction




