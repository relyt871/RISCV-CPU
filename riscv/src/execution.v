`include "def.v"

module Execute (
    input wire[`PC_LEN] pc,
    input wire[`OP_LEN] op,
    input wire[`INT_LEN] rs1,
    input wire[`INT_LEN] rs2,
    input wire[`IMM_LEN] imm,
    output reg[`INT_LEN] rd,
    output wire[`PC_LEN] next_pc,

    input wire[`DATA_LEN] ram_din,
    output wire[`DATA_LEN] ram_dout
);
    reg[`PC_LEN] npc;
    always @(*) begin
        case (op)
            `LUI: begin
                rd <= imm;
                npc <= pc + 4;
            end
            `AUIPC: begin
                rd <= pc + imm;
                npc <= pc + 4;
            end
            `JAL: begin
                rd <= pc + 4;
                npc <= pc + imm;
            end
            `JALR: begin
                rd <= pc + 4;
                npc <= (rs1 + imm) & `MINUS_ONE;
            end
            `BEQ: begin
                npc <= (rs1 == rs2? imm : 4);
            end
            `BNE: begin
                npc <= (rs1 != rs2? imm : 4);
            end
            `BLT: begin
                npc <= ($signed(rs1) < $signed(rs2)? imm : 4);
            end
            `BGE: begin
                npc <= ($signed(rs1) >= $signed(rs2)? imm : 4);
            end
            `BLTU: begin
                npc <= (rs1 < rs2? imm : 4);
            end
            `BGEU: begin
                npc <= (rs1 >= rs2? imm : 4);
            end
            `LB: begin
                rd <= {{24{ram_din[7]}}, ram_din[7:0]};
                npc <= pc + 4;
            end
            `LH: begin
                rd <= {{16{ram_din[15]}}, ram_din[15:0]};
                npc <= pc + 4;
            end
            `LW: begin
                rd <= ram_din;
                npc <= pc + 4;
            end
            `LBU: begin
                rd <= {{24{1'b0}}, ram_din[7:0]};
                npc <= pc + 4;
            end
            `LHU: begin
                rd <= {{16{1'b0}}, ram_din[15:0]};
                npc <= pc + 4;
            end
            `SB: begin
                npc <= pc + 4;
            end
            `SH: begin
                npc <= pc + 4;
            end
            `SW: begin
                npc <= pc + 4;
            end
            `ADDI: begin
                rd <= rs1 + imm;
                npc <= pc + 4;
            end
            `SLTI: begin
                rd <= ($signed(rs1) < $signed(rs2));
                npc <= pc + 4;
            end
            `SLTIU: begin
                rd <= (rs1 < imm);
                npc <= pc + 4;
            end
            `XORI: begin
                rd <= rs1 ^ imm;
                npc <= pc + 4;
            end
            `ORI: begin
                rd <= rs1 | imm;
                npc <= pc + 4;
            end
            `ANDI: begin
                rd <= rs1 & imm;
                npc <= pc + 4;
            end
            `SLLI: begin
                rd <= (rs1 << imm);
                npc <= pc + 4;
            end
            `SRLI: begin
                rd <= (rs1 >> imm);
                npc <= pc + 4;
            end
            `SRAI: begin
                
                npc <= pc + 4;
            end
            `ADD: begin
                rd <= rs1 + rs2;
                npc <= pc + 4;
            end
            `SUB: begin
                rd <= rs1 - rs2;
                npc <= pc + 4;
            end
            `SLL: begin
                rd <= (rs1 << rs2);
                npc <= pc + 4;
            end
            `SLT: begin
                rd <= ($signed(rs1) < $signed(rs2));
                npc <= pc + 4;
            end
            `SLTU: begin
                rd <= (rs1 < rs2);
                npc <= pc + 4;
            end
            `XOR: begin
                rd <= (rs1 ^ rs2);
                npc <= pc + 4;
            end
            `SRL: begin
                rd <= (rs1 >> rs2);
                npc <= pc + 4;
            end
            `SRA: begin
                
                npc <= pc + 4;
            end
            `OR: begin
                rd <= (rs1 | rs2);
                npc <= pc + 4;
            end
            `AND: begin
                rd <= (rs1 & rs2);
                npc <= pc + 4;
            end
            default: begin
                
            end
        endcase
    end
    assign next_pc = npc;
    assign ram_dout = rs2;
endmodule