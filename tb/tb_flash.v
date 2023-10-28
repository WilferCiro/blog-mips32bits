// Wilfer Daniel Ciro Maya - 2023

module tb_flash;
	// Parameters
	parameter DIR_SIZE = 32;
	parameter OPC_SIZE = 32;
	
	// inputs
	reg [DIR_SIZE - 1 : 0] dir;
	
	// outputs
	wire [OPC_SIZE - 1 : 0] opCode;
	
	// Instance the flash module
	flash #(.DIR_SIZE(DIR_SIZE), .OPC_SIZE(OPC_SIZE)) UUT(
		.opCode(opCode),
		.dir(dir)
	);

	initial begin
		$dumpfile("test_flash.vcd");
		$dumpvars(0, tb_flash);
		dir = 0;
		#2
		dir = 1;
		#2
		dir = 2;
		#2
		dir = 3;
		#2
		$finish;		
	end

endmodule 
