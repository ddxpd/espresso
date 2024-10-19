class esp_host_mgr extends uvm_object;

  `uvm_object_utils_begin(esp_host_mgr)
  `uvm_object_utils_end
  
  //subq   sub_q[int];

  int                fid;
  int                num_sq_support;
  int                num_cq_support; 
  nvme_namespace     active_ns[U32];    // KEY is namespace id
  nvme_msix_vector   msix_vector[int];  // KEY is IV id

  esp_host_sq     SQ[int];           // KEY is sqid
  esp_host_cq     CQ[int];           // KEY is cqid

  extern function          new(string name="esp_host_mgr");
  extern function          register_cq(esp_host_cq cq);
  extern function          register_sq(esp_host_sq sq);

endclass


function esp_host_mgr::new(string name="esp_host_mgr");
  super.new(name);
endfunction



function esp_host_mgr::register_cq(esp_host_cq cq);
  if(this.CQ[cq.qid] == null)
    this.CQ[cq.qid] = cq;
  else
    `uvm_fatal(get_name(), $sformatf("CQ %0h for Function %0h already existed.", cq.qid, fid)) 
endfunction



function esp_host_mgr::register_sq(esp_host_sq sq);
  if(this.SQ[sq.qid] == null)
    this.SQ[sq.qid] = sq;
  else
    `uvm_fatal(get_name(), $sformatf("SQ %0h for Function %0h already existed.", sq.qid, fid))
endfunction
