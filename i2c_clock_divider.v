`define WIDTH_i2c 7
`define N_i2c (`WIDTH_i2c'd13)

module i2c_clock_divider(
  input clk_in,
  input rst,
  output clk_out
  );

reg [`WIDTH_i2c-1:0] r_reg;
wire [`WIDTH_i2c-1:0] r_nxt;
reg clk_track;

assign r_nxt = r_reg + 1;           
assign clk_out = clk_track;

always @(posedge clk_in or posedge rst)
begin
  if (rst)
  begin
    r_reg <= `WIDTH_i2c'd0;
    clk_track <= 1'b0;
  end

  else if (r_nxt == `N_i2c)
  begin
    r_reg <= `WIDTH_i2c'd0;
    clk_track <= ~clk_track;
  end

  else 
    r_reg <= r_nxt;
end

endmodule
