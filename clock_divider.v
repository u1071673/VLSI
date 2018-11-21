
module clock_divider
#( 
parameter WIDTH = 2604, // number of registers required to store N (minimum number of widths needed to count N) which is N/2
parameter N = 5208 // from the equation   input_frequency/(2*N)=output_frequency  where input_frequency=100MHz and output_frequency=9600Hz
)
(clk,reset, clk_out);
 
input clk;
input reset;
output clk_out;
 
reg [WIDTH-1:0] r_reg;
wire [WIDTH-1:0] r_nxt;
reg clk_track;
 
always @(posedge clk or posedge reset)
 
begin
  if (reset)
     begin
        r_reg <= 0;
	clk_track <= 1'b0;
     end
 
  else if (r_nxt == N)
 	   begin
	     r_reg <= 0;
	     clk_track <= ~clk_track;
	   end
 
  else 
      r_reg <= r_nxt;
end
 
 assign r_nxt = r_reg + 1;   	      
 assign clk_out = clk_track;
endmodule
