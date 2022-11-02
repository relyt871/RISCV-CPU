`include "def.v"

module ins_queue (
    input wire clk,
    input wire reset,
    input wire ready,

    //input from IF
    output wire full,  
    //output to ID
);
    always @(posedge clk) begin
        if (reset) begin

        end
        else if (ready) begin
            
        end
    end
endmodule