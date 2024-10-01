class base_q extends uvm_object;
  `uvm_object_utils(base_q)
  
  typedef struct {
    U32    num_entry;
    U32    num_dw;
    U32    num_byte;
  } S_QSIZE;

        local U64       base_addr;
        local bit       continuous;
        local U32       qid;
        local S_QSIZE   qsize;
        local U32       tail = 0;  
        local U32       head = 0;  

	      int       entry_size;   // Unit:Byte

              bit       is_creating;
              bit       is_deleting;
         


  extern function          new(string name="esp_host_sq");
  extern function U32      get_num_vld_entry();
  extern function U32      get_num_avail_entry();   

  extern function bit      if_q_full();
  extern function bit      if_q_empty();
  extern function bit      update_tail(int incr = 1);
  extern function bit      update_head(int incr = 1);
  extern function bit      incr_tail();

  extern function int      get_tail();
  extern function int      get_head();
  //extern function int      get_q_size();
  extern function U64      get_tail_addr();
  extern function U64      get_head_addr();
  
  extern function bit      if_admin_sq();

  /*
  //Question: Is it necessary to hook host memory on Q so that we can dump
  //Queue contents?
  //extern function void dump_q();
  */

endclass



function base_q::new(string name="base_q");
  super.new(name);
endfunction



function bit base_q::if_admin_sq();
  return (qid == 0);
endfunction




function U32 base_q::get_num_vld_entry();
  U32 num_vld_entry;

  if (tail >= head) begin
    num_vld_entry = tail - head;
  end else begin
    num_vld_entry = tail + (qsize.num_entry - head);
  end
  return num_vld_entry;
endfunction



function U32 base_q::get_num_avail_entry();
  U32 num_vld, num_avail;

  num_vld   = get_num_vld_entries();
  num_avail = qsize.num_entry - 1 - num_vld;
  return num_avail;
endfunction



function bit base_q::if_q_full();
  bit is_full;
  U32 num_avail;

  num_avail = get_num_avail_entry();
  is_full   = (num_avail == 0) ? 1 : 0;
  return is_full;
endfunction



function bit base_q::if_q_empty();
  return (head == tail);
endfunction



function bit base_q::incr_tail();
  bit is_full;
  bit suc = 0;

  is_full = if_q_full();

  if (is_full) begin
    suc = 0;
  end else begin
    if (tail == (qsize.num_entry - 1)) begin
      tail = 0;
    end else begin
      tail++;
    end
    suc = 1;
  end

  return suc;
endfunction



function void base_q::update_head(int incr = 1);
  head += incr;
endfunction



function void base_q::update_tail(int incr = 1);
  tail += incr;
endfunction



function int base_q::get_tail();
  return tail;
endfunction



function int base_q::get_head();
  return head;
endfunction



function U64 base_q::get_tail_addr();
  return base_addr + tail * entry_size;
endfunction



function U64 base_q::get_head_addr();
  return base_addr + head * entry_size;
endfunction






class esp_host_sq extends base_q;
  
        int cqid; 
	esp_host_cq   CQ;

  `uvm_object_utils(esp_host_sq)

  extern function new (string name = "esp_host_sq");
endclass







class esp_host_cq extends base_q;
  `uvm_object_utils(esp_host_cq)

  esp_host_sq  SQ[$];

  extern function new (string name = "esp_host_cq");
endclass


