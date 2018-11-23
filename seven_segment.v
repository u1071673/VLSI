
module seven_segment(
	input [3:0] binary, // Maximum value = 9
	output a,
	output b,
	output c,
	output d,
	output e,
	output f,
	output g
);

wire A;
wire B;
wire C;
wire D;
wire A_BAR;
wire B_BAR;
wire C_BAR;
wire D_BAR;

assign A = binary[3];
assign B = binary[2];
assign C = binary[1];
assign D = binary[0];
assign A_BAR = ~A;
assign B_BAR = ~B;
assign C_BAR = ~C;
assign D_BAR = ~D;

assign a = A | B | (B & D) | (B_BAR & D_BAR);
assign b = B_BAR | (C_BAR & D_BAR) | (C | D);
assign c = B | C_BAR | D;
assign d = (B_BAR & D_BAR) | (C & D_BAR) | (B & C_BAR & D) | (B_BAR & C) | A;
assign e = (B_BAR & D_BAR) | (C & D_BAR);
assign f = A | (C_BAR & D_BAR) | (B & C_BAR) | (B & D_BAR);
assign g = (B_BAR & C) | (C & D_BAR) | (B & C_BAR) | (B & C_BAR) | A;

endmodule;