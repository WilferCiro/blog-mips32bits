// Wilfer Daniel Ciro Maya - 2023

/*
   Selector | Operation
   ---------------------
		000 | Suma
		001 | Resta
		010 | AND
		011 | OR
		100 | XOR
		101 | None (R = 0)
		110 | None (R = 0)
		111 | None (R = 0)
	  other | None (R = 0)
*/

module tb_alu;
	// Parameters
	parameter BUS_SIZE = 32;
	
	// Inputs
	reg [BUS_SIZE - 1 : 0] A;
	reg [BUS_SIZE - 1 : 0] B;
	reg [3 : 0] selector;
	reg carryIn;
	
	// Outputs
	wire flagZ;
	wire flagN;
	wire flagC;
	wire [BUS_SIZE - 1 : 0] R;

	alu #(.BUS_SIZE(BUS_SIZE)) UUT(
		.A(A),
		.B(B),
		.selector(selector),
		.R(R),
		.carryIn(carryIn),
		.flagZ(flagZ),
		.flagN(flagN),
		.flagC(flagC)
	);

	initial begin
		$dumpfile("test_alu.vcd");
		$dumpvars(0, tb_alu);
		A = 10;
		B = 10;
		carryIn = 1'b0;
		selector = 3'b000;
		#2
		selector = 3'b001;
		#2
		selector = 3'b010;
		#2
		selector = 3'b011;
		#2
		selector = 3'b100;
		#2
		selector = 3'b101;
		#2
		selector = 3'b110;
		#2
		selector = 3'b111;
		#2
		
		A = 100;
		B = 4294967291;
		selector = 3'b000;
		#2
		selector = 3'b001;
		#2
		selector = 3'b010;
		#2
		selector = 3'b011;
		#2
		selector = 3'b100;
		#2
		selector = 3'b101;
		#2
		selector = 3'b110;
		#2
		selector = 3'b111;
		#2
		
		A = 5;
		B = 15;
		selector = 3'b000;
		#2
		selector = 3'b001;
		#2
		selector = 3'b010;
		#2
		selector = 3'b011;
		#2
		selector = 3'b100;
		#2
		selector = 3'b101;
		#2
		selector = 3'b110;
		#2
		selector = 3'b111;
		#2
		$finish;
	end

endmodule 
