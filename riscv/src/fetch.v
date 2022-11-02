`include "def.v"

module IF (
    input wire clk,
    input wire reset,
    input wire ready,

    input wire ins_queue_full,
    //output to instruction queue
);
    always @(posedge clk) begin
        if (reset) begin

        end
        else if (ready) begin
            
        end
    end
endmodule