`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:15:25 11/07/2019 
// Design Name: 
// Module Name:    PC 
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
module PC(
	 input clk,
	 input reset,
	 input en,
    input [31:0] NPC,
    output reg [31:0] PC
    );
always@(posedge clk)begin
	if(reset)begin
		PC<=`PC_init;
	end
	else if(en) begin
		PC<=NPC;
	end
end
endmodule
