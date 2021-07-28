`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:05:56 11/07/2019 
// Design Name: 
// Module Name:    DM 
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
module DM(
    input clock,
    input reset,
    input [31:0] A,
	 input DMWr,
	 input [`DMOp_len-1:0]DMOp,
    input [31:0] WD,
    output reg [31:0] RD,
	 input [31:0] pc
    );
reg[31:0]Mem[`DM_size-1:0];
integer i;

initial begin
	for(i=0;i<`DM_size;i=i+1)begin
		Mem[i]=0;
	end
end

wire [31:0]A4;
assign A4={2'b0,A[31:2]};
always@(*)begin
	RD=Mem[A4];
	case(DMOp)
		`DM_w:begin
			RD=Mem[A4];
		end
		`DM_h:begin
			case(A[1])
				1'b1:begin
					RD={{16{Mem[A4][31]}},Mem[A4][31:16]};
				end
				1'b0:begin
					RD={{16{Mem[A4][15]}},Mem[A4][15:0]};
				end
			endcase
		end
		`DM_hu:begin
			case(A[1])
				1'b1:begin
					RD={16'b0,Mem[A4][31:16]};
				end
				1'b0:begin
					RD={16'b0,Mem[A4][15:0]};
				end
			endcase
		end
		`DM_b:begin
			case(A[1:0])
				2'b00:begin
					RD={{24{Mem[A4][7]}},Mem[A4][7:0]};
				end
				2'b01:begin
					RD={{24{Mem[A4][15]}},Mem[A4][15:8]};
				end
				2'b10:begin
					RD={{24{Mem[A4][23]}},Mem[A4][23:16]};
				end
				2'b11:begin
					RD={{24{Mem[A4][31]}},Mem[A4][31:24]};
				end
			endcase
		end
		`DM_bu:begin
			case(A[1:0])
				2'b00:begin
					RD={24'b0,Mem[A4][7:0]};
				end
				2'b01:begin
					RD={24'b0,Mem[A4][15:8]};
				end
				2'b10:begin
					RD={24'b0,Mem[A4][23:16]};
				end
				2'b11:begin
					RD={24'b0,Mem[A4][31:24]};
				end
			endcase
		end
		`DM_l:begin
			case(A[1:0])
				2'b00:begin
					RD={Mem[A4][7:0],WD[23:0]};
				end
				2'b01:begin
					RD={Mem[A4][15:0],WD[15:0]};
				end
				2'b10:begin
					RD={Mem[A4][23:0],WD[7:0]};
				end
				2'b11:begin
					RD=Mem[A4];
				end
			endcase
		end
		`DM_r:begin
			case(A[1:0])
				2'b00:begin
					RD=Mem[A4];
				end
				2'b01:begin
					RD={WD[31:24],Mem[A4][31:8]};
				end
				2'b10:begin
					RD={WD[31:16],Mem[A4][31:16]};
				end
				2'b11:begin
					RD={WD[31:8],Mem[A4][31:24]};
				end
			endcase
		end
	endcase
end

always@(posedge clock)begin
	if(reset)begin
		for(i=0;i<`DM_size;i=i+1)begin
			Mem[i]=0;
		end
	end
	else if(DMWr) begin
		case(DMOp)
			`DM_w:begin
				Mem[A4]=WD;
			end
			`DM_h:begin
				case(A[1])
					1'b1:begin
						Mem[A4]={WD[15:0],Mem[A4][15:0]};
					end
					1'b0:begin
						Mem[A4]={Mem[A4][31:16],WD[15:0]};
					end
				endcase
			end
			`DM_b:begin
				case(A[1:0])
					2'b00:begin
						Mem[A4]={Mem[A4][31:24],Mem[A4][23:16],Mem[A4][15:8],WD[7:0]};
					end
					2'b01:begin
						Mem[A4]={Mem[A4][31:24],Mem[A4][23:16],WD[7:0],Mem[A4][7:0]};
					end
					2'b10:begin
						Mem[A4]={Mem[A4][31:24],WD[7:0],Mem[A4][15:8],Mem[A4][7:0]};
					end
					2'b11:begin
						Mem[A4]={WD[7:0],Mem[A4][23:16],Mem[A4][15:8],Mem[A4][7:0]};
					end
				endcase
			end
			`DM_l:begin
				case(A[1:0])
					2'b00:begin
						Mem[A4]={Mem[A4][31:8],WD[31:24]};
					end
					2'b01:begin
						Mem[A4]={Mem[A4][31:16],WD[31:16]};
					end
					2'b10:begin
						Mem[A4]={Mem[A4][31:24],WD[31:8]};
					end
					2'b11:begin
						Mem[A4]=WD;
					end
				endcase
			end
			`DM_r:begin
				case(A[1:0])
					2'b00:begin
						Mem[A4]=WD;
					end
					2'b01:begin
						Mem[A4]={WD[23:0],Mem[A4][7:0]};
					end
					2'b10:begin
						Mem[A4]={WD[15:0],Mem[A4][15:0]};
					end
					2'b11:begin
						Mem[A4]={WD[7:0],Mem[A4][23:0]};
					end
				endcase
			end
		endcase
		$display("%d@%h: *%h <= %h",$time,pc,{A[31:2],2'b0},Mem[A4]);
	end
	/*
	if(~reset & DMWr)begin
		$display("%d@%h: *%h <= %h",$time,pc,A,WD);
	end
	*/
end
endmodule
