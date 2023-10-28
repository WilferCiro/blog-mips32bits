// Wilfer Daniel Ciro Maya - 2023
/*
   Selector | Operation
   ---------------------
		000 | SUM
		001 | SUB
		010 | AND
		011 | OR
		100 | XOR
		101 | None (R = 0)
		110 | None (R = 0)
		111 | None (R = 0)
	  other | None (R = 0)
*/


module alu(A, B, selector, R, flagZ, flagN, flagC);
    parameter BUS_SIZE = 32;
    
    // Inputs
    input[BUS_SIZE - 1: 0] A;
    input[BUS_SIZE - 1: 0] B;
    input[2: 0] selector;
    
    // Outputs
    output flagZ;
    output flagN;
    output reg flagC;
    output reg [BUS_SIZE - 1 : 0] R;
    
    // logic block
	always @(A, B, selector)
	begin
		flagC = 1'b0;
		if (selector == 3'b000)	
            // flagC is flag carry, checks if the operation is overflowing
			{flagC, R} = A + B;
		else if (selector == 3'b001)
			R = A - B;
		else if (selector == 3'b010)
			R = A & B;
		else if (selector == 3'b011)
			R = A | B;
		else if (selector == 3'b100)
			R = A ^ B;
		else 
			R = {BUS_SIZE{1'b0}};
	end 
	
	// Zero flag (check if all is 0)
	assign flagZ = ~(|R);
	
	// Negative flag (last bit from result)
	assign flagN = R[BUS_SIZE - 1];

endmodule;