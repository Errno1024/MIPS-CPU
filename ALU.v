`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:42:20 11/07/2019 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [`ALUOp_len-1:0] ALUOp,
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] Res,
	 input [31:0] Ext,
	 output reg Overflow
    );
reg cout,c31;
wire [32:0] As;
wire [32:0] Bs;
wire [32:0] Au;
wire [32:0] Bu;
assign As={A[31],A},Bs={B[31],B},Au={1'b0,A},Bu={1'b0,B};
wire [5:0]msb,lsb;
assign msb=Ext[15:11],lsb=Ext[10:6];
wire [4:0]sh;
assign sh=A[4:0];
integer i,flag;
always@(*)begin
	Res=0;
	Overflow=0;
	case(ALUOp)
		`ALU_add:begin
			{c31,Res[30:0]}={1'b0,A[30:0]}+{1'b0,B[30:0]};
			Res[31]=A[31]^B[31]^c31;
			cout=A[31]&B[31]|c31&A[31]|c31&B[31];
			Overflow=cout^c31;
		end
		`ALU_sub:begin
			{c31,Res[30:0]}={1'b0,A[30:0]}+{1'b0,~B[30:0]}+1;
			Res[31]=A[31]^(~B[31])^c31;
			cout=A[31]&(~B[31])|c31&A[31]|c31&(~B[31]);
			Overflow=cout^c31;
			if(A[31]==0&&B==32'h80000000)begin
				Overflow=1;
			end
		end
		`ALU_and:begin
			Res=A&B;
		end
		`ALU_or:begin
			Res=A|B;
		end
		`ALU_nor:begin
			Res=~(A|B);
		end
		`ALU_xor:begin
			Res=A^B;
		end
		`ALU_slt:begin
			Res=$signed(A)<$signed(B);
		end
		`ALU_sltu:begin
			Res=A<B;
		end
		`ALU_sll:begin
			Res=B<<A[4:0];
		end
		`ALU_srl:begin
			Res=B>>A[4:0];
		end
		`ALU_sra:begin
			Res=$signed(B)>>>A[4:0];
		end
		`ALU_clo:begin
			Res=0;
			flag=1;
			for(i=0;i<32;i=i+1)begin
				if(A[31-i]==1'b0)begin
					flag=0;
				end
				else if(flag)begin
					Res=Res+1;
				end
			end
		end
		`ALU_clz:begin
			Res=0;
			flag=1;
			for(i=0;i<32;i=i+1)begin
				if(A[31-i]==1'b1)begin
					flag=0;
				end
				else if(flag)begin
					Res=Res+1;
				end
			end
		end
		`ALU_ext:begin
			Res=0;
			for(i=0;i<32;i=i+1)begin
				if(i<=msb)begin
					Res[i]=A[i+lsb];
				end
			end
			//Res=A[lsb+msb:lsb];
		end
		`ALU_ins:begin
			Res=B;
			for(i=0;i<32;i=i+1)begin
				if(i>=lsb && i<=msb)begin
					Res[i]=A[i-lsb];
				end
			end
			//Res={B[31:msb+1],A[msb-lsb:0],B[lsb-1:0]};
		end
		`ALU_mov:begin
			Res=A;
		end
		`ALU_rot:begin
			Res=0;
			for(i=0;i<32;i=i+1)begin
				if(i>=32-sh)begin
					Res[i]=B[i+sh-32];
				end
				else begin
					Res[i]=B[i+sh];
				end
			end
			//Res={B[sh-1:0],B[31:sh]};
		end
		`ALU_wsbh:begin
			Res={B[23:16],B[31:24],B[7:0],B[15:8]};
		end
		`ALU_seb:begin
			Res={ {24{B[7]}} ,B[7:0]};
		end
		`ALU_seh:begin
			Res={ {16{B[15]}} ,B[15:0]};
		end
	endcase
end

endmodule