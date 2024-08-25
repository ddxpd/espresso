class identify_controller_data_struct extends uvm_object;
  `uvm_object_utils(identify_controller_data_struct)

  bit [15:0] VID; //PCI Vendor ID  - Bytes 01:00
  bit [15:0] SSVID; //PCI Subsystem Vendor ID  - Bytes 03:02
  bit [159:0] SN; //Serial Number  - Bytes 23:04
  bit [319:0] MN; //Model Number  - Bytes 63:24
  bit [63:0] FR; //Firmware Revision  - Bytes 71:64
  bit [7:0] RAB; //Recommended Arbitration Burst  - Bytes 72
  bit [23:0] IEEE; //IEEE OUI Identifier  - Bytes 75:73
  bit [7:0] CMIC; //Controller Multi-Path I/O and Namespace Sharing Capabilities  - Bytes 76
  bit [7:0] MDTS; //Maximum Data Transfer Size  - Bytes 77
  bit [15:0] CNTLID; //Controller ID  - Bytes 79:78
  bit [31:0] VER; //Version  - Bytes 83:80
  bit [31:0] RTD3R; //RTD3 Resume Latency  - Bytes 87:84
  bit [31:0] RTD3E; //RTD3 Entry Latency  - Bytes 91:88
  bit [31:0] OAES; //Optional Asynchronous Events Supported  - Bytes 95:92
  bit [31:0] CTRATT; //Controller Attributes  - Bytes 99:96
  bit [15:0] RRLS; //Read Recovery Levels Supported  - Bytes 101:100
  bit [7:0] BPCAP; //Boot Partition Capabilities  - Bytes 102
  bit [7:0] RSVD0; // - Bytes 103
  bit [31:0] NSSL; //NVM Subsystem Shutdown Latency  - Bytes 107:104
  bit [15:0] RSVD1; // - Bytes 109:108
  bit [7:0] PLSI; //RSVD Power Loss Signaling Information  - Bytes 110
  bit [7:0] CNTRLTYPE; //Controller Type  - Bytes 111
  bit [127:0] FGUID; //FRU Globally Unique Identifier  - Bytes 127:112
  bit [15:0] CRDT1; //Command Retry Delay Time 1  - Bytes 129:128
  bit [15:0] CRDT2; //Command Retry Delay Time 2  - Bytes 131:130
  bit [15:0] CRDT3; //Command Retry Delay Time 3  - Bytes 133:132
  bit [7:0] CRCAP; //Controller Reachability Capabilities  - Bytes 134
  bit [839:0] RSVD2; // - Bytes 239:135
  bit [103:0] RSVD3; // - Bytes 252:240
  bit [7:0] NVMSR; //NVM Subsystem Report  - Bytes 253
  bit [7:0] VWCI; //VPD Write Cycle Information  - Bytes 254
  bit [7:0] MEC; //Management Endpoint Capabilities  - Bytes 255
  bit [15:0] OACS; //Optional Admin Command Support  - Bytes 257:256
  bit [7:0] ACL; //Abort Command Limit  - Bytes 258
  bit [7:0] AERL; //Asynchronous Event Request Limit  - Bytes 259
  bit [7:0] FRMW; //Firmware Updates  - Bytes 260
  bit [7:0] LPA; //Log Page Attributes  - Bytes 261
  bit [7:0] ELPE; //Error Log Page Entries  - Bytes 262
  bit [7:0] NPSS; //Number of Power States Support  - Bytes 263
  bit [7:0] AVSCC; //Admin Vendor Specific Command Configuration  - Bytes 264
  bit [7:0] APSTA; //Autonomous Power State Transition Attributes  - Bytes 265
  bit [15:0] WCTEMP; //Warning Composite Temperature Threshold  - Bytes 267:266
  bit [15:0] CCTEMP; //Critical Composite Temperature Threshold  - Bytes 269:268
  bit [15:0] MTFA; //Maximum Time for Firmware Activation  - Bytes 271:270
  bit [31:0] HMPRE; //Host Memory Buffer Preferred Size  - Bytes 275:272
  bit [31:0] HMMIN; //Host Memory Buffer Minimum Size  - Bytes 279:276
  bit [127:0] TNVMCAP; //Total NVM Capacity  - Bytes 295:280
  bit [127:0] UNVMCAP; //Unallocated NVM Capacity  - Bytes 311:296
  bit [31:0] RPMBS; //Replay Protected Memory Block Support  - Bytes 315:312
  bit [15:0] EDSTT; //Extended Device Self-test Time  - Bytes 317:316
  bit [7:0] DSTO; //Device Self-test Options  - Bytes 318
  bit [7:0] FWUG; //Firmware Update Granularity  - Bytes 319
  bit [15:0] KAS; //Keep Alive Support  - Bytes 321:320
  bit [15:0] HCTMA; //Host Controlled Thermal Management Attributes  - Bytes 323:322
  bit [15:0] MNTMT; //Minimum Thermal Management Temperature  - Bytes 325:324
  bit [15:0] MXTMT; //Maximum Thermal Management Temperature  - Bytes 327:326
  bit [31:0] SANICAP; //Sanitize Capabilities  - Bytes 331:328
  bit [31:0] HMMINDS; //Host Memory Buffer Minimum Descriptor Entry Size  - Bytes 335:332
  bit [15:0] HMMAXD; //Host Memory Maximum Descriptors Entries  - Bytes 337:336
  bit [15:0] NSETIDMAX; //NVM Set Identifier Maximum  - Bytes 339:338
  bit [15:0] ENDGIDMAX; //Endurance Group Identifier Maximum  - Bytes 341:340
  bit [7:0] ANATT; //ANA Transition Time  - Bytes 342
  bit [7:0] ANACAP; //Asymmetric Namespace Access Capabilities  - Bytes 343
  bit [31:0] ANAGRPMAX; //ANA Group Identifier Maximum  - Bytes 347:344
  bit [31:0] NANAGRPID; //Number of ANA Group Identifiers  - Bytes 351:348
  bit [31:0] PELS; //Persistent Event Log Size  - Bytes 355:352
  bit [15:0] DID; //Domain Identifier  - Bytes 357:356
  bit [7:0] KPIOC; //Key Per IO Capabilities  - Bytes 358
  bit [7:0] RSVD4; // - Bytes 359
  bit [15:0] MPTFAWR; //Maximum Processing Time for Firmware Activation Without Reset  - Bytes 361:360
  bit [47:0] RSVD5; // - Bytes 367:362
  bit [127:0] MEGCAP; //Max Endurance Group Capacity  - Bytes 383:368
  bit [7:0] TMPTHHA; //Temperature Threshold Hysteresis Attributes  - Bytes 384
  bit [7:0] RSVD6; // - Bytes 385
  bit [15:0] CQT; //Command Quiesce Time  - Bytes 387:386
  bit [991:0] RSVD7; // - Bytes 511:388
  bit [7:0] SQES; //Submission Queue Entry Size  - Bytes 512
  bit [7:0] CQES; //Completion Queue Entry Size  - Bytes 513
  bit [15:0] MAXCMD; //Maximum Outstanding Commands  - Bytes 515:514
  bit [31:0] NN; //Number of Namespaces  - Bytes 519:516
  bit [15:0] ONCS; //Optional NVM Command Support  - Bytes 521:520
  bit [15:0] FUSES; //Fused Operation Support  - Bytes 523:522
  bit [7:0] FNA; //Format NVM Attributes  - Bytes 524
  bit [7:0] VWC; //Volatile Write Cache  - Bytes 525
  bit [15:0] AWUN; //Atomic Write Unit Normal  - Bytes 527:526
  bit [15:0] AWUPF; //Atomic Write Unit Power Fail  - Bytes 529:528
  bit [7:0] ICSVSCC; //I/O Command Set Vendor Specific Command Configuration  - Bytes 530
  bit [7:0] NWPC; //Namespace Write Protection Capabilities  - Bytes 531
  bit [15:0] ACWU; //Atomic Compare & Write Unit  - Bytes 533:532
  bit [15:0] CDFS; //Copy Descriptor Formats Supported  - Bytes 535:534
  bit [31:0] SGLS; //SGL Support  - Bytes 539:536
  bit [31:0] MNAN; //Maximum Number of Allowed Namespaces  - Bytes 543:540
  bit [127:0] MAXDNA; //Maximum Domain Namespace Attachments  - Bytes 559:544
  bit [31:0] MAXCNA; //Maximum I/O Controller Namespace Attachments  - Bytes 563:560
  bit [31:0] OAQD; //Optimal Aggregated Queue Depth  - Bytes 567:564
  bit [7:0] RHIRI; //Recommended Host-Initiated Refresh Interval  - Bytes 568
  bit [7:0] HIRT; //Host-Initiated Refresh Time  - Bytes 569
  bit [15:0] CMMRTD; //Controller Maximum Memory Range Tracking Descriptors  - Bytes 571:570
  bit [15:0] NMMRTD; //NVM Subsystem Maximum Memory Range Tracking Descriptors  - Bytes 573:572
  bit [7:0] MINMRTG; //Minimum Memory Range Tracking Granularity  - Bytes 574
  bit [7:0] MAXMRTG; //Maximum Memory Range Tracking Granularity  - Bytes 575
  bit [7:0] TRATTR; //Tracking Attributes  - Bytes 576
  bit [7:0] RSVD8; // - Bytes 577
  bit [15:0] MCUDMQ; //Maximum Controller User Data Migration Queues  - Bytes 579:578
  bit [15:0] MNSUDMQ; //Maximum NVM Subsystem User Data Migration Queues  - Bytes 581:580
  bit [15:0] MCMR; //Maximum CDQ Memory Ranges  - Bytes 583:582
  bit [15:0] NMCMR; //NVM Subsystem Maximum CDQ Memory Ranges  - Bytes 585:584
  bit [15:0] MCDQPC; //Maximum Controller Data Queue PRP Count  - Bytes 587:586
  bit [1439:0] RSVD9; // - Bytes 767:588
  bit [2047:0] SUBNQN; //NVM Subsystem NVMe Qualified Name  - Bytes 1023:768
  bit [6143:0] RSVD10; // - Bytes 1791:1024
  bit [31:0] IOCCSZ; //I/O Queue Command Capsule Supported Size  - Bytes 1795:1792
  bit [31:0] IORCSZ; //I/O Queue Response Capsule Supported Size  - Bytes 1799:1796
  bit [15:0] ICDOFF; //indicated is 1 corresponding to 16 bytes. In Capsule Data Offset  - Bytes 1801:1800
  bit [7:0] FCATT; //Fabrics Controller Attributes  - Bytes 1802
  bit [7:0] MSDBD; //Maximum SGL Data Block Descriptors  - Bytes 1803
  bit [15:0] OFCS; //Optional Fabrics Commands Support  - Bytes 1805:1804
  bit [7:0] DCTYPE; //Discovery Controller Type  - Bytes 1806
  bit [1927:0] RSVD11; // - Bytes 2047:1807
  bit [255:0] PSD0; //Power State 0 Descriptor  - Bytes 2079:2048
  bit [255:0] PSD1; //Power State 1 Descriptor  - Bytes 2111:2080
  bit [255:0] PSD2; //Power State 2 Descriptor  - Bytes 2143:2112
  bit [255:0] PSD3; //Power State 3 Descriptor  - Bytes 2175:2144
  bit [255:0] PSD4; //Power State 4 Descriptor  - Bytes 2207:2176
  bit [255:0] PSD5; //Power State 5 Descriptor  - Bytes 2239:2208
  bit [255:0] PSD6; //Power State 6 Descriptor  - Bytes 2271:2240
  bit [255:0] PSD7; //Power State 7 Descriptor  - Bytes 2303:2272
  bit [255:0] PSD8; //Power State 8 Descriptor  - Bytes 2335:2304
  bit [255:0] PSD9; //Power State 9 Descriptor  - Bytes 2367:2336
  bit [255:0] PSD10; //Power State 10 Descriptor  - Bytes 2399:2368
  bit [255:0] PSD11; //Power State 11 Descriptor  - Bytes 2431:2400
  bit [255:0] PSD12; //Power State 12 Descriptor  - Bytes 2463:2432
  bit [255:0] PSD13; //Power State 13 Descriptor  - Bytes 2495:2464
  bit [255:0] PSD14; //Power State 14 Descriptor  - Bytes 2527:2496
  bit [255:0] PSD15; //Power State 15 Descriptor  - Bytes 2559:2528
  bit [255:0] PSD16; //Power State 16 Descriptor  - Bytes 2591:2560
  bit [255:0] PSD17; //Power State 17 Descriptor  - Bytes 2623:2592
  bit [255:0] PSD18; //Power State 18 Descriptor  - Bytes 2655:2624
  bit [255:0] PSD19; //Power State 19 Descriptor  - Bytes 2687:2656
  bit [255:0] PSD20; //Power State 20 Descriptor  - Bytes 2719:2688
  bit [255:0] PSD21; //Power State 21 Descriptor  - Bytes 2751:2720
  bit [255:0] PSD22; //Power State 22 Descriptor  - Bytes 2783:2752
  bit [255:0] PSD23; //Power State 23 Descriptor  - Bytes 2815:2784
  bit [255:0] PSD24; //Power State 24 Descriptor  - Bytes 2847:2816
  bit [255:0] PSD25; //Power State 25 Descriptor  - Bytes 2879:2848
  bit [255:0] PSD26; //Power State 26 Descriptor  - Bytes 2911:2880
  bit [255:0] PSD27; //Power State 27 Descriptor  - Bytes 2943:2912
  bit [255:0] PSD28; //Power State 28 Descriptor  - Bytes 2975:2944
  bit [255:0] PSD29; //Power State 29 Descriptor  - Bytes 3007:2976
  bit [255:0] PSD30; //Power State 30 Descriptor  - Bytes 3039:3008
  bit [255:0] PSD31; //Power State 31 Descriptor  - Bytes 3071:3040
  bit [8191:0] VS; //Vendor Specific  - Bytes 4095:3072

  U8  [4095:0] raw_bytes;
  U32 [1023:0] raw_dwords;

  function void pack_bytes();
    raw_bytes[01:00] = VID;
    raw_bytes[03:02] = SSVID;
    raw_bytes[23:04] = SN;
    raw_bytes[63:24] = MN;
    raw_bytes[71:64] = FR;
    raw_bytes[72:72] = RAB;
    raw_bytes[75:73] = IEEE;
    raw_bytes[76:76] = CMIC;
    raw_bytes[77:77] = MDTS;
    raw_bytes[79:78] = CNTLID;
    raw_bytes[83:80] = VER;
    raw_bytes[87:84] = RTD3R;
    raw_bytes[91:88] = RTD3E;
    raw_bytes[95:92] = OAES;
    raw_bytes[99:96] = CTRATT;
    raw_bytes[101:100] = RRLS;
    raw_bytes[102:102] = BPCAP;
    raw_bytes[103:103] = RSVD0;
    raw_bytes[107:104] = NSSL;
    raw_bytes[109:108] = RSVD1;
    raw_bytes[110:110] = PLSI;
    raw_bytes[111:111] = CNTRLTYPE;
    raw_bytes[127:112] = FGUID;
    raw_bytes[129:128] = CRDT1;
    raw_bytes[131:130] = CRDT2;
    raw_bytes[133:132] = CRDT3;
    raw_bytes[134:134] = CRCAP;
    raw_bytes[239:135] = RSVD2;
    raw_bytes[252:240] = RSVD3;
    raw_bytes[253:253] = NVMSR;
    raw_bytes[254:254] = VWCI;
    raw_bytes[255:255] = MEC;
    raw_bytes[257:256] = OACS;
    raw_bytes[258:258] = ACL;
    raw_bytes[259:259] = AERL;
    raw_bytes[260:260] = FRMW;
    raw_bytes[261:261] = LPA;
    raw_bytes[262:262] = ELPE;
    raw_bytes[263:263] = NPSS;
    raw_bytes[264:264] = AVSCC;
    raw_bytes[265:265] = APSTA;
    raw_bytes[267:266] = WCTEMP;
    raw_bytes[269:268] = CCTEMP;
    raw_bytes[271:270] = MTFA;
    raw_bytes[275:272] = HMPRE;
    raw_bytes[279:276] = HMMIN;
    raw_bytes[295:280] = TNVMCAP;
    raw_bytes[311:296] = UNVMCAP;
    raw_bytes[315:312] = RPMBS;
    raw_bytes[317:316] = EDSTT;
    raw_bytes[318:318] = DSTO;
    raw_bytes[319:319] = FWUG;
    raw_bytes[321:320] = KAS;
    raw_bytes[323:322] = HCTMA;
    raw_bytes[325:324] = MNTMT;
    raw_bytes[327:326] = MXTMT;
    raw_bytes[331:328] = SANICAP;
    raw_bytes[335:332] = HMMINDS;
    raw_bytes[337:336] = HMMAXD;
    raw_bytes[339:338] = NSETIDMAX;
    raw_bytes[341:340] = ENDGIDMAX;
    raw_bytes[342:342] = ANATT;
    raw_bytes[343:343] = ANACAP;
    raw_bytes[347:344] = ANAGRPMAX;
    raw_bytes[351:348] = NANAGRPID;
    raw_bytes[355:352] = PELS;
    raw_bytes[357:356] = DID;
    raw_bytes[358:358] = KPIOC;
    raw_bytes[359:359] = RSVD4;
    raw_bytes[361:360] = MPTFAWR;
    raw_bytes[367:362] = RSVD5;
    raw_bytes[383:368] = MEGCAP;
    raw_bytes[384:384] = TMPTHHA;
    raw_bytes[385:385] = RSVD6;
    raw_bytes[387:386] = CQT;
    raw_bytes[511:388] = RSVD7;
    raw_bytes[512:512] = SQES;
    raw_bytes[513:513] = CQES;
    raw_bytes[515:514] = MAXCMD;
    raw_bytes[519:516] = NN;
    raw_bytes[521:520] = ONCS;
    raw_bytes[523:522] = FUSES;
    raw_bytes[524:524] = FNA;
    raw_bytes[525:525] = VWC;
    raw_bytes[527:526] = AWUN;
    raw_bytes[529:528] = AWUPF;
    raw_bytes[530:530] = ICSVSCC;
    raw_bytes[531:531] = NWPC;
    raw_bytes[533:532] = ACWU;
    raw_bytes[535:534] = CDFS;
    raw_bytes[539:536] = SGLS;
    raw_bytes[543:540] = MNAN;
    raw_bytes[559:544] = MAXDNA;
    raw_bytes[563:560] = MAXCNA;
    raw_bytes[567:564] = OAQD;
    raw_bytes[568:568] = RHIRI;
    raw_bytes[569:569] = HIRT;
    raw_bytes[571:570] = CMMRTD;
    raw_bytes[573:572] = NMMRTD;
    raw_bytes[574:574] = MINMRTG;
    raw_bytes[575:575] = MAXMRTG;
    raw_bytes[576:576] = TRATTR;
    raw_bytes[577:577] = RSVD8;
    raw_bytes[579:578] = MCUDMQ;
    raw_bytes[581:580] = MNSUDMQ;
    raw_bytes[583:582] = MCMR;
    raw_bytes[585:584] = NMCMR;
    raw_bytes[587:586] = MCDQPC;
    raw_bytes[767:588] = RSVD9;
    raw_bytes[1023:768] = SUBNQN;
    raw_bytes[1791:1024] = RSVD10;
    raw_bytes[1795:1792] = IOCCSZ;
    raw_bytes[1799:1796] = IORCSZ;
    raw_bytes[1801:1800] = ICDOFF;
    raw_bytes[1802:1802] = FCATT;
    raw_bytes[1803:1803] = MSDBD;
    raw_bytes[1805:1804] = OFCS;
    raw_bytes[1806:1806] = DCTYPE;
    raw_bytes[2047:1807] = RSVD11;
    raw_bytes[2079:2048] = PSD0;
    raw_bytes[2111:2080] = PSD1;
    raw_bytes[2143:2112] = PSD2;
    raw_bytes[2175:2144] = PSD3;
    raw_bytes[2207:2176] = PSD4;
    raw_bytes[2239:2208] = PSD5;
    raw_bytes[2271:2240] = PSD6;
    raw_bytes[2303:2272] = PSD7;
    raw_bytes[2335:2304] = PSD8;
    raw_bytes[2367:2336] = PSD9;
    raw_bytes[2399:2368] = PSD10;
    raw_bytes[2431:2400] = PSD11;
    raw_bytes[2463:2432] = PSD12;
    raw_bytes[2495:2464] = PSD13;
    raw_bytes[2527:2496] = PSD14;
    raw_bytes[2559:2528] = PSD15;
    raw_bytes[2591:2560] = PSD16;
    raw_bytes[2623:2592] = PSD17;
    raw_bytes[2655:2624] = PSD18;
    raw_bytes[2687:2656] = PSD19;
    raw_bytes[2719:2688] = PSD20;
    raw_bytes[2751:2720] = PSD21;
    raw_bytes[2783:2752] = PSD22;
    raw_bytes[2815:2784] = PSD23;
    raw_bytes[2847:2816] = PSD24;
    raw_bytes[2879:2848] = PSD25;
    raw_bytes[2911:2880] = PSD26;
    raw_bytes[2943:2912] = PSD27;
    raw_bytes[2975:2944] = PSD28;
    raw_bytes[3007:2976] = PSD29;
    raw_bytes[3039:3008] = PSD30;
    raw_bytes[3071:3040] = PSD31;
    raw_bytes[4095:3072] = VS;
  endfunction

  function void pack_dwords();
    pack_bytes();
    foreach (raw_dwords[i]) begin
      raw_dwords[i] = {raw_bytes[4*i+3], raw_bytes[4*i+2], raw_bytes[4*i+1], raw_bytes[4*i]};
    end
  endfunction

  function void unpack_bytes();
    VID = raw_bytes[01:00];
    SSVID = raw_bytes[03:02];
    SN = raw_bytes[23:04];
    MN = raw_bytes[63:24];
    FR = raw_bytes[71:64];
    RAB = raw_bytes[72:72];
    IEEE = raw_bytes[75:73];
    CMIC = raw_bytes[76:76];
    MDTS = raw_bytes[77:77];
    CNTLID = raw_bytes[79:78];
    VER = raw_bytes[83:80];
    RTD3R = raw_bytes[87:84];
    RTD3E = raw_bytes[91:88];
    OAES = raw_bytes[95:92];
    CTRATT = raw_bytes[99:96];
    RRLS = raw_bytes[101:100];
    BPCAP = raw_bytes[102:102];
    RSVD0 = raw_bytes[103:103];
    NSSL = raw_bytes[107:104];
    RSVD1 = raw_bytes[109:108];
    PLSI = raw_bytes[110:110];
    CNTRLTYPE = raw_bytes[111:111];
    FGUID = raw_bytes[127:112];
    CRDT1 = raw_bytes[129:128];
    CRDT2 = raw_bytes[131:130];
    CRDT3 = raw_bytes[133:132];
    CRCAP = raw_bytes[134:134];
    RSVD2 = raw_bytes[239:135];
    RSVD3 = raw_bytes[252:240];
    NVMSR = raw_bytes[253:253];
    VWCI = raw_bytes[254:254];
    MEC = raw_bytes[255:255];
    OACS = raw_bytes[257:256];
    ACL = raw_bytes[258:258];
    AERL = raw_bytes[259:259];
    FRMW = raw_bytes[260:260];
    LPA = raw_bytes[261:261];
    ELPE = raw_bytes[262:262];
    NPSS = raw_bytes[263:263];
    AVSCC = raw_bytes[264:264];
    APSTA = raw_bytes[265:265];
    WCTEMP = raw_bytes[267:266];
    CCTEMP = raw_bytes[269:268];
    MTFA = raw_bytes[271:270];
    HMPRE = raw_bytes[275:272];
    HMMIN = raw_bytes[279:276];
    TNVMCAP = raw_bytes[295:280];
    UNVMCAP = raw_bytes[311:296];
    RPMBS = raw_bytes[315:312];
    EDSTT = raw_bytes[317:316];
    DSTO = raw_bytes[318:318];
    FWUG = raw_bytes[319:319];
    KAS = raw_bytes[321:320];
    HCTMA = raw_bytes[323:322];
    MNTMT = raw_bytes[325:324];
    MXTMT = raw_bytes[327:326];
    SANICAP = raw_bytes[331:328];
    HMMINDS = raw_bytes[335:332];
    HMMAXD = raw_bytes[337:336];
    NSETIDMAX = raw_bytes[339:338];
    ENDGIDMAX = raw_bytes[341:340];
    ANATT = raw_bytes[342:342];
    ANACAP = raw_bytes[343:343];
    ANAGRPMAX = raw_bytes[347:344];
    NANAGRPID = raw_bytes[351:348];
    PELS = raw_bytes[355:352];
    DID = raw_bytes[357:356];
    KPIOC = raw_bytes[358:358];
    RSVD4 = raw_bytes[359:359];
    MPTFAWR = raw_bytes[361:360];
    RSVD5 = raw_bytes[367:362];
    MEGCAP = raw_bytes[383:368];
    TMPTHHA = raw_bytes[384:384];
    RSVD6 = raw_bytes[385:385];
    CQT = raw_bytes[387:386];
    RSVD7 = raw_bytes[511:388];
    SQES = raw_bytes[512:512];
    CQES = raw_bytes[513:513];
    MAXCMD = raw_bytes[515:514];
    NN = raw_bytes[519:516];
    ONCS = raw_bytes[521:520];
    FUSES = raw_bytes[523:522];
    FNA = raw_bytes[524:524];
    VWC = raw_bytes[525:525];
    AWUN = raw_bytes[527:526];
    AWUPF = raw_bytes[529:528];
    ICSVSCC = raw_bytes[530:530];
    NWPC = raw_bytes[531:531];
    ACWU = raw_bytes[533:532];
    CDFS = raw_bytes[535:534];
    SGLS = raw_bytes[539:536];
    MNAN = raw_bytes[543:540];
    MAXDNA = raw_bytes[559:544];
    MAXCNA = raw_bytes[563:560];
    OAQD = raw_bytes[567:564];
    RHIRI = raw_bytes[568:568];
    HIRT = raw_bytes[569:569];
    CMMRTD = raw_bytes[571:570];
    NMMRTD = raw_bytes[573:572];
    MINMRTG = raw_bytes[574:574];
    MAXMRTG = raw_bytes[575:575];
    TRATTR = raw_bytes[576:576];
    RSVD8 = raw_bytes[577:577];
    MCUDMQ = raw_bytes[579:578];
    MNSUDMQ = raw_bytes[581:580];
    MCMR = raw_bytes[583:582];
    NMCMR = raw_bytes[585:584];
    MCDQPC = raw_bytes[587:586];
    RSVD9 = raw_bytes[767:588];
    SUBNQN = raw_bytes[1023:768];
    RSVD10 = raw_bytes[1791:1024];
    IOCCSZ = raw_bytes[1795:1792];
    IORCSZ = raw_bytes[1799:1796];
    ICDOFF = raw_bytes[1801:1800];
    FCATT = raw_bytes[1802:1802];
    MSDBD = raw_bytes[1803:1803];
    OFCS = raw_bytes[1805:1804];
    DCTYPE = raw_bytes[1806:1806];
    RSVD11 = raw_bytes[2047:1807];
    PSD0 = raw_bytes[2079:2048];
    PSD1 = raw_bytes[2111:2080];
    PSD2 = raw_bytes[2143:2112];
    PSD3 = raw_bytes[2175:2144];
    PSD4 = raw_bytes[2207:2176];
    PSD5 = raw_bytes[2239:2208];
    PSD6 = raw_bytes[2271:2240];
    PSD7 = raw_bytes[2303:2272];
    PSD8 = raw_bytes[2335:2304];
    PSD9 = raw_bytes[2367:2336];
    PSD10 = raw_bytes[2399:2368];
    PSD11 = raw_bytes[2431:2400];
    PSD12 = raw_bytes[2463:2432];
    PSD13 = raw_bytes[2495:2464];
    PSD14 = raw_bytes[2527:2496];
    PSD15 = raw_bytes[2559:2528];
    PSD16 = raw_bytes[2591:2560];
    PSD17 = raw_bytes[2623:2592];
    PSD18 = raw_bytes[2655:2624];
    PSD19 = raw_bytes[2687:2656];
    PSD20 = raw_bytes[2719:2688];
    PSD21 = raw_bytes[2751:2720];
    PSD22 = raw_bytes[2783:2752];
    PSD23 = raw_bytes[2815:2784];
    PSD24 = raw_bytes[2847:2816];
    PSD25 = raw_bytes[2879:2848];
    PSD26 = raw_bytes[2911:2880];
    PSD27 = raw_bytes[2943:2912];
    PSD28 = raw_bytes[2975:2944];
    PSD29 = raw_bytes[3007:2976];
    PSD30 = raw_bytes[3039:3008];
    PSD31 = raw_bytes[3071:3040];
    VS = raw_bytes[4095:3072];
  endfunction

  function void unpack_dwords();
    foreach (raw_dwords[i]) begin
      {raw_bytes[4*i+3], raw_bytes[4*i+2], raw_bytes[4*i+1], raw_bytes[4*i]} = raw_dwords[i];
    end
    unpack_bytes();
  endfunction
endclass
