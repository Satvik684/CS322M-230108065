module equality_comparator(
    input [3:0]a,
    input [3:0]b,
    output y
);

    assign y = (a == b) ? 1 : 0;

endmodule