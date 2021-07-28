`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:56:06 11/07/2019 
// Design Name: 
// Module Name:    BJ 
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
module BJ(
    input [`BJOp_len-1:0] BJOp,
    input [31:0] rs,
    input [31:0] rt,
    output reg ben
    );
always@(*)begin
	ben=0;
	case(BJOp)
		`BJ_beq:begin
			ben=rs==rt;
		end
		`BJ_bne:begin
			ben=rs!=rt;
		end
		`BJ_bgtz:begin
			ben=(rs!=0)&&~rs[31];
		end
		`BJ_bltz:begin
			ben=rs[31];
		end
		`BJ_bgez:begin
			ben=~rs[31];
		end
		`BJ_blez:begin
			ben=(rs==0)||rs[31];
		end
		`BJ_movz:begin
			ben=rt==0;
		end
		`BJ_movn:begin
			ben=rt!=0;
		end
	endcase
end

endmodule
