`include "def.v"

module ins_queue (
    input wire clk,
    input wire reset,
    input wire ready,

    //push new ins
    input wire push,
    input wire [`INS_LEN] push_ins,
    input wire [`PC_LEN] push_pc,
    output reg insq_full,  

    //pop front to decode
    input wire front,
    output reg insq_empty,
    output reg [`INS_LEN] front_ins,
    output reg [`PC_LEN] front_pc
);
    reg [`INSQ_LEN] head, tail;
    reg [`INSQ_LEN] siz;
    reg [`INS_LEN] q_ins[`INSQ_LEN];
    reg [`PC_LEN] q_pc[`INSQ_LEN];

    always @(posedge clk) begin
        if (reset) begin
            head <= 0;
            tail <= 0;
            siz <= 0;
            insq_empty <= 1;
            insq_full <= 0;
        end
        else if (ready) begin
            if (push) begin
                q_ins[tail] <= push_ins;
                q_pc[tail] <= push_pc;
            end
            if (front) begin
                front_ins <= q_ins[head];
                front_pc <= q_pc[head];
            end
            head <= (front? ((head == `INSQ_MAX)? 0 : head + 1) : head);
            tail <= (push? ((tail == `INSQ_MAX)? 0 : tail + 1) : tail);
            siz <= (siz - front + push);
            insq_empty <= (siz - front + push == 0);
            insq_full <= (siz - front + push == `INSQ_MAX);
        end
    end
endmodule
