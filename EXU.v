`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:50:33 12/05/2019 
// Design Name: 
// Module Name:    EXU 
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
module EXU(
	 input clock,
	 input reset,
    input [31:0] PCF,
    input ILOP,
    input Overflow,
    input `EType ETypeE,
    input [31:0] ALUM,
    input `DMOp DMOpM,
    input `EType ETypeM,
    output [5:0] Exception,
	 input FDFlush,
	 input DEFlush,
	 input GeneralFlush
    );
reg[5:0]EXCD,EXCE,EXCM;
initial begin
	EXCD<=`EXC_NONE;
	EXCE<=`EXC_NONE;
	EXCM<=`EXC_NONE;
end

wire[5:0]analyze_F,analyze_D,analyze_E,analyze_M;
assign
	analyze_F=
		//PC='h0_0_0_0_(3,4)_xxxx_xxxx_xx00
		(PCF[1:0]!=2'b00 || (PCF[31:12]!=20'h00003 && PCF[31:12]!=20'h00004)) ? `EXC_PCAD : `EXC_NONE,
	analyze_D=
		(ILOP) ? `EXC_ILOP : `EXC_NONE,
	analyze_E=
		(Overflow && (ETypeE == `ET_ARIT)) ? `EXC_OVER :
		(Overflow && (ETypeE == `ET_LOAD)) ? `EXC_DRAD :
		(Overflow && (ETypeE == `ET_SAVE)) ? `EXC_DWAD :
		`EXC_NONE,
	analyze_M=
		//ALUM='h0000(0,1,2)xx(xx00) or 'h00007f0(0,4,8) or 'h00007f1(0,4,8)
		ETypeM == `ET_LOAD ? (
			(
				DMOpM != `DM_w && ALUM[31:8]=='h00007f ||
				DMOpM == `DM_w && ALUM[1:0]!=0 ||
				(DMOpM == `DM_h || DMOpM == `DM_hu) && ALUM[0]!=0 ||
				ALUM[31:16]!='h0000 ||
				ALUM[15:12]!='h0 && ALUM[15:12]!='h1 && ALUM[15:12]!='h2 && ALUM[15:4]!='h7f0 && ALUM[15:4]!='h7f1 ||
				ALUM[15:8]=='h7f && ALUM[3:2]==3
			) ? `EXC_DRAD : `EXC_NONE
		) :
		ETypeM == `ET_SAVE ? (
			(
				DMOpM != `DM_w && ALUM[31:8]=='h00007f ||
				DMOpM == `DM_w && ALUM[1:0]!=0 ||
				(DMOpM == `DM_h || DMOpM == `DM_hu) && ALUM[0]!=0 ||
				ALUM[31:16]!='h0000 ||
				ALUM[15:12]!='h0 && ALUM[15:12]!='h1 && ALUM[15:12]!='h2 && ALUM[15:4]!='h7f0 && ALUM[15:4]!='h7f1 ||
				ALUM[15:8]=='h7f && (ALUM[3:2]==2 || ALUM[3:2]==3)
			) ? `EXC_DWAD : `EXC_NONE
		) :
		`EXC_NONE;

always@(posedge clock)begin
	if(reset | GeneralFlush)begin
		EXCD<=`EXC_NONE;
		EXCE<=`EXC_NONE;
		EXCM<=`EXC_NONE;
	end
	else begin
		if(FDFlush)begin
			EXCD<=0;
		end
		else if(analyze_F `exc)begin
			EXCD<=analyze_F;
		end
		else begin
			EXCD<=`EXC_NONE;
		end
		
		if(DEFlush)begin
			EXCE<=0;
		end
		else if(EXCD `exc)begin
			EXCE<=EXCD;
		end
		else if(analyze_D `exc)begin
			EXCE<=analyze_D;
		end
		else begin
			EXCE<=`EXC_NONE;
		end
		
		if(EXCE `exc)begin
			EXCM<=EXCE;
		end
		else if(analyze_E `exc)begin
			EXCM<=analyze_E;
		end
		else begin
			EXCM<=`EXC_NONE;
		end
	end
end

assign Exception=
	(EXCM `exc)? EXCM : analyze_M;

endmodule
