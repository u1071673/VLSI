
module main_top (
	input wire clk,
	input wire rst,
	input wire rx,
	inout wire scl,
	inout wire sda,
	output wire tx,
	output wire window_open,
	output wire fan_on,
	output wire geothermal_on,
	output wire solarheater_on,
	output wire move_north,
	output wire move_east,
	output wire move_south,
	output wire move_west,
	output wire solar_anode0_en,
	output wire solar_anode1_en,
	output wire solar_anode2_en,
	output wire solar_anode3_en,
	output wire greenhouse_anode0_en,
	output wire greenhouse_anode1_en,
	output wire greenhouse_anode2_en,
	output wire greenhouse_anode3_en,
	output wire geothermal_anode0_en,
	output wire geothermal_anode1_en,
	output wire geothermal_anode2_en,
	output wire geothermal_anode3_en,
	output wire solar_a_out,
	output wire solar_b_out,
	output wire solar_c_out,
	output wire solar_d_out,
	output wire solar_e_out,
	output wire solar_f_out,
	output wire solar_g_out,
	output wire greehouse_a_out,
	output wire greehouse_b_out,
	output wire greehouse_c_out,
	output wire greehouse_d_out,
	output wire greehouse_e_out,
	output wire greehouse_f_out,
	output wire greehouse_g_out,
	output wire geothermal_a_out,
	output wire geothermal_b_out,
	output wire geothermal_c_out,
	output wire geothermal_d_out,
	output wire geothermal_e_out,
	output wire geothermal_f_out,
	output wire geothermal_g_out
	);

wire sda_en;
wire scl_en;

assign sda_en = sda_out_pad == 1'd0;
assign scl_en = scl_out_pad == 1'd0;

// PWR and GND
pad_vdd pad_vdd0();
pad_gnd pad_gnd0();
pad_vdd pad_vdd_i2c_pullup();
// INPUTS
pad_in pad_in0(.pad(clk), .DataIn(clk_pad));
pad_in pad_in1(.pad(rst), .DataIn(rst_pad));
pad_in pad_in2(.pad(rx), .DataIn(rx_pad));
// INOUT
pad_bidirhe_buffered pad_inout0(.en(sda_en), .out(sda_out_pad), .in(sda_in_pad), .pad(sda));
pad_bidirhe_buffered pad_inout1(.en(scl_en), .out(scl_out_pad), .in(scl_in_pad), .pad(scl));
// OUTPUTS
pad_out_buffered pad_out0(.pad(tx), .out(tx_pad));
pad_out_buffered pad_out1(.pad(window_open), .out(window_open_pad));
pad_out_buffered pad_out2(.pad(fan_on), .out(fan_on_pad));
pad_out_buffered pad_out3(.pad(geothermal_on), .out(geothermal_on_pad));
pad_out_buffered pad_out4(.pad(solarheater_on), .out(solarheater_on_pad));
pad_out_buffered pad_out5(.pad(move_north), .out(move_north_pad));
pad_out_buffered pad_out6(.pad(move_east), .out(move_east_pad));
pad_out_buffered pad_out7(.pad(move_south), .out(move_south_pad));
pad_out_buffered pad_out8(.pad(move_west), .out(move_west_pad));
pad_out_buffered pad_out9(.pad(solar_anode0_en), .out(solar_anode0_en_pad));
pad_out_buffered pad_out10(.pad(solar_anode1_en), .out(solar_anode1_en_pad));
pad_out_buffered pad_out11(.pad(solar_anode2_en), .out(solar_anode2_en_pad));
pad_out_buffered pad_out12(.pad(solar_anode3_en), .out(solar_anode3_en_pad));
pad_out_buffered pad_out13(.pad(greenhouse_anode0_en), .out(greenhouse_anode0_en_pad));
pad_out_buffered pad_out14(.pad(greenhouse_anode1_en), .out(greenhouse_anode1_en_pad));
pad_out_buffered pad_out15(.pad(greenhouse_anode2_en), .out(greenhouse_anode2_en_pad));
pad_out_buffered pad_out16(.pad(greenhouse_anode3_en), .out(greenhouse_anode3_en_pad));
pad_out_buffered pad_out21(.pad(geothermal_anode0_en), .out(geothermal_anode0_en_pad));
pad_out_buffered pad_out22(.pad(geothermal_anode1_en), .out(geothermal_anode1_en_pad));
pad_out_buffered pad_out23(.pad(geothermal_anode2_en), .out(geothermal_anode2_en_pad));
pad_out_buffered pad_out24(.pad(geothermal_anode3_en), .out(geothermal_anode3_en_pad));
pad_out_buffered pad_out25(.pad(solar_a_out), .out(solar_a_out_pad));
pad_out_buffered pad_out26(.pad(solar_b_out), .out(solar_b_out_pad));
pad_out_buffered pad_out27(.pad(solar_c_out), .out(solar_c_out_pad));
pad_out_buffered pad_out28(.pad(solar_d_out), .out(solar_d_out_pad));
pad_out_buffered pad_out29(.pad(solar_e_out), .out(solar_e_out_pad));
pad_out_buffered pad_out30(.pad(solar_f_out), .out(solar_f_out_pad));
pad_out_buffered pad_out31(.pad(solar_g_out), .out(solar_g_out_pad));
pad_out_buffered pad_out32(.pad(greehouse_a_out), .out(greehouse_a_out_pad));
pad_out_buffered pad_out33(.pad(greehouse_b_out), .out(greehouse_b_out_pad));
pad_out_buffered pad_out34(.pad(greehouse_c_out), .out(greehouse_c_out_pad));
pad_out_buffered pad_out35(.pad(greehouse_d_out), .out(greehouse_d_out_pad));
pad_out_buffered pad_out36(.pad(greehouse_e_out), .out(greehouse_e_out_pad));
pad_out_buffered pad_out37(.pad(greehouse_f_out), .out(greehouse_f_out_pad));
pad_out_buffered pad_out38(.pad(greehouse_g_out), .out(greehouse_g_out_pad));
pad_out_buffered pad_out46(.pad(geothermal_a_out), .out(geothermal_a_out_pad));
pad_out_buffered pad_out47(.pad(geothermal_b_out), .out(geothermal_b_out_pad));
pad_out_buffered pad_out48(.pad(geothermal_c_out), .out(geothermal_c_out_pad));
pad_out_buffered pad_out49(.pad(geothermal_d_out), .out(geothermal_d_out_pad));
pad_out_buffered pad_out50(.pad(geothermal_e_out), .out(geothermal_e_out_pad));
pad_out_buffered pad_out51(.pad(geothermal_f_out), .out(geothermal_f_out_pad));
pad_out_buffered pad_out52(.pad(geothermal_g_out), .out(geothermal_g_out_pad));
// PAD CORNERS
pad_corner corner0 ();
pad_corner corner1 ();
pad_corner corner2 ();
pad_corner corner3 ();

// INSTANCE OF MAIN
main main_dut(
	.clk(clk_pad),
	.rst(rst_pad),
	.rx(rx_pad),
	.sda_in(sda_in_pad),
	.scl_in(scl_in_pad),
	.sda_out(sda_out_pad),
	.scl_out(scl_out_pad),
	.tx(tx_pad),
	.window_open(window_open_pad),
	.fan_on(fan_on_pad),
	.geothermal_on(geothermal_on_pad),
	.solarheater_on(solarheater_on_pad),
	.move_north(move_north_pad),
	.move_east(move_east_pad),
	.move_south(move_south_pad),
	.move_west(move_west_pad),
	.solar_anode0_en(solar_anode0_en_pad),
	.solar_anode1_en(solar_anode1_en_pad),
	.solar_anode2_en(solar_anode2_en_pad),
	.solar_anode3_en(solar_anode3_en_pad),
	.greenhouse_anode0_en(greenhouse_anode0_en_pad),
	.greenhouse_anode1_en(greenhouse_anode1_en_pad),
	.greenhouse_anode2_en(greenhouse_anode2_en_pad),
	.greenhouse_anode3_en(greenhouse_anode3_en_pad),
	.geothermal_anode0_en(geothermal_anode0_en_pad),
	.geothermal_anode1_en(geothermal_anode1_en_pad),
	.geothermal_anode2_en(geothermal_anode2_en_pad),
	.geothermal_anode3_en(geothermal_anode3_en_pad),
	.solar_a_out(solar_a_out_pad),
	.solar_b_out(solar_b_out_pad),
	.solar_c_out(solar_c_out_pad),
	.solar_d_out(solar_d_out_pad),
	.solar_e_out(solar_e_out_pad),
	.solar_f_out(solar_f_out_pad),
	.solar_g_out(solar_g_out_pad),
	.greehouse_a_out(greehouse_a_out_pad),
	.greehouse_b_out(greehouse_b_out_pad),
	.greehouse_c_out(greehouse_c_out_pad),
	.greehouse_d_out(greehouse_d_out_pad),
	.greehouse_e_out(greehouse_e_out_pad),
	.greehouse_f_out(greehouse_f_out_pad),
	.greehouse_g_out(greehouse_g_out_pad),
	.geothermal_a_out(geothermal_a_out_pad),
	.geothermal_b_out(geothermal_b_out_pad),
	.geothermal_c_out(geothermal_c_out_pad),
	.geothermal_d_out(geothermal_d_out_pad),
	.geothermal_e_out(geothermal_e_out_pad),
	.geothermal_f_out(geothermal_f_out_pad),
	.geothermal_g_out(geothermal_g_out_pad)
	); 

endmodule // main_top