// Wilfer Daniel Ciro Maya - 2023

module register(D, Q, enable, clk, rst);
	// Parameters declarations
	parameter BUS_SIZE = 32;
	
	// Inputs declarations
	input [BUS_SIZE - 1 : 0] D;
	input enable;
	input clk;
	input rst;
	
	// Outputs declarations
	output reg [BUS_SIZE - 1 : 0] Q;
	
	// Logic block
	always @(posedge clk)
	begin
		if (rst)
			Q = {BUS_SIZE{1'b0}};
		else if(enable)
			Q = D;
	end
endmodule
