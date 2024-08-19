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



function void host_memory::take_data_group_by_dw(bit[63:0] addr, ref bit[31:0] data[$]);
  int size = data.size();
  for(int i; i < size; i++)begin
    data[i][ 7: 0] = mem[addr  ]; 
    data[i][15: 8] = mem[addr+1]; 
    data[i][23:16] = mem[addr+2]; 
    data[i][31:24] = mem[addr+3]; 
    addr += 4;
  end
endfunction
