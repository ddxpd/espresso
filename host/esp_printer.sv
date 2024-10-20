class esp_printer extends uvm_object;
  `uvm_object_utils(esp_printer)

  extern function      new(string name="esp_printer");
  extern function void print_cap(string prefix="cap info", int mgr_id, int start_dw, U32 data[]);
endclass


function esp_printer::new(string name="esp_printer");
  super.new(name);
endfunction


function void esp_printer::print_cap(string prefix="cap info", int mgr_id, int start_dw, U32 data[]);
  int num_dw;

  $display("********%s********mgr %0d", prefix, mgr_id);
  num_dw = data.size();

  for (int i = 0; i < num_dw; i++) begin
    case (start_dw+i)
      0: begin
           S_CAP s = {data[start_dw+i+1], data[start_dw+i]};
           $display("%p", s);
         end
      2: begin
           S_VERSION s = data[start_dw+i];
           $display("%p", s);
         end
      3: begin
           S_INTMS s = data[start_dw+i];
           $display("%p", s);
         end
      4: begin
           S_INTMC s = data[start_dw+i];
           $display("%p", s);
         end
      5: begin
           S_CC s = {data[start_dw+i+1], data[start_dw+i]};
           $display("%p", s);
         end
      7: begin
           S_CSTS s = data[start_dw+i];
           $display("%p", s);
         end
      8: begin
           S_NSSR s = data[start_dw+i];
           $display("%p", s);
         end
      9: begin
           S_AQA s = data[start_dw+i];
           $display("%p", s);
         end
      10: begin
           S_ASQ s = {data[start_dw+i+1], data[start_dw+i]};
           $display("%p", s);
          end
      12: begin
           S_ACQ s = {data[start_dw+i+1], data[start_dw+i]};
           $display("%p", s);
          end
      14: begin
           S_CMBLOC s = data[start_dw+i];
           $display("%p", s);
          end
      15: begin
           S_CMBSZ s = data[start_dw+i];
           $display("%p", s);
          end
      16: begin
           S_BPINFO s = data[start_dw+i];
           $display("%p", s);
          end
      17: begin
           S_BPRSEL s = data[start_dw+i];
           $display("%p", s);
          end
      18: begin
           S_BPMBL s = {data[start_dw+i+1], data[start_dw+i]};
           $display("%p", s);
          end
      20: begin
           S_CMBMSC s = {data[start_dw+i+1], data[start_dw+i]};
           $display("%p", s);
          end
      22: begin
           S_CMBSTS s = data[start_dw+i];
           $display("%p", s);
          end
      23: begin
           S_CMBEBS s = data[start_dw+i];
           $display("%p", s);
          end
      24: begin
           S_CMBSWTP s = data[start_dw+i];
           $display("%p", s);
          end
      25: begin
           S_NSSD s = data[start_dw+i];
           $display("%p", s);
          end
      26: begin
           S_CRTO s = data[start_dw+i];
           $display("%p", s);
          end
      896: begin
           S_PMRCAP s = data[start_dw+i];
           $display("%p", s);
           end
      897: begin
           S_PMRCTL s = data[start_dw+i];
           $display("%p", s);
           end
      898: begin
           S_PMRSTS s = data[start_dw+i];
           $display("%p", s);
           end
      899: begin
           S_PMREBS s = data[start_dw+i];
           $display("%p", s);
           end
      900: begin
           S_PMRSWTP s = data[start_dw+i];
           $display("%p", s);
           end
      901: begin
           S_PMRMSCL s = data[start_dw+i];
           $display("%p", s);
           end
      902: begin
           S_PMRMSCU s = data[start_dw+i];
           $display("%p", s);
           end
    endcase
  end

  $display("********%s********mgr %0d", prefix, mgr_id);
endfunction

