`include "def.v"

module alu(
    input wire[`PC_LEN] pc,
    input wire[`OP_LEN] op,
    input wire[`INT_LEN] rs1,
    input wire[`INT_LEN] rs2,
    input wire[`IMM_LEN] imm,
    input wire[`ROB_LEN] rob,

    //output to CDB
);
    always @(posedge clk) begin
        
    end
endmodule