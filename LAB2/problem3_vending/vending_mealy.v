
module vending_mealy(
    input  wire       clk,
    input  wire       rst,       
    input  wire [1:0] coin,      
    output reg        dispense,  
    output reg        chg5      
);

    
    localparam S0  = 2'd0; 
    localparam S5  = 2'd1; 
    localparam S10 = 2'd2; 
    localparam S15 = 2'd3;

    reg [1:0] state, next_state;

    
    wire coin5  = (coin == 2'b01);
    wire coin10 = (coin == 2'b10);
    wire idle   = (coin == 2'b00);
    always @(*) begin
        dispense   = 1'b0;
        chg5       = 1'b0;

        next_state = state;

        case (state)
            S0: begin
                if (coin5)       next_state = S5;
                else if (coin10) next_state = S10;
                else             next_state = S0; 
            end

            S5: begin
                if (coin5)       next_state = S10;
                else if (coin10) next_state = S15;
                else             next_state = S5;
            end

            S10: begin
                if (coin10) begin
                    dispense   = 1'b1; 
                    next_state = S0;
                end else if (coin5) begin
                    next_state = S15;
                end else begin
                    next_state = S10;
                end
            end

            S15: begin
                if (coin5) begin
                    dispense   = 1'b1;
                    next_state = S0;
                end else if (coin10) begin
                    dispense   = 1'b1;
                    chg5       = 1'b1;
                    next_state = S0;
                end else begin
                    next_state = S15;
                end
            end

            default: next_state = S0;
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

endmodule
