// Wilfer Daniel Ciro Maya - 2023

/*
	dirSel  | output
	0		| dir + 1
	1		| dirIn
*/
/*
	Memory max size: 2^DIR_SIZE = 255 (ex: 2^8 = 256)
*/

module tb_program_counter;
	// Parameters
	parameter DIR_SIZE = 32;
	
	// Inputs
	reg clk;
	reg rst;
	reg enable;
	reg dirSel;
	reg [DIR_SIZE - 1 : 0] dirIn;
	
	// Outputs
	wire [DIR_SIZE - 1 : 0] dirOut;
	
	// Instance the flash module
	program_counter #(.DIR_SIZE(DIR_SIZE)) UUT(
		.dirSel(dirSel),
		.dirIn(dirIn),
		.enable(enable),
		.clk(clk),
		.rst(rst),
		.dirOut(dirOut)
	);

	initial begin
		$dumpfile("test_program_counter.vcd");
		$dumpvars(0, tb_program_counter);
		dirSel = 1'b0;
		clk = 1'b0;
		enable = 1'b1;
		dirIn = 8;
		rst = 1'b0;
		#4
		rst = 1'b1;
		#4
		
		#100
		
		dirSel = 1'b1;
		#10
		dirSel = 1'b0;
		#20
		
		$finish;
	end
	
	always begin
		#1 clk = ~clk;
	end

endmodule 
