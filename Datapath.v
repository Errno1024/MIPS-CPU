`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:20:30 11/07/2019 
// Design Name: 
// Module Name:    Datapath 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "def.v"
module Datapath(
    input clock,
    input reset,
	 input PCWr,
	 input FDEn,
	 input FDFlush,
	 input DEFlush,
	 input `FWS ForwardRsD,
	 input `FWS ForwardRtD,
	 input `FWS ForwardRsE,
	 input `FWS ForwardRtE,
	 input `FWS ForwardRtM,

	 output [`TUselen-1:0]TUseRsD,
	 output [`TUselen-1:0]TUseRtD,
	 //output [`TNewlen-1:0]TNewE,
	 output [`TNewlen-1:0]TNewE_MDU,
	 output [`TNewlen-1:0]TNewM,
	 
	 output [`NPCOp_len-1:0] NPCOpD,
	 output ben,
	 
	 output [4:0]rsD,
	 output [4:0]rtD,
	 output [4:0]rsE,
	 output [4:0]rtE,
	 output [4:0]rtM,
	 
	 //output [4:0]DstE,
	 output [4:0]DstE_MDU,
	 output [4:0]DstM,
	 output [4:0]DstW,
	 //output RFWrE,
	 output RFWrE_MDU,
	 output RFWrM,
	 output RFWrW,
	 output [`WDSlen-1:0]WDSelE,//MDU不可能在E级就得出结果，无需修改
	 output [`WDSlen-1:0]WDSelM,
	 
	 output `TIndex TIndexE,//MDU不可能在E级就得出结果，无需修改
	 output `TIndex TIndexM,
	 output MDUDpD,
	 output MDUBusy,
	 output MDUReady,
	 output MDUToBusy,
	 output RFWrMDU,
	 output [4:0]DstMDU,
	 output [4:0]DstD,
	 output `TIndex TIndexD,
	 output LikelyD,
	 
	 output kernel,
	 output eretD,
	 output CP0WrE,
	 output CP0WrM,
	 input GeneralFlush,
	 
	 input [5:0]HInt,
	 output [31:0] EPCExpectation,
	 
	 output `b32 DMAddr,
	 output `b32 DMWD,
	 input `b32 HWRD,
	 output DMWrM_kernel,
	 input `CS ChipSelect
    );

wire [5:0]Exception;
//wire kernel;

wire `b32 npc,pc;
PC _pc(clock,reset,PCWr,npc,pc);

wire[5:0]opcodeF,functF;
wire[4:0]rsF,rtF,rdF;
wire[15:0]imm16F;
wire[25:0]imm26F;
wire `b32 insF;
IM _im(pc,opcodeF,functF,rsF,rtF,rdF,imm16F,imm26F,insF);

//wire eretD,eretE,eretM;
wire eretE,eretM;
wire `b32 EPC;
//wire `NPCOp NPCOpD;
wire `b32 FWR1D,FWR2D;
wire `b32 R1D,R2D,R1E,R2E,R2M;
wire `b32 PC8F;
wire [25:0]imm26D;
wire `b32 PC8D,PC8E,PC8M,PC8W;
wire `b32 PCD,PCE,PCM,PCW;
NPC _npc(NPCOpD,pc,imm26D,FWR1D,ben,PC8D,PCD,EPC,eretD,kernel,npc,PC8F);

wire `b32 insD;
wire[4:0]rdD,rdE,rdM;
wire[15:0]imm16D;

//wire GeneralFlush;
wire jumpD,jumpE,jumpM,jumpW;

F_D _fd(clock,reset,
	FDEn,FDFlush,insF,PC8F,pc,
	eretD,LikelyD,npc,
	insD,rsD,rtD,rdD,imm16D,imm26D,PC8D,PCD,
	jumpD,DelaySlotD,
	GeneralFlush
);

//wire[4:0]DstD;
wire[4:0]DstE;
wire `b32 WD;
GRF _grf(clock,reset,
	RFWrW,rsD,rtD,DstW,WD,
	R1D,R2D,
	PCW
);

wire `EXTOp EXTOpD;
wire `b32 EXD,EXE;
EXT _ext(EXTOpD,imm16D,EXD);

wire `A3S A3SelD;
A3S _a3s(A3SelD,rdD,rtD,DstD);

wire `b32 ALUE,ALUM,ALUW;
wire `b32 MEMM,MEMW;
wire `b32 MDUE,MDUM,MDUW;
FWS _fwsdrs(ForwardRsD,R1D,WD,ALUM,MDUM,PC8M,PC8E,FWR1D);
FWS _fwsdrt(ForwardRtD,R2D,WD,ALUM,MDUM,PC8M,PC8E,FWR2D);

wire `BJOp BJOpD;
BJ _bj(BJOpD,FWR1D,FWR2D,ben);

wire `WDS WDSelD,WDSelW;
wire `SHS SHSelD,SHSelE;
wire `ALUS ALUSelD,ALUSelE;
wire `ALUOp ALUOpD,ALUOpE;
wire `DMOp DMOpD,DMOpE,DMOpM;
wire RFWrD,RFWrE;
wire DMWrD,DMWrE,DMWrM;
wire MDUWrD,MDUWrE;
wire `MDUOp MDUOpD,MDUOpE;
wire `TNew TNewD,TNewE,TNewW;
wire `DMAS DMASelD,DMASelE,DMASelM;
wire `DMWS DMWSelD,DMWSelE,DMWSelM;

//wire `TIndex TIndexD,TIndexW;
wire `TIndex TIndexW;
//wire LikelyD;
wire `EType ETypeD,ETypeE,ETypeM;
wire ILOPD;

wire CP0WrD;//,CP0WrE,CP0WrM;
wire [2:0]selD,selE,selM;
assign selD=insD[2:0];

wire DelaySlotD,DelaySlotE,DelaySlotM;

CTRL _ctrl(insD,ben,
	A3SelD,WDSelD,SHSelD,ALUSelD,
	NPCOpD,EXTOpD,ALUOpD,BJOpD,DMOpD,MDUOpD,
	RFWrD,DMWrD,MDUWrD,
	TUseRsD,TUseRtD,TNewD,
	DMASelD,DMWSelD,
	TIndexD,
	MDUDpD,
	LikelyD,
	ETypeD,
	ILOPD,
	eretD,
	CP0WrD,
	jumpD
);
wire `b32 CP0M,CP0W;

WDS _wds(WDSelW,ALUW,MEMW,MDUW,PC8W,CP0W,WD);

//assign DelaySlotD = jumpE;

D_E _de(clock,reset,DEFlush,
	TNewD,
	RFWrD,DMWrD,MDUWrD,
	ALUOpD,DMOpD,MDUOpD,
	WDSelD,ALUSelD,SHSelD,
	FWR1D,FWR2D,EXD,rsD,rtD,DstD,PC8D,PCD,
	selD,eretD,CP0WrD,rdD,jumpD,DelaySlotD,
	TNewE,
	RFWrE,DMWrE,MDUWrE,
	ALUOpE,DMOpE,MDUOpE,
	WDSelE,ALUSelE,SHSelE,
	R1E,R2E,EXE,rsE,rtE,DstE,PC8E,PCE,
	selE,eretE,CP0WrE,rdE,jumpE,DelaySlotE,

	DMASelD,DMWSelD,DMASelE,DMWSelE,
	TIndexD,TIndexE,
	ETypeD,ETypeE,
	GeneralFlush
);

wire `b32 FWR1E,FWR2E;
FWS _fwsers(ForwardRsE,R1E,WD,ALUM,MDUM,PC8M,PC8E,FWR1E);
FWS _fwsert(ForwardRtE,R2E,WD,ALUM,MDUM,PC8M,PC8E,FWR2E);

wire `b32 hi,lo;
wire `b32 PC8MDU,PCMDU;

wire MDUWrE_kernel;
assign MDUWrE_kernel=(MDUWrE & ~kernel);

MDU _mdu(clock,reset,
	MDUOpE,MDUWrE_kernel,FWR1E,FWR2E,MDUE,
	DstE,PC8E,PCE,
	hi,lo,
	RFWrMDU,DstMDU,PC8MDU,PCMDU,
	MDUBusy,MDUReady,MDUToBusy
);

wire `b32 ALU1,ALU2;
SHS _shs(SHSelE,FWR1E,EXE,ALU1);
ALUS _alus(ALUSelE,FWR2E,EXE,ALU2);

wire Overflow;
ALU _alu(ALUOpE,ALU1,ALU2,ALUE,EXE,Overflow);

wire `WDS WDSelE_MDU;
//wire RFWrE_MDU;
//wire [4:0]DstE_MDU;
wire `b32 PC8E_MDU,PCE_MDU;

assign WDSelE_MDU=
	(~MDUBusy & ~MDUToBusy & MDUReady & RFWrMDU)? `WDS_MDU : WDSelE;
assign RFWrE_MDU=
	(~MDUBusy & ~MDUToBusy & MDUReady & RFWrMDU)? 1 : RFWrE;
assign TNewE_MDU=
	(~MDUBusy & ~MDUToBusy & MDUReady & RFWrMDU)? 1 : TNewE;
assign DstE_MDU=
	(~MDUBusy & ~MDUToBusy & MDUReady & RFWrMDU)? DstMDU : DstE;
assign PC8E_MDU=
	(~MDUBusy & ~MDUToBusy & MDUReady & RFWrMDU)? PC8MDU : PC8E;
assign PCE_MDU=
	(~MDUBusy & ~MDUToBusy & MDUReady & RFWrMDU)? PCMDU : PCE;

E_M _em(clock,reset,
	TNewE_MDU,
	RFWrE_MDU,
	DMWrE,
	DMOpE,
	WDSelE_MDU,
	DstE_MDU,
	FWR2E,rtE,
	ALUE,
	PC8E_MDU,
	MDUE,
	PCE_MDU,
	selE,eretE,CP0WrE,rdE,jumpE,DelaySlotE,
	TNewM,
	RFWrM,DMWrM,
	DMOpM,
	WDSelM,
	DstM,R2M,rtM,
	ALUM,PC8M,MDUM,PCM,
	selM,eretM,CP0WrM,rdM,jumpM,DelaySlotM,
	
	DMASelE,DMWSelE,DMASelM,DMWSelM,
	TIndexE,TIndexM,
	ETypeE,ETypeM,
	GeneralFlush
);

wire `b32 FWR2M;
FWS _fwsmrt(ForwardRtM,R2M,WD,ALUM,MDUM,PC8M,PC8E,FWR2M);

//wire `b32 DMAddr,DMWD;
DMAS _dmas(DMASelM,ALUM,FWR2M,MDUM,DMAddr);
DMWS _dmws(DMWSelM,FWR2M,ALUM,MDUM,DMWD);

//wire DMWrM_kernel;
assign DMWrM_kernel=(DMWrM & ~kernel);

wire DMWr_CS;
assign DMWr_CS= DMWrM_kernel && (ChipSelect == `CS_DM);

wire `b32 DMRD;

DM _dm(clock,reset,
	DMAddr,DMWr_CS,DMOpM,DMWD,
	DMRD,
	PCM
);

assign MEMM =
	(ChipSelect == `CS_DM) ? DMRD :
	(ChipSelect == `CS_IM) ? `HW_Err :
	HWRD;

M_W _mw(clock,reset,
	TNewM,RFWrM,WDSelM,DstM,ALUM,MEMM,PC8M,MDUM,CP0M,PCM,jumpM,
	TNewW,RFWrW,WDSelW,DstW,ALUW,MEMW,PC8W,MDUW,CP0W,PCW,jumpW,
	TIndexM,TIndexW,
	GeneralFlush
);

EXU _exu(clock,reset,
	pc,ILOPD,Overflow,ETypeE,DMAddr,DMOpM,ETypeM,
	Exception,
	FDFlush,DEFlush,GeneralFlush
);

//wire [5:0]HInt;


Coprocessor0 _cp0(clock,reset,
	rdM,selM,FWR2M,CP0M,PCM,
	Exception,eretM,HInt,CP0WrM,
	kernel,EPC,
	DelaySlotM
);

assign EPCExpectation=PCM;

endmodule
