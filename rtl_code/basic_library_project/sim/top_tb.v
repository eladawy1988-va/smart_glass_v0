

`timescale 1ns/1ns

module top_tb();

reg  clk, rst_n, l_start, r_start, l_clear, r_clear;

top TOP(clk, rst_n, l_start, r_start, l_clear, r_clear);

initial
begin
 clk = 0;
 //$dumpfile("../vcd/interface_tb.vcd");
 //$dumpvars(0, top_tb);

 rst_n = 0;
 l_clear = 0;
 r_clear = 0;
 l_start = 0;
 r_start = 0;
  repeat (10) @(posedge clk);
 rst_n = 1;
 l_start = 1;
 r_start = 1;
  repeat (2)  @(posedge clk);
 l_start = 0;
 r_start = 0;
   repeat (10860050) @(posedge clk);
 //#10860050;
 $finish;
end

always
begin
 clk = ~clk;
 #1;
end

endmodule
