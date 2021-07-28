`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:25:30 11/13/2019 
// Design Name: 
// Module Name:    MDU 
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
module MDU(
    input clock,
    input reset,
    input [`MDUOp_len-1:0] MDUOp,
    input MDUWr,
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] Res,
	 input [4:0] DstE,
	 input `b32 PC8E,
	 input `b32 PCE,
	 output reg [31:0] realhi,
	 output reg [31:0] reallo,
	 output RFWrExeOut,
	 output reg [4:0] DstExe,
	 output reg `b32 PC8Exe,
	 output reg `b32 PCExe,
	 output busy,ready,
	 output reg toBusy
    );
wire [63:0]As,Bs,Au,Bu;
assign As={ {32{A[31]}} ,A},Bs={ {32{B[31]}} ,B};
assign Au={32'b0,A},Bu={32'b0,B};
reg[31:0]hi,lo;

reg [3:0]count;
wire nomission;
assign busy=(count!=1)&&(count!=0);
assign ready=(count==2)||(count==1);
assign nomission=(count==0)||(count==1)&&!RFWrExe;

reg `MDUOp MDUOpExe;
reg RFWrExe;

initial begin
	hi<=0;
	lo<=0;
	count<=0;
	MDUOpExe<=0;
	RFWrExe<=0;
	DstExe<=0;
	realhi<=0;
	reallo<=0;
	PC8Exe<=0;
	PCExe<=0;
end

reg RFWrToBusy;
assign RFWrExeOut=RFWrToBusy | RFWrExe;

always@(*)begin
	Res=reallo;
	toBusy=0;
	RFWrToBusy=0;
	if(nomission) begin
		case(MDUOp)
			`MDU_hi:begin
				Res=realhi;
			end
			`MDU_lo:begin
				Res=reallo;
			end
		endcase
		if(MDUWr)begin
			case(MDUOp)
				`MDU_mult:begin
					toBusy=1;
				end
				`MDU_multu:begin
					toBusy=1;
				end
				`MDU_div:begin
					toBusy=1;
				end
				`MDU_divu:begin
					toBusy=1;
				end
				`MDU_madd:begin
					toBusy=1;
				end
				`MDU_maddu:begin
					toBusy=1;
				end
				`MDU_msub:begin
					toBusy=1;
				end
				`MDU_msubu:begin
					toBusy=1;
				end
				`MDU_mul:begin
					toBusy=1;
					RFWrToBusy=1;
				end
			endcase
		end
	end
	else begin
		case(MDUOpExe)
			`MDU_hi:begin
				Res=realhi;
			end
			`MDU_lo:begin
				Res=reallo;
			end
			`MDU_mul:begin
				Res=reallo;
			end
		endcase
	end
end

always@(posedge clock)begin
	if(reset)begin
		hi<=0;
		lo<=0;
		count<=0;
		MDUOpExe<=0;
		RFWrExe<=0;
		DstExe<=0;
		realhi<=0;
		reallo<=0;
		PC8Exe<=0;
		PCExe<=0;
	end
	else if(MDUWr&nomission) begin
		MDUOpExe<=MDUOp;
		case(MDUOp)
			`MDU_mult:begin
				{hi,lo}<=$signed(As)*$signed(Bs);
				count<=6;
			end
			`MDU_multu:begin
				{hi,lo}<=Au*Bu;
				count<=6;
			end
			`MDU_div:begin
				if(B!=0)begin
					hi<=$signed(A)%$signed(B);
					lo<=$signed(A)/$signed(B);
				end
				count<=11;
			end
			`MDU_divu:begin
				if(B!=0)begin
					hi<=A%B;
					lo<=A/B;
				end
				count<=11;
			end
			`MDU_hi:begin
				hi<=A;
				realhi<=A;
				count<=0;
			end
			`MDU_lo:begin
				lo<=A;
				reallo<=A;
				count<=0;
			end
			`MDU_madd:begin
				{hi,lo}<={hi,lo}+$signed(As)*$signed(Bs);
				count<=6;
			end
			`MDU_maddu:begin
				{hi,lo}<={hi,lo}+Au*Bu;
				count<=6;
			end
			`MDU_msub:begin
				{hi,lo}<={hi,lo}-$signed(As)*$signed(Bs);
				count<=6;
			end
			`MDU_msubu:begin
				{hi,lo}<={hi,lo}-Au*Bu;
				count<=6;
			end
			`MDU_mul:begin
				{hi,lo}<=$signed(As)*$signed(Bs);
				count<=6;
				DstExe<=DstE;
				RFWrExe<=1;
				PC8Exe<=PC8E;
				PCExe<=PCE;
			end
		endcase
	end
	else begin
		if(count!=0)begin
			count<=count-1;
		end
		if(busy&ready)begin
			realhi<=hi;
			reallo<=lo;
		end
		if(!busy&ready)begin
			RFWrExe<=0;
			DstExe<=0;
			PC8Exe<=0;
			PCExe<=0;
		end
	end
end
endmodule
