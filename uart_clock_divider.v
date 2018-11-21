`define WIDTH 2604
`define N 5208

module uart_clock_divider(
  input clk_in,
  input rst,
  output clk_out
  );

reg [`WIDTH-1:0] r_reg;
wire [`WIDTH-1:0] r_nxt;
reg clk_track;

assign r_nxt = r_reg + 1;           
assign clk_out = clk_track;

always @(posedge clk_in or posedge rst)
begin
  if (rst)
  begin
    r_reg <= 0;
    clk_track <= 1'b0;
  end

  else if (r_nxt == `N)
  begin
    r_reg <= 0;
    clk_track <= ~clk_track;
  end

  else 
    r_reg <= r_nxt;
end

endmodule
