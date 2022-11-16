`include "def.v"

module alu(
    input wire work,

    input wire[`PC_LEN] pc,
    input wire[`OP_LEN] op,
    input wire[`INT_LEN] rs1,
    input wire[`INT_LEN] rs2,
    input wire[`IMM_LEN] imm,
    input wire[`ROB_LEN] rob_pos,

    output reg flag,
    output reg [`DATA_LEN] rd,
    output reg [`ROB_LEN] rob_to
);
    
    always @(posedge clk) begin
        flag = work;
        if (work) begin
            rob_to <= rob_pos;
            case (op) 
                `ADDI: begin
                    rd <= rs1 + imm;
                end
                `SLTI: begin
                    rd <= ($signed(rs1) < $signed(rs2));
                end
                `SLTIU: begin
                    rd <= (rs1 < imm);
                end
                `XORI: begin
                    rd <= rs1 ^ imm;
                end
                `ORI: begin
                    rd <= rs1 | imm;
                end
                `ANDI: begin
                    rd <= rs1 & imm;
                end
                `SLLI: begin
                    rd <= (rs1 << imm);
                end
                `SRLI: begin
                    rd <= (rs1 >> imm);
                end
                `SRAI: begin
                    rd <= ($signed(rs1) >> imm);
                end
                `ADD: begin
                    rd <= rs1 + rs2;
                end
                `SUB: begin
                    rd <= rs1 - rs2;
                end
                `SLL: begin
                    rd <= (rs1 << rs2);
                end
                `SLT: begin
                    rd <= ($signed(rs1) < $signed(rs2));
                end
                `SLTU: begin
                    rd <= (rs1 < rs2);
                end
                `XOR: begin
                    rd <= (rs1 ^ rs2);
                end
                `SRL: begin
                    rd <= (rs1 >> rs2);
                end
                `SRA: begin
                    rd <= ($signed(rs1) >> rs2);
                end
                `OR: begin
                    rd <= (rs1 | rs2);
                end
                `AND: begin
                    rd <= (rs1 & rs2);
                end
                default: begin
                    flag <= 0;
                end
            endcase
        end
    end
endmodule