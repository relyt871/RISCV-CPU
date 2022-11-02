`include "def.v"

module lsbuffer (
    input wire clk,
    input wire reset,
    input wire ready,

    //input from mem
    //output from mem
    
    //output to CDB (load)
);
    always @(posedge clk) begin
        if (reset) begin

        end
        else if (ready) begin
            
        end
    end
endmodule