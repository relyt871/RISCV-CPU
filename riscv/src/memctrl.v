`include "def.v"

module memctrl (
    input wire clk,
    input wire reset,
    input wire ready,
    input wire clear,

    input wire [7:0] mem_din,
    output reg [7:0] mem_dout,
    output reg [31:0] mem_a,
    output reg mem_wr,
    input wire io_buffer_full,

    //request from loadstore buffer
    input wire lsb_mem_in_flag,
    input wire lsb_mem_type,
    input wire [`ADDR_LEN] lsb_mem_pc,
    input wire [`MEM_LEN] lsb_mem_len,
    input wire [`DATA_LEN] lsb_mem_output,
    output reg lsb_mem_out_flag,
    output reg [`DATA_LEN] lsb_mem_input,

    //request from ins_cache
    input wire icache_mem_in_flag,
    input wire [`ADDR_LEN] icache_mem_pc,
    output reg icache_mem_out_flag,
    output reg [`INS_LEN] icache_mem_ins
);

    reg busy;
    reg type; //0:read, 1:write
    reg bel; //1:lsb, 0:icache
    reg [`ADDR_LEN] start;
    reg [`MEM_LEN] len, now;
    reg [`DATA_LEN] toread, towrite;

    always @(posedge clk) begin
        if (reset) begin
            busy <= 0;
            mem_a <= 0;
            mem_wr <= 0;
            lsb_mem_out_flag <= 0;
            icache_mem_out_flag <= 0;
        end
        else if (ready) begin
            if (!busy) begin  //initialize for next read/write
                if (lsb_mem_in_flag) begin
                    busy <= 1;
                    type <= lsb_mem_type;
                    bel <= 1;
                    start <= lsb_mem_pc;
                    len <= lsb_mem_len;
                    now <= (lsb_mem_type? 1 : 0);
                    towrite <= lsb_mem_output;
                    mem_a <= lsb_mem_pc;
                    mem_wr <= lsb_mem_type;
                    mem_dout <= lsb_mem_output[7:0];
                    lsb_mem_out_flag <= 0;
                    icache_mem_out_flag <= 0;
                end
                else if (icache_mem_in_flag) begin
                    busy <= 1;
                    type <= 0;
                    bel <= 0;
                    start <= icache_mem_pc;
                    len <= 3'b100;
                    now <= 0;
                    mem_a <= icache_mem_pc;
                    mem_wr <= 0;
                    lsb_mem_out_flag <= 0;
                    icache_mem_out_flag <= 0;
                end
                else begin
                    mem_a <= 0;
                    mem_wr <= 0;
                    mem_dout <= 0;
                    lsb_mem_out_flag <= 0;
                    icache_mem_out_flag <= 0;
                end
            end
            else begin //read/write in progress
                if (type == 0) begin //read
                    if (now == len) begin
                        mem_a <= 0;
                        mem_wr <= 0;
                        if (bel == 0) begin
                            lsb_mem_out_flag <= 1;
                            icache_mem_out_flag <= 0;
                        end
                        else begin
                            lsb_mem_out_flag <= 0;
                            icache_mem_out_flag <= 1;
                        end
                        case (len)
                            2'b00: begin
                                lsb_mem_input <= {{24{1'b0}}, mem_din};
                            end
                            2'b01: begin
                                lsb_mem_input <= {{16{1'b0}}, mem_din, toread[7:0]};
                            end
                            2'b11: begin
                                if (bel) lsb_mem_input <= {mem_din, toread[23:0]};
                                else icache_mem_ins <= {mem_din, toread[23:0]};
                            end
                        endcase
                        busy <= 0;
                    end
                    else begin
                        mem_wr <= 0;
                        lsb_mem_out_flag <= 0;
                        icache_mem_out_flag <= 0;
                        case (now)
                            2'b00: begin
                                toread[7:0] <= mem_din;
                            end
                            2'b01: begin
                                toread[15:8] <= mem_din;
                            end
                            2'b10: begin
                                toread[23:16] <= mem_din;
                            end
                        endcase
                        now <= now + 1;
                        mem_a <= mem_a + 1;
                    end
                end
                else begin //write
                    if (now == len) begin
                        lsb_mem_out_flag <= 1;
                        icache_mem_out_flag <= 0;
                        mem_a <= 0;
                        mem_wr <= 0;
                        busy <= 0;
                    end
                    else begin
                        mem_wr <= 1;
                        lsb_mem_out_flag <= 0;
                        icache_mem_out_flag <= 0;
                        case (now)
                            2'b01: begin
                                mem_dout <= towrite[15:8];
                            end
                            2'b10: begin
                                mem_dout <= towrite[23:16];
                            end
                            2'b11: begin
                                mem_dout <= towrite[31:24];
                            end
                        endcase
                        now <= now + 1;
                        mem_a <= mem_a + 1;
                    end
                end
            end
        end
    end
endmodule