// Wilfer Daniel Ciro Maya - 2023

module port_memory(dirSelect, enWrMemory, enWrPort, selectRead, inputPorts, valueWriteMem);

    input [7:0] dirSelect;
    output reg enWrMemory;
    output reg enWrPort;
    output reg selectRead;
    input [1:0] inputPorts;
    output reg [31:0] valueWriteMem;
    
    always @(dirSelect) begin
        selectRead = 1'b0;
        valueWriteMem = 32'b0;
        enWrMemory = 1'b0;
        enWrPort = 1'b0;
        if (dirSelect < 7'd8)
        begin
            enWrMemory = 1'b0;
            enWrPort = 1'b1;
        end else if (dirSelect == 7'd8 || dirSelect == 7'd9) begin
            selectRead = 1'b1;
            if (dirSelect == 7'd8) begin
                valueWriteMem = {{31'b0}, inputPorts[0]};              
            end else begin
                valueWriteMem = {{31'b0}, inputPorts[1]};
            end
        end else begin
            enWrMemory = 1'b1;
            enWrPort = 1'b0;
        end
    end
    
endmodule

