class esp_user_ctrl extends uvm_object;

  `uvm_object_utils_begin(esp_user_ctrl)
  `uvm_object_utils_end
  
  int   cid;

  function new(string name="esp_user_ctrl");
    super.new(name);
  endfunction

endclass



function automatic void turn_bit8_array_2_bit32_array(ref U8 src[$], ref U32 dest[$]);
  int  dest_size = dest.size();
  U32  temp;

  for(int i = 0; i < dest_size; i++)begin
    temp = {src[i*8+3], src[i*8+2], src[i*8+1], src[i*8]};
    dest.push_back(temp);
  end
endfunction



function automatic void turn_bit32_array_2_bit8_array(ref U32 src[$], ref U8 dest[$]);
  int  src_size = src.size();

  for(int i = 0; i < src_size; i++)begin
    for(int j = 0; j < 4; j++)begin
      dest.push_back(src[i][j*8+:8]);
    end
  end
endfunction



function automatic void turn_bit8_array_2_bit64_array(ref U8 src[$], ref U64 dest[$]);
  int  dest_size = dest.size();
  U32  temp;

  for(int i = 0; i < dest_size; i++)begin
    temp = {src[i*8+7], src[i*8+6], src[i*8+5], src[i*8+4], src[i*8+3], src[i*8+2], src[i*8+1], src[i*8]};
    dest.push_back(temp);
  end
endfunction



function automatic void turn_bit64_array_2_bit8_array(ref U64 src[$], ref U8 dest[$]);
  int  src_size = src.size();

  for(int i = 0; i < src_size; i++)begin
    for(int j = 0; j < 8; j++)begin
      dest.push_back(src[i][j*8+:8]);
    end
  end
endfunction
