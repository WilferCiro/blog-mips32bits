// Wilfer Daniel Ciro Maya - 2023

module data_path(opCode, MemaReg, enWrSram, ALUSelector, enablePC, fteALU, clk, rst, regDst, flagZ, dirSelPC, ALU_res_memory, outMemory_memory, DRB_reg_file_memory);

	// Parameters declarations
	parameter BUS_SIZE = 32;
	parameter DIR_SIZE = BUS_SIZE;
	parameter OPC_SIZE = BUS_SIZE; 
	parameter DIR_SIZE_INTERNAL = 5; // No change
	
	// Control wires
	input clk;
	input rst;
	input MemaReg;
	input enWrSram;
	input [2 : 0] ALUSelector;
	input enablePC;
	input fteALU;
	input regDst;
	
	output reg flagZ;
	input [1:0] dirSelPC;
	
	
	output [BUS_SIZE - 1 : 0] ALU_res_memory;
	input [BUS_SIZE - 1 : 0] outMemory_memory;
	output [BUS_SIZE - 1 : 0] DRB_reg_file_memory;	
	
	
	// Internal Wires
	output [OPC_SIZE - 1 : 0] opCode;
	wire [BUS_SIZE - 1 : 0] ALU_res;
	wire [BUS_SIZE - 1 : 0] DW_reg_file;	
	wire [BUS_SIZE - 1 : 0] ALU_inB;
	wire [BUS_SIZE - 1 : 0] extendedData6;
	wire [DIR_SIZE - 1 : 0] dirPC;
	wire [DIR_SIZE_INTERNAL - 1 : 0] dirWriteRF;
	
	// Internal wires
	wire flagN, flagC;
	
	/***** Registers for pipeline *****/
	reg [OPC_SIZE - 1 : 0] opCode_reg;
	wire [OPC_SIZE - 1 : 0] opCode_src;
	
	reg [BUS_SIZE - 1 : 0] DRA_reg_file_reg;
    reg [BUS_SIZE - 1 : 0] DRB_reg_file_reg;
    reg [BUS_SIZE - 1 : 0] DRB_B_reg_file_reg;
	wire [BUS_SIZE - 1 : 0] DRA_reg_file_src;
	wire [BUS_SIZE - 1 : 0] DRB_reg_file_src;
	
	wire [BUS_SIZE - 1 : 0] ALU_res_src;
	reg [BUS_SIZE - 1 : 0] ALU_res_reg;
	reg [BUS_SIZE - 1 : 0] ALU_B_res_reg;
	
	wire flagZ_src;
	
	wire [DIR_SIZE_INTERNAL - 1 : 0] RtE_src;
	reg [DIR_SIZE_INTERNAL - 1 : 0] RtE_reg;
	wire [DIR_SIZE_INTERNAL - 1 : 0] RdE_src;
	reg [DIR_SIZE_INTERNAL - 1 : 0] RdE_reg;
	
	wire [DIR_SIZE_INTERNAL - 1 : 0] dirWriteRF_src;
	reg [DIR_SIZE_INTERNAL - 1 : 0] dirWriteRFA_reg;
	reg [DIR_SIZE_INTERNAL - 1 : 0] dirWriteRFB_reg;
		
	reg [BUS_SIZE - 1 : 0] outMemory_reg;
		
	wire [BUS_SIZE - 1 : 0] extendedData16_src;
	reg [BUS_SIZE - 1 : 0] extendedData16_reg;
	
	assign RtE_src = opCode_reg[15 : 11];
	assign RdE_src = opCode_reg[20 : 16];
	
	assign opCode = opCode_reg;
	assign ALU_res_memory = ALU_res_reg;
	
	always @(posedge clk) begin
	   if (rst) begin
	       opCode_reg = {OPC_SIZE{1'b0}};
	       DRA_reg_file_reg = {BUS_SIZE{1'b0}};
	       DRB_reg_file_reg <= {BUS_SIZE{1'b0}};
	       DRB_B_reg_file_reg <= {BUS_SIZE{1'b0}};
	       
	       ALU_res_reg <= {BUS_SIZE{1'b0}};
	       ALU_B_res_reg <= {BUS_SIZE{1'b0}};
	       
	       RtE_reg = {DIR_SIZE_INTERNAL{1'b0}};
	       RdE_reg = {DIR_SIZE_INTERNAL{1'b0}};
	       
	       dirWriteRFA_reg <= {DIR_SIZE_INTERNAL{1'b0}};
	       dirWriteRFB_reg <= {DIR_SIZE_INTERNAL{1'b0}};
	       
	       outMemory_reg = {BUS_SIZE{1'b0}};
	       
	       extendedData16_reg = {BUS_SIZE{1'b0}};
	       
	       flagZ = 1'b0;
	   end else begin
	       opCode_reg = opCode_src;
	       DRA_reg_file_reg = DRA_reg_file_src;
	       DRB_reg_file_reg <= DRB_reg_file_src;
	       DRB_B_reg_file_reg <= DRB_reg_file_reg; 
	       
	       ALU_res_reg <= ALU_res_src;
	       ALU_B_res_reg <= ALU_res_reg;
	       
	       RdE_reg = RdE_src;
	       RtE_reg = RtE_src;
	       
	       dirWriteRFA_reg <= dirWriteRF_src;
	       dirWriteRFB_reg <= dirWriteRFA_reg;
	       
	       outMemory_reg = outMemory_memory;
	       
	       flagZ = flagZ_src;
	       
	       extendedData16_reg = extendedData16_src;
	   end	   
	end
	
	
	// Connections and asignations
	assign DW_reg_file = MemaReg ? outMemory_reg : ALU_B_res_reg;
	assign ALU_inB = fteALU ? extendedData16_reg : DRB_reg_file_reg;
	assign dirWriteRF_src = regDst ? RtE_reg : RdE_reg;
	
	assign ALU_res_memory = ALU_res_reg; 
	assign DRB_reg_file_memory = DRB_B_reg_file_reg; 
	
	// Connect the register file
	sram #(.BUS_SIZE(BUS_SIZE), .DIR_SIZE_INTERNAL(DIR_SIZE_INTERNAL)) RegFile (
		.outA(DRA_reg_file_src),
		.outB(DRB_reg_file_src),
		.clk(clk),
		.enWrite(enWrSram),
		.writeData(DW_reg_file),
		.dirWrite(dirWriteRFB_reg), // Rd
		.dirA(opCode_reg[25 : 21]), // Rs
		.dirB(opCode_reg[20 : 16]) // Rt
	);
	
	// connect the ROM memory that has the firmware
	flash #(.BUS_SIZE(BUS_SIZE), .DIR_SIZE(DIR_SIZE), .OPC_SIZE(OPC_SIZE)) MyRunner(
		.dir(dirPC),
		.opCode(opCode_src)
	);
	
	// Connect the ALU	
	alu #(.BUS_SIZE(BUS_SIZE)) MyALU (
		.A(DRA_reg_file_reg),
		.B(ALU_inB),
		.selector(ALUSelector),
		.R(ALU_res_src),
		.flagZ(flagZ_src),
		.flagN(flagN),
		.flagC(flagC)
	);
	
	// Connect the module for extend the data sign
	extend_sign #(.BUS_IN(16), .BUS_SIZE(BUS_SIZE)) ex_signal16(
		.dataIn(opCode_reg[15 : 0]),
		.dataOut(extendedData16_src)
	);
	
	extend_sign #(.BUS_IN(26), .BUS_SIZE(BUS_SIZE)) ex_signal6(
		.dataIn(opCode_reg[25 : 0]),
		.dataOut(extendedData6)
	);
	
	// Connect the program counter (PC)
	program_counter #(.DIR_SIZE(DIR_SIZE)) MyPC(
		.clk(clk),
		.rst(rst),
		.enable(enablePC),
		.dirInBranch(extendedData16_reg),
		.dirInJump(extendedData6),
		.dirSel(dirSelPC),
		.dirOut(dirPC)
	);

endmodule 
