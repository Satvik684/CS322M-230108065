
`timescale 1ns/1ps

module tb_traffic_light;
    reg clk;
    reg rst;
    reg tick;
    wire ns_g, ns_y, ns_r, ew_g, ew_y, ew_r;

    
    traffic_light dut (
        .clk(clk), .rst(rst), .tick(tick),
        .ns_g(ns_g), .ns_y(ns_y), .ns_r(ns_r),
        .ew_g(ew_g), .ew_y(ew_y), .ew_r(ew_r)
    );

    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

   
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_traffic_light);

        rst = 1;
        tick = 0;
        #20;    
        rst = 0;

        #2000;
        $display("Testbench done.");
        $finish;
    end

    reg [2:0] fast_div;
    always @(posedge clk) begin
        if (rst) begin
            fast_div <= 0;
            tick <= 0;
        end else begin
            if (fast_div == 4) begin
                tick <= 1;
                fast_div <= 0;
            end else begin
                tick <= 0;
                fast_div <= fast_div + 1;
            end
        end
    end

    always @(posedge clk) begin
        if (tick) begin
            $display("%0t: tick -- ns_g=%b ns_y=%b ns_r=%b | ew_g=%b ew_y=%b ew_r=%b",
                     $time, ns_g, ns_y, ns_r, ew_g, ew_y, ew_r);
        end
    end

endmodule
