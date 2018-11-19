// TODO: Change Threshold values from degrees to a 0-255 value.
`define HOT_TO_IDLE_TH 85
`define IDLE_TO_HOT_TH 90
`define IDLE_TO_COLD_TH 70
`define COLD_TO_IDLE_TH 75

module temp_control (
input wire [7:0] HOT_TO_IDLE_TH,
input wire [7:0] IDLE_TO_HOT_TH,
input wire [7:0] IDLE_TO_COLD_TH,
input wire [7:0] COLD_TO_IDLE_TH,
input wire clk,
input wire rst,
input wire [7:0] gt,
input wire t_g_gt,
output wire out
);

localparam [1:0] STATE_IDLE = 2'd0, STATE_HOT = 2'd1, STATE_COLD = 2'd2;
reg [1:0] state, next_state;

// OUTPUT COMBINATIONAL LOGIC
assign out = (state == STATE_HOT && gt > HOT_TO_IDLE_TH && (!t_g_gt)) || (state == STATE_COLD && gt < COLD_TO_IDLE_TH && t_g_gt);

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
	if(rst) state = STATE_IDLE;
	else state = next_state;
end

// NEXT STATE COMBINATIONAL LOGIC
always@(gt or state)
begin
	case(state)
		STATE_IDLE:
		begin
			if(gt >= IDLE_TO_HOT_TH) next_state = STATE_HOT;
			else if (gt <= IDLE_TO_COLD_TH) next_state = STATE_COLD;
			else next_state = STATE_IDLE;
		end
		STATE_HOT: if(gt <= HOT_TO_IDLE_TH) next_state = STATE_IDLE;
		STATE_COLD: if(gt >= COLD_TO_IDLE_TH) next_state = STATE_IDLE;
		default:
		begin
			// TODO: Figure out what to do for default case.
		end
	endcase

end

endmodule
