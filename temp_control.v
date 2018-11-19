`define TH 8'd5

module temp_control (
input wire [7:0] cooldown_th, /* set only to value between 90-120 */
input wire [7:0] heatup_th, /* set only to value between 10-80 */
input wire [7:0] geothermal,
input wire clk,
input wire rst,
input wire temp_g_geothermal,
output wire out
);

localparam [1:0] STATE_IDLE = 2'd0, STATE_COOLDOWN = 2'd1, STATE_HEATUP = 2'd2;
reg [1:0] state, next_state;
wire hot_to_idle_th;
wire cold_to_idle_th;

// OUTPUT COMBINATIONAL LOGIC
assign out = (state == STATE_COOLDOWN && geothermal > hot_to_idle_th && (!temp_g_geothermal)) || (state == STATE_HEATUP && geothermal < cold_to_idle_th && temp_g_geothermal);
assign hot_to_idle_th = cooldown_th - TH;
assign cold_to_idle_th = heatup_th + TH;

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
	if(rst) state = STATE_IDLE;
	else state = next_state;
end

// NEXT STATE COMBINATIONAL LOGIC
always@(geothermal or state or cooldown_th or heatup_th or hot_to_idle_th or cold_to_idle_th)
begin
	case(state)
		STATE_IDLE:
		begin
			if(geothermal >= cooldown_th) next_state = STATE_COOLDOWN;
			else if (geothermal <= heatup_th) next_state = STATE_HEATUP;
			else next_state = STATE_IDLE;
		end
		STATE_COOLDOWN: if(geothermal <= hot_to_idle_th) next_state = STATE_IDLE;
		STATE_HEATUP: if(geothermal >= cold_to_idle_th) next_state = STATE_IDLE;
		default:
		begin
			// TODO: Figure out what to do for default case.
		end
	endcase

end

endmodule
