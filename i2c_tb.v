`timescale 1ns / 1ps

module i2c_tb;

  localparam [3:0] TEST1 = 4'd1, TEST2 = 4'd2, TEST3 = 4'd3, TEST4 = 4'd4, TEST5 = 4'd5, TEST6 = 4'd6, TEST7 = 4'd7, TEST8 = 4'd8, TEST9 = 4'd9, TEST10 = 4'd10, TEST11 = 4'd11;
  reg [3:0] test, bytes_written;
  reg [15:0] transmit_data;
  wire pull_sda_low;

  // INPUTS
  reg rw;
  reg rst;
  reg clk;
  reg start;
  reg two_bytes;
  reg sda_in;
  reg scl_in;
  reg [6:0] addr;
  reg [15:0] data;

  // OUTPUTS
  wire sda_out;
  wire scl_out;
  wire ready;
  wire [15:0] read_data;

  // INSTANTIATE THE UNIT UNDER TEST (UUT)
  i2c uut(
    .scl_in(scl_in),
    .sda_in(sda_in),
    .scl_out(scl_out),
    .sda_out(sda_out),
    .ready(ready),
    .rst(rst),
    .start(start),
    .addr(addr),
    .data(data),
    .two_bytes(two_bytes),
    .read_data(read_data),
    .rw(rw),
    .clk(clk)
    );

  always #2.5 clk = ~clk;
  always@(*)
  begin
    sda_in = (((test == TEST5 || test == TEST6 || test == TEST7|| test == TEST8) && uut.state == 4 && bytes_written < 1) || // Slave acknowedge states
              ((uut.state == 7 || uut.state == 8) && ~transmit_data[uut.count]) ||
               test == TEST9 || test == TEST11) ? 1'b0 : 1'b1;
    scl_in = test == TEST10 || test == TEST11 ? 1'b0 : 1'bz;
  end

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
    start = 0;
    two_bytes = 0;
    transmit_data = 0;
    bytes_written = 0;

    // WAIT 10ns FOR GLOBAL RESET TO FINISH
    #10;
    // ADD STIMULUS HERE
    test = TEST1; // Test for one byte write without slave acknowledge
    rw = 0;
    two_bytes = 0;
    data  = 16'haa55;
    transmit_data = 16'h0000; 
    start = 1; #5;
    start = 0; #5;

    #75;

    test = TEST2; // Test for two byte write without slave acknowledge
    rw = 0;
    two_bytes = 1;
    data  = 16'haa55;
    transmit_data = 16'h0000;
    start = 1; #5;
    start = 0; #5;

    #75;

    test = TEST3; // Test for one byte read without slave acknowledge
    rw = 1;
    two_bytes = 0;
    transmit_data = 16'ha0a0;
    data  = 16'h0000;
    start = 1; #5;
    start = 0; #5;

    #75;

    test = TEST4; // Test for two byte read without slave acknowledge
    rw = 1;
    two_bytes = 1;
    data  = 16'h0000;
    transmit_data = 16'ha0a0;
    start = 1; #5;
    start = 0; #5;

    #75;

    test = TEST5; // Test for one byte write with slave acknowledge
    rw = 0;
    two_bytes = 0;
    data  = 16'haa55;
    transmit_data = 16'h0000; 
    start = 1; #5;
    start = 0; #5;

    #100;

    test = TEST6; // Test for two byte write with slave acknowledge
    rw = 0;
    two_bytes = 1;
    data  = 16'haa55;
    transmit_data = 16'h0000;
    start = 1; #5;
    start = 0; #5;

    #200;

    test = TEST7; // Test for one byte read with slave acknowledge
    rw = 1;
    two_bytes = 0;
    data  = 16'h0000;
    transmit_data = 16'ha7b8;
    start = 1; #5;
    start = 0; #5;

    #100;

    test = TEST8; // Test for two byte read with slave acknowledge
    rw = 1;
    two_bytes = 1;
    data  = 16'h0000;
    transmit_data = 16'ha7b8; 
    start = 1; #5;
    start = 0; #5;

    #200;

    test = TEST9; // Testing ready line to ensure we don't say i2c is ready when another device is using it.
    #25;
    test = 0;
    #25;

    test = TEST10; // Testing ready line to ensure we don't say i2c is ready when another device is using it.
    #25;
    test = 0;
    #25;
    
    test = TEST11;
    #25;
    test = 0;
    #25;

  end

endmodule
