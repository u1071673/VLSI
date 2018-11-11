
module i2c (
input wire clk,
input wire rst,
output reg sda,
output reg scl
);

parameter [7:0] STATE_IDLE = 8'd0, STATE_START = 8'd1, STATE_ADDR = 8'd2, STATE_RW = 8'd3;

reg [7:0] state, count;
reg [6:0] addr;

// OUTPUT COMBINATIONAL LOGIC
assign sda = (state == STATE_IDLE);

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
	if(rst) state = STATE_IDLE;
	else state = next_state;
end

// NEXT STATE COMBINATIONAL LOGIC
always@(state)
begin
	case(state)

		default: // STATE_IDLE
		begin
			if(ts2 < (ts1 - `TH)) next_state = STATE_1G2;
			else next_state = STATE_IDLE;
		end
	endcase

end

endmodule
