module tb_seq_detect_mealy;
  reg clk, rst, din;
  wire y;

  seq_detect_mealy dut(.clk(clk), .rst(rst), .din(din), .y(y));

  
  initial begin clk=0; forever #5 clk=~clk; end

  initial begin
    $dumpfile("waves/dump.vcd");  
    $dumpvars(0, tb_seq_detect_mealy); 
    rst = 1; din = 0; #20; rst = 0;
    din=1; #10; din=1; #10; din=0; #10; din=1; #10;
    din=1; #10; din=0; #10; din=1; #10; din=1; #10;
    din=1; #10; din=0; #10; din=1; #10;

    #20 $finish;
  end
endmodule
