// Wilfer Daniel Ciro Maya - 2023

module tb_control_unit;
	// Parameters
	parameter BUS_SIZE = 32;
	parameter DIR_SIZE = 32;
	parameter OPC_SIZE = BUS_SIZE;
	parameter DIR_SIZE_INTERNAL = 5;
	
	// input definitions
	reg [OPC_SIZE - 1 : 0] opCode;
	reg flagN;
	reg flagZ;
	reg flagC;
	reg clk;
	reg rst;
	
	/** output definitions **/
	// For ALU
	wire [2 : 0] aluOp;
	
	// For PC
	wire muxPC;
	wire [DIR_SIZE - 1 : 0] dirPC;
	wire enPC;
	
	// For File Bank
	wire enWrite;
	wire [DIR_SIZE_INTERNAL - 1 : 0] dirWrite;
	
	// Instance the flash module
	control_path #(.BUS_SIZE(BUS_SIZE), .DIR_SIZE(DIR_SIZE)) UUT(
		.opCode(opCode),
		.flagZ(flagZ),
		.flagN(flagN),
		.flagC(flagC),
		.muxPC(muxPC),
		.dirPC(dirPC),
		.dirWrite(dirWrite),
		.enWrite(enWrite),
		.aluOp(aluOp),
		.clk(clk),
		.rst(rst),
		.enPC(enPC)
	);

	initial begin
		$dumpfile("test_control_unit.vcd");
		$dumpvars(0, tb_control_unit);
		opCode = 32'b101011_01010_000000000000000000000;
		clk = 1'b0;
		rst = 1'b0;
		#2
		rst = 1'b1;
		#2
		#20
		
		$finish;
	end
	
	always begin
		#1 clk = ~clk;
	end

endmodule 
