`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:47:28 11/12/2019 
// Design Name: 
// Module Name:    MW 
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
module M_W(
    input clock,
    input reset,
	 input [`TNewlen-1:0]TNewM,
    input RFWrM,
    input [`WDSlen-1:0] WDSelM,
    input [4:0] DstM,
	 input [31:0] ALUM,
	 input [31:0] MEMM,
    input [31:0] PC8M,
	 input [31:0] MDUM,
	 input [31:0] CP0M,
	 input [31:0] PCM,
	 input jumpM,
	 output reg [`TNewlen-1:0]TNewW,
	 output reg RFWrW,
    output reg [`WDSlen-1:0] WDSelW,
    output reg [4:0] DstW,
    output reg [31:0] ALUW,
    output reg [31:0] MEMW,
    output reg [31:0] PC8W,
	 output reg [31:0] MDUW,
	 output reg [31:0] CP0W,
	 output reg [31:0] PCW,
	 output reg jumpW,
	 
	 input `TIndex TIndexM,
	 output reg `TIndex TIndexW,
	 input GeneralFlush
    );
initial begin
	TNewW<=0;
	RFWrW<=0;
	WDSelW<=0;
	DstW<=0;
	ALUW<=0;
	MEMW<=0;
	PC8W<=0;
	MDUW<=0;
	PCW<=0;
	TIndexW<=0;
	CP0W<=0;
	jumpW<=0;
end
always@(posedge clock)begin
	if(reset || GeneralFlush)begin
		TNewW<=0;
		RFWrW<=0;
		WDSelW<=0;
		DstW<=0;
		ALUW<=0;
		MEMW<=0;
		PC8W<=0;
		MDUW<=0;
		PCW<=0;
		TIndexW<=0;
		CP0W<=0;
		jumpW<=0;
	end
	else begin
		if(TNewM!=0)begin
			TNewW<=TNewM-1;
		end
		else begin
			TNewW<=0;
		end
		RFWrW<=RFWrM;
		WDSelW<=WDSelM;
		DstW<=DstM;
		ALUW<=ALUM;
		MEMW<=MEMM;
		PC8W<=PC8M;
		MDUW<=MDUM;
		PCW<=PCM;
		CP0W<=CP0M;
		if(TIndexM!=0)begin
			TIndexW<=TIndexM-1;
		end
		else begin
			TIndexW<=0;
		end
		jumpW<=jumpM;
	end
end

endmodule
