// Wilfer Daniel Ciro Maya - 2023

module memory(pOut, clk, enWrite, writeData, dirIn);

	// parameters definitions
	parameter BUS_SIZE = 32;
	parameter MEM_SIZE = 256; // no modify
	
	// inputs definitions
	input clk;
	input enWrite;
	input [BUS_SIZE - 1 : 0] writeData;
	input [8 - 1 : 0] dirIn;
	
	// outputs definitions
	output [BUS_SIZE - 1 : 0] pOut;
	
	// Internal data definition
	reg [BUS_SIZE - 1 : 0] MEM [0 : MEM_SIZE];
	
	// Out assignation
	assign pOut = MEM[dirIn];
	
	// Index 0 of memory has the 0 value
	initial begin
		MEM[0] = {BUS_SIZE{1'b0}};
	end
	
	// sram description
	always @(posedge clk)
	begin
		if (enWrite)
			MEM[dirIn] = writeData;
	end
	
endmodule 


