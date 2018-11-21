`define TH 8'd5

module temp_control (
input wire [7:0] cooldown_th, /* set only to value between 90-120 */
input wire [7:0] heatup_th, /* set only to value between 10-80 */
input wire [7:0] greenhouse_temp,
input wire clk,
input wire rst,
input wire temp_g_greenhouse_temp,
output wire out
);

localparam [1:0] STATE_IDLE = 2'd0, STATE_COOLDOWN = 2'd1, STATE_HEATUP = 2'd2;
reg [1:0] state, next_state;
reg initialized;
wire hot_to_idle_th;
wire cold_to_idle_th;

// OUTPUT COMBINATIONAL LOGIC
assign out = (state == STATE_COOLDOWN && greenhouse_temp > hot_to_idle_th && (!temp_g_greenhouse_temp)) || (state == STATE_HEATUP && greenhouse_temp < cold_to_idle_th && temp_g_greenhouse_temp);
assign hot_to_idle_th = cooldown_th - `TH;
assign cold_to_idle_th = heatup_th + `TH;

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
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
always@(greenhouse_temp or state or cooldown_th or heatup_th or hot_to_idle_th or cold_to_idle_th)
begin
	case(state)
		STATE_IDLE:
		begin
			if(greenhouse_temp >= cooldown_th) next_state = STATE_COOLDOWN;
			else if (greenhouse_temp <= heatup_th) next_state = STATE_HEATUP;
			else next_state = STATE_IDLE;
		end
		STATE_COOLDOWN: if(greenhouse_temp <= hot_to_idle_th) next_state = STATE_IDLE;
		STATE_HEATUP: if(greenhouse_temp >= cold_to_idle_th) next_state = STATE_IDLE;
		default:
		begin
			// TODO: Figure out what to do for default case.
		end
	endcase

end

endmodule
