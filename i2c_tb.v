`timescale 1ns / 1ps

module i2c_tb;

  localparam [3:0] TEST1 = 4'd1, TEST2 = 4'd2, TEST3 = 4'd3, TEST4 = 4'd4, TEST5 = 4'd5, TEST6 = 4'd6, TEST7 = 4'd7, TEST8 = 4'd8, TEST9 = 4'd9;
  reg [3:0] test, bytes_written;

  // INPUTS
  reg rw;
  reg rst;
  reg clk;
  reg start;
  reg two_bytes;
  reg [6:0] addr;
  reg [15:0] data;

  // OUTPUTS
  wire sda;
  wire scl;
  wire ready;
  wire [15:0] read_data;

  // INSTANTIATE THE UNIT UNDER TEST (UUT)
  i2c uut(
    .sda(sda),
    .ready(ready),
    .rst(rst),
    .start(start),
    .scl(scl),
    .addr(addr),
    .data(data),
    .two_bytes(two_bytes),
    .read_data(read_data),
    .rw(rw),
    .clk(clk)
    );

  always #2.5 clk = ~clk;

  assign sda = ((test == TEST2 || test == TEST4 || test == TEST6 || test == TEST8) && uut.state == 4 && bytes_written < 1) ? 1'b0 : 1'bz;

  always@(posedge uut.state)
  begin
   if(uut.state == 0 || uut.state == 1) bytes_written <= 0;
   else if(uut.state == 5 || uut.state == 7) bytes_written <= bytes_written + 1;
   else;

 end

 initial begin
    // INITIALIZE INPUTS
    addr  = 7'h50 ;
    data = 0;
    clk = 0;
    rst = 0;
    rw = 0;
    test = 0;
    bytes_written = 0;
    start = 0;
    two_bytes = 0;
    // WAIT 10ns FOR GLOBAL RESET TO FINISH
    #10;
    // ADD STIMULUS HERE
    test = TEST1; // Test for one byte write without slave acknowledge
    rw = 0;
    data  = 16'haa55;
    start = 1; #5;
    start = 0; #5;

    #75;

    test = TEST2; // Test for one byte write with slave acknowledge
    rw = 0;
    data  = 16'haa55;
    start = 1; #5;
    start = 0; #5;

    #100;

    test = TEST3; // Test for one byte read without slave acknowledge
    rw = 1;
    data  = 16'h0000;
    start = 1; #5;
    start = 0; #5;

    #75;

    test = TEST4; // Test for one byte read without slave acknowledge
    rw = 1;
    start = 1; #5;
    start = 0; #5;

    #100;

    test = TEST5; // Test for two byte write without slave acknowledge
    rw = 0;
    data  = 16'haa55;
    two_bytes = 1;
    start = 1; #5;
    start = 0; #5;

    #75;

    test = TEST6; // Test for two byte write with slave acknowledge
    rw = 0;
    data  = 16'haa55;
    two_bytes = 1;
    start = 1; #5;
    start = 0; #5;

    #200;

    test = TEST7; // Test for two byte read without slave acknowledge
    rw = 1;
    data  = 16'h0000;
    two_bytes = 1;
    start = 1; #5;
    start = 0; #5;

    #75;

    test = TEST8; // Test for two byte read with slave acknowledge
    rw = 1;
    data  = 16'h0000;
    two_bytes = 1;
    start = 1; #5;
    start = 0; #5;

    #100;
  end

endmodule
