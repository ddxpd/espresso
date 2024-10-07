parameter  NUM_DW_SQE = 16;
parameter  NUM_DW_CDE = 4;
parameter  HOST_AXI_WIDTH = 64;



typedef bit[127:0]  U128;
typedef bit[63:0]   U64;
typedef bit[31:0]   U32;
typedef bit[15:0]   U16;
typedef bit[ 7:0]   U8;


typedef enum bit[8:0] {
  ESP_WRITE        = 'h1,
  ESP_READ         = 'h2,

  
  ESP_DELETE_SQ    = 'h100,
  ESP_CREATE_SQ    = 'h101,
  ESP_DELETE_CQ    = 'h104,
  ESP_CREATE_CQ    = 'h105,
  ESP_IDENTIFY     = 'h106

} ESP_OPC_E;



typedef enum U8 {
  NVME_WRITE     = 'h1,
  NVME_READ      = 'h2
} IO_OPC_E;

typedef enum U8 {
  NVME_IDENTIFY  = 'h6
} ADMIN_OPC_E;


typedef enum U8 {
  NS_DATA        = 'h0
} INENITFY_CNS_E;


typedef enum bit[1:0] {
  NVME_PRP       = 'h0,
  NVME_SGL0      = 'h1,  // MPTR is not SGL
  NVME_SGL1      = 'h2   // MPTR is also SGL
} PSDT_E;


typedef enum U8 {
  CMD_IDLE        = 'h0,
  CMD_DONE        = 'h1,
  CMD_UNFINISH    = 'h2,
} CMD_STAT_E;


typedef enum bit {
  IO_CMD        = 'h0,
  ADMIN_CMD     = 'h1
} CMD_TYPE_E;


typedef enum U8 {
  QUEUE_INACTIVE     = 'h0,
  QUEUE_ACTIVE       = 'h1,
  QUEUE_CREATING     = 'h2,
  QUEUE_DELETING     = 'h3,
  QUEUE_OCCUPIED     = 'h4
} QUEUE_STAT_E;
