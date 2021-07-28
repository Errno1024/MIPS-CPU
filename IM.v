`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:29:40 11/07/2019 
// Design Name: 
// Module Name:    IM 
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
module IM(
    input [31:0] Addr,
    output [5:0] opcode,
    output [5:0] funct,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [15:0] imm16,
	 output [25:0] imm26,
	 output [31:0] instr
    );
reg [31:0]mem[`IM_size-1:0];
wire [31:0]Address;
assign Address=Addr-`PC_init;

assign instr=(Addr[1:0] == 0) ? mem[{Address[31:2]}] : 32'h00000000;

assign opcode=instr[31:26],funct=instr[5:0],rs=instr[25:21],rt=instr[20:16],rd=instr[15:11],imm16=instr[15:0],imm26=instr[25:0];

integer i;
initial begin
	for(i=0;i<`IM_size;i=i+1)begin
		mem[i]=32'b0;
	end
	$readmemh("code.txt",mem);
	$readmemh("code_handler.txt",mem,1120,2047);
end
endmodule
