/************CAPABILITIES************/
//OFFSET 0x0
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

//OFFSET 0x8
typedef struct packed {
  bit [31:16] MJR; // Major Version
  bit [15:08] MNR; // Minor Version
  bit [07:00] TER; // Tertiary Version
} S_VERSION;

//OFFSET 0xC
typedef struct packed {
  bit [31:00] IVMS; // Interrupt Vector Mask Set
} S_INTMS;

//OFFSET 0x10
typedef struct packed {
  bit [31:00] IVMC; // Interrupt Vector Mask Clear
} S_INTMC;

//OFFSET 0x14
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

//OFFSET 0x1C
typedef struct packed {
  bit [31:07] RSVD0; //
  bit [06:06] ST; // Shutdown Type
  bit [05:05] PP; // Processing Paused
  bit [04:04] NSSRO; // NVM Subsystem Reset Occurred
  bit [03:02] SHST; // Shutdown Status
  bit [01:01] CFS; // Controller Fatal Status
  bit [00:00] RDY; // Ready
} S_CSTS;

//OFFSET 0x20
typedef struct packed {
  bit [31:00] NSSRC; // NVM Subsystem Reset Control
} S_NSSR;

//OFFSET 0x24
typedef struct packed {
  bit [31:28] RSVD0; //
  bit [27:16] ACQS; // Admin Completion Queue Size
  bit [15:12] RSVD1; //
  bit [11:00] ASQS; // Admin Submission Queue Size
} S_AQA;

//OFFSET 0x28
typedef struct packed {
  bit [63:12] ASQB; // Admin Submission Queue Base
  bit [11:00] RSVD0; //
} S_ASQ;

//OFFSET 0x30
typedef struct packed {
  bit [63:12] ACQB; // Admin Completion Queue Base
  bit [11:00] RSVD0; //
} S_ACQ;

//OFFSET 0x38
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

//OFFET 0x3c
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


//OFFET 0x40
typedef struct packed {
  bit [31:31] ABPID; // Active Boot Partition ID
  bit [30:26] RSVD0; //
  bit [25:24] BRS; // Boot Read Status
  bit [23:15] RSVD1; //
  bit [14:00] BPSZ; // Boot Partition Size
} S_BPINFO;

//OFFET 0x44
typedef struct packed {
  bit [31:31] BPID; // Boot Partition Identifier
  bit [30:30] RSVD0; //
  bit [29:10] BPROF; // Boot Partition Read Offset
  bit [09:00] BPRSZ; // Boot Partition Read Size
} S_BPRSEL;

//OFFET 0x48
typedef struct packed {
  bit [63:12] BMBBA; // Boot Partition Memory Buffer Base Address
  bit [11:00] RSVD0; //
} S_BPMBL;

//OFFET 0x50
typedef struct packed {
  bit [63:12] CBA; // Controller Base Address
  bit [11:02] RSVD0; //
  bit [01:01] CMSE; // Controller Memory Space Enable
  bit [00:00] CRE; // Capabilities Registers Enabled
} S_CMBMSC;

//OFFET 0x58
typedef struct packed {
  bit [31:01] RSVD0; //
  bit [00:00] CBAI; // Controller Base Address Invalid
} S_CMBSTS;

//OFFSET 0x5c
typedef struct packed {
  bit [31:8] CMBWBZ; // CMB Elasticity Buffer Size Base
  bit [7:5] RSVD0; //
  bit [4:4] CMBRBB; // CMB Read Bypass Behavior
  bit [3:0] CMBSZU; // CMB Elasticity Buffer Size Units
} S_CMBEBS;

//OFFSET 0x60
typedef struct packed {
  bit [31:8] CMDSWTV; // CMB Sustained Write Throughput
  bit [7:4] RSVD0; //
  bit [3:0] CMBSWTU; // CMB Sustained Write Throughput Units
} S_CMBSWTP;

//OFFSET 0x64
typedef struct packed {
  bit [31:00] NSSC; // NVM Subsystem Shutdown Control
} S_NSSD;

//OFFSET 0x68
typedef struct packed {
  bit [31:16] CRIMT; // Controller Ready Independent of Media Timeout
  bit [15:0] CRWMT; // Controller Ready With Media Timeout
} S_CRTO;

//OFFSET 0xe00
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

//OFFSET 0xe04
typedef struct packed {
  bit [31:1] RSVD0; //
  bit [0:0] EN; // Enable
} S_PMRCTL;

//OFFSET 0xe08
typedef struct packed {
  bit [31:13] RSVD0; //
  bit [12:12] CBAI; // Controller Base Address Invalid
  bit [11:9] HSTS; // Health Status
  bit [8:8] NRDY; // Not Ready
  bit [7:0] ERR; // Error
} S_PMRSTS;

//OFFSET 0xe0c
typedef struct packed {
  bit [31:8] PMRWBZ; // PMR Elasticity Buffer Size Base
  bit [7:5] RSVD0; //
  bit [4:4] PMRRBB; // PMR Read Bypass Behavior
  bit [3:0] PMRSZU; // PMR Elasticity Buffer Size Units
} S_PMREBS;

//OFFSET 0xe10
typedef struct packed {
  bit [31:8] PMRSWTV; // PMR Sustained Write Throughput
  bit [7:4] RSVD0; //
  bit [3:0] PMRSWTU; // PMR Sustained Write Throughput Units
} S_PMRSWTP;

//OFFSET 0xe14
typedef struct packed {
  bit [31:12] CBA; // Controller Base Address
  bit [11:02] RSVD0; //
  bit [01:01] CMSE; // Controller Memory Space Enable
  bit [00:00] RSVD1; //
} S_PMRMSCL;

//OFFSET 0xe18
typedef struct packed {
  bit [31:00] CBA; // Controller Base Address
} S_PMRMSCU;



/************NVME CMD FORMAT************/
/************ Admin Command ************/
typedef struct packed {
  bit [31:16] CID; // Command Identifier
  bit [15:00] SQID; // Submission Queue Identifier
} S_CMD_ABORT_DWORD_10;


typedef struct packed {
  bit [31:16] ELID; // 1 Element Identifier
  bit [15:04] RSVD0; //
  bit [03:00] OPER; // Operation
} S_CMD_CAP_MNGT_DWORD_10;


typedef struct packed {
  bit [31:00] CAPL; // Capacity Lower
} S_CMD_CAP_MNGT_DWORD_11;


typedef struct packed {
  bit [31:00] CAPU; // Capacity Upper
} S_CMD_CAP_MNGT_DWORD_12;


typedef struct packed {
  bit [31:16] MOS; // Management Operation Specific
  bit [15:08] RSVD0; //
  bit [07:00] SEL; // Select
} S_CMD_CTLRER_DATA_Q_DWORD_10;


typedef struct packed {
  bit [31:16] CQS; // Create Queue Specific
  bit [15:01] RSVD0; //
  bit [00:00] PC; // Physically Contiguous
} S_CMD_CREATE_CTLRER_DATA_Q_DWORD_11;


typedef struct packed {
  bit [31:00] CDQSIZE; // Controller Data Queue Size
} S_CMD_CREATE_CTLRER_DATA_Q_DWORD_12;


typedef struct packed {
  bit [31:16] RSVD0; //
  bit [15:00] CDQID; // Controller Data Queue Identifier
} S_CMD_DELETE_CTLRER_DATA_Q_DWORD_11;


typedef struct packed {
  bit [31:04] RSVD0; //
  bit [03:00] STC; // Self-test Code
} S_CMD_DEVICE_SELF_TEST_DWORD_10;


typedef struct packed {
  bit [31:00] DSTP; // Device Self-test Parameter
} S_CMD_DEVICE_SELF_TEST_DWORD_15;


typedef struct packed {
  bit [31:00] NUMD; // Number of Dwords
} S_CMD_DIRECTIVE_RCV_DWORD_10;


typedef struct packed {
  bit [31:16] DSPEC; // Directive Specific
  bit [15:08] DTYPE; // Directive Type
  bit [07:00] DOPER; // Directive Operation
} S_CMD_DIRECTIVE_RCV_DWORD_11;


typedef struct packed {
  bit [31:00] NUMD; // Number of Dwords
} S_CMD_DIRECTIVE_SEND_DWORD_10;


typedef struct packed {
  bit [31:16] DSPEC; // Directive Specific
  bit [15:08] DTYPE; // Directive Type
  bit [07:00] DOPER; // Directive Operation
} S_CMD_DIRECTIVE_SEND_DWORD_11;


typedef struct packed {
  bit [31:31] BPID; // Boot Partition ID
  bit [30:06] RSVD0; //
  bit [05:03] CA; // Commit Action
  bit [02:00] FS; // Firmware Slot
} S_CMD_FIRMWARE_COMMIT_DWORD_10;


typedef struct packed {
  bit [31:00] NUMD; // Number of Dwords
} S_CMD_FIRMWARE_DOWNLOAD_DWORD_10;


typedef struct packed {
  bit [31:00] OFST; // Offset
} S_CMD_FIRMWARE_DOWNLOAD_DWORD_11;


typedef struct packed {
  bit [31:14] RSVD0; //
  bit [13:12] LBAFU; // LBA Format Upper
  bit [11:09] SES; // Secure Erase Settings
  bit [08:08] PIL; // 1 Protection Information Location
  bit [07:05] PI; // 1 Protection Information
  bit [04:04] MSET; // 1 Metadata Settings
  bit [03:00] LBAFL; // LBA Format Lower
} S_CMD_FORMAT_NVM_DWORD_10;


typedef struct packed {
  bit [31:11] RSVD0; //
  bit [10:08] SEL; // Select
  bit [07:00] FID; // Feature Identifier
} S_CMD_GET_FEATURE_DWORD_10;


typedef struct packed {
  bit [31:07] RSVD0; //
  bit [06:00] UIDX; // UUID Index
} S_CMD_GET_FEATURE_DWORD_14;


typedef struct packed {
  bit [31:16] NUMDL; // Number of Dwords Lower
  bit [15:15] RAE; // Retain Asynchronous Event
  bit [14:08] LSP; // Log Specific Parameter
  bit [07:00] LID; // Log Page Identifier
} S_CMD_GET_LOG_PAGE_DWORD_10;


typedef struct packed {
  bit [31:16] LSI; // Log Specific Identifier
  bit [15:00] NUMDU; // Number of Dwords
} S_CMD_GET_LOG_PAGE_DWORD_11;


typedef struct packed {
  bit [31:00] LPOL; // Log Page Offset Lower
} S_CMD_GET_LOG_PAGE_DWORD_12;


typedef struct packed {
  bit [31:00] LPOU; // Log Page Offset Upper
} S_CMD_GET_LOG_PAGE_DWORD_13;


typedef struct packed {
  bit [31:24] CSI; // Command Set Identifier
  bit [23:23] OT; // Offset Type
  bit [22:07] RSVD0; //
  bit [06:00] UIDX; // UUID Index
} S_CMD_GET_LOG_PAGE_DWORD_14;


typedef struct packed {
  bit [31:16] CNTID; // Controller Identifier
  bit [15:08] RSVD0; //
  bit [07:00] CNS; // Controller or Namespace Structure
} S_CMD_IDENTIFY_DWORD_10;


typedef struct packed {
  bit [31:24] CSI; // Command Set Identifier
  bit [23:16] RSVD0; //
  bit [15:00] CNSSID; // CNS Specific Identifier
} S_CMD_IDENTIFY_DWORD_11;


typedef struct packed {
  bit [31:07] RSVD0; //
  bit [06:00] UIDX; // UUID Index
} S_CMD_IDENTIFY_DWORD_14;


typedef struct packed {
  bit [31:16] RSVD0; //
  bit [15:08] OFI; // Opcode or Feature Identifier 
  bit [07:07] RSVD1; //
  bit [06:05] IFC; // Interface 
  bit [04:04] PRHBT; //Prohibit
  bit [03:00] SCP; //Scope
} S_CMD_LOCKDOWN_DWORD_10;


typedef struct packed {
  bit [31:07] RSVD; //
  bit [06:00] UIDX; // UUID Index 
} S_CMD_LOCKDOWN_DWORD_14;


typedef struct packed {
  bit [31:16] MOS; // Management Operation Specific
  bit [15:08] RSVD; // 
  bit [07:00] SEL; // Select
} S_CMD_MIGRATION_RCV_10;


typedef struct packed {
  bit [31:00] OL; // Offset Lower 
} S_CMD_MIGRATION_RCV_12;


typedef struct packed {
  bit [31:00] OU; // Offset Upper 
} S_CMD_MIGRATION_RCV_13;


typedef struct packed {
  bit [31:07] RSVD;
  bit [06:00] UIDX; // UUID Index 
} S_CMD_MIGRATION_RCV_14;


typedef struct packed {
  bit [31:00] NUMDL; // Number of Dwords
} S_CMD_MIGRATION_RCV_15;


typedef struct packed {
  bit [15:08] RSVD0; //
  bit [7:0] CSVI; // Controller State Version Index 
} S_CMD_GET_CTLR_STATE_MNGT_OP_DWORD_11;


typedef struct packed {
  bit [31:16] MOS; // Management Operation Specific
  bit [15:08] RSVD; // 
  bit [07:00] SEL; // Select
} S_CMD_MIGRATION_SEND_10;


typedef struct packed {
  bit [31:07] RSVD;
  bit [06:00] UIDX; // UUID Index 
} S_CMD_MIGRATION_SEND_14;


typedef struct packed {
  bit [31:31] DUDMQ; //Delete User Data Migration Queue
  bit [30:24] RSVD;
  bit [23:16] STYPE; // Suspend Type
  bit [15:0] CNTLID; // Controller Identifier
} S_CMD_SUSPEND_11;


typedef struct packed {
  bit [31:16] RSVD;
  bit [15:0] CNTLID; // Controller Identifier
} S_CMD_RESUME_11;


typedef struct packed {
  bit [31:24] CSUUIDI; //Controller State UUID Index
  bit [23:16] CSVI; //Controller State Version Index
  bit [15:0] CNTLID; // Controller Identifier
} S_CMD_SET_CTLR_STATE_DWORD_11;


typedef struct packed {
  bit [31:0] CSOL; // Controller State Offset Lower
} S_CMD_SET_CTLR_STATE_DWORD_12;


typedef struct packed {
  bit [31:0] CSOU; // Controller State Offset Upper
} S_CMD_SET_CTLR_STATE_DWORD_13;


typedef struct packed {
  bit [31:0] NUMD; // Number of Dwords
} S_CMD_SET_CTLR_STATE_DWORD_15;


typedef struct packed {
  bit [31:04] RSVD0; //
  bit [03:00] SEL; // Select 
} S_CMD_NS_ATTACH_DWORD_10;


typedef struct packed {
  bit [31:04] RSVD0; //
  bit [03:00] SEL; // Select 
} S_CMD_NS_MANAGEMENT_DWORD_10;


typedef struct packed {
  bit [31:24] CSI; //Command Set Identifier
  bit [23:00] RSVD0;
} S_CMD_NS_MANAGEMENT_DWORD_11;


typedef struct packed {
  bit [31:11] RSVD0; //
  bit [10:10] EMVS; // Enter Media Verification State 
  bit [09:09] NDAS; // No-Deallocate After Sanitize 
  bit [08:08] OIPBP; // Overwrite Invert Pattern Between Passes 
  bit [07:04] OWPASS; // Overwrite Pass Count 
  bit [03:03] AUSE; // Allow Unrestricted Sanitize Exit 
  bit [02:00] SANACT;//Sanitize Action
} S_CMD_SANITIZE_DWORD_10;


typedef struct packed {
  bit [31:00] OVRPAT; // Overwrite Pattern 
} S_CMD_SANITIZE_DWORD_11;


typedef struct packed {
  bit [31:24] SECP; //Security Protocol
  bit [23:16] SPSP1; //SP Specific 1
  bit [15:08] SPSP0; //SP Specific 0
  bit [07:00] NSSF; //NVMe Security Specific Field
} S_CMD_SECURITY_RCV_DWORD_10;


typedef struct packed {
  bit [31:00] AL; //Allocation Length
} S_CMD_SECURITY_RCV_DWORD_11;


typedef struct packed {
  bit [31:24] SECP; //Security Protocol
  bit [23:16] SPSP1; //SP Specific 1
  bit [15:08] SPSP0; //SP Specific 0
  bit [07:00] NSSF; //NVMe Security Specific Field
} S_CMD_SECURITY_SEND_DWORD_10;


typedef struct packed {
  bit [31:00] TL; //Transfer Length
} S_CMD_SECURITY_SEND_DWORD_11;


typedef struct packed {
  bit [31:31] SV; // Save 
  bit [30:08] RSVD0; //
  bit [07:00] FID; // Feature Identifier 
} S_CMD_SET_FEATURE_DWORD_10;


typedef struct packed {
  bit [31:07] RSVD0; //
  bit [06:00] UIDX; // UUID Index 
} S_CMD_SET_FEATURE_DWORD_14;


typedef struct packed {
  bit [31:08] RSVD0; //
  bit [07:00] SEL; // Select  
} S_CMD_TRACK_RCV_DWORD_10;


typedef struct packed {
  bit [31:00] NUMDL; // Number of Dwords  
} S_CMD_TRACK_RCV_DWORD_12;


typedef struct packed {
  bit [31:16] RSVD0; //
  bit [15:00] CNTLID; // Controller Identifier
} S_CMD_TRACK_RCV_DWORD_11;


typedef struct packed {
  bit [31:16] MOS; // Management Operation Specific
  bit [15:08] RSVD0; //
  bit [07:00] SEL; // Select  
} S_CMD_TRACK_SEND_DWORD_10;


typedef struct packed {
  bit [31:16] RSVD0; //
  bit [15:00] CNTLID; // Controller Identifier
} S_CMD_TRACK_SEND_DWORD_11;


typedef struct packed {
  bit [31:16] QSIZE; // Queue Size 
  bit [15:00] QID; // Queue Identifier 
} S_CREATE_IOCQ_DWORD_10;


typedef struct packed {
  bit [31:16] IV; // Interrupt Vector 
  bit [15:02] RSVD0; //
  bit [01:01] IEN; // Interrupts Enabled 
  bit [00:00] PC; // Physically Contiguous 
} S_CREATE_IOCQ_DWORD_11;


typedef struct packed {
  bit [31:16] QSIZE; // Queue Size 
  bit [15:00] QID; // Queue Identifier 
} S_CREATE_IOSQ_DWORD_10;


typedef struct packed {
  bit [31:16] CQID; // Completion Queue Identifier 
  bit [15:03] RSVD; //
  bit [02:01] QPRIO; // Queue Priority
  bit [00:00] PC; // Physically Contiguous
} S_CREATE_IOSQ_DWORD_11;


typedef struct packed {
  bit [31:16] RSVD; //
  bit [15:00] NVMSETID; // NVM Set Identifier
} S_CREATE_IOSQ_DWORD_12;


typedef struct packed {
  bit [31:16] RSVD; //
  bit [15:00] QID; // Queue Identifier 
} S_DELETE_IOCQ_DWORD_10;


typedef struct packed {
  bit [31:16] RSVD; //
  bit [15:00] QID; // Queue Identifier 
} S_DELETE_IOSQ_DWORD_10;


typedef struct packed {
  bit [31:16] CNTLID; // Controller Identifier 
  bit [15:11] RSVD0; //
  bit [10:08] RT; // Resource Type
  bit [07:04] RSVD; //
  bit [03:00] ACT; // Action
} S_VIRTUAL_MNGR_DWORD_10;


typedef struct packed {
  bit [31:16] RSVD; //
  bit [15:00] NR; // Number of Controller Resources) 
} S_VIRTUAL_MNGR_DWORD_11;


typedef struct packed {
  bit [31:16] CID; // Command Identifier
  bit [15:14] PSDT; // PRP or SGL for Data Transfer
  bit [13:10] RSVD0; //
  bit [09:08] FUSE; // Fused Operation
  bit [07:00] OPC; // Opcode
} S_CMD_DWORD_0;


typedef struct packed {
  bit [31:00] NSID;
} S_CMD_DWORD_1;


//DW2 and DW3 are command specific

typedef struct packed {
  bit [63:00] MPTR;
} S_CMD_DWORD_4_5;


typedef struct packed {
  bit [63:00] PRP1;
} S_CMD_DWORD_6_7;


typedef struct packed {
  bit [63:00] PRP2;
} S_CMD_DWORD_8_9;


typedef union {
  S_CMD_ABORT_DWORD_10                abort;
  S_CMD_CAP_MNGT_DWORD_10             cap_mngt;
  S_CMD_CTLRER_DATA_Q_DWORD_10        ctrler_data_q;
  S_CMD_DEVICE_SELF_TEST_DWORD_10     device_self_test;
  S_CMD_DIRECTIVE_RCV_DWORD_10        directive_rcv;
  S_CMD_DIRECTIVE_SEND_DWORD_10       directive_send;
  S_CMD_FIRMWARE_COMMIT_DWORD_10      firmware_commit;
  S_CMD_FIRMWARE_DOWNLOAD_DWORD_10    firmware_download;
  S_CMD_FORMAT_NVM_DWORD_10           format_nvm;
  S_CMD_GET_FEATURE_DWORD_10          get_feature;
  S_CMD_GET_LOG_PAGE_DWORD_10         get_logpage;
  S_CMD_IDENTIFY_DWORD_10             identify;
  S_CMD_LOCKDOWN_DWORD_10             lockdown;
  S_CMD_MIGRATION_RCV_10              migration_rcv;
  S_CMD_MIGRATION_SEND_10             migration_send;
  S_CMD_NS_ATTACH_DWORD_10            ns_attach;
  S_CMD_NS_MANAGEMENT_DWORD_10        ns_management;
  S_CMD_SECURITY_RCV_DWORD_10         security_rcv;
  S_CMD_SECURITY_SEND_DWORD_10        security_send;
  S_CMD_SET_FEATURE_DWORD_10          set_feature;
  S_CREATE_IOCQ_DWORD_10              create_iocq;
  S_CREATE_IOSQ_DWORD_10              create_iosq;
  S_DELETE_IOCQ_DWORD_10              delete_iocq;
  S_DELETE_IOSQ_DWORD_10              delete_iosq;
  S_VIRTUAL_MNGR_DWORD_10             virtual_mngr;
} S_ACMD_DWORD_10;


typedef union {
  S_CMD_CAP_MNGT_DWORD_11                cap_mngt;
  S_CMD_CREATE_CTLRER_DATA_Q_DWORD_11    create_ctrler_data_q;
  S_CMD_DELETE_CTLRER_DATA_Q_DWORD_11    delete_ctrler_data_q;
  S_CMD_DIRECTIVE_RCV_DWORD_11           directive_rcv;
  S_CMD_DIRECTIVE_SEND_DWORD_11          directive_send;
  S_CMD_FIRMWARE_DOWNLOAD_DWORD_11       firmware_download;
  S_CMD_GET_LOG_PAGE_DWORD_11            get_logpage;
  S_CMD_IDENTIFY_DWORD_11                identify;
  S_CMD_GET_CTLR_STATE_MNGT_OP_DWORD_11  get_ctrl_state;
  S_CMD_SUSPEND_11                       suspend;
  S_CMD_RESUME_11                        resume;
  S_CMD_SET_CTLR_STATE_DWORD_11          set_ctrl_state;
  S_CMD_NS_MANAGEMENT_DWORD_11           ns_management;
  S_CMD_SECURITY_RCV_DWORD_11            security_rcv;
  S_CMD_SECURITY_SEND_DWORD_11           security_send;
  S_CREATE_IOCQ_DWORD_11                 create_iocq;
  S_CREATE_IOSQ_DWORD_11                 create_iosq;
  S_VIRTUAL_MNGR_DWORD_11                virtual_mngr;
} S_ACMD_DWORD_11;


typedef union {
  S_CMD_CAP_MNGT_DWORD_12             cap_mngt;
  S_CMD_CREATE_CTLRER_DATA_Q_DWORD_12 create_ctrler_data_q;
  S_CMD_GET_LOG_PAGE_DWORD_12         get_logpage;
  S_CMD_MIGRATION_RCV_12              migration_rcv;
  S_CREATE_IOSQ_DWORD_12                 create_iosq;
} S_ACMD_DWORD_12;


typedef union {
  S_CMD_GET_LOG_PAGE_DWORD_13         get_logpage;
  S_CMD_MIGRATION_RCV_13              migration_rcv;
} S_ACMD_DWORD_13;


typedef union {
  S_CMD_GET_FEATURE_DWORD_14          get_feature;
  S_CMD_GET_LOG_PAGE_DWORD_14         get_logpage;
  S_CMD_IDENTIFY_DWORD_14             identify;
  S_CMD_LOCKDOWN_DWORD_14             lockdown;
  S_CMD_MIGRATION_RCV_14              migration_rcv;
  S_CMD_MIGRATION_SEND_14             migration_send;
  S_CMD_SET_FEATURE_DWORD_14          set_feature;
} S_ACMD_DWORD_14;


typedef union {
  S_CMD_DEVICE_SELF_TEST_DWORD_15     device_self_test;
  S_CMD_MIGRATION_RCV_15              migration_rcv;
  S_CMD_SET_CTLR_STATE_DWORD_15       set_ctrl_state;
} S_ACMD_DWORD_15;


/************ IO Command ************/
typedef struct packed {
  bit [31:16] CID; // Command Identifier 
  bit [15:00] SQID; // Submission Queue Identifier 
} S_CANCEL_DWORD_10;


typedef struct packed {
  bit [31:03] RSVD; // 
  bit [02:00] ACODE; // Action Code
} S_CANCEL_DWORD_11;


typedef struct packed {
  bit [31:16] MOS; // Management Operation Specific
  bit [15:08] RSVD; // Reserved
  bit [07:00] MO; // Management Operation
} S_IO_MANAGEMENT_RCV_DWORD_10;


typedef struct packed {
  bit [31:00] NUMD; // Number of Dwords
} S_IO_MANAGEMENT_RCV_DWORD_11;


typedef struct packed {
  bit [31:16] MOS; // Management Operation Specific
  bit [15:08] RSVD; // Reserved
  bit [07:00] MO; // Management Operation
} S_IO_MANAGEMENT_SEND_DWORD_10;


typedef struct packed {
  bit [31:16] RSVD0; //
  bit [15:08] RTYPE; // Reservation Type
  bit [07:05] RSVD1; //
  bit [04:04] DISNSRS; // Dispersed Namespace Reservation Support
  bit [03:03] IEKEY; // Ignore Existing Key
  bit [02:00] RACQA; // Reservation Acquire Action
} S_RESERVATION_ACQUIRE_DWORD_10;


typedef struct packed {
  bit [31:30] CPTPL; // Change Persist Through Power Loss State
  bit [29:05] RSVD0; // Reserved
  bit [04:04] DISNSRS; // Dispersed Namespace Reservation Support
  bit [03:03] IEKEY; // Ignore Existing Key
  bit [02:00] RREGA; // Reservation Register Action
} S_RESERVATION_REGISTER_DWORD_10;


typedef struct packed {
  bit [31:16] RSVD0; //
  bit [15:08] RTYPE; // Reservation Type
  bit [07:05] RSVD1; //
  bit [04:04] DISNSRS; // Dispersed Namespace Reservation Support
  bit [03:03] IEKEY; // Ignore Existing Key
  bit [02:00] RRELA; // Reservation Release Action
} S_RESERVATION_RELEASE_DWORD_10;


typedef struct packed {
  bit [31:00] NUMD; // Number of Dwords
} S_RESERVATION_REPORT_DWORD_10;


typedef struct packed {
  bit [31:02] RSVD; // Reserved
  bit [01:01] DISNSRS; // Dispersed Namespace Reservation Support
  bit [00:00] EDS; //Extended Data Structure
} S_RESERVATION_REPORT_DWORD_11;


typedef struct packed {
  bit [31:00] ELBTU_LSB; // Expected Logical Block Tags Upper
} S_COMPARE_DWORD_2;


typedef struct packed {
  bit [31:16] RSVD; // Reserved
  bit [15:00] ELBTU_MSB; // Expected Logical Block Tags Upper
} S_COMPARE_DWORD_3;


typedef struct packed {
  bit [31:00] SLBA_LSB; // Starting LBA
} S_COMPARE_DWORD_10;


typedef struct packed {
  bit [31:00] SLBA_MSB; // Starting LBA
} S_COMPARE_DWORD_11;

typedef struct packed {
  bit [31:31] LR; // Limited Retry (LR)
  bit [30:30] FUA; // Force Unit Access 
  bit [29:26] PRINFO; // Protection Information 
  bit [25:25] RSVD0; //
  bit [24:24] STC; // Storage Tag Check 
  bit [23:20] RSVD1; //
  bit [19:16] CETYPE; // Command Extension Type 
  bit [15:00] NLB; // Number of Logical Blocks 
} S_COMPARE_DWORD_12;


typedef struct packed {
  bit [31:16] RSVD0; //
  bit [15:00] CEV; // Command Extension Value 
} S_COMPARE_DWORD_13;


typedef struct packed {
  bit [31:00] ELBTL; // Expected Logical Block Tags Lower 
} S_COMPARE_DWORD_14;


typedef struct packed {
  bit [31:16] ELBATM; // Expected Logical Block Application Tag Mask 
  bit [15:00] ELBAT; // Expected Logical Block Application Tag 
} S_COMPARE_DWORD_15;


typedef struct packed {
  bit [31:00] LBTU_LSB; // Logical Block Tags Upper
} S_COPY_DWORD_2;


typedef struct packed {
  bit [31:16] RSVD; // Reserved
  bit [15:00] LBTU_MSB; // Logical Block Tags Upper (LBTU)
} S_COPY_DWORD_3;


typedef struct packed {
  bit [31:00] SDLBA_LSB; // Starting Destination LBA
} S_COPY_DWORD_10;


typedef struct packed {
  bit [31:00] SDLBA_MSB; // Starting Destination LBA
} S_COPY_DWORD_11;


typedef struct packed {
  bit [31:31] LR; // Limited Retry 
  bit [30:30] FUA; // Force Unit Access 
  bit [29:26] PRINFOW; // Protection Information Write 
  bit [25:25] STCR; // Storage Tag Check Read 
  bit [24:24] STCW; // Storage Tag Check Write 
  bit [23:20] DTYPE; // Directive Type 
  bit [19:16] CETYPE; // Command Extension Type 
  bit [15:12] PRINFOR; // Protection Information Read 
  bit [11:08] DESFMT; // Descriptor Format 
  bit [07:00] NR; // Number of Ranges 
} S_COPY_DWORD_12;


typedef struct packed {
  bit [31:16] DSPEC; // Directive Specific 
  bit [15:00] CEV; // Command Extension Value 
} S_COPY_DWORD_13;


typedef struct packed {
  bit [31:00] LBTL; // Logical Block Tags Lower 
} S_COPY_DWORD_14;


typedef struct packed {
  bit [31:16] LBATM; // Logical Block Application Tag Mask 
  bit [15:00] LBAT; // Logical Block Application Tag 
} S_COPY_DWORD_15;


typedef struct packed {
  bit [31:08] RSVD0; //
  bit [07:00] NR; // Number of Ranges 
} S_DATASET_MNGMENT_DWORD_10;


typedef struct packed {
  bit [31:03] RSVD0; //
  bit [02:02] AD; // Attribute – Deallocate 
  bit [01:01] IDW; // Attribute – Integral Dataset for Write 
  bit [00:00] IDR; // Attribute – Integral Dataset for Read 
} S_DATASET_MNGMENT_DWORD_11;


typedef struct packed {
  bit [31:00] ELBTU_LSB; // Expected Logical Block Tags Upper 
} S_READ_DWORD_2;


typedef struct packed {
  bit [31:16] RSVD0; //
  bit [15:00] ELBTU_MSB; // Expected Logical Block Tags Upper 
} S_READ_DWORD_3;


typedef struct packed {
  bit [31:00] SLBA_LSB; // Starting LBA 
} S_READ_DWORD_10;


typedef struct packed {
  bit [31:00] SLBA_MSB; // Starting LBA 
} S_READ_DWORD_11;


typedef struct packed {
  bit [31:31] LR; // Limited Retry 
  bit [30:30] FUA; // Force Unit Access 
  bit [29:26] PRINFO; // Protection Information 
  bit [25:25] RSVD0; //
  bit [24:24] STC; // Storage Tag Check 
  bit [23:20] RSVD1; //
  bit [19:16] CETYPE; // Command Extension Type 
  bit [15:00] NLB; // Number of Logical Blocks 
} S_READ_DWORD_12;


typedef struct packed {
  bit [31:08] RSVD0; //
  bit [07:07] INCPRS; // Incompressible 
  bit [06:06] SEQREQ; // Sequential Request
  bit [05:04] AL; // Access Latency
  bit [03:00] AF; // Access Frequency
} S_READ_CTYPE0_DWORD_13;


typedef struct packed {
  bit [31:16] RSVD0; //
  bit [15:00] CEV; // Command Extension Value
} S_READ_CTYPE_NON0_DWORD_13;


typedef struct packed {
  bit [31:00] ELBTL; // Expected Logical Block Tags Lower 
} S_READ_DWORD_14;

typedef struct packed {
  bit [31:16] ELBATM;//Expected Logical Block Application Tag Mask
  bit [15:00] ELBAT;//Expected Logical Block Application Tag
} S_READ_DWORD_15;


typedef struct packed {
  bit [31:00] ELBTU_LSB; // Expected Logical Block Tags Upper
} S_VERIFY_DWORD_2;


typedef struct packed {
  bit [31:16] RSVD; // Reserved
  bit [15:00] ELBTU_MSB; // Expected Logical Block Tags Upper
} S_VERIFY_DWORD_3;


typedef struct packed {
  bit [31:00] SLBA_LSB; // Starting LBA 
} S_VERIFY_DWORD_10;


typedef struct packed {
  bit [31:00] SLBA_MSB; // Starting LBA 
} S_VERIFY_DWORD_11;


typedef struct packed {
  bit [31:31] LR; // Limited Retry 
  bit [30:30] FUA; // Force Unit Access 
  bit [29:26] PRINFO; // Protection Information 
  bit [25:25] RSVD0; //
  bit [24:24] STC; // Storage Tag Check 
  bit [23:20] RSVD1; //
  bit [19:16] CETYPE; // Command Extension Type 
  bit [15:00] NLB; // Number of Logical Blocks 
} S_VERIFY_DWORD_12;


typedef struct packed {
  bit [31:16] RSVD0; //
  bit [15:00] CEV; // Command Extention Value 
} S_VERIFY_DWORD_13;


typedef struct packed {
  bit [31:00] ELBTL; // Expected Logical Block Tags Lower 
} S_VERIFY_DWORD_14;


typedef struct packed {
  bit [31:16] ELBATM; // Expected Logical Block Application Tag Mask
  bit [15:00] ELBAT; // Expected Logical Block Application Tag
} S_VERIFY_DWORD_15;


typedef struct packed {
  bit [31:00] LBTU_LSB; // Logical Block Tags Upper
} S_WRITE_DWORD_2;


typedef struct packed {
  bit [31:16] RSVD; // Reserved
  bit [15:00] LBTU_MSB; // Logical Block Tags Upper (LBTU)
} S_WRITE_DWORD_3;


typedef struct packed {
  bit [31:00] SLBA_LSB; // Starting LBA 
} S_WRITE_DWORD_10;


typedef struct packed {
  bit [31:00] SLBA_MSB; // Starting LBA 
} S_WRITE_DWORD_11;


typedef struct packed {
  bit [31:31] LR; // Limited Retry (LR)
  bit [30:30] FUA; // Force Unit Access 
  bit [29:26] PRINFO; // Protection Information 
  bit [25:25] RSVD0; //
  bit [24:24] STC; // Storage Tag Check 
  bit [23:20] DTYPE; // Directive Type
  bit [19:16] CETYPE; // Command Extension Type 
  bit [15:00] NLB; // Number of Logical Blocks 
} S_WRITE_DWORD_12;


typedef struct packed {
  bit [31:16] DSPEC; // Directive Specific 
  bit [15:08] RSVD; // 
  bit [07:07] INCPRS; // Incompressible 
  bit [06:06] SEQREQ; // Sequential Request
  bit [05:04] AL; // Access Latency
  bit [03:00] AF; // Access Frequency
} S_WRITE_CTYPE0_DWORD_13;


typedef struct packed {
  bit [31:16] DSPEC; // Directive Specific (DSPEC)
  bit [15:00] CEV; // Command Extension Value (CEV)
} S_WRITE_CTYPE_NON0_DWORD_13;


typedef struct packed {
  bit [31:00] LBTL; // Logical Block Tags Lower 
} S_WRITE_DWORD_14;


typedef struct packed {
  bit [31:16] LBATM; // Logical Block Application Tag Mask 
  bit [15:00] LBAT; // Logical Block Application Tag 
} S_WRITE_DWORD_15;


typedef struct packed {
  bit [31:00] SLBA_LSB; // Starting LBA
} S_WRITE_UNCOR_DWORD_10;


typedef struct packed {
  bit [31:00] SLBA_MSB; // Starting LBA
} S_WRITE_UNCOR_DWORD_11;


typedef struct packed {
  bit [31:24] RSVD0; // 
  bit [23:20] DTYPE; // Directive Type
  bit [19:16] RSVD1; // 
  bit [15:00] NLB; // Number of Logical Blocks 
} S_WRITE_UNCOR_DWORD_12;


typedef struct packed {
  bit [31:16] DSPEC; // Directive Specific
  bit [15:00] RSVD; // 
} S_WRITE_UNCOR_DWORD_13;


typedef struct packed {
  bit [31:00] LBTU_LSB; // Logical Block Tags Upper
} S_WRITE_ZEROES_DWORD_2;


typedef struct packed {
  bit [31:16] RSVD; // Reserved
  bit [15:00] LBTU_MSB; // Logical Block Tags Upper (LBTU)
} S_WRITE_ZEROES_DWORD_3;


typedef struct packed {
  bit [31:31] LR; // Limited Retry 
  bit [30:30] FUA; // Force Unit Access 
  bit [29:26] PRINFO; // Protection Information 
  bit [25:25] DEAC; // Deallocate 
  bit [24:24] STC; // Storage Tag Check 
  bit [23:23] NSZ; // Namespace Zeroes 
  bit [22:20] DTYPE; // Directive Type 
  bit [19:16] CETYPE; // Command Extension Type 
  bit [15:00] NLB; // Number of Logical Blocks 
} S_WRITE_ZEROES_DWORD_12;


typedef struct packed {
  bit [31:16] DSPEC; // Directive Specific 
  bit [15:00] RSVD; //
} S_WRITE_ZEROES_CETYPE0_DWORD_13;


typedef struct packed {
  bit [31:16] DSPEC; // Directive Specific 
  bit [15:00] CEV; // Command Extension Value 
} S_WRITE_ZEROES_CETYPE_NON0_DWORD_13;


typedef struct packed {
  bit [31:00] LBTL; // Logical Block Tags Lower 
} S_WRITE_ZEROES_DWORD_14;


typedef struct packed {
  bit [31:16] LBATM; // Logical Block Application Tag Mask 
  bit [15:00] LBAT; // Logical Block Application Tag 
} S_WRITE_ZEROES_DWORD_15;


/************NVME COMPLETION FORMAT************/
typedef struct packed {
  bit [31:31] DNR; // Do Not Retry
  bit [30:30] MORE; //MORE
  bit [29:28] CRD; //Command Retry Delay
  bit [27:25] SCT; //Status Code Type
  bit [24:17] SC; //Status Code
  bit [16:16] PHASE; // Phase Tag
  bit [15:00] CID; // Command Identifier
} S_CMPL_DW_3;


typedef struct packed {
  bit [31:16] SQID; // SQ Identifier
  bit [15:00] SQHD; // SQ Head Pointer
} S_CMPL_DW_2;


typedef struct packed {
  bit [31:01] RSVD0; //
  bit [00:00] IANP; // Immediate Abort Not Performed
} S_CMPL_ABORT_DW0;


typedef struct packed {
  bit [31:24] RSVD0; //
  bit [23:16] LID; // Log Page Identifier
  bit [15:08] AEI; // Asynchronous Event Information
  bit [07:03] RSVD1; //
  bit [02:00] AET; // Asynchronous Event Type
} S_CMPL_ASYNC_DW0;


typedef struct packed {
  bit [31:00] EVNTSP; // Event Specific Parameter
} S_CMPL_ASYNC_DW1;


typedef struct packed {
  bit [31:16] RSVD0; //
  bit [15:00] CELID; // Created Element Identifier
} S_CMPL_CAP_MNGT_DWORD_0;


typedef struct packed {
  bit [31:16] RSVD0; //
  bit [15:00] CDQID; // Controller Data Queue Identifier
} S_CMPL_CTLRER_DATA_Q_DWORD_0;


typedef struct packed {
  bit [31:02] RSVD0; //
  bit [01:00] MUD; // Multiple Update Detected
} S_CMPL_FIRMWARE_COMMIT_DWORD_0;


typedef struct packed {
  bit [31:03] RSVD0; //
  bit [02:02] CHANG; //Changeable
  bit [01:01] NSSPEC; //NS Specific
  bit [00:00] SVBL; //Saveable
} S_CMPL_GET_FEATURE_DWORD_0;


typedef struct packed {
  bit [31:01] RSVD0; //
  bit [00:00] CSUP; // Controller Suspended 
} S_CPL_GET_CTLR_STATE_MNGT_OP_DWORD_0;


typedef struct packed {
  bit [31:00] NSID; //Namespace Identifier
} S_CPL_NS_MANAGEMENT_DWORD_0;

/**************** IO Completion ******************/
typedef struct packed {
  bit [31:16] CEDA; // Commands Eligible for Deferred Abort
  bit [15:00] CMDA; // Commands Aborted
} S_CPL_CANCEL_DWORD_0;


typedef struct packed {
  bit [31:01] RSVD0; //
  bit [00:00] LBACZ; // LBAs Cleared to Zero 
} S_CPL_WRITE_ZEROES_DWORD_0;

