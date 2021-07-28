`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:16:31 11/07/2019 
// Design Name: 
// Module Name:    mux 
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
module A3S(
    input [`A3Slen-1:0] sel,
    input [4:0] rd,
    input [4:0] rt,
    output reg [4:0] A3
    );
always@(*)begin
	A3=rd;
	case(sel)
		`A3S_rd:begin
			A3=rd;
		end
		`A3S_rt:begin
			A3=rt;
		end
		`A3S_ra:begin
			A3=`RF_ra;
		end
	endcase
end
endmodule

module WDS(
    input [`WDSlen-1:0] sel,
    input [31:0] ALU,
    input [31:0] MEM,
	 input [31:0] MDU,
    input [31:0] NPC,
	 input [31:0] CP0,
    output reg [31:0] WD
    );
always@(*)begin
	WD=ALU;
	case(sel)
		`WDS_ALU:begin
			WD=ALU;
		end
		`WDS_MEM:begin
			WD=MEM;
		end
		`WDS_NPC:begin
			WD=NPC;
		end
		`WDS_MDU:begin
			WD=MDU;
		end
		`WDS_CP0:begin
			WD=CP0;
		end
	endcase
end
endmodule

module SHS(
    input [`SHSlen-1:0] sel,
    input [31:0] rs,
    input [31:0] sh,
    output reg [31:0] ALUop1
    );
always@(*)begin
	ALUop1=rs;
	case(sel)
		`SHS_rs:begin
			ALUop1=rs;
		end
		`SHS_sh:begin
			ALUop1=sh;
		end
	endcase
end
endmodule

module ALUS(
    input [`ALUSlen-1:0] sel,
    input [31:0] rt,
    input [31:0] imm,
    output reg [31:0] ALUop2
    );
always@(*)begin
	ALUop2=rt;
	case(sel)
		`ALUS_rt:begin
			ALUop2=rt;
		end
		`ALUS_imm:begin
			ALUop2=imm;
		end
	endcase
end
endmodule

module DMAS(
    input [`DMASlen-1:0] sel,
    input [31:0] res,
    input [31:0] rt,
	 input [31:0] mdu,
    output reg [31:0] Addr
    );
always@(*)begin
	Addr=res;
	case(sel)
		`DMAS_res:begin
			Addr=res;
		end
		`DMAS_rt:begin
			Addr=rt;
		end
		`DMAS_mdu:begin
			Addr=mdu;
		end
	endcase
end
endmodule

module DMWS(
    input [`DMWSlen-1:0] sel,
    input [31:0] rt,
    input [31:0] res,
	 input [31:0] mdu,
    output reg [31:0] DMWD
    );
always@(*)begin
	DMWD=rt;
	case(sel)
		`DMWS_rt:begin
			DMWD=rt;
		end
		`DMWS_res:begin
			DMWD=res;
		end
		`DMWS_mdu:begin
			DMWD=mdu;
		end
	endcase
end
endmodule

module FWS(
	 input [`FWSlen-1:0]sel,
	 input [31:0]orig,
	 input [31:0]W,
	 input [31:0]MALU,
	 input [31:0]MMDU,
	 input [31:0]MPC8,
	 input [31:0]EPC8,
	 output reg [31:0]O
	 );
	always@(*)begin
		O=0;
		case(sel)
			`FW_orig:	O=orig;
			`FW_W:		O=W;
			`FW_MALU:	O=MALU;
			`FW_MMDU:	O=MMDU;
			`FW_MPC8:	O=MPC8;
			`FW_EPC8:	O=EPC8;
		endcase
	end
endmodule
