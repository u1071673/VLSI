module hc(clk, a, b, out)
	input [7:0] a, g;
	output out;
	reg AT, GT;

always@*
begin
	if(a>g) begin
		out = 1;
	end
	else if (g>a) begin
		out = 0;
	end
		
end
endmodule