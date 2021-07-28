`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:18:54 11/30/2019 
// Design Name: 
// Module Name:    Coprocessor0 
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
module Coprocessor0(
    input clock,
    input reset,
    input [4:0] Addr,		//LevelM
	 input [2:0] sel,			//LevelM
    input [31:0] DIn,		//LevelM
    output reg [31:0] DOut,//LevelM
    input [31:0] PCex,		//LevelM
    input [5:0] exception,	//LevelM
    input eret,				//LevelM
    input [5:0] HInt,		//LevelM
    input CP0Wr,				//LevelM
    output kernel,			//LevelF
    output [31:0] EPC,		//LevelF
	 input DelaySlotM			//LevelM //To judge if the instruction in level M is in the delay slot
    );

reg[31:0]CP0reg[31:0];
`define SR CP0reg[12]
`define CAUSE CP0reg[13]
`define EPC CP0reg[14]
`define PrID CP0reg[15]
`define IntEn `SR[15:10]
`define CurrentInt `CAUSE[15:10]
`define EXL `SR[1]
`define GlbEn `SR[0]
`define ExcCode `CAUSE[6:2]
`define BD `CAUSE[31]

always@(*)begin
	`ifdef cp0_demo
		DOut=`PrID;
		case(Addr)
			12:begin
				DOut={16'b0,`IntEn,8'b0,`EXL,`GlbEn};
			end
			13:begin
				//DOut={`BD,15'b0,`CurrentInt,3'b0,`ExcCode,2'b0};
				DOut={`BD,15'b0,HInt,3'b0,`ExcCode,2'b0};
			end
			14:begin
				DOut=`EPC;
			end
			15:begin
				DOut=`PrID;
			end
		endcase
	`else
		DOut=CP0reg[Addr];
	`endif
end

wire request;
assign request= |(HInt & `IntEn) & ~`EXL & `GlbEn;
assign EPC=`EPC;

assign kernel=request | (exception[5] & ~`EXL);

wire[31:0]PCex_aligned;
`ifdef cp0_demo
assign PCex_aligned={PCex[31:2],2'b0};
`else
assign PCex_aligned=PCex;
`endif

always@(posedge clock)begin
	if(reset)begin
		`SR<=`SR_init;
		`CAUSE<=`CAUSE_init;
		`EPC<=`EPC_init;
		`PrID<=`PrID_init;
	end
	else begin
	//$display("PCexM: %h",PCex);
		if(kernel & DelaySlotM)begin
			`BD<=1;
		end
		if(request)begin
			if(DelaySlotM)begin
				`EPC<=PCex_aligned-4;
			end
			else begin
				`EPC<=PCex_aligned;
			end
			`CurrentInt<=HInt;// & `IntEn;
			`ExcCode<=5'b00000;
			`EXL<=1;
		end
		else if(exception[5] & ~`EXL)begin //Exceptions do not use `GlbEn as a criterion
			if(DelaySlotM)begin
				`EPC<=PCex_aligned-4;
			end
			else begin
				`EPC<=PCex_aligned;
			end
			`CurrentInt<=HInt;//
			`ExcCode<=exception[4:0];
			`EXL<=1;
		end
		else if(eret)begin
			//`CurrentInt<=0;
			//`ExcCode<=0;
			`EXL<=0;
			`BD<=0;
		end
		else if(CP0Wr)begin
			case(Addr)
				12:begin//SR
					`SR<=DIn;
				end
				14:begin//EPC
					`EPC<=DIn;
				end
			endcase
		end
	end
end
endmodule
