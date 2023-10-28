// Wilfer Daniel Ciro Maya - 2023

module tb_file_bank;
	// parameters definitions
	parameter BUS_SIZE = 32;
	parameter DIR_SIZE_INTERNAL = 5;
	
	// inputs definitions
	reg clk;
	reg rst;
	reg enWrite;
	reg [BUS_SIZE - 1 : 0] writeData;
	reg [DIR_SIZE_INTERNAL - 1 : 0] dirWrite;
	reg [DIR_SIZE_INTERNAL - 1 : 0] dirA;
	reg [DIR_SIZE_INTERNAL - 1 : 0] dirB;
	
	// outputs definitions
	wire [BUS_SIZE - 1 : 0] outA;
	wire [BUS_SIZE - 1 : 0] outB;
	
	// Instance the flash module
	sram #(.BUS_SIZE(BUS_SIZE), .DIR_SIZE_INTERNAL(5)) UUT(
		.outA(outA),
		.outB(outB),
		.clk(clk),
		.rst(rst),
		.enWrite(enWrite),
		.writeData(writeData),
		.dirWrite(dirWrite),
		.dirA(dirA),
		.dirB(dirB)
	);

	initial begin
		$dumpfile("test_file_bank.vcd");
		$dumpvars(0, tb_file_bank);
		
		clk = 1'b1;
		rst = 1'b0;
		enWrite = 1'b0;
		writeData = 20;
		dirA = 5'd10;
		dirB = 5'd20;
		dirWrite = 5'd5;
		
		#4
		rst = 1'b1;
		#4
		
		enWrite = 1'b1;
		dirWrite = 5'd5;
		dirA = 5'd5;
		#10
		enWrite = 1'b0;
		writeData = 3;
		#10		
		
		enWrite = 1'b1;
		dirWrite = 5'd12;
		dirA = 5'd5;
		dirB = 5'd12;
		#10
		enWrite = 1'b0;
		#10		
		#10
		
		$finish;
	end
	
	always begin
		#1 clk = ~clk;
	end

endmodule 
