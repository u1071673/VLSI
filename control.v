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

parameter [1:0] s_ge90 = 2'd0, s_le70 = 2'd1, s_idle = 2'd2;
reg [1:0] state, next_state;

// OUTPUT COMBINATIONAL LOGIC
assign out = (state == s_ge90 && gt > `GE90_TH && (!t_g_gt)) || (state == s_le70 && gt < `LE70_TH && t_g_gt);

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
	if(rst) state = s_idle;
	else state = next_state;
end

// NEXT STATE COMBINATIONAL LOGIC
always@(gt or state)
begin
	case(state)
		s_ge90: if(gt <= `GE90_TH) next_state = s_idle;
		s_le70: if(gt >= `LE70_TH) next_state = s_idle;
		default: // s_idle:
		begin
			if(gt >= `IDLE_HIGH_TH) next_state = s_ge90;
			else if (gt <= `IDLE_LOW_TH) next_state = s_le70;
			else next_state = s_idle;
		end
	endcase
			
end

endmodule