`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:41:17 11/12/2019 
// Design Name: 
// Module Name:    EM 
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
module E_M(
    input clock,
    input reset,
	 input [`TNewlen-1:0]TNewE,
    input RFWrE,
	 input DMWrE,
	 input [`DMOp_len-1:0] DMOpE,
    input [`WDSlen-1:0] WDSelE,
    input [4:0] DstE,
    input [31:0] R2E,
	 input [4:0] rtE,
    input [31:0] ALUE,
    input [31:0] PC8E,
	 input [31:0] MDUE,
	 input [31:0] PCE,
	 input [2:0] selE,
	 input eretE,
	 input CP0WrE,
	 input [4:0]rdE,
	 input jumpE,
	 input DelaySlotE,
	 output reg [`TNewlen-1:0]TNewM,
    output reg RFWrM,
    output reg DMWrM,
	 output reg [`DMOp_len-1:0] DMOpM,
    output reg [`WDSlen-1:0] WDSelM,
    output reg [4:0] DstM,
    output reg [31:0] R2M,
	 output reg [4:0] rtM,
    output reg [31:0] ALUM,
    output reg [31:0] PC8M,
	 output reg [31:0] MDUM,
	 output reg [31:0] PCM,
	 output reg [2:0] selM,
	 output reg eretM,
	 output reg CP0WrM,
	 output reg [4:0]rdM,
	 output reg jumpM,
	 output reg DelaySlotM,
	 
	 input `DMAS DMASelE,
	 input `DMWS DMWSelE,
	 output reg `DMAS DMASelM,
	 output reg `DMWS DMWSelM,
	 input `TIndex TIndexE,
	 output reg `TIndex TIndexM,
	 input `EType ETypeE,
	 output reg `EType ETypeM,
	 input GeneralFlush
    );
initial begin
	TNewM<=0;
	RFWrM<=0;
	DMWrM<=0;
	DMOpM<=0;
	WDSelM<=0;
	DstM<=0;
	R2M<=0;
	rtM<=0;
	ALUM<=0;
	PC8M<=0;
	MDUM<=0;
	PCM<=0;
	
	DMASelM<=0;
	DMWSelM<=0;
	TIndexM<=0;
	
	ETypeM<=0;
	
	selM<=0;
	eretM<=0;
	CP0WrM<=0;
	rdM<=0;
	jumpM<=0;
	DelaySlotM<=0;
end
always@(posedge clock)begin
	if(reset || GeneralFlush)begin
		TNewM<=0;
		RFWrM<=0;
		DMWrM<=0;
		DMOpM<=0;
		WDSelM<=0;
		DstM<=0;
		R2M<=0;
		rtM<=0;
		ALUM<=0;
		PC8M<=0;
		MDUM<=0;
		PCM<=0;
		
		DMASelM<=0;
		DMWSelM<=0;
		TIndexM<=0;
		
		ETypeM<=0;
		
		selM<=0;
		eretM<=0;
		CP0WrM<=0;
		rdM<=0;
		jumpM<=0;
		DelaySlotM<=0;
	end
	else begin
		if(TNewE!=0)begin
			TNewM<=TNewE-1;
		end
		else begin
			TNewM<=0;
		end
		RFWrM<=RFWrE;
		DMWrM<=DMWrE;
		DMOpM<=DMOpE;
		WDSelM<=WDSelE;
		DstM<=DstE;
		R2M<=R2E;
		rtM<=rtE;
		ALUM<=ALUE;
		PC8M<=PC8E;
		MDUM<=MDUE;
		PCM<=PCE;
		
		DMASelM<=DMASelE;
		DMWSelM<=DMWSelE;
		if(TIndexE!=0)begin
			TIndexM<=TIndexE-1;
		end
		else begin
			TIndexM<=0;
		end
		
		ETypeM<=ETypeE;
		
		selM<=selE;
		eretM<=eretE;
		CP0WrM<=CP0WrE;
		rdM<=rdE;
		jumpM<=jumpE;
		DelaySlotM<=DelaySlotE;
	end
end

endmodule
