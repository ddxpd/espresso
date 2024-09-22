class nvme_cmd extends uvm_object;
  
      
       nvme_function_manager  mgr;

       U32         SQE_DW[];
       CMD_STAT_E  state;

  rand IO_OPC_E    opc;
  rand U16         sqid;
  rand U16         cqid;
  rand U16         cid;
       int         uid;         //unique ID, not belong to NVME spec
  rand U32         nsid;
       U128        dptr;
       U64         mptr;
       U64         slba;
  rand U16         nlb; 
       PSDT_E      psdt;   


       U8          data[];
       int         host_tdata_size;
       int         ctrler_tdata_size;

       int         host_udata_size;
       int         host_mdata_size;


       int         udata_size;    //Only used by IO cmd
       int         mdata_size;    //Only used by IO cmd
       bit         is_admin;

  
  //-----------------------------------------------
  //             USER CONFIG
  //             
  //  Default value : -1;
  //-----------------------------------------------
       int         usr_sqid     = -1;
       int         usr_cqid     = -1;
       int         usr_cid      = -1;
       int         usr_nsid     = -1;
       //int         usr_mptr;
       int         usr_nlb      = -1;

       //nvme_struct_lib.sv
       S_CMD_DWORD_0       sdw0;
       S_CMD_DWORD_1       sdw1;
       //DW2 and DW3 are command specific
       S_IOCMD_DWORD_2     sdw2_io;
       S_IOCMD_DWORD_3     sdw3_io;
       S_CMD_DWORD_4_5     smptr;
       S_CMD_DWORD_6_7     sprp1;
       S_CMD_DWORD_8_9     sprp2;
       S_ACMD_DWORD_10     sdw10_adm;
       S_ACMD_DWORD_11     sdw11_adm;
       S_ACMD_DWORD_12     sdw12_adm;
       S_ACMD_DWORD_13     sdw13_adm;
       S_ACMD_DWORD_14     sdw14_adm;
       S_ACMD_DWORD_15     sdw15_adm;
       S_IOCMD_DWORD_10    sdw10_io;
       S_IOCMD_DWORD_11    sdw11_io;
       S_IOCMD_DWORD_12    sdw12_io;
       S_IOCMD_DWORD_13    sdw13_io;
       S_IOCMD_DWORD_14    sdw14_io;
       S_IOCMD_DWORD_15    sdw15_io;

  `uvm_object_utils(nvme_cmd)

  //`uvm_object_utils_begin(nvme_cmd)
  //  `uvm_field_int      (addr, UVM_ALL_ON)
  //  `uvm_field_queue_int(data, UVM_ALL_ON)
  //  `uvm_field_object   (ext,  UVM_ALL_ON)
  //  `uvm_field_string   (str,  UVM_ALL_ON)
  //`uvm_object_utils_end

  //-----------------------------------------------
  //             CONSTRAINT
  //-----------------------------------------------
  constraint c_sqid {
    //contraint by mgr
  }

  constraint c_cqid {
    //contraint by mgr
  }


  constraint c_nsid {
    //contraint by mgr
  }
  
  constraint c_nlb {
    //contraint by mgr
  }


  extern function             new(string name="nvme_cmd");
  extern function void        create_data(string dp = "INCR");
  extern function void        pre_randomize();
  extern function void        post_randomize();
  extern function void        process_self_stage_0();
  extern function bit         is_admin_cmd();
  extern function void        calculate_data_size();
  extern function PSDT_E      get_psdt();
  extern function void        pack_dws();
  extern function void        unpack_dws();

endclass



function nvme_cmd::new(string name="nvme_cmd");
  super.new(name);
  SQE_DW = new[NUM_DW_SQE];
endfunction



// dp: data pattern
function void nvme_cmd::create_data(string dp = "INCR");

  data = new[host_tdata_size];
  `uvm_info(get_name(), $sformatf("host_tdata_size = %0d", host_tdata_size), UVM_LOW) 
  case(dp)
    "INCR":begin
	     for(int i = 0; i < host_tdata_size; i++)begin
               data[i] = i; 
               `uvm_info(get_name(), $sformatf(" data[%0h] = %0h", i, data[i]), UVM_LOW) 
             end
           end
  endcase
endfunction



function void nvme_cmd::pre_randomize();
   //U16         usr_sqid;
   //U16         usr_cqid;
   //U16         usr_cid;
   //U32         usr_nsid;
   //U16         usr_nlb; 
   
   if(usr_sqid != -1)begin
     c_sqid.constraint_mode(0);
   end
endfunction



function void nvme_cmd::post_randomize();
endfunction



function void nvme_cmd::process_self_stage_0();
  if(sqid == 0)
    is_admin = 1;
  else 
    is_admin = 0;

  calculate_data_size();

endfunction



function bit nvme_cmd::is_admin_cmd();
  return is_admin;
endfunction



function PSDT_E nvme_cmd::get_psdt();
  return psdt;
endfunction



function void nvme_cmd::calculate_data_size();
  int lba_size, meta_size;//TODO 
  bit is_meta_stripe; // is get from mgr.ns[]


  udata_size        = nlb * lba_size;  //lba_size is get from mgr.ns[]  //TODO    
  mdata_size        = nlb * meta_size; //meta_size is get from mgr.ns[]  //TODO    
  host_tdata_size   = host_udata_size + host_mdata_size;
  ctrler_tdata_size = host_udata_size + host_mdata_size /* +... */;
endfunction

function void nvme_cmd::pack_dws();
  SQE_DW[0]              = sdw0;
  SQE_DW[1]              = sdw1;
  {SQE_DW[5], SQE_DW[4]} = smptr;
  {SQE_DW[7], SQE_DW[6]} = sprp1;
  {SQE_DW[9], SQE_DW[8]} = sprp2;
  if (is_admin) begin //is_admin depends on SQID
    SQE_DW[2]  = 0;
    SQE_DW[3]  = 0;
    SQE_DW[10] = sdw10_adm.dw;
    SQE_DW[11] = sdw11_adm.dw;
    SQE_DW[12] = sdw12_adm.dw;
    SQE_DW[13] = sdw13_adm.dw;
    SQE_DW[14] = sdw14_adm.dw;
    SQE_DW[15] = sdw15_adm.dw;
  end else begin
    SQE_DW[2]  = sdw2_io.dw;
    SQE_DW[3]  = sdw3_io.dw;
    SQE_DW[10] = sdw10_io.dw;
    SQE_DW[11] = sdw11_io.dw;
    SQE_DW[12] = sdw12_io.dw;
    SQE_DW[13] = sdw13_io.dw;
    SQE_DW[14] = sdw14_io.dw;
    SQE_DW[15] = sdw15_io.dw;
  end
endfunction


function void nvme_cmd::unpack_dws();
  sdw0         = SQE_DW[0];
  sdw1         = SQE_DW[1];
  smptr        = {SQE_DW[5], SQE_DW[4]};
  sprp1        = {SQE_DW[7], SQE_DW[6]};
  sprp2        = {SQE_DW[9], SQE_DW[8]};
  if (is_admin) begin //is_admin depends on SQID
    sdw10_adm.dw = SQE_DW[10];
    sdw11_adm.dw = SQE_DW[11];
    sdw12_adm.dw = SQE_DW[12];
    sdw13_adm.dw = SQE_DW[13];
    sdw14_adm.dw = SQE_DW[14];
    sdw15_adm.dw = SQE_DW[15];
  end else begin
    sdw2_io.dw   = SQE_DW[2] ;
    sdw3_io.dw   = SQE_DW[3] ;
    sdw10_io.dw  = SQE_DW[10];
    sdw11_io.dw  = SQE_DW[11];
    sdw12_io.dw  = SQE_DW[12];
    sdw13_io.dw  = SQE_DW[13];
    sdw14_io.dw  = SQE_DW[14];
    sdw15_io.dw  = SQE_DW[15];
  end
endfunction

