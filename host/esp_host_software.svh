parameter  NUM_DW_SQE = 16;

class esp_host extends uvm_object;
  `uvm_object_utils(esp_host)

  host_memory    host_mem;

  extern function new(string name="esp_host"); 
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

 

  if(is_admin == 0 && cmd.SQE_DW[0][7:0] == 'h01)begin
    int nsid = cmd.SQE_DW[1];
    int nlb  = cmd.SQE_DW[12][15:0];
    int cmd_size;
    //calculate the cmd size
    //...
    //calculate_cmd_size();
    cmd_size = nlb * nlb_size;
    //host assign the host memory space to the data and return DSPT
    malloc_memory_space(cmd);
    //malloc host memory for PRP List
    //fill PRP List or SGL DSPT to host memory

    //check if the corresponding SQ has enough space to put the cmd
    //When PRP and SGL is ready, put the cmd to related SQ
    fill_cmd_to_SQ(cmd);
        

    //create data for cmd
    cmd.create_data(cmd_size, data_pattern); 
    //fill data to host mem
    fill_data_to_host_mem(cmd); 
    
    
  end
    
endtask



function esp_host::calculate_cmd_size();

endfunction


function esp_host::malloc_memory_space(cmd_entry cmd);
  bit[63:0] addr;
  malloc_space(cmd.cmd_size, addr);
  cmd.SQE_DW[6] = addr[31:0];
  cmd.SQE_DW[7] = addr[63:32];
  //PRP and SGL
endfunction


function esp_host::fill_data_to_host_mem(cmd);
  bit[63:0] addr;
  bit       size;

  size = cmd.data.size();
  addr = {cmd.SQE_DW[7], cmd.SEQ_DW[6]};
  for(int i; i < size; i++)
  host_mem.fill_data_by_byte(addr+i, cmd.data[i]);
endfunction



function esp_host::fill_cmd_to_SQ(cmd);
  bit[63:0] addr;
  bit       size;

  addr = get_cmd_positon();
  host_mem.fill_data_group_by_dw(addr, cmd.SQE_DW);
endfunction


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



class host_memory;

       bit [31:0]     mem[ bit[63:0] ];


  extern function new(string name="host_memory");
  extern function void fill_data_by_byte(bit[63:0] addr, bit[7:0] data);
  extern function void fill_data_by_dw(bit[63:0] addr, bit[31:0] data);
  extern function void malloc_space(int size, ref bit[63:0] addr);

  
endclass



function void host_memory::fill_data_by_byte(bit[63:0] addr, bit[7:0] data);
  mem[addr] = data;
endfunction



function void host_memory::fill_data_by_dw(bit[63:0] addr, bit[31:0] data);
  mem[addr  ] = data[ 7: 0];
  mem[addr+1] = data[15: 8];
  mem[addr+2] = data[23:16];
  mem[addr+3] = data[31:24];
endfunction



function void host_memory::fill_data_group_by_dw(bit[63:0] addr, const ref bit[31:0] data[$]);
  int size = data.size();
  for(int i; i < size; i++)begin
    mem[addr  ] = data[i][ 7: 0];
    mem[addr+1] = data[i][15: 8];
    mem[addr+2] = data[i][23:16];
    mem[addr+3] = data[i][31:24];
    addr += 4;
  end
endfunction
