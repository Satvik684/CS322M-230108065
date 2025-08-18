
`timescale 1ns/1ps

module tb_vending_mealy;
    reg        clk;
    reg        rst;
    reg [1:0]  coin;
    wire       dispense;
    wire       chg5;


    vending_mealy dut(
        .clk(clk), .rst(rst), .coin(coin),
        .dispense(dispense), .chg5(chg5)
    );


    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task put5;  begin coin = 2'b01; @(posedge clk); coin = 2'b00; end endtask
    task put10; begin coin = 2'b10; @(posedge clk); coin = 2'b00; end endtask
    task idle1; begin coin = 2'b00; @(posedge clk); end endtask


    always @(posedge clk) begin
        if (dispense || chg5)
            $display("%0t ns: dispense=%b chg5=%b (coin=%b)",
                     $time, dispense, chg5, coin);
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_vending_mealy);


        coin = 2'b00;
        rst  = 1;
        repeat (3) @(posedge clk);
        rst  = 0;


        idle1; put10; idle1; put10; idle1;


        idle1; put5; idle1; put5; idle1; put10; idle1;


        idle1; put10; idle1; put5; idle1; put10; idle1;

        repeat (5) @(posedge clk);
        $display("TB done.");
        $finish;
    end
endmodule
