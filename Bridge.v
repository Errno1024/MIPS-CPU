`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:09:19 12/07/2019 
// Design Name: 
// Module Name:    Bridge 
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
`define AD_DM_begin	32'h00000000
`define AD_DM_end		32'h00003000
`define AD_IM_begin	32'h00003000
`define AD_IM_end		32'h00005000
`define AD_H1_begin	32'h00007F00
`define AD_H1_end		32'h00007F0C
`define AD_H2_begin	32'h00007F10
`define AD_H2_end		32'h00007F1C
module Bridge(
    input [31:0] Addr,
    input [31:0] DMWD,
	 input DMWr,
    output [31:0] DMRD,
    input [31:0] H0RD,
    input [31:0] H1RD,
    output [31:0] HWD,
    output [31:0] HAddr,
    output H0Wr,
    output H1Wr,
	 input H0Int,
	 input H1Int,
	 input H2Int,
	 output [5:0] HWInt,
	 output `CS ChipSelect
    );
assign HAddr={Addr[31:2],2'b0};
//assign HWD=DMWD;
assign HWInt={
	1'b0,
	1'b0,
	1'b0,
	H2Int,
	H1Int,
	H0Int
};
//DM (0,1,2)xxx
//IM (3,4)xxx
//H0 7F0x
//H1 7F1x
assign ChipSelect=
	(Addr[15:12]=='h0 || Addr[15:12]=='h1 || Addr[15:12]=='h2) ? `CS_DM :
	(Addr[15:12]=='h3 || Addr[15:12]=='h4) ? `CS_IM :
	(Addr[15:4]=='h7F0) ? `CS_H0 :
	(Addr[15:4]=='h7F1) ? `CS_H1 :
	`CS_DM;//Default

assign H0Wr=DMWr && (ChipSelect==`CS_H0);
assign H1Wr=DMWr && (ChipSelect==`CS_H1);

assign DMRD=
	(ChipSelect == `CS_H0) ? H0RD :
	(ChipSelect == `CS_H1) ? H1RD :
	`HW_Err;

assign HWD=DMWD;

endmodule
