
`timescale 1ns / 1ps

module hc_tb;

  // INPUTS (reg)
  reg clk;
  reg rst;
  reg [7:0] ts1, ts2;

  // OUTPUTS (wire)
  wire out;

  // INSTANTIATE THE UNIT UNDER TEST (UUT)
  hc uut(
  .clk(clk),
  .rst(rst),
  .ts1(ts1),
  .ts2(ts2),
  .out(out)
  );

  always #1 clk = ~clk;

  initial begin
    // INITIALIZE INPUTS
    clk = 0;
    rst = 0;
    ts1 = -5;
    ts2 = -5;
    // WAIT 100ns FOR GLOBAL RESET TO FINISH
   
    #10;
    // ADD STIMULUS HERE
    // TODO: Test 1
    #10;
    // TODO: Test 2
    #10;

    #100;

  end

endmodule