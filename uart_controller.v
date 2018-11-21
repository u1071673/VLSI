

module uart_controller(
input wire clk,
input wire rst,
output wire [15:0] solar_cooldown_th,
output wire [15:0] solar_heatup_th,
output wire [7:0] greenhouse_cooldown_th,
output wire [7:0] greenhouse_heatup_th,
output wire [7:0] ambient_cooldown_th,
output wire [7:0] ambient_heatup_th,
output wire [7:0] geothermal_cooldown_th,
output wire [7:0] geothermal_heatup_th
);

reg [15:0] latched_solar_cooldown_th;
reg [15:0] latched_solar_heatup_th;
reg [7:0] latched_greenhouse_cooldown_th;
reg [7:0] latched_greenhouse_heatup_th;
reg [7:0] latched_ambient_cooldown_th;
reg [7:0] latched_ambient_heatup_th;
reg [7:0] latched_geothermal_cooldown_th;
reg [7:0] latched_geothermal_heatup_th;

uart uart_module(
.data_tx(data_tx),
.clk(clk),
.rst(rst),
.rx(rx),
.start_tx(start_tx),
.data_rx(data_rx),
.tx(tx),
.ready_tx(ready_tx),
.ready_rx(ready_rx)
);

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
	if(rst) initialized <= 1'd0;
	else if (initialized)
	begin
		state <= next_state;
		case(state)
		STATE_SOLAR:
		begin
			if(ready) latched_solar_celcius <= solar_read_data[15:7];
		end
		STATE_GREENHOUSE:
		begin
			if(ready) latched_greenhouse_celcius <= greenhouse_read_data[15:7];
		end
		STATE_AMBIENT:
		begin
			if(ready) latched_ambient_celcius <= ambient_read_data[15:7];
		end
		STATE_GEOTHERMAL:
		begin
			if(ready) latched_geothermal_celcius <= geothermal_read_data[15:7];
		end
		STATE_NORTH:
		begin
			if(ready) latched_n_lux <= calulated_n_lux;
		end
		STATE_EAST:
		begin
			if(ready) latched_e_lux <= calulated_e_lux;
		end
		STATE_SOUTH:
		begin
			if(ready) latched_s_lux <= calulated_s_lux;
		end
		STATE_WEST:
		begin
			if(ready) latched_w_lux <= calulated_w_lux;
		end
		endcase
	end
  	else // initialize
	begin
		state <= STATE_IDLE;
		initialized <= 1'd1;
	end
end

// NEXT STATE COMBINATIONAL LOGIC (Only set 'next_' wires)
always@(state or ready)
begin

	case(state)
	endcase
end
endmodule