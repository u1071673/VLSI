
module uart(
input wire [7:0] data_tx,
input wire clk,
input wire rst,
input wire rx,
input wire start_tx,
output wire [7:0] data_rx,
output wire tx,
output wire ready_tx,
output wire ready_rx
);


  uart_rx rx_module(
    .clk(clk),
    .rst(rst),
    .data(data_rx),
    .rx(rx),
    .ready(ready_rx)
  );

  uart_tx tx_module(
      .clk(clk),
      .rst(rst),
      .start(start_tx),
      .data(data_tx),
      .tx(tx),
      .ready(ready_tx)
  );

endmodule