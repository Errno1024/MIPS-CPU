`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:36:50 11/12/2019 
// Design Name: 
// Module Name:    DE 
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
module D_E(
    input clock,
    input reset,
    input flush,
	 input [`TNewlen-1:0]TNewD,
    input RFWrD,
    input DMWrD,
	 input MDUWrD,
    input [`ALUOp_len-1:0] ALUOpD,
	 input [`DMOp_len-1:0] DMOpD,
	 input [`MDUOp_len-1:0] MDUOpD,
    input [`WDSlen-1:0] WDSelD,
    input [`ALUSlen-1:0] ALUSelD,
    input [`ALUSlen-1:0] SHSelD,
    input [31:0] R1D,
    input [31:0] R2D,
    input [31:0] EXD,
    input [4:0] rsD,
    input [4:0] rtD,
    input [4:0] DstD,
	 input [31:0] PC8D,
	 input [31:0] PCD,
	 input [2:0] selD,
	 input eretD,
	 input CP0WrD,
	 input [4:0] rdD,
	 input jumpD,
	 input DelaySlotD,
	 output reg [`TNewlen-1:0]TNewE,
    output reg RFWrE,
    output reg DMWrE,
	 output reg MDUWrE,
    output reg [`ALUOp_len-1:0] ALUOpE,
	 output reg [`DMOp_len-1:0] DMOpE,
	 output reg [`MDUOp_len-1:0] MDUOpE,
    output reg [`WDSlen-1:0] WDSelE,
    output reg [`ALUSlen-1:0] ALUSelE,
    output reg [`ALUSlen-1:0] SHSelE,
    output reg [31:0] R1E,
    output reg [31:0] R2E,
    output reg [31:0] EXE,
    output reg [4:0] rsE,
    output reg [4:0] rtE,
    output reg [4:0] DstE,
	 output reg [31:0] PC8E,
	 output reg [31:0] PCE,
	 output reg [2:0] selE,
	 output reg eretE,
	 output reg CP0WrE,
	 output reg [4:0] rdE,
	 output reg jumpE,
	 output reg DelaySlotE,
	 
	 input `DMAS DMASelD,
	 input `DMWS DMWSelD,
	 output reg `DMAS DMASelE,
	 output reg `DMWS DMWSelE,
	 input `TIndex TIndexD,
	 output reg `TIndex TIndexE,
	 input `EType ETypeD,
	 output reg `EType ETypeE,
	 input GeneralFlush
    );
initial begin
	TNewE<=0;
	RFWrE<=0;
	DMWrE<=0;
	MDUWrE<=0;
	ALUOpE<=0;
	DMOpE<=0;
	MDUOpE<=0;
	WDSelE<=0;
	ALUSelE<=0;
	SHSelE<=0;
	R1E<=0;
	R2E<=0;
	EXE<=0;
	rsE<=0;
	rtE<=0;
	DstE<=0;
	PC8E<=0;
	PCE<=0;
	
	DMASelE<=0;
	DMWSelE<=0;
	TIndexE<=0;
	
	ETypeE<=0;
	
	selE<=0;
	eretE<=0;
	CP0WrE<=0;
	rdE<=0;
	jumpE<=0;
	DelaySlotE<=0;
end
always@(posedge clock)begin
	if(reset || flush || GeneralFlush)begin
		TNewE<=0;
		RFWrE<=0;
		DMWrE<=0;
		MDUWrE<=0;
		ALUOpE<=0;
		DMOpE<=0;
		MDUOpE<=0;
		WDSelE<=0;
		ALUSelE<=0;
		SHSelE<=0;
		R1E<=0;
		R2E<=0;
		EXE<=0;
		rsE<=0;
		rtE<=0;
		DstE<=0;
		PC8E<=0;
		
		DMASelE<=0;
		DMWSelE<=0;
		TIndexE<=0;
		
		ETypeE<=0;
		
		selE<=0;
		eretE<=0;
		CP0WrE<=0;
		rdE<=0;
		jumpE<=0;
		if(reset || GeneralFlush)begin
			PCE<=0;
			DelaySlotE<=0;
		end
		else begin
			PCE<=PCD;
			DelaySlotE<=DelaySlotD;
		end
	end
	else begin
		TNewE<=TNewD;
		RFWrE<=RFWrD;
		DMWrE<=DMWrD;
		MDUWrE<=MDUWrD;
		ALUOpE<=ALUOpD;
		DMOpE<=DMOpD;
		MDUOpE<=MDUOpD;
		WDSelE<=WDSelD;
		ALUSelE<=ALUSelD;
		SHSelE<=SHSelD;
		R1E<=R1D;
		R2E<=R2D;
		EXE<=EXD;
		rsE<=rsD;
		rtE<=rtD;
		DstE<=DstD;
		PC8E<=PC8D;
		PCE<=PCD;
		
		DMASelE<=DMASelD;
		DMWSelE<=DMWSelD;
		if(TIndexD!=0)begin
			TIndexE<=TIndexD-1;
		end
		else begin
			TIndexE<=0;
		end
		
		ETypeE<=ETypeD;
		
		selE<=selD;
		eretE<=eretD;
		CP0WrE<=CP0WrD;
		rdE<=rdD;
		jumpE<=jumpD;
		DelaySlotE<=DelaySlotD;
	end
end

endmodule
