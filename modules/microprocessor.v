// Wilfer Daniel Ciro Maya - 2023

module microprocessor(clk, rst, outputPorts, inputPorts);
	// parameters definitions
	parameter BUS_SIZE = 32;
	parameter DIR_SIZE = BUS_SIZE;
	parameter OPC_SIZE = BUS_SIZE; 
	parameter DIR_SIZE_INTERNAL = 5; // No change
	
	// Inputs
	input clk;
	input rst;
	
	input [1:0] inputPorts;
	output [7:0] outputPorts;
	
	// Internal wires
	wire MemaReg;
	wire rst_n;
	wire enWrSram;
	wire [2 : 0] ALUSelector;
	wire enWriteMemory;
	wire branch;
	wire jump;
	wire enablePC;
	wire fteALU;
	wire regDst;
	wire [OPC_SIZE - 1 : 0] opCode;
	
	wire flagZ;
	wire [1:0] dirSelPC;
	
	wire [BUS_SIZE - 1 : 0] outMemory;
	wire [BUS_SIZE - 1 : 0] DRB_reg_file;
	wire [BUS_SIZE - 1 : 0] ALU_res;	
	
	assign rst_n = rst;
	
	// Connection of data_path and control_path
	
	data_path #(.BUS_SIZE(BUS_SIZE), .DIR_SIZE(DIR_SIZE)) myData(
		.opCode(opCode),
		.MemaReg(MemaReg),
		.enWrSram(enWrSram),
		.ALUSelector(ALUSelector),
		.enablePC(enablePC),
		.fteALU(fteALU),
		.clk(clk),
		.rst(rst_n),
		.regDst(regDst),
		.dirSelPC(dirSelPC),
		.flagZ(flagZ),
		.ALU_res_memory(ALU_res),
		.outMemory_memory(outMemory),
		.DRB_reg_file_memory(DRB_reg_file)
	);
	
	
	control_path #(.BUS_SIZE(BUS_SIZE), .DIR_SIZE(DIR_SIZE)) myControl(
		.opCode(opCode[31:26]),
		.functionCode(opCode[5:0]),
		.MemaReg(MemaReg),
		.enWrSram(enWrSram),
		.ALUSelector(ALUSelector),
		.enWriteMemory(enWriteMemory),
		.fteALU(fteALU),
		.enablePC(enablePC),
		.clk(clk),
		.rst(rst_n),
		.regDst(regDst),
		.dirSelPC(dirSelPC),
		.flagZ(flagZ)	
	);
	
	
	
	wire [7:0] dirmemory;
	wire enablePortsController;
	wire enableMemoryController;
	wire selectReadMemory;
	wire [31:0] valueWriteMemAlt, memoryOut;
	assign dirmemory = ALU_res[7:0];
	// Connect the program memory
	memory #(.BUS_SIZE(BUS_SIZE)) MyMemory (
		.pOut(memoryOut),
		.clk(clk),
		.enWrite(enWriteMemory & enableMemoryController),
		.writeData(DRB_reg_file),
		.dirIn(dirmemory)
	);
	assign outMemory = !selectReadMemory ? memoryOut : valueWriteMemAlt;
	port_memory cont_mem(
	   .dirSelect(dirmemory),
	   .enWrMemory(enableMemoryController),
	   .enWrPort(enablePortsController),
	   .selectRead(selectReadMemory),
	   .inputPorts(inputPorts),
	   .valueWriteMem(valueWriteMemAlt)
	);
	
	ports pt(
        .portWrite(dirmemory[2:0]),
        .valueWrite(DRB_reg_file[0]),
        .enWrite(enablePortsController & enWriteMemory),
        .valuePort(outputPorts),
        .clk(clk),
        .rst(rst_n)
	);
	
	// Connect probes 
	/*ila_0 probese(
	   .clk(clk),
	   .probe0({{24{1'b0}}, outputPorts}),
	   .probe1({microprocesador.myData.MyALU.A[23:0], microprocesador.myData.RegFile.MEM[17][5:0], inputPorts}),
	   //.probe3(microprocesador.MyData.MyALU.B),
	   .probe2(microprocesador.myData.MyPC.dirOut)
	);*/

endmodule 
