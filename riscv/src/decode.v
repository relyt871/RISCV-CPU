`include "def.v"

module Decode (
    input wire [`INS_LEN] ins,
    output reg [`OP_LEN] op,
    output reg [`REG_LEN] rd,
    output reg [`REG_LEN] rs1,
    output reg [`REG_LEN] rs2,
    output reg [`IMM_LEN] imm
);
    wire [6:0] opcode;
    wire [2:0] func3;
    assign opcode = ins[6:0];
    assign func3 = ins[14:12];
    
    always @(*) begin
        rd <= ins[11:7];
        rs1 <= ins[19:15];
        rs2 <= ins[24:20];
        case (opcode)
            7'b0110111: begin
                op <= `LUI;
                imm <= {ins[31:12], {12'b0}};
            end
            7'b0010111: begin
                op <= `AUIPC;
                imm <= {ins[31:12], {12'b0}};
            end
            7'b1101111: begin
                op <= `JAL;
                imm <= {{13{ins[31]}}, ins[19:12], ins[20], ins[30:21], {1'b0}};
            end
            7'b1100111: begin
                op <= `JALR;
                imm <= {{20{ins[31]}}, ins[31:20]};
            end
            7'b1100011: begin
                case (func3)
                    3'b000: op <= `BEQ;
                    3'b001: op <= `BNE;
                    3'b100: op <= `BLT;
                    3'b101: op <= `BGE;
                    3'b110: op <= `BLTU;
                    3'b111: op <= `BGEU;
                    default: op <= `WOW;
                endcase
                imm <= {{20{ins[31]}}, ins[7], ins[30:25], ins[11:8], {1'b0}};
            end
            7'b0000011: begin
                case (func3)
                    3'b000: op <= `LB;
                    3'b001: op <= `LH;
                    3'b010: op <= `LW;
                    3'b011: op <= `LD;
                    3'b100: op <= `LBU;
                    3'b101: op <= `LHU;
                    default: op <= `WOW;
                endcase
                imm <= {{20{ins[31]}}, ins[31:20]};
            end
            7'b0100011: begin
                case (func3)
                    3'b000: op <= `SB;
                    3'b001: op <= `SH;
                    3'b010: op <= `SW;
                    3'b011: op <= `SD;
                endcase
                imm <= {{20{ins[31]}}, ins[31:25], ins[11:7]};
            end
            7'b0010011: begin
                case (func3)
                    3'b000: op <= `ADDI;
                    3'b001: op <= `SLLI;
                    3'b010: op <= `SLTI;
                    3'b011: op <= `SLTIU;
                    3'b100: op <= `XORI;
                    3'b101: op <= (ins[30]? `SRAI : `SRLI);
                    3'b110: op <= `ORI;
                    3'b111: op <= `ANDI;
                endcase
                imm <= {{20{ins[31]}}, ins[31:20]};
            end
            7'b0110011: begin
                case (func3) 
                    3'b000: op <= (ins[30]? `SUB : `ADD);
                    3'b001: op <= `SLL;
                    3'b010: op <= `SLT;
                    3'b011: op <= `SLTU;
                    3'b100: op <= `XOR;
                    3'b101: op <= (ins[30]? `SRA : `SRL);
                    3'b110: op <= `OR;
                    3'b111: op <= `AND;
                endcase
            end
            default: begin
                op <= `WOW;
            end
        endcase
    end
endmodule