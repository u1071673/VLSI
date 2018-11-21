
module uart_clock_divider_tb;
  reg clk_in,reset;
  wire clk_out;

  uart_clock_divider uut(clk_in,reset,clk_out);

  always #5 clk_in=~clk_in; 
  initial
  clk_in= 1'b0; 
  begin
   #5 reset=1'b1;
   #10 reset=1'b0;
   #500 $finish;
  end

endmodule

