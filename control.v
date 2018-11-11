// TODO: Change Threshold values from degrees to a 0-255 value.
`define GE90_TH 85
`define IDLE_HIGH_TH 90
`define IDLE_LOW_TH 70
`define LE70_TH 75

module control (
input wire clk,
input wire rst,
input wire [7:0] gt,
input wire t_g_gt,
output wire out
);

localparam [1:0] STATE_IDLE = 2'd0, STATE_GE90 = 2'd1, STATE_LE70 = 2'd2;
reg [1:0] state, next_state;

// OUTPUT COMBINATIONAL LOGIC
assign out = (state == STATE_GE90 && gt > `GE90_TH && (!t_g_gt)) || (state == STATE_LE70 && gt < `LE70_TH && t_g_gt);

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
			if(gt >= `IDLE_HIGH_TH) next_state = STATE_GE90;
			else if (gt <= `IDLE_LOW_TH) next_state = STATE_LE70;
			else next_state = STATE_IDLE;
		end
		STATE_GE90: if(gt <= `GE90_TH) next_state = STATE_IDLE;
		STATE_LE70: if(gt >= `LE70_TH) next_state = STATE_IDLE;
		default:
		begin
			// TODO: Figure out what to do for default case.
		end
	endcase

end

endmodule
