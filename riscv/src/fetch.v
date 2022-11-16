`include "def.v"

module Fetch (
    input wire clk,
    input wire reset,
    input wire ready,

    input wire mem_ok,
    input wire [`INS_LEN] mem_din,
    output reg fin_read,
    output reg [`PC_LEN] nxt_addr,

    input wire insq_full,
    output reg flag,
    output reg [`INS_LEN] cur_ins,
    output reg [`PC_LEN] cur_pc,

    input wire jump,
    input wire [`PC_LEN] pc_jump_to
);

    reg [`PC_LEN] PC;

    always @(posedge clk) begin
        if (reset) begin
            pc <= 0;
            fin_read <= 0;
            nxt_addr <= 0;
            flag <= 0;
        end
        else if (ready) begin
            if (jump) begin
                PC = pc_jump_to;
                flag <= 0;
                fin_read <= 1;
                nxt_addr <= PC;
            end
            else if (mem_ok && !insq_full) begin
                fin_read <= 1;
                nxt_addr <= PC + 3'b100;
                flag <= 1;
                cur_ins <= mem_din;
                cur_pc <= PC;
                PC <= PC + 3'b100;
            end
            else begin
                fin_read <= 0;
                flag <= 0;
            end
        end
    end
endmodule