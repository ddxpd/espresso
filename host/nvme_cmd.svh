class nvme_cmd extends uvm_object;
  `uvm_object_utils(nvme_cmd)
      
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

  //constraint c_ {
  //  
  //}
  //
  //constraint c_ {
  //  
  //}
  //
  //constraint c_ {
  //  
  //}
  //
  //constraint c_ {
  //  
  //}
  

       

  extern function             new(string name="nvme_cmd");
  extern function void        create_data(string dp = "INCR");
  extern function void        pre_randomize();
  extern function void        post_randomize();
  extern function void        process_self_stage_0();
  extern function bit         is_admin_cmd();
  extern function void        calculate_data_size();
  extern function PSDT_E      get_psdt();


  

  
endclass



function nvme_cmd::new(string name="nvme_cmd");
  super.new(name);
  SQE_DW = new[NUM_DW_SQE];
endfunction



// dp: data pattern
function void nvme_cmd::create_data(string dp = "INCR");

  data = new[host_tdata_size];
  case(dp)
    "INCR":begin
	     for(int i = 0; i < host_tdata_size; i++)
               data[i] = i; 
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
