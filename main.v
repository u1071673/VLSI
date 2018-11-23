
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
	output wire move_west
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
wire rx;
wire tx;
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

uart uart_module(
	.clk(uart_clk)
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


// GEOTHERMAL MODULES
hc hc_solarheater(
	.clk(clk),
	.rst(rst),
	.ts1(solar_celcius),
	.ts2(greenhouse_celcius),
	.out(solar_g_greenhouse_temp)
	);

temp_control temp_control_geothermal(
	.clk(clk),
	.rst(rst),
	.cooldown_th(solar_cooldown_th),
	.heatup_th(solar_heatup_th),
	.greenhouse_temp(solar_celcius),
	.temp_g_greenhouse_temp(solar_g_greenhouse_temp),
	.out(solarheater_on)
	);


endmodule // main
