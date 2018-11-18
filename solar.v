`define TH 8'd10

module solar (
	input wire clk,
	input wire rst,
	input wire [7:0] lsn, lse, lss, lsw,
	output wire mn, me, ms, mw
	);

localparam [2:0] STATE_IDLE = 3'd0, STATE_MN = 3'd1, STATE_ME = 3'd2, STATE_MS = 3'd3, STATE_MW = 3'd4;
reg [2:0] state, next_state;
reg inizitalized;

// OUTPUT COMBINATIONAL LOGIC
assign mn = (state == STATE_MN);
assign me = (state == STATE_ME);
assign ms = (state == STATE_MS);
assign mw = (state == STATE_MW);


// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
	if(rst) initialized 1'd0;
	else if(initialized) state <= next_state;
	else 
	begin
		state <= STATE_IDLE;
		initialized <= 1'd1;
	end
end

// NEXT STATE COMBINATIONAL LOGIC
always@(lsn or lse or lss or lsw or state)
begin
	case(state)
		STATE_IDLE:
		begin
			if(lsn > (lss + `TH)) next_state = STATE_MN;
			else if(lse > (lsw + `TH)) next_state = STATE_ME;
			else if(lss > (lsn + `TH)) next_state = STATE_MS;
			else if(lsw > (lse + `TH)) next_state = STATE_MW;
			else next_state = STATE_IDLE;
		end
		STATE_MN: if((lsn + `TH) < lss) next_state = STATE_IDLE;
		STATE_ME: if((lse + `TH) < lsw) next_state = STATE_IDLE;
		STATE_MS: if((lss + `TH) < lsn) next_state = STATE_IDLE;
		STATE_MW: if((lsw + `TH) < lse) next_state = STATE_IDLE;
		default
		begin
			next_state = STATE_IDLE;
		end
	endcase

end

endmodule
