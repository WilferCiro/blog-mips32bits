// Wilfer Daniel Ciro Maya - 2023
/*
	dirSel  | output
	0		| dir + 1
	1		| dirIn
*/
/*
	Memory max size: 2^DIR_SIZE = 255 (ex: 2^8 = 256)
*/

module program_counter(clk, rst, enable, dirInBranch, dirInJump, dirSel, dirOut);
	// parameters declarations
	parameter DIR_SIZE = 32;
	
	// Inputs declarations
	input clk;
	input rst;
	input enable;
	input [1 : 0] dirSel;
	input [DIR_SIZE - 1 : 0] dirInBranch;
	input [DIR_SIZE - 1 : 0] dirInJump;
	
	// Outputs declarations
	output reg [DIR_SIZE - 1 : 0] dirOut;
	
	wire [DIR_SIZE - 1 : 0] dirBranch_src, dirJump_src, dirNormal, dirOut_src;	
	reg [DIR_SIZE - 1 : 0] dirOut_A, dirOut_B, dirBranch, dirJump;
	
	assign dirOut_src = dirSel[0] == 1'b1 ? dirBranch : (dirSel[1] == 1'b1 ? dirJump_src : dirNormal);
	
	assign dirBranch_src = dirOut_B + dirInBranch;	
	assign dirJump_src = dirOut_B + dirInJump;
	assign dirNormal = dirOut + {{(DIR_SIZE - 1){1'b0}}, 1'b1};
	
	always @(posedge clk) begin
	   if (rst)
	       dirOut <= {DIR_SIZE{1'b0}};
	   else
	       dirOut <= dirOut_src;
	end	
	
	always @(posedge clk) begin
	   if (rst) begin
	       dirOut_A <= {DIR_SIZE{1'b0}};
	       dirOut_B <= {DIR_SIZE{1'b0}};
	       
	       dirJump <= {DIR_SIZE{1'b0}};
	       dirBranch <= {DIR_SIZE{1'b0}};
	   end else begin
	       dirOut_A <= dirOut;
	       dirOut_B <= dirOut_A;
	       
	       dirJump <= dirJump_src;
	       dirBranch <= dirBranch_src;
	   end
	end

endmodule 
