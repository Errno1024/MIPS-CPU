`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:14:36 11/07/2019
// Design Name:   mips
// Module Name:   D:/ISE-workspace/SingleCycleCpu/mips_test.v
// Project Name:  SingleCycleCpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`include "def.v"
module mips_test;

	// Inputs
	reg clk;
	reg reset;
	reg interrupt;
	wire [31:0]addr;
	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk(clk), 
		.reset(reset),
		.interrupt(interrupt),
		.addr(addr)
	);
	integer i;
	initial begin
		// Initialize Inputs
		clk = 1;
		reset=0;
		reset = 1;
		interrupt = 0;
		#0.5;
		//for(i=0;i<`IM_size;i=i+1)begin
			//uut._datapath._im.mem[i]=0;
		//end
		//$readmemh("code.txt",uut._datapath._im.mem);
		#1 reset=0;#0.5;
		//#9.5 reset=1;#1 reset=0;#0.5
		
		// Wait 100 ns for global reset to finish
		#8192;$finish;
        
		// Add stimulus here

	end
   always#0.5 clk=~clk;
endmodule

