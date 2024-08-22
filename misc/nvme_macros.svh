parameter  NUM_DW_SQE = 16;
parameter  NUM_DW_CDE = 4;
parameter  HOST_AXI_WIDTH = 64;



typedef bit[127:0]  U128;
typedef bit[63:0]   U64;
typedef bit[31:0]   U32;
typedef bit[15:0]   U16;
typedef bit[ 7:0]   U8;


enum U8 {
  NVME_WRITE     = 'h1,
  NVME_READ      = 'h2
} IO_OPC_E



enum U8 {
  CMD_DONE        = 'h1,
  CMD_UNFINISH    = 'h2
} CMD_STAT_E
