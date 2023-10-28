`timescale 1ns / 1ps
// Wilfer Daniel Ciro Maya - 2023

module tb_microprocessor;
	reg clk;
	reg rst;
	integer file;
	// Instance the microprocesador module
	microprocessor UUT(
		.clk(clk),
		.rst(rst)
	);

	initial begin
		$dumpfile("test_microprocesor.vcd");
		$dumpvars(0, tb_microprocesor);
		file = $fopen("output.txt", "w");
		$fwrite(file, "\n");
		
		clk = 1'b0;
		rst = 1'b1;
		#2
		rst = 1'b0;
		#200;
		$finish;	
	end
	
	always begin
		#1 clk = ~clk;
	end

endmodule 
