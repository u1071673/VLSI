module solar (clk, LSN, LSE, LSS, LSW, MN, ME, MS, MW)
input [7:0] LSN, LSE, LSS, LSW;
output MN, ME, MS, MW;
parameter [2:0] S_MN = 3'b000, S_ME = 3'b001, S_MS = 3'b010, S_MW = 3'b011;
reg [2:0] state, next_state:


// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
	if(rst) state = S_IDLE;
	else state = next_state;
end

// NEXT STATE COMBINATIONAL LOGIC
always@(LSN or LSE or LSS or LSW or state)
begin
	case(state)
		S_MN:
			
		S_ME:
		S_MS:
		S_MW:
		default:
`			if((LSN + 10) > LSS) next_state = S_MN;
			
end

// OUTPUT COMBINATIONAL LOGIC
assign MN = (state == S_MN);
assign ME = (state == S_ME);
assign MS = (state == S_MS);
assign MW = (state == S_MW);

endmodule