
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

i2c_control i2c_control_module(

);


i2c_clock_divider i2c_clock_divider_module(

);


uart uart_module(

);

uart_clock_divider uart_clock_divider_module(

);


temp_control temp_control_module(

);

solar solar_module(

);

hc hc_module(

);

endmodule // main
