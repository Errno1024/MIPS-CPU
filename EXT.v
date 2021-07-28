`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:04:38 11/07/2019 
// Design Name: 
// Module Name:    EXT 
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
module EXT(
    input [`EXTOp_len-1:0] EXTOp,
    input [15:0] In,
    output reg [31:0] Out
    );
always@(*)begin
	Out={16'b0,In};
	case(EXTOp)
		`EXT_zero:begin
			Out={16'b0,In};
		end
		`EXT_sign:begin
			Out={{16{In[15]}},In};
		end
		`EXT_high:begin
			Out={In,16'b0};
		end
		`EXT_shift:begin
			Out={27'b0,In[10:6]};
		end
	endcase
end

endmodule