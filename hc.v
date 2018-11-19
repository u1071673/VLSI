`define TH 8'd10 // 10 Degrees celcius

module hc(
        input wire HIST_TH,
	input wire clk,
	input wire rst,
	input wire [7:0] ts1, ts2,
	output wire out
	);

localparam STATE_2GE1 = 2'd0, STATE_1G2 = 2'd1;
reg [1:0] state, next_state;


// OUTPUT COMBINATIONAL LOGIC
assign out = (state == STATE_1G2); // If ts1 is greater than ts2 then output high.

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
	if(rst) state = STATE_2GE1;
	else state = next_state;
end

// NEXT STATE COMBINATIONAL LOGIC
always@(ts1 or ts2 or state)
begin
	case(state)
		STATE_2GE1:
		begin
			if(ts1 > 8'd0 && ts2 > 8'd0)
			begin
				if(ts2 < (ts1 - HIST_TH)) next_state = STATE_1G2;
				else next_state = STATE_2GE1;
			end
		end
		STATE_1G2 : 
		if(ts1 < (ts2 - HIST_TH)) next_state = STATE_2GE1;
		default:
		next_state = STATE_2GE1;
	endcase


end

endmodule
