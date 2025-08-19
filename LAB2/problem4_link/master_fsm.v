module master_fsm(
    input wire clk,
    input wire rst,
    input wire ack,
    output reg req,
    output reg [7:0] data,
    output reg done
);
    localparam IDLE = 3'd0;
    localparam SEND = 3'd1;
    localparam WAIT_ACK = 3'd2;
    localparam DROP_REQ = 3'd3;
    localparam WAIT_ACK_LOW = 3'd4;
    localparam NEXTB = 3'd5;
    localparam DONE = 3'd6;

    reg [2:0] state;
    reg [1:0] idx;

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            idx <= 0;
            req <= 0;
            data <= 8'h00;
            done <= 0;
        end else begin
            done <= 0;
            case (state)
                IDLE: begin
                    idx <= 0;
                    req <= 0;
                    state <= SEND;
                end
                SEND: begin
                    data <= 8'hA0 + idx;
                    req <= 1;
                    state <= WAIT_ACK;
                end
                WAIT_ACK: begin
                    if (ack) state <= DROP_REQ;
                end
                DROP_REQ: begin
                    req <= 0;
                    state <= WAIT_ACK_LOW;
                end
                WAIT_ACK_LOW: begin
                    if (!ack) state <= NEXTB;
                end
                NEXTB: begin
                    if (idx == 2'd3) begin
                        done <= 1;
                        state <= DONE;
                    end else begin
                        idx <= idx + 1;
                        state <= SEND;
                    end
                end
                DONE: begin
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
