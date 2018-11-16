`timescale 1ns / 1ps

module i2c_tb;

  // INPUTS
  reg rw;
  reg rst;
  reg clk;
  reg start;
  reg [7:0] data;
  reg [6:0] addr;

  // OUTPUTS
  wire sda;
  wire scl;
  wire ready;

  
  // INSTANTIATE THE UNIT UNDER TEST (UUT)
  i2c utt(
      .sda(sda),
      .ready(ready),
      .rst(rst),
      .start(start),
      .scl(scl),
      .data(data),
      .rw(rw),
      .clk(clk),
      .addr(addr)
  );

  always #1 clk = ~clk;

  assign sda = (utt.state == 4) ? 1'b0 : 1'bz;

  initial begin
    // INITIALIZE INPUTS
    clk = 0;
    rst = 1;
    addr  = 7'h50 ;
    data  = 8'h55 ;
    rw = 0;
    // WAIT 10ns FOR GLOBAL RESET TO FINISH
    #10;
    // ADD STIMULUS HERE
    rst = 0;
    start = 1;
    #10;
    start = 0;

    #100;

  end

endmodule
