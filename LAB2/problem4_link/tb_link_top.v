module tb_link_top;
    reg clk;
    reg rst;
    wire done;
    wire [7:0] last_byte;

    link_top dut(.clk(clk), .rst(rst), .done(done), .last_byte(last_byte));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        repeat(3) @(posedge clk);
        rst = 0;

        repeat(80) @(posedge clk);
        $finish;
    end

    initial begin
        $dumpfile("waves/link.vcd");
        $dumpvars(0, tb_link_top);
    end
endmodule
