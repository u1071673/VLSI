
module uart_clock_divider_tb;
  reg clk_in, rst;
  wire clk_out;

  uart_clock_divider uut(
  .clk_in(clk_in),
  .rst(rst), 
  .clk_out(clk_out)
  );

  always #5 clk_in=~clk_in; 

  initial
  begin
   clk_in = 1'b0; 
   #5; rst = 1'b1;
   #10; rst = 1'b0;
   #500;
  end

endmodule

