`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:23:16 11/07/2019 
// Design Name: 
// Module Name:    NPC 
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
module NPC(
    input [`NPCOp_len-1:0] NPCOp,
    input [31:0] pc,
    input [25:0] imm26,
    input [31:0] ra,
    input ben,
	 input [31:0]pc8D,
	 input [31:0]pcD,
	 input [31:0]epc,
	 input eret,
	 input kernel,
    output reg [31:0] npc,
    output [31:0] pc8
    );
	`ifdef delayslot
		assign pc8=pc+8;
	`else
		assign pc8=pc+4;
	`endif

	 wire[31:0]pc4;
	 assign pc4=pc+4;
always@(*)begin
	npc=pc4;
	if(kernel)begin
		npc=`EX_init;
	end
	else if(eret)begin
		npc=epc;
	end
	else begin
		case(NPCOp)
			`NPC_PC4:begin
				npc=pc4;
			end
			`NPC_B:begin
				if(ben)begin
					npc=pcD+4+{ {14{imm26[15]}} ,imm26[15:0],2'b0};
				end
				else begin
					npc=pc4;
				end
			end
			`NPC_J:begin
				npc={pc[31:28],imm26,2'b0};
			end
			`NPC_JR:begin
				npc=ra;
			end
		endcase
	end
end
endmodule
