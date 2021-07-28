`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:29:31 11/12/2019 
// Design Name: 
// Module Name:    FD 
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
module F_D(
    input clock,
    input reset,
    input en,
    input flush,
    input [31:0] ins,
	 input [31:0] PC8F,
	 input [31:0] PCF,
	 input eret,
	 input Likely,
	 input [31:0] npc,
	 output reg [31:0]reg_ins,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [15:0] imm16,
    output [25:0] imm26,
	 output reg [31:0] PC8D,
	 output reg [31:0] PCD,
	 input jumpD,
	 output reg DelaySlotD,
	 input GeneralFlush
    );
assign 	opcode=reg_ins[31:26],
			rs=reg_ins[25:21],
			rt=reg_ins[20:16],
			rd=reg_ins[15:11],
			funct=reg_ins[5:0],
			imm16=reg_ins[15:0],
			imm26=reg_ins[25:0];
initial begin
	reg_ins<=0;
	PC8D<=0;
	PCD<=0;
end
always@(posedge clock)begin
	if(reset || flush || GeneralFlush)begin
		reg_ins<=0;
		PC8D<=0;
		if(eret || Likely)begin
			PCD<=npc;
		end
		else begin
			PCD<=0;
		end
		DelaySlotD<=0;
	end
	else if(en) begin
		reg_ins<=ins;
		PC8D<=PC8F;
		PCD<=PCF;
		DelaySlotD<=jumpD;
	end
end
endmodule
