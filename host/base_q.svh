class base_q extends uvm_object;
  `uvm_object_utils(base_q)

        int     qid;
        U32     base_addr;
	int     entry_size;
        int     num_entries;

  local U16     tail_ptr;
  local U16     head_ptr;
   
        bit     is_creating;
        bit     is_deleting;

  /*
  extern function new (string name = "");

  //Question: Is it necessary to hook host memory on Q so that we can dump
  //Queue contents?
  //host_mem mem_h;
  //extern function void dump_q();

  //APIs for users
  extern function int get_tail_ptr();
  extern function int get_head_ptr();
  extern function int get_num_entries();
  extern function int get_entry_size();
  extern function int get_q_size();
  extern function bit is_q_empty();
  extern function bit is_q_full();
  extern function bit is_admin_q();

  //APIs for developers
  //return if it is successful
  extern function bit update_tail_ptr(int num);
  extern function bit update_head_ptr(int num);
  */
endclass

class sq extends base_q;
  
        int cqid; 

  `uvm_object_utils(sq)

  //extern function new (string name = "");
endclass


class cq extends base_q;
  `uvm_object_utils(cq)

  //extern function new (string name = "");
endclass
