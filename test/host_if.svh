interface host_intf();


  host_memory  host_mem;
  bit          msix_intr_happens;
  


  function clear_msix_intr();
    msix_intr_happens = 0; 
  endtask 

  
  function void host_memory::fill_byte_data_direct(U64 addr, U8 data);
    host_mem.fill_byte_data_direct(addr, data);
  endfunction



  function void fill_dw_data_direct(U64 addr, U32 data);
    if(addr == 'h00000001 && data == 'h12345678)
      msix_intr_happens = 1; 
    host_mem.fill_dw_data_direct(addr, data);
  endfunction
  
  
  
  function void fill_dw_data_group_direct(U64 addr, const ref U32 data[$]);
    host_mem.(addr, data);
  endfunction
  
  
  
  function void fill_byte_data_group_direct(U64 addr, const ref U8 data[$]);
    host_mem.fill_dw_data_group_direct(addr, data);
  endfunction
  
  
  
  function void take_byte_data_direct(U64 addr, U8 data);
    host_mem.take_byte_data_direct(addr, data);
  endfunction
  
  
  
  function void take_dw_data_direct(U64 addr, U32 data);
    host_mem.take_dw_data_direct(addr, data);
  endfunction
  
  
  
  function void take_byte_data_group_direct(U64 addr, const ref U8 data[$]);
    host_mem.take_byte_data_group_direct(addr, data);
  endfunction
  
  
  
  function void take_dw_data_group_direct(U64 addr, const ref U32 data[$]);
    host_mem.take_dw_data_group_direct(addr, data);
  endfunction

endinterface



