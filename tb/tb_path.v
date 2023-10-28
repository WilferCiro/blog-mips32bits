// Wilfer Daniel Ciro Maya - 2023

module tb_path;

	// inputs definitions
	reg clk;
	reg rst;
	reg MemaReg;
	reg enWrSram;
	reg [2 : 0] ALUSelector;
	reg enWriteMemory;
	reg ftePC;
	reg enablePC;
	reg fteALU;
	reg regDst;
	
	// outputs definitions	
	
	// Instance the flash module
	data_path data(
		.MemaReg(MemaReg),
		.enWrSram(enWrSram),
		.ALUSelector(ALUSelector),
		.enWriteMemory(enWriteMemory),
		.ftePC(ftePC),
		.enablePC(enablePC),
		.fteALU(fteALU),
		.clk(clk),
		.rst(rst),
		.regDst(regDst)
	);

	initial begin
		$dumpfile("tb_path.vcd");
		$dumpvars(0, tb_path);
		
		// start values
		
		MemaReg = 1'b0;
		enWrSram = 1'b0;
		ALUSelector = 3'b0;
		enWriteMemory = 1'b0;
		ftePC = 1'b0;
		enablePC = 1'b0;
		fteALU = 1'b0;
		regDst = 1'b0;
		
		clk = 1'b1;
		rst = 1'b1;			
		#4
		rst = 1'b0;
		#2
		rst = 1'b1;
				
		/**** describe logic ***/
		// Format I
		regDst = 1'b0;
		fteALU = 1'b1;
		MemaReg = 1'b0;
		enWrSram = 1'b1;
		#2
		enablePC = 1'b1;
		#2
		
		
		
		// Format R
		
		
		#20;
		
		$finish;
	end
	
	always begin
		#1 clk = ~clk;
	end

endmodule 
