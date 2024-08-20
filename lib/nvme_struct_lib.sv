typedef struct packed {
  bit [31:31] BPID; // Boot Partition Identifier 
  bit [30:30] RSVD0; //
  bit [29:10] BPROF; // Boot Partition Read Offset 
  bit [09:00] BPRSZ; // Boot Partition Read Size 
} S_BPRSEL;


typedef struct packed {
  bit [31:00] NSSRC; // NVM Subsystem Reset Control 
} S_NSSR;


typedef struct packed {
  bit [63:12] CBA; // Controller Base Address 
  bit [11:02] RSVD0; //
  bit [01:01] CMSE; // Controller Memory Space Enable 
  bit [00:00] CRE; // Capabilities Registers Enabled 
} S_CMBMSC;


typedef struct packed {
  bit [31:8] CMBSWTV; // CMB Sustained Write Throughput 
} S_CMBSWTP;


typedef struct packed {
  bit [31:31] ABPID; // Active Boot Partition ID 
  bit [30:26] RSVD0; //
  bit [25:24] BRS; // Boot Read Status 
  bit [23:15] RSVD1; //
  bit [14:00] BPSZ; // Boot Partition Size 
} S_BPINFO;


typedef struct packed {
  bit [31:16] MJR; // Major Version 
  bit [15:08] MNR; // Minor Version 
  bit [07:00] TER; // Tertiary Version 
} S_SPECIFICATION_VERSION_DESCRIPTOR;


typedef struct packed {
  bit [31:12] SZ; // Size 
  bit [11:08] SZU; // Size Units 
  bit [07:05] RSVD0; //
  bit [04:04] WDS; // Write Data Support 
  bit [03:03] RDS; // Read Data Support 
  bit [02:02] LISTS; // PRP SGL List Support 
  bit [01:01] CQS; // Completion Queue Support 
  bit [00:00] SQS; // Submission Queue Support 
} S_CMBSZ;


typedef struct packed {
  bit [31:00] CBA; // Controller Base Address 
} S_PMRMSCU;


typedef struct packed {
  bit [31:25] RSVD0; //
  bit [24:24] CRIME; // Controller Ready Independent of Media Enable 
  bit [23:20] IOCQES; // I/O Completion Queue Entry Size 
  bit [19:16] IOSQES; // I/O Submission Queue Entry Size 
  bit [15:14] SHN; // Shutdown Notification 
  bit [13:11] AMS; // Arbitration Mechanism Selected 
  bit [10:07] MPS; // Memory Page Size 
  bit [06:04] CSS; // I/O Command Set Selected 
  bit [03:01] RSVD1; //
  bit [00:00] EN; // Enable 
} S_CC;


typedef struct packed {
  bit [63:62] RSVD0; //
  bit [61:61] NSSES; // NVM Subsystem Shutdown Enhancements Supported 
  bit [60:59] CRMS; // Controller Ready Modes Supported 
  bit [58:58] NSSS; // NVM Subsystem Shutdown Supported 
  bit [57:57] CMBS; // Controller Memory Buffer Supported 
  bit [56:56] PMRS; // Persistent Memory Region Supported 
  bit [55:52] MPSMAX; // Memory Page Size Maximum 
  bit [51:48] MPSMIN; // Memory Page Size Minimum 
  bit [47:46] CPS; // Controller Power Scope 
  bit [45:45] BPS; // Boot Partition Support 
  bit [44:37] CSS; // Command Sets Supported 
  bit [36:36] NSSRS; // NVM Subsystem Reset Supported 
  bit [35:32] DSTRD; // Doorbell Stride 
  bit [31:24] TO; // Timeout 
  bit [23:19] RSVD1; //
  bit [18:17] AMS; // Arbitration Mechanism Supported 
  bit [16:16] CQR; // Contiguous Queues Required 
  bit [15:00] MQES; // Maximum Queue Entries Supported 
} S_CAP;


typedef struct packed {
  bit [31:16] CRIMT; // Controller Ready Independent of Media Timeout 
  bit [15:0] CRWMT; // Controller Ready With Media Timeout 
} S_CRTO;


typedef struct packed {
  bit [31:12] OFST; // Offset 
  bit [11:09] RSVD0; //
  bit [08:08] CQDA; // CMB Queue Dword Alignment 
  bit [07:07] CDMMMS; // CMB Data Metadata Mixed Memory Support 
  bit [06:06] CDPCILS; // CMB Data Pointer and Command Independent Locations Support 
  bit [05:05] CDPMLS; // CMB Data Pointer Mixed Locations Support 
  bit [04:04] CQPDS; // CMB Queue Physically Discontiguous Support 
  bit [03:03] CQMMS; // CMB Queue Mixed Memory Support 
  bit [02:00] BIR; // Base Indicator Register 
} S_CMBLOC;


typedef struct packed {
  bit [31:01] RSVD0; //
  bit [00:00] CBAI; // Controller Base Address Invalid 
} S_CMBSTS;


typedef struct packed {
  bit [31:00] NSSC; // NVM Subsystem Shutdown Control 
} S_NSSD;


typedef struct packed {
  bit [31:16] CID; // Command Identifier 
  bit [15:14] PSDT; // PRP or SGL for Data Transfer 
  bit [13:10] RSVD0; //
  bit [09:08] FUSE; // Fused Operation 
  bit [07:00] OPC; // Opcode 
} S_COMMAND_DWORD_0;


typedef struct packed {
  bit [31:8] CMBWBZ; // CMB Elasticity Buffer Size Base 
  bit [7:5] RSVD0; //
  bit [4:4] CMBRBB; // CMB Read Bypass Behavior 
  bit [3:0] CMBSZU; // CMB Elasticity Buffer Size Units 
} S_CMBEBS;


typedef struct packed {
  bit [31:00] IVMC; // Interrupt Vector Mask Clear 
} S_INTMC;


typedef struct packed {
  bit [31:8] PMRSWTV; // PMR Sustained Write Throughput 
  bit [7:4] RSVD0; //
  bit [3:0] PMRSWTU; // PMR Sustained Write Throughput Units 
} S_PMRSWTP;


typedef struct packed {
  bit [31:8] PMRWBZ; // PMR Elasticity Buffer Size Base 
  bit [7:5] RSVD0; //
  bit [4:4] PMRRBB; // PMR Read Bypass Behavior 
  bit [3:0] PMRSZU; // PMR Elasticity Buffer Size Units 
} S_PMREBS;


typedef struct packed {
  bit [31:28] RSVD0; //
  bit [27:16] ACQS; // Admin Completion Queue Size 
  bit [15:12] RSVD1; //
  bit [11:00] ASQS; // Admin Submission Queue Size 
} S_AQA;


typedef struct packed {
  bit [31:07] RSVD0; //
  bit [06:06] ST; // Shutdown Type 
  bit [05:05] PP; // Processing Paused 
  bit [04:04] NSSRO; // NVM Subsystem Reset Occurred 
  bit [03:02] SHST; // Shutdown Status 
  bit [01:01] CFS; // Controller Fatal Status 
  bit [00:00] RDY; // Ready 
} S_CSTS;


typedef struct packed {
  bit [63:12] BMBBA; // Boot Partition Memory Buffer Base Address 
  bit [11:00] RSVD0; //
} S_BPMBL;


typedef struct packed {
  bit [255:220] RSVD0; //
  bit [219:216] EPFVTS; // Emergency Power Fail Vault Time Scale 
  bit [215:212] FQVTS; // Forced Quiescence Vault Time Scale 
} S_IDENTIFY;


typedef struct packed {
  bit [31:00] IVMS; // Interrupt Vector Mask Set 
} S_INTMS;


typedef struct packed {
  bit [31:12] CBA; // Controller Base Address 
  bit [11:02] RSVD0; //
  bit [01:01] CMSE; // Controller Memory Space Enable 
  bit [00:00] RSVD1; //
} S_PMRMSCL;


typedef struct packed {
  bit [31:13] RSVD0; //
  bit [12:12] CBAI; // Controller Base Address Invalid 
  bit [11:9] HSTS; // Health Status 
  bit [8:8] NRDY; // Not Ready 
  bit [7:0] ERR; // Error 
} S_PMRSTS;


typedef struct packed {
  bit [63:12] ACQB; // Admin Completion Queue Base 
  bit [11:00] RSVD0; //
} S_ACQ;


typedef struct packed {
  bit [63:12] ASQB; // Admin Submission Queue Base 
  bit [11:00] RSVD0; //
} S_ASQ;


typedef struct packed {
  bit [31:1] RSVD0; //
  bit [0:0] EN; // Enable 
} S_PMRCTL;


typedef struct packed {
  bit [31:25] RSVD0; //
  bit [24:24] CMSS; // Controller Memory Space Supported 
  bit [23:16] PMRTO; // Persistent Memory Region Timeout 
  bit [15:14] RSVD1; //
  bit [13:10] PMRWBM; // Persistent Memory Region Write Barrier Mechanisms 
  bit [9:8] PMRTU; // Persistent Memory Region Time Units 
  bit [7:5] BIR; // Base Indicator Register 
  bit [4:4] WDS; // Write Data Support 
  bit [3:3] RDS; // Read Data Support 
  bit [2:0] RSVD2; //
} S_PMRCAP;


