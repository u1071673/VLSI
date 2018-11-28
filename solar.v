module solar (
	input wire [15:0] th, /* set this to a value between 50 - 5000 (default is 2525, jump in increments of 50) */
	input wire clk,
	input wire rst,
	input wire [15:0] lsn, lse, lss, lsw,
	output wire mn, me, ms, mw
	);

localparam [2:0] STATE_IDLE = 3'd0, STATE_MN = 3'd1, STATE_ME = 3'd2, STATE_MS = 3'd3, STATE_MW = 3'd4;
reg [2:0] state, next_state;
reg initialized;

wire [15:0] lsn_th;
wire [15:0] lse_th;
wire [15:0] lss_th;
wire [15:0] lsw_th;

assign lsn_th = lsn + th;
assign lse_th = lse + th;
assign lss_th = lss + th;
assign lsw_th = lsw + th;

// OUTPUT COMBINATIONAL LOGIC
assign mn = (state == STATE_MN);
assign me = (state == STATE_ME);
assign ms = (state == STATE_MS);
assign mw = (state == STATE_MW);


// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk or posedge rst)
begin
	if(rst) initialized <= 1'd0;
	else if(initialized) state <= next_state;
	else 
	begin
		state <= STATE_IDLE;
		initialized <= 1'd1;
	end
end

// NEXT STATE COMBINATIONAL LOGIC
always@(lsn or lse or lss or lsw or state or lsn_th or lse_th or lss_th or lsw_th)
begin
	next_state = state;
	case(state)
		STATE_IDLE:
		begin
			if(lsn > lss_th) next_state = STATE_MN;
			else if(lse > lsw_th) next_state = STATE_ME;
			else if(lss > lsn_th) next_state = STATE_MS;
			else if(lsw > lse_th) next_state = STATE_MW;
			else next_state = STATE_IDLE;
		end
		STATE_MN: if(lsn < lss) next_state = STATE_IDLE;
		STATE_ME: if(lse < lsw) next_state = STATE_IDLE;
		STATE_MS: if(lss < lsn) next_state = STATE_IDLE;
		STATE_MW: if(lsw < lse) next_state = STATE_IDLE;
		default:
		begin
			next_state = STATE_IDLE;
		end
	endcase

end

endmodule
