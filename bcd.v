
module bcd 
#(
parameter N = 8
)
(
	input wire clk,
	input wire rst,
	input wire signed [N-1:0] binary,
	output wire sign,
	output wire [3:0] hundreds,
	output wire [3:0] tens,
	output wire [3:0] ones,
	output wire data_ready
);

localparam [3:0] STATE_START = 3'd0, STATE_WORK = 3'd1, STATE_READY = 3'd2;

reg [N-1:0] latched_binary;
reg [3:0] state, next_state;
reg [4:0] count, next_count;
reg [3:0] h, next_h;
reg [3:0] t, next_t;
reg [3:0] o, next_o;
reg initialized;

wire [N-1:0] abs_binary;

assign sign = latched_binary[N-1];
assign abs_binary = sign ? ~latched_binary + {{(N-1){1'b0}},1'b1} : latched_binary; // Get absolute value of binary
assign hundreds = h;
assign tens = t;
assign ones = o;
assign data_ready = state == STATE_READY;

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk or posedge rst)
begin
	if(rst) initialized <= 1'd0;
	else if(initialized)
	begin
		state <= next_state;
		count <= next_count;
		h <= next_h;
		t <= next_t;
		o <= next_o;
		if(state == STATE_START) latched_binary <= $unsigned(binary);
	end
	else 
	begin
		state <= STATE_START;
		count <= 5'd0;
		latched_binary <= {N{1'b0}};
		h <= 4'd0;
		t <= 4'd0;
		o <= 4'd0;
		initialized <= 1'd1;
	end
end

// NEXT STATE COMBINATIONAL LOGIC
always@(state or abs_binary or latched_binary or binary or count or h or t or o)
begin
	case(state)
		STATE_START:
		begin
			next_state = STATE_WORK;
			next_count = N;
			next_h = 4'd0;
			next_t = 4'd0;
			next_o = 4'd0;
		end
		STATE_WORK:
		begin
			if(next_count == 5'd0) next_state = STATE_READY;
			else 
			begin
				next_state = STATE_WORK;
				next_count = count - 5'd1;
				if(h >= 4'd5) next_h = h + 3;
				else next_h = h;
				if(t >= 4'd5) next_t = t + 3;
				else next_t = t;
				if(o >= 4'd5) next_o = o + 3;
				else next_o = o;

				next_h = next_h << 1;
				next_h[0] = next_t[3];
				next_t = next_t << 1;
				next_t[0] = next_o[3];
				next_o = next_o << 1;
				next_o[0] = abs_binary[next_count];
			end
		end
		STATE_READY:
		begin
			if(latched_binary != $unsigned(binary)) next_state = STATE_START;
			else next_state = STATE_READY;
			next_count = 5'd0;
			next_h = h;
			next_t = t;
			next_o = o;
		end
		default:
		begin
			next_state = STATE_START;
			next_count = 5'd0;
			next_h = 4'd0;
			next_t = 4'd0;
			next_o = 4'd0;
		end
	endcase

end


endmodule // bcd