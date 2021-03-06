`define TH 8'sd5

module hc(
	input wire clk,
	input wire rst,
	input wire signed [7:0] ts1, ts2,
	output wire out
	);

localparam STATE_2GE1 = 2'd0, STATE_1G2 = 2'd1;
reg [1:0] state, next_state;
reg initialized;

// OUTPUT COMBINATIONAL LOGIC
assign out = (state == STATE_1G2); // If ts1 is greater than ts2 then output high.

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk or posedge rst)
begin
	if(rst) initialized <= 1'd0;
	else if(initialized) state <= next_state;
	else 
	begin 
		state <= STATE_2GE1; // Initialize
		initialized <= 1'd1; 
	end
	
end

// NEXT STATE COMBINATIONAL LOGIC
always@(ts1 or ts2 or state)
begin
	next_state = state;
	case(state)
		STATE_2GE1:
		begin
			if(ts2 < (ts1 - `TH)) next_state = STATE_1G2;
			else next_state = STATE_2GE1;
		end
		STATE_1G2 : 
		begin
			if(ts1 < (ts2 - `TH)) next_state = STATE_2GE1;
			else next_state = STATE_1G2;
		end
		default:
		next_state = STATE_2GE1;
	endcase

end

endmodule
