class mem_slice extends uvm_object;

  static int    slice_cnt;  //1 based
  int           slice_id;
  
  U64           start_addr;
  U64           end_addr;
  U64           size;
  bit           in_use;

  `uvm_object_utils(mem_slice)
  

  function new(string name="mem_slice");
    super.new(name);
    slice_id = slice_cnt;
    slice_cnt++;
  endfunction


  function void calculate_size();
    size = end_addr + 1 - start_addr;
  endfunction
  
endclass





class host_memory_manager extends uvm_component;

  `uvm_component_utils(host_memory_manager)     
  
  host_memory    host_mem;
  mem_slice      slice[$];

  int        unit_size = 4096; //Bytes
  

  extern function    new(string name, uvm_component parent);
  extern function    init();
  extern task        malloc(int req_size, output U64 addr, output bit suc, input int timeout = 10000);   //TODO page unaligned
  extern task        free(U64 addr);  
endclass



function host_memory_manager::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction



function host_memory_manager::init();
  U64         mem_start_addr;
  U64         mem_end_addr;
  U64         curr_addr;
  mem_slice   ms;

  mem_start_addr = host_mem.start_addr;
  mem_end_addr   = host_mem.end_addr;
  curr_addr      = mem_start_addr;

  do begin 
    if(curr_addr + unit_size > mem_end_addr)begin
      ms = mem_slice::type_id::create("mem_slice");
      ms.start_addr = curr_addr;
      ms.end_addr   = mem_end_addr;
    end
    else begin
      ms = mem_slice::type_id::create("mem_slice");
      ms.start_addr = curr_addr;
      ms.end_addr   = curr_addr + unit_size - 1;
    end
    ms.calculate_size();
    slice.push_back(ms);
    curr_addr += unit_size;
  end while(curr_addr < mem_end_addr);

  foreach(slice[i])begin
    $display("mem slice %0d start addr = %0h, end addr = %0h", 
              slice[i].slice_id, slice[i].start_addr, slice[i].end_addr); 
  end
  
endfunction



task host_memory_manager::malloc(int req_size, output U64 addr, output bit suc, input int timeout = 10000);  //TODO page unaligned
  int  free_size;
  int  next_sid;
  int  last_sid = slice.size() - 1;
  int  start_sid;
  bit  beyond_boudry, slice_occupied;
  int  time_out;

  do begin
    beyond_boudry = 0;
    slice_occupied = 0;
    do begin
      if(slice[next_sid].in_use == 0)begin
        start_sid      = next_sid;
        free_size      = 0;
        slice_occupied = 0;
        do begin
          free_size += slice[next_sid].size;
          next_sid++;

          if(free_size >= req_size)begin
            suc = 1;  
          end
          else begin
            if(next_sid > last_sid)
              beyond_boudry = 1;
            if(slice[next_sid].in_use == 0)
              slice_occupied = 1;
          end
        end while(!suc && !slice_occupied && !beyond_boudry);
      end
      else begin
        next_sid++;
        if(next_sid > last_sid)
          beyond_boudry = 1;
      end
    end while(!suc && !beyond_boudry);

    if(!suc)begin
      #1000ns; 
      time_out += 1000;
    end
  end while(!suc && time_out < timeout);

  if(suc)
    addr = slice[start_sid].start_addr;
  else
    addr = 0;
endtask



task host_memory_manager::free(U64 addr);
  

endtask
