module uart_rx_tb;

  localparam [3:0] TEST1 = 4'd1, TEST2 = 4'd2, TEST3 = 4'd3, TEST4 = 4'd4, TEST5 = 4'd5, TEST6 = 4'd6, TEST7 = 4'd7;
  reg [7:0] test;

  // INPUTS
  reg start;
  reg clk;
  reg rst;
  reg [7:0] data_tx;

  // OUTPUTS
  wire rx;
  wire tx;
  wire [7:0] data_rx;
  wire ready_tx;
  wire ready_rx;

  // INSTANTIATE THE UNIT UNDER TEST (UUT)
  uart_rx uut_rx(
    .clk(clk),
    .rst(rst),
    .data(data_rx),
    .rx(rx),
    .ready(ready_rx)
  );

  uart_tx uut_tx(
      .clk(clk),
      .rst(rst),
      .start(start),
      .data(data_tx),
      .tx(tx),
      .ready(ready_tx)
  );

  assign rx = tx;

  always #2.5 clk = ~clk;

  initial begin
    // INITIALIZE INPUTS
    data_tx = 8'h41;
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

    #300;
    
    test = TEST2;
    start = 1; #5;
    start = 0; #5;

    #300;

  end

endmodule
