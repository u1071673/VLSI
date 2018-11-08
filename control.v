// TODO: Change Threshold values from degrees to a 0-255 value.
`define GE90_TH 85
`define IDLE_HIGH_TH 90
`define IDLE_LOW_TH 70
`define LE70_TH 75

module solar (clk, rst, tsgh, ts_g_tsgh, out);
input clk;
input rst;
input ts_g_tsgh;
input [7:0] tsgh;
output out;
parameter [1:0] s_ge90 = 2'd0, s_le70 = 2'd1, s_idle = 2'd2;
reg [1:0] state, next_state;

// OUTPUT COMBINATIONAL LOGIC
assign out = (state == s_ge90 && tsgh > `GE90_TH && (!ts_g_tsgh)) || (state == s_le70 && tsgh < `LE70_TH && ts_g_tsgh);

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
	if(rst) state = s_idle;
	else state = next_state;
end

// NEXT STATE COMBINATIONAL LOGIC
always@(tsgh or state)
begin
	case(state)
		s_ge90: if(tsgh <= `GE90_TH) next_state = s_idle;
		s_le70: if(tsgh >= `LE70_TH) next_state = s_idle;
		default: // s_idle:
		begin
			if(tsgh >= `IDLE_HIGH_TH) next_state = s_ge90;
			else if (tsgh <= `IDLE_LOW_TH) next_state = s_le70;
			else next_state = s_idle;
		end
	endcase
			
end

endmodule