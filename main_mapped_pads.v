
module pad_out_buffered (
	input out,
	output pad
);
wire out_pre, out_pre1, out_pre2, out_buf;

INVX1 inv0 (.A(out), .Z(out_pre));
INVX4 inv1 (.A(out_pre), .Z(out_pre1));
INVX16 inv2 (.A(out_pre1), .Z(out_pre2));
INVX32 inv3 (.A(out_pre2), .Z(out_buf));
pad_out pad_out0(.pad(pad), .DataOut(out_buf));

endmodule // pad_out_buffered

module pad_bidirhe_buffered (
	input out,
	output pad,
	input en,
	output in
);

wire out_pre, out_pre1, out_pre2, out_buf;

INVX1 inv0 (.A(out), .Z(out_pre));
INVX4 inv1 (.A(out_pre), .Z(out_pre1));
INVX16 inv2 (.A(out_pre1), .Z(out_pre2));
INVX32 inv3 (.A(out_pre2), .Z(out_buf));
//pad_out pad_out0(.pad(pad), .DataOut(out_buf));
pad_bidirhe pad_bidirhe0(.EN(en), .DataOut(out_buf), .DataIn(in), .pad(pad));

endmodule // pad_out_buffered