interface host_intf();
//  input bit clk
//);
  import misc_pkg::*;
  import host_mem_pkg::*;

  host_memory  host_mem;
  bit          msix_intr_happens;
  U64          msix_addr[$];
  U64          msix_data[U64];   //KEY is msix_addr;
  int          msix_id[U64];     //KEY is msix_addr;
  bit          intr_triggered[int]; //KEY is msix_addr;
  bit          pcie_enum_done = 0;
  U64          pcie_range_baddr[int][int], pcie_range_size[int][int];
 

  task send_wr_trans(U64 addr, U8 data[]);
    foreach (data[i]) begin
      fill_byte_data_direct(addr+i, data[i]);
    end
  endtask

  task automatic send_rd_trans(U64 addr, ref U8 data[]);
    foreach (data[i]) begin
      take_byte_data_direct(addr+i, data[i]);
    end
  endtask


  function void clear_msix_intr();
    msix_intr_happens = 0; 
  endfunction 



  function automatic void add_msix_vector(int id, U64 addr, U64 data);
    msix_addr.push_back(addr);
    msix_data[addr] = data;
    msix_id[addr]   = id;
  endfunction


  
  function automatic void fill_byte_data_direct(U64 addr, U8 data);
    host_mem.fill_byte_data_direct(addr, data);
  endfunction



  function automatic void fill_dw_data_direct(U64 addr, U32 data);
    U64 fq[$];
    int id;

    fq = msix_addr.find(x) with ( x == addr );
    if(fq.size() == 1)begin
      msix_intr_happens = 1; 
      id = msix_id[addr];
      intr_triggered[id] = 1;
      $display("MSIX triggered");
    end
    $display("fill_dw_data_direct addr %0x, data %0x", addr, data);
    host_mem.fill_dw_data_direct(addr, data);
  endfunction
  
  
  
  function automatic void fill_dw_data_array_direct(U64 addr, ref U32 data[]);
    U32  data_temp[];
    int  size = data.size();
    data_temp = new[size];
    foreach(data[i])begin
      data_temp[i] = data[i];
    end
    host_mem.fill_dw_data_array_direct(addr, data_temp);
  endfunction
  
  
  
  function automatic void fill_byte_data_array_direct(U64 addr, ref U8 data[]);
    U8   data_temp[];
    int  size = data.size();
    data_temp = new[size];
    foreach(data[i])
      data_temp[i] = data[i];
    host_mem.fill_byte_data_array_direct(addr, data_temp);
  endfunction
  

  
  function automatic void fill_dw_data_queue_direct(U64 addr, int byte_size, ref U32 data[$]);
    host_mem.fill_dw_data_queue_direct(addr, byte_size, data);
  endfunction
  
  
  
  function automatic void fill_byte_data_queue_direct(U64 addr, int byte_size, ref U8 data[$]);
    host_mem.fill_byte_data_queue_direct(addr, byte_size, data);
  endfunction

  
  
  function automatic void take_byte_data_direct(U64 addr, ref U8 data);
    host_mem.take_byte_data_direct(addr, data);
  endfunction
  
  
  
  function automatic void take_dw_data_direct(U64 addr, ref U32 data);
    host_mem.take_dw_data_direct(addr, data);
  endfunction
  
  
  
  function automatic void take_byte_data_array_direct(U64 addr, ref U8 data[]);
    host_mem.take_byte_data_array_direct(addr, data);
  endfunction
  
  
  
  function automatic void take_dw_data_array_direct(U64 addr, ref U32 data[]);
    U32  data_temp[];
    int  size = data.size();
    data_temp = new[size];
    host_mem.take_dw_data_array_direct(addr, data_temp);
    foreach(data[i])
      data[i] = data_temp[i];
  endfunction

  

  function automatic void take_byte_data_queue_direct(U64 addr, int byte_size, ref U8 data[$]);
    host_mem.take_byte_data_queue_direct(addr, byte_size, data);
  endfunction
  
  
  
  function automatic void take_dw_data_queue_direct(U64 addr, int byte_size, ref U32 data[$]);
    host_mem.take_dw_data_queue_direct(addr, byte_size, data);
  endfunction


endinterface



