// Wilfer Daniel Ciro Maya - 2023

module control_path(opCode, functionCode, MemaReg, enWrSram, ALUSelector, enWriteMemory, enablePC, fteALU, clk, rst, regDst, flagZ, dirSelPC);
	// parameters definitions
	parameter BUS_SIZE = 32;
	parameter DIR_SIZE = 32;
	parameter OPC_SIZE = BUS_SIZE;
	
	// Inputs definitions
	input [6 - 1 : 0] opCode;
	input [6 - 1 : 0] functionCode;
	input clk;
	input rst;
	input flagZ;
	
	
	// Outputs definitions
	output reg MemaReg;
	output reg enWrSram;
	output reg [2 : 0] ALUSelector;
	output reg fteALU;
	output reg enWriteMemory;
	output reg enablePC;
	output reg regDst;
	output [1:0] dirSelPC;	
	
	reg branch_src;
	reg branch_A;
	reg branch_B;
	reg jump;
	
	
	// Registers for pipeline
	reg regDst_src;
	reg [2 : 0] ALUSelector_src;
	reg fteALU_src;
	
	reg enWriteMemory_src; 
	reg enWriteMemory_A;
	
	reg MemaReg_src;
	reg MemaReg_A;
	reg MemaReg_B;
	
	reg enWrSram_src;
	reg enWrSram_A;
	reg enWrSram_B;
	
	always @(posedge clk) begin
	   if (rst) begin
	       regDst = 1'b0;
	       ALUSelector = 3'b000;
	       fteALU = 1'b0;
	       branch_A <= 1'b0;
	       branch_B <= 1'b0;
	       
	       enWriteMemory_A <= 1'b0;
	       enWriteMemory <= 1'b0;
	       
	       MemaReg_A <= 1'b0;
	       MemaReg_B <= 1'b0;
	       MemaReg <= 1'b0;
	       
	       enWrSram <= 1'b0;
	       enWrSram_A <= 1'b0;
	       enWrSram_B <= 1'b0;
	   end else begin
	       regDst = regDst_src;
	       fteALU = fteALU_src;
	       ALUSelector = ALUSelector_src;
	       branch_A <= branch_src;
	       branch_B <= branch_A;
	       
	       enWriteMemory_A <= enWriteMemory_src;
	       enWriteMemory <= enWriteMemory_A;
	       	       
	       MemaReg_A <= MemaReg_src;
	       MemaReg_B <= MemaReg_A;
	       MemaReg <= MemaReg_B;
	       
	       enWrSram_A <= enWrSram_src;
	       enWrSram_B <= enWrSram_A;
	       enWrSram <= enWrSram_B;
	   end
	end
	
	assign dirSelPC = {jump, branch_B & flagZ};
	
	always @(opCode, functionCode)
	begin
		MemaReg_src = 1'b0;
		enWrSram_src = 1'b0;
		ALUSelector_src = 3'b000;
		enWriteMemory_src = 1'b0;
		
		branch_src = 1'b0;
		jump = 1'b0;
		
		enablePC = 1'b1;
		fteALU_src = 1'b0;
		regDst_src = 1'b0;		
		
		if (opCode == 6'b0) begin
			regDst_src = 1'b1;
			case (functionCode)
				6'b100000: begin // ADD 
					ALUSelector_src = 3'b000;
                    enWrSram_src = 1'b1;
                end
				6'b100010: begin // SUB
					ALUSelector_src = 3'b001;
                    enWrSram_src = 1'b1;
                end
				6'b100100: begin// AND
					ALUSelector_src = 3'b010;
                    enWrSram_src = 1'b1;
                end
				6'b100101: begin// OR
					ALUSelector_src = 3'b011;
                    enWrSram_src = 1'b1;
                end
				6'b100110: begin// XOR
					ALUSelector_src = 3'b100;
                    enWrSram_src = 1'b1;
                end
				6'b000000: begin// Other
					ALUSelector_src = 3'bxxx;
			     end
				default: begin
					ALUSelector_src = 3'bxxx;
					enWrSram_src = 1'b0;
                end
			endcase
		end
		else begin
			case(opCode)
				6'b100011: begin // lw 35
					enWrSram_src = 1'b1;	
					fteALU_src = 1'b1;
					MemaReg_src = 1'b1;
				end
				6'b101011: begin // sw 43
					fteALU_src = 1'b1;
					enWriteMemory_src = 1'b1;
					
					regDst_src = 1'bx;
					MemaReg_src = 1'bx;
				end
				6'b000100: begin // beq		4			
					branch_src = 1'b1;
					ALUSelector_src = 3'b001;
					
					regDst_src = 1'bx;	
					MemaReg_src = 1'bx;
				end
				6'b000010: begin // jump 2
					jump = 1'b1;
					regDst_src = 1'bx;
					fteALU_src = 1'bx;
					branch_src = 1'b0;	
					MemaReg_src = 1'bx;
					ALUSelector_src = 3'bxxx;
				end
				6'b001111: begin // LUI 15
					regDst_src = 1'b0;
					fteALU_src = 1'b1;
					enWrSram_src = 1'b1;
				end
				6'b001000: begin // ADDI 8
				    fteALU_src = 1'b1;
					ALUSelector_src = 3'b000;
					enWrSram_src = 1'b1;
					regDst_src = 1'b0;
				end
				6'b001100: begin // ANDI 12
				    fteALU_src = 1'b1;
					ALUSelector_src = 3'b010;	
					enWrSram_src = 1'b1;
					regDst_src = 1'b0;
				end
				6'b001101: begin // ORI 13
				    fteALU_src = 1'b1;
					ALUSelector_src = 3'b011;
					enWrSram_src = 1'b1;
					regDst_src = 1'b0; 
				end
				6'b001110: begin // XORI
				    fteALU_src = 1'b1;
					ALUSelector_src = 3'b100;	
					enWrSram_src = 1'b1;
					regDst_src = 1'b0;
				end
				default: begin
					enWrSram_src = 1'bx;
					regDst_src = 1'bx;
					fteALU_src = 1'bx;
				end
			endcase
		end
	end
	
endmodule 
