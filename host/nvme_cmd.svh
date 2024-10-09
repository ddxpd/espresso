class nvme_cmd extends uvm_object;
  
  static local int         uid_cnt;    

         esp_func_manager  mgr;

         U32         SQE_DW[];
         CMD_STAT_E  state;
         ESP_OPC_E   esp_opc;

  rand   U8          opc;
         int         fid  = -1;         //assigned in pre_randomzie()
  rand   int         sqid = -1;         //assigned in post_randomzie()
  rand   int         cqid = -1;         //assigned in post_randomzie()
  rand   int         cid  = -1;         //assigned in post_randomzie()
         int         uid  = -1;         //unique ID, not belong to NVME spec
  	 
         int         nsid;
         U128        dptr;
         U64         mptr;
         U64         slba;
  rand   U16         nlb; 
         PSDT_E      psdt;   


         U8          data[];
         int         host_tdata_size;     //t stands for total, host side
         int         ctrler_tdata_size;   //t stands for total, fw side

         int         host_udata_size;     //u stands for user, means pure lba data
         int         host_mdata_size;     //m stands for meta


         int         udata_size;    //Only used by IO cmd
         int         mdata_size;    //Only used by IO cmd

  local  bit         is_admin;
  local  bit         has_data;

  //For temp
         INENITFY_CNS_E  cns;

  
  //-----------------------------------------------
  //             USER CONFIG
  //             
  //  Default value : -1;
  //-----------------------------------------------
       esp_user_ctrl   user_ctrl;
       int             usr_cid      = -1;
       int             usr_nsid     = -1;
       //int           usr_mptr;
       int             usr_nlb      = -1;


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

       //GENERAL_PATTERN     gp;

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


  constraint c_nsid {
    //contraint by mgr   //Could be pick later
  }
  
  constraint c_nlb {
    soft nlb dist {0:=40,[1:3]:=60};   
  }


  extern function             new(string name="nvme_cmd");
  extern function void        create_data(string dp = "INCR");
  extern function void        pre_randomize();
  extern function void        post_randomize();
  extern function void        stage_0_process_user_ctrl();
  extern function void        stage_1_basic_process();   //To self-setting some set auxiliary variable
  extern function void        stage_2_fill_sqe();
  extern function void        stage_3_detail_process();

  extern function bit         if_is_admin();
  extern function bit         if_has_data();


  extern function void        calculate_data_size();
  extern function PSDT_E      get_psdt();
  extern function U64         get_prp1();
  extern function U64         get_prp2();
  extern function int         get_fid();

  extern function             assign_uid();

  extern function void        pack_dws();
  extern function void        unpack_dws();

  //**********************************
  //      Used for controller
  extern function void        set_admin(int admin = 1);
  extern function void        parse_opc();
  //**********************************

endclass



function nvme_cmd::new(string name="nvme_cmd");
  super.new(name);
  assign_uid();
  SQE_DW = new[NUM_DW_SQE];
endfunction


function nvme_cmd::assign_uid();
  uid_cnt++;
  uid = uid_cnt;
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
   //U16         usr_cid;
   //U32         usr_nsid;
   //U16         usr_nlb; 

   fid = mgr.fid; 

   c_nlb.constraint_mode(0);

   case(esp_opc)
     ESP_WRITE:
              begin
                c_nlb.constraint_mode(1);
	      end

   endcase
   
   
endfunction



function void nvme_cmd::post_randomize();
  int    ri;       //Random Index
  int    fq[$];    //Found Queue
  //assign NSID SQID CQID and CID
  
  if(nsid == -1)begin
    fq[$] = mgr.active_ns.find_index(x) with (x.is_active == 1);
    ri    = $urandom_range(0, fq.size()-1);
    nsid  = fq[ri];
  end

  if(sqid == -1)begin

  end

  if(cqid == -1)begin

  end

  if(cid == -1)begin

  end
endfunction



function void nvme_cmd::stage_0_process_user_ctrl();



  if(user_ctrl.cid != -1)
    cid = user_ctrl.cid;

endfunction



function void nvme_cmd::stage_1_basic_process();
  if(esp_opc & 'h100 != 0)begin
    is_admin = 1;
    
    //SQID check
    if(sqid != 0)
      `uvm_error(get_name(), $sformatf("Admin cmd should not be post to non-Admin SQ which qid is %0h", sqid))
  end
  else begin
    is_admin = 0;

    //SQID check
    if(sqid == 0)
      `uvm_error(get_name(), $sformatf("IO cmd should not be post to Admin SQ")) 
  end

endfunction



function void nvme_cmd::stage_2_fill_sqe();
  
 
endfunction



function void nvme_cmd::stage_3_detail_process();
  case(esp_opc)
    ESP_WRITE:      
      begin
        calculate_data_size();
      end
  endcase
endfunction




function bit nvme_cmd::if_is_admin();
  return is_admin;
endfunction



function bit nvme_cmd::if_has_data();
  return has_data;
endfunction



function PSDT_E nvme_cmd::get_psdt();
  return psdt;
endfunction



function void nvme_cmd::calculate_data_size();
  int lba_size, meta_size;//TODO 
  bit is_meta_stripe; // is get from mgr.ns[]


  udata_size        = (nlb + 1) * lba_size;  //lba_size is get from mgr.ns[]  //TODO    
  mdata_size        = (nlb + 1) * meta_size; //meta_size is get from mgr.ns[]  //TODO    
  host_tdata_size   = host_udata_size + host_mdata_size;
  ctrler_tdata_size = host_udata_size + host_mdata_size /* +... */;
endfunction



function U64 nvme_cmd::get_prp1();
  return dptr[63:0];
endfunction



function U64 nvme_cmd::get_prp2();
  return dptr[127:64];
endfunction



function int nvme_cmd::get_fid();
  return fid;
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



//*********************************************
//              TEMP FUNCTION     
//*********************************************

function bit nvme_cmd::set_admin(int admin = 1);
  is_admin = 1;
endfunction



function nvme_cmd::parse_opc();
  case({is_admin, SQE_DW[0][7:0]})
    {1, 'h01}:  esp_opc = ESP_WRITE;
    
  endcase
endfunction
