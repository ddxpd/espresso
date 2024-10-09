//class esp_host_sq extends uvm_object;
//
//  typedef struct {
//    U32    num_cmd;
//    U32    num_dw;
//    U32    num_byte;
//  } S_QSIZE;
//
//  local host_memory    host_mem;
//
//  local U64       base_addr;
//  local bit       continuous;
//  local U32       qid;
//  local S_QSIZE   qsize;
//  local U32       tail = 0;  //per cmd
//  local U32       head = 0;  //per cmd
//  //If queue is continuous, prp1 is q base.
//  //If queue is non-continous, prp1 is prp list.
//  local U64       prp1 = 0;
//
//  local nvme_cmd  host_sqe[];
//
//  `uvm_object_utils(esp_host_sq)
//
//  extern function          new(string name="esp_host_sq");
//  extern function void     create_sq(U32 q_id, U32 num_of_cmd, bit q_cont, U64 q_prp1);
//  extern function U32      get_num_vld_cmds();
//  extern function U32      get_num_avail_entries();
//  extern function bit      check_if_q_full();
//  extern function bit      incr_tail();
//  extern function void     fill_sq_mem(nvme_cmd cmd);
//  extern task              push_sqe(nvme_cmd cmd);
//
//
//  extern function U64      get_cmd_addr();
//  extern function void     update_head(int incr = 1);
//  extern function bit      is_admin_sq();
//
//endclass
//
//
//
//function esp_host_sq::new(string name="esp_host_sq");
//  super.new(name);
//endfunction
//
//
//
//function void esp_host_sq::create_sq(U32 q_id, U32 num_of_cmd, bit q_cont, U64 q_prp1);
//  qid            = q_id;
//  qsize.num_cmd  = num_of_cmd;
//  qsize.num_dw   = num_of_cmd * 16;
//  qsize.num_byte = num_of_cmd * 16 * 4;
//  continuous     = q_cont;
//  base_addr      = q_prp1;
//
//  host_sqe       = new[num_of_cmd];
//
//  if (qsize.num_cmd <= 2) begin
//    `uvm_error(get_name(), $sformatf("QID %0d, QSIZE (per cmd) %0d shall be no less than 2", qid, qsize.num_cmd))
//  end
//endfunction
//
//
//
//function U32 esp_host_sq::get_num_vld_cmds();
//  U32 num_vld_cmds;
//
//  if (tail >= head) begin
//    num_vld_cmds = tail - head;
//  end else begin
//    num_vld_cmds = tail + (qsize.num_cmd - head);
//  end
//  return num_vld_cmds;
//endfunction
//
//
//
//function U32 esp_host_sq::get_num_avail_entries();
//  U32 num_vld, num_avail;
//
//  num_vld   = get_num_vld_cmds();
//  num_avail = qsize.num_cmd - 1 - num_vld;
//  return num_avail;
//endfunction
//
//
//
//function bit esp_host_sq::check_if_q_full();
//  bit is_full;
//  U32 num_avail;
//
//  num_avail = get_num_avail_entries();
//  is_full   = (num_avail == 0) ? 1 : 0;
//  return is_full;
//endfunction
//
//function bit esp_host_sq::incr_tail();
//  bit is_full;
//  bit suc = 0;
//
//  is_full = check_if_q_full();
//
//  if (is_full) begin
//    suc = 0;
//  end else begin
//    if (tail == (qsize.num_cmd - 1)) begin
//      tail = 0;
//    end else begin
//      tail++;
//    end
//    suc = 1;
//  end
//
//  return suc;
//endfunction
//
//
//
//function void esp_host_sq::fill_sq_mem(nvme_cmd cmd);
//  U64 prp;
//  host_sqe[tail] = cmd;
//
//  //TODO: Currently non-cont is not considered.
//  if (continuous) begin
//    prp = base_addr + tail * 16 * 4;
//    cmd.pack_dws();
//    host_mem.fill_dw_data_group_direct(prp, cmd.SQE_DW);  //TODO memory operation should not be involved in sq class. BY ZHB 
//  end
//endfunction
//
//
//task esp_host_sq::push_sqe(nvme_cmd cmd);
//  bit q_full, suc;
//  do begin
//    q_full = check_if_q_full();
//    #1; //1 time unit
//  end while (q_full == 1);
//
//  suc = incr_tail();
//  if (suc == 0) `uvm_error(get_name(), $sformatf("SQ 0x%0x is still full. tail is at 0x%0x, head is at 0x%0x", qid, tail, head))
//
//  fill_sq_mem(cmd);
//endtask
//
//
//
//function U64 esp_host_sq::get_cmd_addr();
//  return base_addr + head * 16 * 4;
//endfunction
//
//
//
//function void esp_host_sq::update_head(int incr = 1);
//  head += incr;
//endfunction
//
//
//
//function bit esp_host_sq::is_admin_sq();
//  return (qid == 0);
//endfunction
