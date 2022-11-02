`include "def.v"

module robuffer (
    input wire clk,
    input wire reset,
    input wire ready,

    //input from ID
    //output to ID

    //input from CDB
    //output to CDB
);
    always @(posedge clk) begin
        if (reset) begin

        end
        else if (ready) begin
            
        end
    end
endmodule