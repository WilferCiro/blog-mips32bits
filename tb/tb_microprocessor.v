`timescale 1ns / 1ps
// Wilfer Daniel Ciro Maya - 2023

module tb_microprocesor;
	reg clk;
	reg rst;
	wire flagOut;
	// Instance the microprocesador module
	microprocessor UUT(
		.clk(clk),
		.rst(rst)
	);

	initial begin
		clk = 1'b0;
		rst = 1'b1;
		#4
		rst = 1'b0;
		#500000;
	
	end
	
	always begin
		#1 clk = ~clk;
	end

endmodule 
