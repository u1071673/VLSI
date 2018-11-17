`timescale 1ns / 1ps

module i2c_tb;

  localparam [3:0] TEST1 = 4'd1, TEST2 = 4'd2, TEST3 = 4'd3, TEST4 = 4'd4, TEST5 = 4'd5, TEST6 = 4'd6, TEST7 = 4'd7;
  reg [3:0] test, bytes_written;
  reg [7:0] state;

  // INPUTS
  reg rw;
  reg rst;
  reg clk;
  reg start;
  reg [6:0] addr;
  reg [7:0] data;

  // OUTPUTS
  wire sda;
  wire scl;
  wire ready;

  // INSTANTIATE THE UNIT UNDER TEST (UUT)
  i2c uut(
    .sda(sda),
    .ready(ready),
    .rst(rst),
    .start(start),
    .scl(scl),
    .addr(addr),
    .data(data),
    .rw(rw),
    .clk(clk)
    );

  always #2.5 clk = ~clk;

  assign sda = ((test == TEST1 || test == TEST2) && uut.state == 4 && bytes_written < 1) ? 1'b0 : 1'bz;

  always@(posedge uut.state)
  begin
   if(uut.state == 0 || uut.state == 1) bytes_written <= 0;
   else if(uut.state == 5) bytes_written <= bytes_written + 1;
   else;

 end

 initial begin
    // INITIALIZE INPUTS
    addr  = 7'h50 ;
    data  = 8'h55 ;
    clk = 0;
    rst = 0;
    rw = 0;
    test = 0;
    bytes_written = 0;
    // WAIT 10ns FOR GLOBAL RESET TO FINISH
    #100;
    // ADD STIMULUS HERE
    test = TEST1; // Test for write
    rw = 0;
    start = 1; #5;
    start = 0; #5;

    #100;

    test = TEST2; // Test for read
    rw = 1;
    start = 1; #5;
    start = 0; #5;

    #100;

  end

endmodule
