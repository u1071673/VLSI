
`timescale 1ns / 1ns
module i2c_tb  ; 

  // INPUTS
  reg rst; 
  reg [7:0] data; 
  reg clk;
  reg [6:0] addr; 

  // OUTPUTS
  wire sda; 
  wire scl;

  // INSTANTIATE THE UNIT UNDER TEST (UUT)
  i2c UUT(
      .sda(sda),
      .rst(rst),
      .scl(scl),
      .data(data),
      .clk(clk),
      .addr(addr)); 

 always #1 clk = ~clk;

 initial begin
 // INITIALIZE INPUTS
 clk = 0;
 rst = 1;
 addr  = 7'h50 ;	  
 data  = 8'haa ;
 // WAIT 100ns FOR GLOBAL RESET TO FINISH
 #100
 // ADD STIMULUS HERE
 rst = 0;
 $finish;
 end

endmodule
