
module seven_segment_controller (
	input clk,
	input rst,
	input signed [7:0] binary, /* Value to display on all segments */
	output seg0_en,
	output seg1_en,
	output seg2_en,
	output seg3_en,
	output a_out,
	output b_out,
	output c_out,
	output d_out,
	output e_out,
	output f_out,
	output g_out
	);

localparam [2:0] STATE_DIGIT1_EN = 4'd0, STATE_DIGIT2_EN = 4'd1, STATE_DIGIT3_EN = 4'd2, STATE_DIGIT4_EN = 4'd3;

reg [19:0] count_refresh; 
reg [3:0] latched_bcd, next_bcd;

reg latched_anode0_en, next_anode0_en;
reg latched_anode1_en, next_anode1_en;
reg latched_anode2_en, next_anode2_en;
reg latched_anode3_en, next_anode3_en;

wire [3:0] bcd_to_display, hundreds, tens, ones;
wire [1:0] state;
wire a_out;
wire b_out;
wire c_out;
wire d_out;
wire e_out;
wire f_out;
wire g_out;
wire sign;
wire bcd_ready;


assign seg0 = latched_anode0_en;
assign seg1 = latched_anode1_en;
assign seg2 = latched_anode2_en;
assign seg3 = latched_anode3_en;

assign bcd_to_display = latched_bcd;

// Accounting for negative signed numbers
assign a_out = (state == STATE_DIGIT1_EN) 1'b0 ? a;
assign b_out = (state == STATE_DIGIT1_EN) 1'b0 ? b;
assign c_out = (state == STATE_DIGIT1_EN) 1'b0 ? c;
assign d_out = (state == STATE_DIGIT1_EN) 1'b0 ? d;
assign e_out = (state == STATE_DIGIT1_EN) 1'b0 ? e;
assign f_out = (state == STATE_DIGIT1_EN) 1'b0 ? f;
assign g_out = (state == STATE_DIGIT1_EN) sign ? g;

bcd #(.N(8)) uut(
	.clk(clk),
	.rst(rst),
	.binary(binary),
	.sign(sign),
	.hundreds(hundreds),
	.tens(tens),
	.ones(ones),
	.data_ready(bcd_ready)
	);

seven_segment sev_seg(
	.binary(bcd_to_display),
	.a(a),
	.b(b),
	.c(c),
	.d(d),
	.e(e),
	.f(f),
	.g(g)
	);


// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk or posedge rst)
begin
	if(rst) initialized <= 1'd0;
	else if(initialized)
	begin
		state <= next_state;
		count <= next_count;
		latched_anode0_en <= next_anode0_en;
		latched_anode1_en <= next_anode1_en;
		latched_anode2_en <= next_anode2_en;
		latched_anode3_en <= next_anode3_en;
		latched_bcd <= next_bcd;
		count_refresh <= count_refresh + 20'd1; // Rolls over.
	end
	else 
	begin
		state <= STATE_anode_1;
		count <= 5'd0;
		latched_anode0_en <= 1'b1;
		latched_anode1_en <= 1'b1;
		latched_anode2_en <= 1'b1;
		latched_anode3_en <= 1'b1;
		latched_bcd <= 4'b0;
		count_refresh <= 20'd0;
		initialized <= 1'd1;
	end
end

// NEXT STATE COMBINATIONAL LOGIC
always@(state or count_refresh)
begin
	case (state)
		next_state = count_refresh[19:18];
		next_anode0_en = 1'b1;
		next_anode1_en = 1'b1;
		next_anode2_en = 1'b1;
		next_anode3_en = 1'b1;
		STATE_DIGIT1_EN:
		begin
			next_anode4_en = 1'b0; 
			// no bcd used for sign.
		end
		STATE_DIGIT2_EN:
		begin
			next_anode3_en = 1'b0;
			next_bcd = hundreds;
		end
		STATE_DIGIT3_EN:
		begin
			next_anode2_en = 1'b0;
			next_bcd = tens;
		end
		STATE_DIGIT4_EN:
		begin
			next_anode1_en = 1'b0;
			next_bcd = ones;
		end
	
		default : /* default */;
	endcase
end
endmodule