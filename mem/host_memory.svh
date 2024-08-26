class host_memory;

      U8   mem[];


  extern function             new(string name="host_memory");
  extern function             init(int mem_size);
  //extern function void        malloc_space(int size, ref U64 addr);
  extern function void        fill_byte_data_direct(U64 addr, U8 data);
  extern function void        fill_dw_data_direct(U64 addr, U32 data);
  extern function void        fill_dw_data_group_direct(U64 addr, ref U32 data[]);
  extern function void        fill_byte_data_group_direct(U64 addr, ref U8 data[]);
  extern function void        take_byte_data_direct(U64 addr, U8 data);
  extern function void        take_dw_data_direct(U64 addr, U32 data);
  extern function void        take_byte_data_group_direct(U64 addr, ref U8 data[]);
  extern function void        take_dw_data_group_direct(U64 addr, ref U32 data[]);

endclass



function host_memory::new(string name="host_memory");
  init('h1_0000_0000);
endfunction



function host_memory::init(int mem_size);
  mem = new[mem_size];
endfunction



function void host_memory::fill_byte_data_direct(U64 addr, U8 data);
  mem[addr] = data;
endfunction



function void host_memory::fill_dw_data_direct(U64 addr, U32 data);
  mem[addr  ] = data[ 7: 0];
  mem[addr+1] = data[15: 8];
  mem[addr+2] = data[23:16];
  mem[addr+3] = data[31:24];
endfunction



function void host_memory::fill_dw_data_group_direct(U64 addr, ref U32 data[]);
  int size = data.size();
  $display("host mem debug size = %0d", size); 
  for(int i; i < size; i++)begin
    mem[addr] = data[i][ 7: 0];
    $display("mem[%0h] = %0h data[i] = %0h", addr, mem[addr], data[i][ 7: 0]); 
    mem[addr+1] = data[i][15: 8];
    $display("mem[%0h] = %0h data[i] = %0h", addr+1, mem[addr+1], data[i][15: 8]); 
    mem[addr+2] = data[i][23:16];
    $display("mem[%0h] = %0h data[i] = %0h", addr+2, mem[addr+2], data[i][23:16]); 
    mem[addr+3] = data[i][31:24];
    $display("mem[%0h] = %0h data[i] = %0h", addr+3, mem[addr+3], data[i][31:24]); 
    addr += 4;
  end
endfunction



function void host_memory::fill_byte_data_group_direct(U64 addr, ref U8 data[]);
  int size = data.size();
  for(int i; i < size; i++)begin
    mem[addr] = data[i];
  end
endfunction



function void host_memory::take_byte_data_direct(U64 addr, U8 data);
  data = mem[addr];
endfunction



function void host_memory::take_dw_data_direct(U64 addr, U32 data);
   data[ 7: 0] = mem[addr  ];
   data[15: 8] = mem[addr+1];
   data[23:16] = mem[addr+2];
   data[31:24] = mem[addr+3];
endfunction



function void host_memory::take_byte_data_group_direct(U64 addr,  ref U8 data[]);
  int size = data.size();
  for(int i; i < size; i++)begin
   data[i] =  mem[addr];
  end
endfunction



function void host_memory::take_dw_data_group_direct(U64 addr,  ref U32 data[]);
  int size = data.size();
  for(int i; i < size; i++)begin
    data[i][ 7: 0] = mem[addr  ];
    data[i][15: 8] = mem[addr+1];
    data[i][23:16] = mem[addr+2];
    data[i][31:24] = mem[addr+3];
    addr += 4;
  end
endfunction







