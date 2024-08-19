class cmd_entry extends uvm_object;
  `uvm_object_utils(cmd_entry)

       bit [31:0]     SQE_DW[NUM_DW_SQE];
  rand bit [7:0]      opc;
       bit [7:0]      data[];

  extern function new(string name="cmd_entry");
  extern function void create_data(int size, string dp = "INCR");

  
endclass


function void cmd_entry::create_data(int size, string dp = "INCR");
  data = new[size];
  case(dp)
    "INCR":begin
	     for(int i = 0; i < size; i++)
               data[i] = i; 
           end
  endcase
endfunction
