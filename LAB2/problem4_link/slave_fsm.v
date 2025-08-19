module slave_fsm(
    input wire clk,
    input wire rst,
    input wire req,
    input wire [7:0] data_in,
    output reg ack,
    output reg [7:0] last_byte
);
    localparam WAIT_REQ = 2'd0;
    localparam ACK1 = 2'd1;
    localparam ACK2 = 2'd2;
    localparam DROP_ACK = 2'd3;

    reg [1:0] state;

    always @(posedge clk) begin
        if (rst) begin
            state <= WAIT_REQ;
            ack <= 0;
            last_byte <= 8'h00;
        end else begin
            case (state)
                WAIT_REQ: begin
                    ack <= 0;
                    if (req) begin
                        last_byte <= data_in;
                        ack <= 1;
                        state <= ACK1;
                    end
                end
                ACK1: begin
                    ack <= 1;
                    state <= ACK2;
                end
                ACK2: begin
                    ack <= 1;
                    state <= DROP_ACK;
                end
                DROP_ACK: begin
                    ack <= 0;
                    state <= WAIT_REQ;
                end
                default: state <= WAIT_REQ;
            endcase
        end
    end
endmodule
