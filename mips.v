`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:12:08 11/07/2019 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset,
	 input interrupt,
	 output [31:0]addr
    );
wire PCWr,FDEn,FDFlush,DEFlush;
wire `FWS ForwardRsD,ForwardRtD,ForwardRsE,ForwardRtE,ForwardRtM;
wire `TUse TUseRsD,TUseRtD;
wire `TNew TNewE,TNewM;
wire `NPCOp NPCOpD;
wire ben;
wire [4:0]rsD,rtD,rsE,rtE,rtM,DstE,DstM,DstW;
wire RFWrE,RFWrM,RFWrW;
wire `WDS WDSelE,WDSelM;

wire `TIndex TIndexE,TIndexM;
wire MDUDpD;
wire MDUBusy,MDUReady,MDUToBusy;
wire RFWrMDU;
wire [4:0]DstMDU;
wire [4:0]DstD;
wire `TIndex TIndexD;
wire LikelyD;
wire kernel,eretD,GeneralFlush;

wire `b32 DMAddr,DMWD,DMRD,H0RD,H1RD,HWD,HAddr;
wire DMWrM,H0Wr,H1Wr,H0Int,H1Int;
wire `CS ChipSelect;

wire[5:0]HInt;
wire CP0WrE,CP0WrM;
Datapath _datapath(clk,reset,
	PCWr,FDEn,FDFlush,DEFlush,
	ForwardRsD,ForwardRtD,ForwardRsE,ForwardRtE,ForwardRtM,
	TUseRsD,TUseRtD,
	TNewE,TNewM,
	NPCOpD,ben,
	rsD,rtD,rsE,rtE,rtM,DstE,DstM,DstW,
	RFWrE,RFWrM,RFWrW,WDSelE,WDSelM,
	
	TIndexE,TIndexM,
	MDUDpD,MDUBusy,MDUReady,MDUToBusy,RFWrMDU,DstMDU,
	DstD,TIndexD,
	LikelyD,
	kernel,eretD,CP0WrE,CP0WrM,GeneralFlush,
	
	HInt,addr,
	
	DMAddr,DMWD,DMRD,DMWrM,ChipSelect
);


Hazard _Hazard(
	TUseRsD,TUseRtD,
	TNewE,TNewM,
	NPCOpD,ben,
	rsD,rtD,rsE,rtE,rtM,DstE,DstM,DstW,
	RFWrE,RFWrM,RFWrW,WDSelE,WDSelM,
	PCWr,FDEn,FDFlush,DEFlush,
	ForwardRsD,ForwardRtD,ForwardRsE,ForwardRtE,ForwardRtM,
	
	TIndexE,TIndexM,
	MDUDpD,MDUBusy,MDUReady,MDUToBusy,RFWrMDU,DstMDU,
	DstD,TIndexD,
	LikelyD,
	kernel,eretD,CP0WrE,CP0WrM,GeneralFlush
);

Bridge _bridge(
	DMAddr,DMWD,DMWrM,DMRD,
	H0RD,H1RD,HWD,HAddr,
	H0Wr,H1Wr,
	H0Int,H1Int,interrupt,
	HInt,
	ChipSelect
);

TC _tc0(clk,reset,HAddr[31:2],H0Wr,HWD,H0RD,H0Int);
TC _tc1(clk,reset,HAddr[31:2],H1Wr,HWD,H1RD,H1Int);

endmodule
