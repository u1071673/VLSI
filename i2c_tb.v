

module i2c_tb;

  // INPUTS
  reg rst;
  reg clk;
  reg [7:0] data;
  reg [6:0] addr;

  // OUTPUTS
  wire sda;
  wire scl;

  // INSTANTIATE THE UNIT UNDER TEST (UUT)
  i2c utt(
      .sda(sda),
      .rst(rst),
      .scl(scl),
      .data(data),
      .clk(clk),
      .addr(addr)
  );

  always #1 clk = ~clk;

  initial begin
    // INITIALIZE INPUTS
    clk = 0;
    rst = 1;
    addr  = 7'h50 ;
    data  = 8'haa ;
    // WAIT 100ns FOR GLOBAL RESET TO FINISH
    #10;
    // ADD STIMULUS HERE
    rst = 0;

    #100;

  end

endmodule
