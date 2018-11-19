
`timescale 1ns / 1ps

module solar_tb;

  localparam [3:0] TEST1 = 4'd1, TEST2 = 4'd2, TEST3 = 4'd3, TEST4 = 4'd4, TEST5 = 4'd5, TEST6 = 4'd6, TEST7 = 4'd7, TEST8 = 4'd8, TEST9 = 4'd9, TEST10 = 4'd10, TEST11 = 4'd11;
  reg [3:0] test; 

  // INPUTS (reg)
  reg [7:0] th;
  reg clk;
  reg rst;
  reg [7:0] lsn, lse, lss, lsw;

  // OUTPUTS (wire)
  wire mn, me, ms, mw;

  // INSTANTIATE THE UNIT UNDER TEST (UUT)
solar (
  .th(th),
  .clk(clk),
  .rst(rst),
  .lsn(lsn),
  .lse(lse), 
  .lss(lss), 
  .lsw(lsw),
  .mn(mn), 
  .me(me), 
  .ms(ms), 
  .mw(mw)
  );

  always #2.5 clk = ~clk;

  initial begin
    // INITIALIZE INPUTS
    th = 8'd10;
    clk = 0;
    rst = 0;
    lsn = 8'd100;
    lse = 8'd100;
    lss = 8'd100;
    lsw = 8'd100;
    // WAIT 100ns FOR GLOBAL RESET TO FINISH
    #10;
    // ADD STIMULUS HERE
    test = TEST1;
    lsn = 8'd115;    
    #10;

    test = TEST2;
    #10;

    #100;

  end

endmodule