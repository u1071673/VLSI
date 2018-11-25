
module main(
	input wire clk,
	input wire rst,
	input wire rx,
	inout wire sda,
	inout wire scl,
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
	output wire ambient_anode0_en,
	output wire ambient_anode1_en,
	output wire ambient_anode2_en,
	output wire ambient_anode3_en,
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
	output wire ambient_a_out,
	output wire ambient_b_out,
	output wire ambient_c_out,
	output wire ambient_d_out,
	output wire ambient_e_out,
	output wire ambient_f_out,
	output wire ambient_g_out,
	output wire geothermal_a_out,
	output wire geothermal_b_out,
	output wire geothermal_c_out,
	output wire geothermal_d_out,
	output wire geothermal_e_out,
	output wire geothermal_f_out,
	output wire geothermal_g_out
	);
// To Do: Add vdd and gnd wires to chip
wire [15:0] n_lux;
wire [15:0] e_lux;
wire [15:0] s_lux;
wire [15:0] w_lux;
wire [15:0] solar_th;
wire signed [7:0] solar_cooldown_th;
wire signed [7:0] solar_heatup_th;
wire signed [7:0] ambient_cooldown_th;
wire signed [7:0] ambient_heatup_th;
wire signed [7:0] geothermal_cooldown_th;
wire signed [7:0] geothermal_heatup_th;
wire [7:0] solar_celcius;
wire [7:0] greenhouse_celcius;
wire [7:0] ambient_celcius;
wire [7:0] geothermal_celcius;
wire ambient_g_greenhouse_temp;
wire geothermal_g_greenhouse_temp;
wire solar_g_greenhouse_temp;
wire i2c_clk;
wire uart_clk;

assign window_open = fan_on;

i2c_clock_divider i2c_clock_divider_module(
	.clk_in(clk),
	.rst(rst),
	.clk_out(i2c_clk)
	);

uart_clock_divider uart_clock_divider_module(
	.clk_in(clk),
	.rst(rst),
	.clk_out(uart_clk)
	);

i2c_control i2c_control_module(
	.clk(i2c_clk),
	.rst(rst),
	.sda(sda),
	.scl(scl),
	.n_lux(n_lux),
	.e_lux(e_lux),
	.s_lux(s_lux),
	.w_lux(w_lux),
	.solar_celcius(solar_celcius),
	.greenhouse_celcius(greenhouse_celcius),
	.ambient_celcius(ambient_celcius),
	.geothermal_celcius(geothermal_celcius)
	);

solar solar_module(
	.clk(clk),
	.rst(rst),
	.th(solar_th),
	.lsn(n_lux), 
	.lse(e_lux), 
	.lss(s_lux),
	.lsw(w_lux),
	.mn(move_north), 
	.me(move_east), 
	.ms(move_south),
	.mw(move_west)
	);

uart_controller uart_module(
	.clk(uart_clk),
	.rst(rst),
	.rx(rx),
	.tx(tx),
	.solar_th(solar_th),
	.solar_cooldown_th(solar_cooldown_th),
	.solar_heatup_th(solar_heatup_th),
	.ambient_cooldown_th(ambient_cooldown_th),
	.ambient_heatup_th(ambient_heatup_th),
	.geothermal_cooldown_th(geothermal_cooldown_th),
	.geothermal_heatup_th(geothermal_heatup_th)
	);

// WINDOW MODULES
hc hc_window(
	.clk(clk),
	.rst(rst),
	.ts1(ambient_celcius),
	.ts2(greenhouse_celcius),
	.out(ambient_g_greenhouse_temp)
	);

temp_control temp_control_window(
	.clk(clk),
	.rst(rst),
	.cooldown_th(ambient_cooldown_th),
	.heatup_th(ambient_heatup_th),
	.greenhouse_temp(greenhouse_celcius),
	.temp_g_greenhouse_temp(ambient_g_greenhouse_temp),
	.out(window_open)
	);

// GEOTHERMAL MODULES
hc hc_geothermal(
	.clk(clk),
	.rst(rst),
	.ts1(geothermal_celcius),
	.ts2(greenhouse_celcius),
	.out(geothermal_g_greenhouse_temp)
	);

temp_control temp_control_geothermal(
	.clk(clk),
	.rst(rst),
	.cooldown_th(geothermal_cooldown_th),
	.heatup_th(geothermal_heatup_th),
	.greenhouse_temp(greenhouse_celcius),
	.temp_g_greenhouse_temp(geothermal_g_greenhouse_temp),
	.out(geothermal_on)
	);


// SOLARHEATER MODULES
hc hc_solarheater(
	.clk(clk),
	.rst(rst),
	.ts1(solar_celcius),
	.ts2(greenhouse_celcius),
	.out(solar_g_greenhouse_temp)
	);

temp_control temp_control_solarheater(
	.clk(clk),
	.rst(rst),
	.cooldown_th(solar_cooldown_th),
	.heatup_th(solar_heatup_th),
	.greenhouse_temp(solar_celcius),
	.temp_g_greenhouse_temp(solar_g_greenhouse_temp),
	.out(solarheater_on)
	);

// SOLAR CELCIUS SEVEN SEG
seven_segment_controller solar_sev_seg(
	.clk(clk),
	.rst(rst),
	.binary(solar_celcius), 
	.anode0_en(solar_anode0_en),
	.anode1_en(solar_anode1_en),
	.anode2_en(solar_anode2_en),
	.anode3_en(solar_anode3_en),
	.a_out(solar_a_out),
	.b_out(solar_b_out),
	.c_out(solar_c_out),
	.d_out(solar_d_out),
	.e_out(solar_e_out),
	.f_out(solar_f_out),
	.g_out(solar_g_out)
	);

// GREENHOUSE_CELCIUS SEVEN SEG
seven_segment_controller greenhouse_sev_seg(
	.clk(clk),
	.rst(rst),
	.binary(greenhouse_celcius),
	.anode0_en(greenhouse_anode0_en),
	.anode1_en(greenhouse_anode1_en),
	.anode2_en(greenhouse_anode2_en),
	.anode3_en(greenhouse_anode3_en),
	.a_out(greehouse_a_out),
	.b_out(greehouse_b_out),
	.c_out(greehouse_c_out),
	.d_out(greehouse_d_out),
	.e_out(greehouse_e_out),
	.f_out(greehouse_f_out),
	.g_out(greehouse_g_out)
	);

// AMBIENT_CELCIUS SEVEN SEG
seven_segment_controller ambient_sev_seg(
	.clk(clk),
	.rst(rst),
	.binary(ambient_celcius),
	.anode0_en(ambient_anode0_en),
	.anode1_en(ambient_anode1_en),
	.anode2_en(ambient_anode2_en),
	.anode3_en(ambient_anode3_en),
	.a_out(ambient_a_out),
	.b_out(ambient_b_out),
	.c_out(ambient_c_out),
	.d_out(ambient_d_out),
	.e_out(ambient_e_out),
	.f_out(ambient_f_out),
	.g_out(ambient_g_out)
	);

// GEOTHERMAL_CELCIUS SEVEN SEG
seven_segment_controller geothermal_sev_seg(
	.clk(clk),
	.rst(rst),
	.binary(geothermal_celcius),
	.anode0_en(geothermal_anode0_en),
	.anode1_en(geothermal_anode1_en),
	.anode2_en(geothermal_anode2_en),
	.anode3_en(geothermal_anode3_en),
	.a_out(geothermal_a_out),
	.b_out(geothermal_b_out),
	.c_out(geothermal_c_out),
	.d_out(geothermal_d_out),
	.e_out(geothermal_e_out),
	.f_out(geothermal_f_out),
	.g_out(geothermal_g_out)
	);



endmodule // main
