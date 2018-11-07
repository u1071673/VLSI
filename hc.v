`define TH 8'd10

module hc(clk, rst, AT, GT, out)
	input clk;
	input rst;
	input [7:0] AT, GT;
	output AT_out, GT_out;
	parameter s_AT_out = 1, s_GT_out = 0;
	reg state, next_state;
	
	// OUTPUT COMBINATIONAL LOGIC
	assign AT_out = (state == s_AT_out);
	assign GT_out = (state == s_GT_out);
	
	// UPDATE STATE SEQUENTIAL LOGIC
	always@(posedge clk)
	begin
		if(rst) state = s_AT_out;
		else state = next_state;s
	end
	
	// NEXT STATE COMBINATIONAL LOGIC
	always@(AT or GT or state)
	begin
	case(state)
		s_GT_out: if((GT < (AT-`TH)) next_state = s_AT_out;
		default: 
		begin
			if(AT < (GT - `TH)) next_state = s_GT_out;
			else if(AT > (GT - `TH)) next_state = s_AT_out;
			else next_state = next_state;
		end
	endcase
		
	end
endmodule