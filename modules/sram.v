// Wilfer Daniel Ciro Maya - 2023


module sram(outA, outB, clk, enWrite, writeData, dirWrite, dirA, dirB);
	// parameters definitions
	parameter BUS_SIZE = 32;
	parameter DIR_SIZE_INTERNAL = 5;
	parameter MEM_SIZE = 32;
	
	// inputs definitions
	input clk;
	input enWrite;
	input [BUS_SIZE - 1 : 0] writeData;
	input [DIR_SIZE_INTERNAL - 1 : 0] dirWrite;
	input [DIR_SIZE_INTERNAL - 1 : 0] dirA;
	input [DIR_SIZE_INTERNAL - 1 : 0] dirB;
	
	// outputs definitions
	output [BUS_SIZE - 1 : 0] outA;
	output [BUS_SIZE - 1 : 0] outB;
	
	// Signals and registers definitions
	reg [BUS_SIZE - 1 : 0] MEM [0 : MEM_SIZE - 1];
	assign outA = MEM[dirA];
	assign outB = MEM[dirB];
	
	initial begin
		MEM[0] = {BUS_SIZE{1'b0}};
	end
	
	always @(posedge clk)
	begin
		if (enWrite)
			MEM[dirWrite] = writeData;
	end	
endmodule 
