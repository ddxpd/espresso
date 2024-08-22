class nvme_cmd extends uvm_object;
  `uvm_object_utils(nvme_cmd)
      
       nvme_function_manager  mgr;

       U32         SQE_DW[NUM_DW_SQE];
       CMD_STAT_E  state;

  rand IO_OPC_E    opc;
  rand U16         sqid;
  rand U16         cqid;
  rand U16         cid;
       int         uid;         //unique ID, not belong to NVME spec
  rand U32         nsid;
       U128        dptr;
       U64         mptr;
  rand U16         nlb; 


       U8          data[];
       int         data_size;

  
  //-----------------------------------------------
  //             USER CONFIG
  //             
  //  Default value : -1;
  //-----------------------------------------------
       int         usr_sqid     = -1;
       int         usr_cqid     = -1;
       int         usr_cid      = -1;
       int         usr_nsid     = -1;
       int         //usr_mptr;
       int         usr_nlb      = -1;

  //-----------------------------------------------
  //             CONSTRAINT
  //-----------------------------------------------
  constraint c_sqid {
    
  }

  constraint c_cqid {
    
  }

  constraint c_cid {
    
  }

  constraint c_nsid {
    
  }
  
  constraint c_nlb {
    
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
  

       

  extern function new(string name="nvme_cmd");
  extern function void create_data(int size, string dp = "INCR");
  extern function void pre_randomize();
  extern function void post_randomize();


  

  
endclass


function void nvme_cmd::create_data(int size, string dp = "INCR");
  data = new[size];
  case(dp)
    "INCR":begin
	     for(int i = 0; i < size; i++)
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
