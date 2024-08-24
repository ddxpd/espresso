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
  bit [31:8] PMRSWTV; // PMR Sustained Write Throughput
  bit [7:4] RSVD0; //
  bit [3:0] PMRSWTU; // PMR Sustained Write Throughput Units
} S_PMRSWTP;

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



/************NVME COMMAND FORMAT************/
typedef struct packed {
  bit [31:16] CID; // Command Identifier
  bit [15:14] PSDT; // PRP or SGL for Data Transfer
  bit [13:10] RSVD0; //
  bit [09:08] FUSE; // Fused Operation
  bit [07:00] OPC; // Opcode
} S_COMMAND_DWORD_0;

typedef struct packed {
  bit [31:00] NSID;
} S_COMMAND_DWORD_1;

//DW2 and DW3 are command specific

typedef struct packed {
  bit [63:00] MPTR;
} S_COMMAND_DWORD_4_5;

typedef struct packed {
  bit [63:00] PRP1;
} S_COMMAND_DWORD_6_7;

typedef struct packed {
  bit [63:00] PRP2;
} S_COMMAND_DWORD_8_9;



/************NVME COMPLETION FORMAT************/
typedef struct packed {
  bit [31:31] DNR; // Do Not Retry
  bit [30:30] MORE; //MORE
  bit [29:28] CRD; //Command Retry Delay
  bit [27:25] SCT; //Status Code Type
  bit [24:17] SC; //Status Code
  bit [16:16] PHASE; // Phase Tag
  bit [15:00] CID; // Command Identifier
} S_DW_3;


typedef struct packed {
  bit [31:16] SQID; // SQ Identifier
  bit [15:00] SQHD; // SQ Head Pointer
} S_DW_2;



/************Completion Status Code Enum************/
typedef enum {
  GenericCommandStatus = 'h0,
  CommandSpecificStatus = 'h1,
  MediaandDataIntegrityErrors = 'h2,
  PathRelatedStatus = 'h3,
  VendorSpecific = 'h7
} E_STATUS_CODE_TYPE;

typedef enum {
  SuccessfulCompletion = 'h00,
  InvalidCommandOpcode = 'h01,
  InvalidFieldinCommand = 'h02,
  CommandIDConflict = 'h03,
  DataTransferError = 'h04,
  CommandsAbortedduetoPowerLossNotification = 'h05,
  InternalError = 'h06,
  CommandAbortRequested = 'h07,
  CommandAbortedduetoSQDeletion = 'h08,
  CommandAbortedduetoFailedFusedCommand = 'h09,
  CommandAbortedduetoMissingFusedCommand = 'h0A,
  InvalidNamespaceorFormat = 'h0B,
  CommandSequenceError = 'h0C,
  InvalidSGLSegmentDescriptor = 'h0D,
  InvalidNumberofSGLDescriptors = 'h0E,
  DataSGLLengthInvalid = 'h0F,
  MetadataSGLLengthInvalid = 'h10,
  SGLDescriptorTypeInvalid = 'h11,
  InvalidUseofControllerMemoryBuffer = 'h12,
  PRPOffsetInvalid = 'h13,
  AtomicWriteUnitExceeded = 'h14,
  OperationDenied = 'h15,
  SGLOffsetInvalid = 'h16,
  Reserved = 'h17,
  HostIdentifierInconsistentFormat = 'h18,
  KeepAliveTimerExpired = 'h19,
  KeepAliveTimeoutInvalid = 'h1A,
  CommandAbortedduetoPreemptandAbort = 'h1B,
  SanitizeFailed = 'h1C,
  SanitizeInProgress = 'h1D,
  SGLDataBlockGranularityInvalid = 'h1E,
  CommandNotSupportedforQueueinCMB = 'h1F,
  NamespaceisWriteProtected = 'h20,
  CommandInterrupted = 'h21,
  TransientTransportError = 'h22,
  CommandProhibitedbyCommandandFeatureLockdown = 'h23,
  AdminCommandMediaNotReady = 'h24,
  InvalidKeyTag = 'h25,
  HostDispersedNamespaceSupportNotEnabled = 'h26,
  HostIdentifierNotInitialized = 'h27,
  IncorrectKey = 'h28,
  FDPDisabled = 'h29,
  InvalidPlacementHandleList = 'h2A,
  Reserved = 'h2Bhto7F,
  LBAOutofRange = 'h80,
  CapacityExceeded = 'h81,
  NamespaceNotReady = 'h82,
  ReservationConflict = 'h83,
  FormatInProgress = 'h84,
  InvalidValueSize = 'h85,
  InvalidKeySize = 'h86,
  KVKeyDoesNotExist = 'h87,
  UnrecoveredError = 'h88,
  KeyExists = 'h89
  //90h to BF, Reserved
  //C0h to FF, Vendor Specific
} E_GENERIC_STATUS_CODE;


typedef enum {
  CompletionQueueInvalid = 'h00,
  InvalidQueueIdentifier = 'h01,
  InvalidQueueSize = 'h02,
  AbortCommandLimitExceeded = 'h03,
  Reserved = 'h04,
  AsynchronousEventRequestLimitExceeded = 'h05,
  InvalidFirmwareSlot = 'h06,
  InvalidFirmwareImage = 'h07,
  InvalidInterruptVector = 'h08,
  InvalidLogPage = 'h09,
  InvalidFormat = 'h0A,
  FirmwareActivationRequiresConventionalReset = 'h0B,
  InvalidQueueDeletion = 'h0C,
  FeatureIdentifierNotSaveable = 'h0D,
  FeatureNotChangeable = 'h0E,
  FeatureNotNamespaceSpecific = 'h0F,
  FirmwareActivationRequiresNVMSubsystemReset = 'h10,
  FirmwareActivationRequiresControllerLevelReset = 'h11,
  FirmwareActivationRequiresMaximumTimeViolation = 'h12,
  FirmwareActivationProhibited = 'h13,
  OverlappingRange = 'h14,
  NamespaceInsufficientCapacity = 'h15,
  NamespaceIdentifierUnavailable = 'h16,
  Reserved = 'h17,
  NamespaceAlreadyAttached = 'h18,
  NamespaceIsPrivate = 'h19,
  NamespaceNotAttached = 'h1A,
  ThinProvisioningNotSupported = 'h1B,
  ControllerListInvalid = 'h1C,
  DeviceSelf-testInProgress = 'h1D,
  BootPartitionWriteProhibited = 'h1E,
  InvalidControllerIdentifier = 'h1F,
  InvalidSecondaryControllerState = 'h20,
  InvalidNumberofControllerResources = 'h21,
  InvalidResourceIdentifier = 'h22,
  SanitizeProhibitedWhilePersistentMemoryRegionisEnabled = 'h23,
  ANAGroupIdentifierInvalid = 'h24,
  ANAAttachFailed = 'h25,
  InsufficientCapacity = 'h26,
  NamespaceAttachmentLimitExceeded = 'h27,
  ProhibitionofCommandExecutionNotSupported = 'h28,
  IOCommandSetNotSupported = 'h29,
  IOCommandSetNotEnabled = 'h2A,
  IOCommandSetCombinationRejected = 'h2B,
  InvalidIOCommandSet = 'h2C,
  IdentifierUnavailable = 'h2D,
  NamespaceIsDispersed = 'h2E,
  InvalidDiscoveryInformation = 'h2F,
  ZoningDataStructureLocked = 'h30,
  ZoningDataStructureNotFound = 'h31,
  InsufficientDiscoveryResources = 'h32,
  RequestedFunctionDisabled = 'h33,
  ZoneGroupOriginatorInvalid = 'h34,
  InvalidHost = 'h35,
  InvalidNVMSubsystem = 'h36,
  InvalidControllerDataQueue = 'h37,
  NotEnoughResources = 'h38,
  ControllerSuspended = 'h39,
  ControllerNotSuspended = 'h3A,
  ControllerDataQueueFull = 'h3B
} E_COMMAND_SPECIFIC_STATUS_CODE;



/************Admin Command Opcode Enum************/
typedef enum {
  DeleteIOSubmissionQueue = 'h00,
  CreateIOSubmissionQueue = 'h01,
  GetLogPage = 'h02,
  DeleteIOCompletionQueue = 'h04,
  CreateIOCompletionQueue = 'h05,
  Identify = 'h06,
  Abort = 'h08,
  SetFeatures = 'h09,
  GetFeatures = 'h0A,
  AsynchronousEventRequest = 'h0C,
  NamespaceManagement = 'h0D,
  FirmwareCommit = 'h10,
  FirmwareImageDownload = 'h11,
  DeviceSelf-test = 'h14,
  NamespaceAttachment = 'h15,
  KeepAlive = 'h18,
  DirectiveSend = 'h19,
  DirectiveReceive = 'h1A,
  VirtualizationManagement = 'h1C,
  NVMe-MISend = 'h1D,
  NVMe-MIReceive = 'h1E,
  CapacityManagement = 'h20,
  DiscoveryInformationManagement = 'h21,
  FabricZoningReceive = 'h22,
  Lockdown = 'h24,
  FabricZoningLookup = 'h25,
  10ClearExportedNVMResourceConfiguration = 'h28,
  FabricZoningSend = 'h29,
  10CreateExportedNVMSubsystem = 'h2A,
  10ManageExportedNVMSubsystem = 'h2D,
  10ManageExportedNamespace = 'h31,
  10ManageExportedPort = 'h35,
  SendDiscoveryLogPage = 'h39,
  TrackSend = 'h3D,
  TrackReceive = 'h3E,
  MigrationSend = 'h41,
  MigrationReceive = 'h42,
  ControllerDataQueue = 'h45,
  DoorbellBufferConfig = 'h7C,
  9FabricsCommands = 'h7F,
  FormatNVM = 'h80,
  SecuritySend = 'h81,
  SecurityReceive = 'h82,
  Sanitize = 'h84,
  LoadProgram = 'h85,
  GetLBAStatus = 'h86,
  ProgramActivationManagement = 'h88,
  MemoryRangeSetManagement = 'h89
  //Vendorspecific = 'hC0h to FF,
} E_ADMIN_CMD_OPCODE;

