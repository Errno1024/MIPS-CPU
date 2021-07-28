`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:33:49 11/07/2019 
// Design Name: 
// Module Name:    GRF 
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
module Register(
    input clock,
    input reset,
    input en,
    input [31:0] resetVal,
    input [31:0] In,
    output reg [31:0] Out
    );
	 initial Out<=0;
	 
	always@(posedge clock)begin
		if(reset)Out<=resetVal;
		else if(en)Out<=In;
	end
endmodule

module GRF(
    input clk,
    input reset,
    input RFWr,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
    output [31:0] RD1,
    output [31:0] RD2,
	 input [31:0] pc
    );
wire [31:0]Outs[31:0];
wire ens[31:0];
wire [31:0]resetVals[31:0];
assign Outs[0]=32'b0;
assign RD1=Outs[A1],RD2=Outs[A2];

genvar i;
generate
	for(i=1;i<32;i=i+1)begin:gen_Register
		assign ens[i]=RFWr && (A3==i);
		case(i)
			`RF_sp:assign resetVals[i]=`sp_init;
			`RF_gp:assign resetVals[i]=`gp_init;
			default:assign resetVals[i]=32'b0;
		endcase
		Register register(clk,reset,ens[i],resetVals[i],WD,Outs[i]);
	end
endgenerate

always@(posedge clk)begin
	if(~reset & RFWr)begin
		if(A3!=0)//
			$display("%d@%h: $%d <= %h",$time,pc,A3,WD);
	end
end
endmodule
