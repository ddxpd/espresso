typedef class esp_host_cq;
typedef class esp_host_sq;


class prplist;
  U64    base_addr;
  U64    prps[$];   //Not include the next prplist base addr

  function new(name = "prplist");
  endfunction
endclass



class base_q extends uvm_object;
  `uvm_object_utils(base_q)
  
  typedef struct {
    U32    num_entry;
    U32    num_dw;
    U32    num_byte;
  } S_QSIZE;
              QUEUE_STAT_E   state;

              U64       base_addr;
              bit       continuous;
              U32       qid;
              S_QSIZE   qsize;
              U32       tail = 0;  
              U32       head = 0;  

              bit       is_prplist;
	      prplist   prp_list[$];   //Avalid when prp 'is_prplist = 1'

	      int       entry_size;   // Unit:Byte



  extern function          new(string name="base_q");
  extern function U32      get_num_vld_entry();
  extern function U32      get_num_avail_entry();   

  extern function bit      if_q_full();
  extern function bit      if_q_empty();
  extern function void     update_tail(int incr = 1);
  extern function void     update_head(int incr = 1);
  extern function bit      incr_tail();

  extern function int      get_tail();
  extern function int      get_head();
  //extern function int      get_q_size();
  extern function U64      get_tail_addr();
  extern function U64      get_head_addr();

  extern function void     set_base_addr(U64 addr);
  extern function void     set_continuous(bit pc);
  extern function void     set_qid(int qid_f);
  extern function void     set_q_size(int qsize_f, int entry_size_f = 16);
  extern function void     reset_ptr();
  
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

  num_vld   = get_num_vld_entry();
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



function void base_q::set_base_addr(U64 addr);
  base_addr = addr;
endfunction



function void base_q::set_continuous(bit pc);
  continuous = pc;
endfunction



function void base_q::set_qid(int qid_f);
  qid = qid_f;
endfunction



function void base_q::set_q_size(int qsize_f, int entry_size_f = 16);
  qsize.num_byte = qsize_f;
  entry_size = entry_size_f;
endfunction



function void base_q::reset_ptr();
  head = 0;
  tail = 0;
endfunction










class esp_host_sq extends base_q;
  
  int cqid; 
  esp_host_cq   CQ;

  `uvm_object_utils(esp_host_sq)

  extern function        new(string name = "esp_host_sq");
  extern function void   add_cq(ref esp_host_cq cq);
endclass



function esp_host_sq::new(string name = "esp_host_sq");
  super.new(name);
endfunction



function void esp_host_sq::add_cq(ref esp_host_cq cq);
  if(CQ == null)begin
    CQ = cq;
    //cqid = CQ.qid;
    //cq.add_sq(this);
  end
  else 
    `uvm_error(get_name(), $sformatf("CQ is already set for this SQ.")) 
endfunction






class esp_host_cq extends base_q;
  `uvm_object_utils(esp_host_cq)

  esp_host_sq  SQ[int];

  extern function new(string name = "esp_host_cq");
  extern function add_sq(ref esp_host_sq sq);
endclass



function esp_host_cq::new(string name = "esp_host_cq");
  super.new(name);
endfunction



function esp_host_cq::add_sq(ref esp_host_sq sq);
  int  qid = sq.qid;
  `uvm_info(get_name(), $sformatf("qid = %0d", qid), UVM_LOW) 
  if(SQ[qid] == null)
    SQ[qid] = sq;
  else
    `uvm_error(get_name(), $sformatf("SQ is already set for SQ %0h.", sq.qid)) 
endfunction
