`include "def.v"

module ins_queue (
    input wire clk,
    input wire reset,
    input wire ready,

    input wire push,
    input wire [`INS_LEN] push_ins,
    input wire [`PC_LEN] push_pc,
    output wire full,  

    input wire front,
    output reg empty,
    output reg [`INS_LEN] front_ins [`QUEUE_LEN],
    output reg [`PC_LEN] front_pc [`QUEUE_LEN]
);
    reg [`QUEUE_LEN] head, tail;
    reg [`INS_LEN] q_ins;
    reg [`PC_LEN] q_pc;
    wire nxt_head = (front? (head == QUEUE_SIZ? 0 : head + 1) : head);
    wire nxt_tail = (push ? (tail == QUEUE_SIZ? 0 : tail + 1) : tail);

    always @(posedge clk) begin
        if (reset) begin
            head <= 0;
            tail <= 0;
            empty <= 1;
        end
        else if (ready) begin
            if (push) begin
                q_ins[tail] = push_ins;
                q_pc[tail] = push_pc;
            end
            if (front) begin
                front_ins = q_ins[head];
                front_pc = q_pc[head];
            end
            head <= nxt_head;
            tail <= nxt_tail;
            full <= (head == 0? tail == QUEUE_SIZ : tail == head - 1);
            empty <= (head == tail);
        end
    end
endmodule