`define TH 8'd10

module hc(
input wire clk,
input wire rst,
input wire [7:0] ts1, ts2,
output wire out
);

parameter s_1g2 = 2'd0, s_idle = 2'd1; // s_idle is that same as s_2ge1
reg state, next_state;

// OUTPUT COMBINATIONAL LOGIC
assign out = (state == s_1g2); // If ts1 is greater than ts2 then output high.

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
	if(rst) state = s_idle;
	else state = next_state;
end

// NEXT STATE COMBINATIONAL LOGIC
always@(ts1 or ts2 or state)
begin
	case(state)
		s_1g2 : if(ts1 < (ts2 - `TH)) next_state = s_idle;
		default: // s_2ge1:
		begin
			if(ts2 < (ts1 - `TH)) next_state = s_1g2;
			else next_state = s_idle;
		end
	endcase
			
end

endmodule