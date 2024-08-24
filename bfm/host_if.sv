interface host_intf();
//  input bit clk
//);
  import misc_pkg::*;
  import host_mem_pkg::*;

  host_memory  host_mem;
  bit          msix_intr_happens;
  U64          test;
  


  function clear_msix_intr();
    msix_intr_happens = 0; 
  endfunction 

  
  function void fill_byte_data_direct(U64 addr, U8 data);
    host_mem.fill_byte_data_direct(addr, data);
  endfunction



  function void fill_dw_data_direct(U64 addr, U32 data);
    if(addr == 'h00000001 && data == 'h12345678)
      msix_intr_happens = 1; 
    host_mem.fill_dw_data_direct(addr, data);
  endfunction
  
  
  
  function automatic void fill_dw_data_group_direct(U64 addr, ref U32 data[]);
    U32  data_temp[];
    int  size = data.size();
    data_temp = new[size];
    foreach(data[i])
      data_temp[i] = data[i];
    host_mem.fill_dw_data_group_direct(addr, data_temp);
  endfunction
  
  
  
  function automatic void fill_byte_data_group_direct(U64 addr, ref U8 data[]);
    U8   data_temp[];
    int  size = data.size();
    data_temp = new[size];
    foreach(data[i])
      data_temp[i] = data[i];
    host_mem.fill_byte_data_group_direct(addr, data_temp);
  endfunction
  
  
  
  function void take_byte_data_direct(U64 addr, U8 data);
    host_mem.take_byte_data_direct(addr, data);
  endfunction
  
  
  
  function void take_dw_data_direct(U64 addr, U32 data);
    host_mem.take_dw_data_direct(addr, data);
  endfunction
  
  
  
  function automatic void take_byte_data_group_direct(U64 addr, ref U8 data[]);
    U8   data_temp[];
    int  size = data.size();
    data_temp = new[size];
    foreach(data[i])
      data_temp[i] = data[i];
    host_mem.take_byte_data_group_direct(addr, data_temp);
  endfunction
  
  
  
  function automatic void take_dw_data_group_direct(U64 addr, ref U32 data[]);
    U32  data_temp[];
    int  size = data.size();
    data_temp = new[size];
    foreach(data[i])
      data_temp[i] = data[i];
    host_mem.take_dw_data_group_direct(addr, data_temp);
  endfunction

endinterface



