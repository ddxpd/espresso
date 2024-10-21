class esp_host_mgr extends uvm_object;

  `uvm_object_utils(esp_host_mgr)

  int               mgr_id;
  int               num_of_bar; 
  S_BAR_RANGE       bar_range[];
  E_CTRLER_STATE    state = ST_RESET;

  int               fid;
  int               num_sq_support;
  int               num_cq_support; 
  nvme_namespace    active_ns[U32];    // KEY is namespace id
  nvme_msix_vector  msix_vector[int];  // KEY is IV id

  esp_host_sq       SQ[int];           // KEY is sqid
  esp_host_cq       CQ[int];           // KEY is cqid

  S_CAP             cap;
  S_VERSION         version;
  S_INTMS           intms;
  S_INTMC           intmc;
  S_CC              cc;
  S_CSTS            csts;
  S_NSSR            nssr;
  S_AQA             aqa;
  S_ASQ             asq;
  S_ACQ             acq;
  S_CMBLOC          cmbloc;
  S_CMBSZ           cmbsz;
  S_BPINFO          bpinfo;
  S_BPRSEL          bprsel;
  S_BPMBL           bpmbl;
  S_CMBMSC          cmbmsc;
  S_CMBSTS          cmbsts;
  S_CMBEBS          cmbebs;
  S_CMBSWTP         cmbswtp;
  S_NSSD            nssd;
  S_CRTO            crto;
  S_PMRCAP          pmrcap;
  S_PMRCTL          pmrctl;
  S_PMRSTS          pmrsts;
  S_PMREBS          pmrebs;
  S_PMRSWTP         pmrswtp;
  S_PMRMSCL         pmrmscl;
  S_PMRMSCU         pmrmscu;

  extern function new(string name="esp_host_mgr");
  extern function register_cq(esp_host_cq cq);
  extern function register_sq(esp_host_sq sq);
  extern function update_cap(int start_dw, int num_dw, ref U32 data[]);

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


function esp_host_mgr::update_cap(int start_dw, int num_dw, ref U32 data[]);
  num_dw = data.size();

  for (int i = 0; i < num_dw; i++) begin
    case (start_dw+i)
      0: begin
           cap = {data[start_dw+i+1], data[start_dw+i]};
         end
      2: begin
           version = data[start_dw+i];
         end
      3: begin
           intms = data[start_dw+i];
         end
      4: begin
           intmc = data[start_dw+i];
         end
      5: begin
           cc = {data[start_dw+i+1], data[start_dw+i]};
         end
      7: begin
           csts = data[start_dw+i];
         end
      8: begin
           nssr = data[start_dw+i];
         end
      9: begin
           aqa = data[start_dw+i];
         end
      10: begin
           asq = {data[start_dw+i+1], data[start_dw+i]};
          end
      12: begin
           acq = {data[start_dw+i+1], data[start_dw+i]};
          end
      14: begin
           cmbloc = data[start_dw+i];
          end
      15: begin
           cmbsz = data[start_dw+i];
          end
      16: begin
           bpinfo = data[start_dw+i];
          end
      17: begin
           bprsel = data[start_dw+i];
          end
      18: begin
           bpmbl = {data[start_dw+i+1], data[start_dw+i]};
          end
      20: begin
           cmbmsc = {data[start_dw+i+1], data[start_dw+i]};
          end
      22: begin
           cmbsts = data[start_dw+i];
          end
      23: begin
           cmbebs = data[start_dw+i];
          end
      24: begin
           cmbswtp = data[start_dw+i];
          end
      25: begin
           nssd = data[start_dw+i];
          end
      26: begin
           crto = data[start_dw+i];
          end
      896: begin
           pmrcap = data[start_dw+i];
           end
      897: begin
           pmrctl = data[start_dw+i];
           end
      898: begin
           pmrsts = data[start_dw+i];
           end
      899: begin
           pmrebs = data[start_dw+i];
           end
      900: begin
           pmrswtp = data[start_dw+i];
           end
      901: begin
           pmrmscl = data[start_dw+i];
           end
      902: begin
           pmrmscu = data[start_dw+i];
           end
    endcase
  end

endfunction

