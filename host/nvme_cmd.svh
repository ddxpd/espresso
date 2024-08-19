class nvme_cmd extends uvm_object;
  `uvm_object_utils(nvme_cmd)

       bit [31:0]     SQE_DW[NUM_DW_SQE];
  rand bit [7:0]      opc;
       bit [7:0]      data[];

  extern function new(string name="nvme_cmd");
  extern function void create_data(int size, string dp = "INCR");

  
endclass


function void nvme_cmd::create_data(int size, string dp = "INCR");
  data = new[size];
  case(dp)
    "INCR":begin
	     for(int i = 0; i < size; i++)
               data[i] = i; 
           end
  endcase
endfunction
