// Wilfer Daniel Ciro Maya - 2023

module extend_sign(dataIn, dataOut);

	// Parameters definition
	parameter BUS_IN = 16;
	parameter BUS_SIZE = 32;
	
	// Inputs definitions	
	input [BUS_IN - 1 : 0] dataIn;
	
	// Outputs definitions
	output [BUS_SIZE - 1 : 0] dataOut;
	
	// Block logic
	assign dataOut = {{(BUS_SIZE - BUS_IN){dataIn[BUS_IN - 1]}}, dataIn};

endmodule 
