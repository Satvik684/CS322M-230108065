
module traffic_light(
    input  wire clk,
    input  wire rst,  
    input  wire tick,  
    output reg  ns_g,
    output reg  ns_y,
    output reg  ns_r,
    output reg  ew_g,
    output reg  ew_y,
    output reg  ew_r
);


localparam S_NS_G = 2'd0;
localparam S_NS_Y = 2'd1;
localparam S_EW_G = 2'd2;
localparam S_EW_Y = 2'd3;

reg [1:0] state, next_state;

reg [3:0] tick_cnt;


always @(*) begin
    next_state = state;
    case (state)
        S_NS_G: if (tick && tick_cnt == 4) next_state = S_NS_Y; 
        S_NS_Y: if (tick && tick_cnt == 1) next_state = S_EW_G; 
        S_EW_G: if (tick && tick_cnt == 4) next_state = S_EW_Y; 
        S_EW_Y: if (tick && tick_cnt == 1) next_state = S_NS_G; 
        default: next_state = S_NS_G;
    endcase
end

always @(posedge clk) begin
    if (rst) begin
        state    <= S_NS_G;
        tick_cnt <= 0;
    end else begin
        if (tick) begin
            if (next_state != state) begin
                state    <= next_state;
                tick_cnt <= 0;          
            end else begin
                tick_cnt <= tick_cnt + 1; 
            end
        end
        
    end
end

always @(*) begin
    ns_g = 0; ns_y = 0; ns_r = 0;
    ew_g = 0; ew_y = 0; ew_r = 0;

    case (state)
        S_NS_G: begin
            ns_g = 1;      
            ew_r = 1;     
        end
        S_NS_Y: begin
            ns_y = 1;     
            ew_r = 1;    
        end
        S_EW_G: begin
            ew_g = 1;     
            ns_r = 1;     
        end
        S_EW_Y: begin
            ew_y = 1;   
            ns_r = 1;    
        end
        default: begin
            ns_r = 1;
            ew_r = 1;
        end
    endcase
end

endmodule
