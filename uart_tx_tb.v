module uart_tx_tb;

  localparam [3:0] TEST1 = 4'd1, TEST2 = 4'd2, TEST3 = 4'd3, TEST4 = 4'd4, TEST5 = 4'd5, TEST6 = 4'd6, TEST7 = 4'd7;
  reg [7:0] test;

  // INPUTS
  reg clk;
  reg rst;
  reg start;
  reg [7:0] data;

  // OUTPUTS
  wire tx;
  wire idle_ready;

  // INSTANTIATE THE UNIT UNDER TEST (UUT)
  uart_tx uut(
      .clk(clk),
      .rst(rst),
      .start(start),
      .data(data),
      .tx(tx),
      .idle_ready(idle_ready)
  );

  always #2.5 clk = ~clk;

  initial begin
    // INITIALIZE INPUTS
    data  = 8'h41;
    clk = 0;
    rst = 0;
    test = 0;
    start = 0;
    // WAIT 10ns FOR GLOBAL RESET TO FINISH
    #100;
    // ADD STIMULUS HERE
    test = TEST1; 
    start = 1; #5;
    start = 0; #5;

    #100;

    test = TEST2; 
    start = 1; #5;
    start = 0; #5;

    #100;

  end

endmodule
