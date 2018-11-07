`define TH 8'd10

module solar (clk, rst, lsn, lse, lss, lsw, mn, me, ms, mw);
input clk;
input rst;
input [7:0] lsn, lse, lss, lsw;
output mn, me, ms, mw;
parameter [2:0] s_mn = 3'd0, s_me = 3'd1, s_ms = 3'd2, s_mw = 3'd3, s_idle = 3'd4;
reg [2:0] state, next_state;

// OUTPUT COMBINATIONAL LOGIC
assign mn = (state == s_mn);
assign me = (state == s_me);
assign ms = (state == s_ms);
assign mw = (state == s_mw);


// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
	if(rst) state = s_idle;
	else state = next_state;s
end

// NEXT STATE COMBINATIONAL LOGIC
always@(lsn or lse or lss or lsw or state)
begin
	case(state)
		s_mn: if((lsn + `TH) < lss) next_state = s_idle;
		s_me: if((lse + `TH) < lsw) next_state = s_idle;
		s_ms: if((lss + `TH) < lsn) next_state = s_idle;
		s_mw: if((lsw + `TH) < lse) next_state = s_idle;
		default: // s_idle:
		begin
			if(lsn > (lss + `TH)) next_state = s_mn;
			else if(lse > (lsw + `TH)) next_state = s_me;
			else if(lss > (lsn + `TH)) next_state = s_ms;
			else if(lsw > (lse + `TH)) next_state = s_mw;
			else next_state = s_idle;
		end
	endcase
			
end

endmodule