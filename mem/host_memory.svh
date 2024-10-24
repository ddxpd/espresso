class host_memory;

      U8       mem[U64];
      U64      start_addr = 'h0;
      U64      end_addr   = 'h4000_0000 - 1;

      U8       dft_val    = 'hff;

  extern function             new(string name="host_memory");
  extern function void        init();
  //extern function void        malloc_space(int size, ref U64 addr);
  extern function void        fill_byte_data_direct(U64 addr, U8 data);
  extern function void        fill_dw_data_direct(U64 addr, U32 data);
  extern function void        fill_dw_data_array_direct(U64 addr, ref U32 data[]);
  extern function void        fill_byte_data_array_direct(U64 addr, ref U8 data[]);
  extern function void        fill_dw_data_queue_direct(U64 addr, int byte_size, ref U32 data[$]);
  extern function void        fill_byte_data_queue_direct(U64 addr, int byte_size, ref U8 data[$]);

  extern function void        take_byte_data_direct(U64 addr, ref U8 data);
  extern function void        take_dw_data_direct(U64 addr, ref U32 data);
  extern function void        take_byte_data_array_direct(U64 addr, ref U8 data[]);
  extern function void        take_dw_data_array_direct(U64 addr, ref U32 data[]);
  extern function void        take_byte_data_queue_direct(U64 addr, int byte_size, ref U8 data[$]);
  extern function void        take_dw_data_queue_direct(U64 addr, int byte_size, ref U32 data[$]);

endclass



function host_memory::new(string name="host_memory");
  init();
endfunction



function void host_memory::init();
  for(int i = 0; i < 'h10_0000; i++)
    mem[i] = 0;
endfunction



function void host_memory::fill_byte_data_direct(U64 addr, U8 data);
  mem[addr] = data;
  $display("fill_byte_data_direct mem[%0h] = %0h", addr, mem[addr]);
endfunction



function void host_memory::fill_dw_data_direct(U64 addr, U32 data);
  mem[addr  ] = data[ 7: 0];
  mem[addr+1] = data[15: 8];
  mem[addr+2] = data[23:16];
  mem[addr+3] = data[31:24];
  $display("fill_dw_data_direct, addr = %0h, U32 data = %0h", addr, data);
  $display("mem[%0h] = %0h", addr, mem[addr]);
  $display("mem[%0h] = %0h", addr, mem[addr+1]);
  $display("mem[%0h] = %0h", addr, mem[addr+2]);
  $display("mem[%0h] = %0h", addr, mem[addr+3]);
endfunction



function void host_memory::fill_dw_data_array_direct(U64 addr, ref U32 data[]);
  int size = data.size();
  $display("fill_dw_data_array_direct, U32 data size = %0d", size); 
  for(int i = 0; i < size; i++)begin
    mem[addr]   = data[i][ 7: 0];
    mem[addr+1] = data[i][15: 8];
    mem[addr+2] = data[i][23:16];
    mem[addr+3] = data[i][31:24];
    $display("fill_dw_data_array_direct, addr = %0h, data[%0d] = %0h", addr, i, data[i]);
    $display("mem[%0h] = %0h", addr, mem[addr]);
    $display("mem[%0h] = %0h", addr, mem[addr+1]);
    $display("mem[%0h] = %0h", addr, mem[addr+2]);
    $display("mem[%0h] = %0h", addr, mem[addr+3]);
    addr += 4;
  end
endfunction



function void host_memory::fill_byte_data_array_direct(U64 addr, ref U8 data[]);
  int size = data.size();
  $display("fill_byte_data_array_direct, U8 data size = %0d", size);
  for(int i = 0; i < size; i++)begin
    mem[addr] = data[i];
    $display("fill_byte_data_array_direct, mem[%0h] = %0h", addr, mem[addr]);
  end
endfunction



function void host_memory::fill_dw_data_queue_direct(U64 addr, int byte_size, ref U32 data[$]);
  $display("fill_dw_data_queue_direct, U32 data size = %0d", byte_size); 
  for(int i = 0; i < byte_size/4; i++)begin
    mem[addr]   = data[i][ 7: 0];
    mem[addr+1] = data[i][15: 8];
    mem[addr+2] = data[i][23:16];
    mem[addr+3] = data[i][31:24];
    $display("fill_dw_data_array_direct, addr = %0h, data[%0d] = %0h", addr, i, data[i]);
    $display("mem[%0h] = %0h", addr, mem[addr]);
    $display("mem[%0h] = %0h", addr, mem[addr+1]);
    $display("mem[%0h] = %0h", addr, mem[addr+2]);
    $display("mem[%0h] = %0h", addr, mem[addr+3]);
    addr += 4;
  end
endfunction



function void host_memory::fill_byte_data_queue_direct(U64 addr, int byte_size, ref U8 data[$]);
  $display("fill_byte_data_queue_direct, U8 data size = %0d", byte_size);
  for(int i = 0; i < byte_size; i++)begin
    mem[addr] = data[i];
    $display("fill_byte_data_array_direct, mem[%0h] = %0h", addr, mem[addr]);
  end
endfunction



function void host_memory::take_byte_data_direct(U64 addr, ref U8 data);
  data = mem[addr];
  $display("take_byte_data_direct, mem[%0h] = %0h, got U8 data = %0h", addr, mem[addr], data);
endfunction



function void host_memory::take_dw_data_direct(U64 addr, ref U32 data);
   data[ 7: 0] = mem.exists(addr)   ? mem[addr  ] : dft_val;
   data[15: 8] = mem.exists(addr+1) ? mem[addr+1] : dft_val;
   data[23:16] = mem.exists(addr+2) ? mem[addr+2] : dft_val;
   data[31:24] = mem.exists(addr+3) ? mem[addr+3] : dft_val;
   $display("take_dw_data_direct, addr %0h got U32 data = %0h", addr, data);
endfunction



function void host_memory::take_byte_data_array_direct(U64 addr,  ref U8 data[]);
  int size = data.size();
  $display("take_byte_data_array_direct, U8 data size = %0d", size);
  for(int i = 0; i < size; i++)begin
   data[i] = mem.exists(addr) ? mem[addr] : dft_val;
   $display("take_byte_data_array_direct, mem[%0h] = %0h, got U8 data = %0h", addr, mem[addr], data[i]);
   addr++;
  end
endfunction



function void host_memory::take_dw_data_array_direct(U64 addr,  ref U32 data[]);
  int size = data.size();
  $display("take_dw_data_array_direct, U32 data size = %0d", size);
  for(int i = 0; i < size; i++)begin
    data[i][ 7: 0] = mem.exists(addr)   ? mem[addr  ] : dft_val;
    data[i][15: 8] = mem.exists(addr+1) ? mem[addr+1] : dft_val;
    data[i][23:16] = mem.exists(addr+2) ? mem[addr+2] : dft_val;
    data[i][31:24] = mem.exists(addr+3) ? mem[addr+3] : dft_val;
    $display("take_dw_data_array_direct, addr %0h got U32 data = %0h", addr, data[i]);
    addr += 4;
  end
endfunction




function void host_memory::take_byte_data_queue_direct(U64 addr, int byte_size, ref U8 data[$]);
  $display("take_byte_data_array_direct, U8 data size = %0d", byte_size);
  for(int i = 0; i < byte_size; i++)begin
   data[i] =  mem.exists(addr) ? mem[addr] : dft_val;
   $display("take_byte_data_array_direct, mem[%0h] = %0h, got U8 data = %0h", addr, mem[addr], data[i]);
   addr++;
  end

endfunction



function void host_memory::take_dw_data_queue_direct(U64 addr, int byte_size, ref U32 data[$]);
  $display("take_dw_data_array_direct, U32 data size = %0d", byte_size);
  for(int i = 0; i < byte_size/4; i++)begin
    data[i][ 7: 0] = mem.exists(addr)   ? mem[addr  ] : dft_val;
    data[i][15: 8] = mem.exists(addr+1) ? mem[addr+1] : dft_val;
    data[i][23:16] = mem.exists(addr+2) ? mem[addr+2] : dft_val;
    data[i][31:24] = mem.exists(addr+3) ? mem[addr+3] : dft_val;
    $display("take_dw_data_array_direct, addr %0h got U32 data = %0h", addr, data[i]);
    addr += 4;
  end
endfunction
