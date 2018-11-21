
module clock_divider_tb;
  reg clk,reset;
  wire clk_out;
 
     clock_divider t1(clk,reset,clk_out);
        initial
          clk= 1'b0;
     always
        #5  clk=~clk; 
        initial
            begin
               #5 reset=1'b1;
               #10 reset=1'b0;
               #500 $finish;
            end
 
        initial
               $monitor("clk=%b,reset=%b,clk_out=%b",clk,reset,clk_out);
 
        initial
            begin
              $dumpfile("clock_divider_tb.vcd");
              $dumpvars(0,clock_divider_tb);
             end
    endmodule

