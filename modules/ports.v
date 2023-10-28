// Wilfer Daniel Ciro Maya - 2023

module ports(
    input [2:0] portWrite,
    input valueWrite,
    input enWrite,
    output [7:0] valuePort,
    input clk,
    input rst
    );
   
	
	// Internal bus
	reg [7:0] enable;
	
	// Decoder
	always @(portWrite, valueWrite)
	begin
		case(portWrite)
			3'd0:	enable = {{7{1'b0}}, 1'b1};
			3'd1:	enable = {{6{1'b0}}, 1'b1, {1{1'b0}}};
			3'd2:	enable = {{5{1'b0}}, 1'b1, {2{1'b0}}};
			3'd3:	enable = {{4{1'b0}}, 1'b1, {3{1'b0}}};
			3'd4:	enable = {{3{1'b0}}, 1'b1, {4{1'b0}}};
			3'd5:	enable = {{2{1'b0}}, 1'b1, {5{1'b0}}};
			3'd6:	enable = {{1{1'b0}}, 1'b1, {6{1'b0}}};
			3'd7:	enable = {1'b1, {7{1'b0}}};
		endcase 	
	end
	
	// generate all registers
	genvar i;
	generate
		for (i = 0; i < 8; i = i + 1)
		begin: GENERATE_REGISTERS_BLOCK
			register #(.BUS_SIZE(1)) regi (
				.D(valueWrite),
				.Q(valuePort[i]),
				.enable(enable[i] & enWrite),
				.clk(clk),
				.rst(rst)
			);
		end
	endgenerate
	
	
endmodule
