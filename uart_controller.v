

module uart_controller(
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

endmodule