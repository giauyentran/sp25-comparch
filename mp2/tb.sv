`timescale 10ns/10ns
`include "top.sv"

`timescale 1ns / 1ps

module top_tb;

    logic clk;
    logic RGB_R;
    logic RGB_G;
    logic RGB_B;

    top uut (
        .clk(clk),
        .RGB_R(RGB_R),
        .RGB_G(RGB_G),
        .RGB_B(RGB_B)
    );

    initial clk = 0;
    always #41.666 clk = ~clk;

    initial begin

        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);

        #1_000_000_000;  // 1 second
        $finish;
    end

endmodule

