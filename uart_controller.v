
module uart_controller(
	input wire clk,
	input wire rst,
	input wire rx,
	output wire [15:0] solar_th,
	output wire [7:0] solar_cooldown_th,
	output wire [7:0] solar_heatup_th,
	output wire [7:0] greenhouse_cooldown_th,
	output wire [7:0] greenhouse_heatup_th,
	output wire [7:0] ambient_cooldown_th,
	output wire [7:0] ambient_heatup_th,
	output wire [7:0] geothermal_cooldown_th,
	output wire [7:0] geothermal_heatup_th,
	output wire tx
	);

localparam [7:0] STATE_IDLE = 8'd0, STATE_INCREMENT = "w", STATE_DECREMENT = "s";
localparam [7:0] SOLAR_MODE = "A", SOLAR_COOLDOWN_MODE = "B", SOLAR_HEATUP_MODE = "C", GREENHOUSE_COOLDOWN_MODE = "D", GREENHOUSE_HEATUP_MODE = "E", AMBIENT_COOLDOWN_MODE = "F", AMBIENT_HEATUP_MODE = "G", GEOTHERMAL_COOLDOWN_MODE = "H", GEOTHERMAL_HEATUP_MODE = "I";

reg [15:0] actual_solar_th, next_actual_solar_th; /* set this to a value between 50 - 5000 (default is 2550, jump in increments of 50) */
reg [7:0] actual_solar_cooldown_th, next_actual_solar_cooldown_th; /* set only to value between 32 - 50 (default 35) */
reg [7:0] actual_solar_heatup_th, next_actual_solar_heatup_th; /* set only to value between -12 - 27  (default 16) */
reg [7:0] actual_greenhouse_cooldown_th, next_actual_greenhouse_cooldown_th; /* set only to value between 32 - 50 (default 35) */
reg [7:0] actual_greenhouse_heatup_th, next_actual_greenhouse_heatup_th; /* set only to value between -12 - 27  (default 16) */
reg [7:0] actual_ambient_cooldown_th, next_actual_ambient_cooldown_th; /* set only to value between 32 - 50 (default 35) */
reg [7:0] actual_ambient_heatup_th, next_actual_ambient_heatup_th; /* set only to value between -12 - 27  (default 16) */
reg [7:0] actual_geothermal_cooldown_th, next_actual_geothermal_cooldown_th; /* set only to value between 32 - 50 (default 35) */
reg [7:0] actual_geothermal_heatup_th, next_actual_geothermal_heatup_th; /* set only to value between -12 - 27  (default 16) */
reg [7:0] latched_data_tx, next_data_tx;
reg [3:0] state, next_state, mode, next_mode;
reg initialized, latched_start_tx, next_start_tx;

assign solar_th = actual_solar_th;
assign solar_cooldown_th = actual_solar_cooldown_th;
assign solar_heatup_th = actual_solar_heatup_th;
assign greenhouse_cooldown_th = actual_greenhouse_cooldown_th;
assign greenhouse_heatup_th = actual_greenhouse_heatup_th;
assign ambient_cooldown_th = actual_ambient_cooldown_th;
assign ambient_heatup_th = actual_ambient_heatup_th;
assign geothermal_cooldown_th = actual_geothermal_cooldown_th;
assign geothermal_heatup_th = actual_geothermal_heatup_th;
assign start_tx = latched_start_tx;
assign data_tx = latched_data_tx;

uart uart_module(
	.data_tx(data_tx),
	.clk(clk),
	.rst(rst),
	.rx(rx),
	.start_tx(start_tx),
	.data_rx(data_rx),
	.tx(tx),
	.idle_ready_tx(idle_ready_tx),
	.data_ready_rx(data_ready_rx)
	);

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
	if(rst) initialized <= 1'd0;
	else if (initialized)
	begin
		state <= next_state;
		mode <= next_mode;
		latched_start_tx <= next_start_tx;
		latched_data_tx <= next_data_tx;
		actual_solar_th <= next_actual_solar_th;
		actual_solar_cooldown_th <= next_actual_solar_cooldown_th;
		actual_solar_heatup_th <= next_actual_solar_heatup_th;
		actual_greenhouse_cooldown_th <= next_actual_greenhouse_cooldown_th;
		actual_greenhouse_heatup_th <= next_actual_greenhouse_heatup_th;
		actual_ambient_cooldown_th <= next_actual_ambient_cooldown_th;
		actual_ambient_heatup_th <= next_actual_ambient_heatup_th;
		actual_geothermal_cooldown_th <= next_actual_geothermal_cooldown_th;
		actual_geothermal_heatup_th <= next_actual_geothermal_heatup_th;
	end
  	else // initialize
  	begin
  		state <= STATE_IDLE;
  		mode <= SOLAR_MODE;
  		actual_solar_th <= 16'd2550;
  		actual_solar_cooldown_th <= 8'd35;
  		actual_solar_heatup_th <= 8'd16;
  		actual_greenhouse_cooldown_th <= 8'd35;
  		actual_greenhouse_heatup_th <= 8'd16;
  		actual_ambient_cooldown_th <= 8'd35;
  		actual_ambient_heatup_th <= 8'd16;
  		actual_geothermal_cooldown_th <= 8'd35;
  		actual_geothermal_heatup_th <= 8'd16;
  		initialized <= 1'd1;
  	end
  end

// NEXT STATE COMBINATIONAL LOGIC (Only set 'next_' wires)
always@(state or mode or idle_ready_tx or data_ready_rx or data_rx or actual_solar_th or actual_solar_cooldown_th or actual_solar_heatup_th or actual_greenhouse_cooldown_th or actual_greenhouse_heatup_th or actual_ambient_cooldown_th or actual_ambient_heatup_th or actual_geothermal_cooldown_th or actual_geothermal_heatup_th)
begin
	next_data_tx = 8'd0;
	next_start_tx = 1'd0;
	next_actual_solar_th = actual_solar_th;
	next_actual_solar_cooldown_th = actual_solar_cooldown_th;
	next_actual_solar_heatup_th = actual_solar_heatup_th;
	next_actual_greenhouse_cooldown_th = actual_greenhouse_cooldown_th;
	next_actual_greenhouse_heatup_th = actual_greenhouse_heatup_th;
	next_actual_ambient_cooldown_th = actual_ambient_cooldown_th;
	next_actual_ambient_heatup_th = actual_ambient_heatup_th;
	next_actual_geothermal_cooldown_th = actual_geothermal_cooldown_th;
	next_actual_geothermal_heatup_th = actual_geothermal_heatup_th;
	case(state)
		STATE_IDLE:
		begin

			if(data_ready_rx && (data_rx == STATE_INCREMENT || data_rx == STATE_DECREMENT))
			begin
				if(idle_ready_tx)
				begin
					next_start_tx = 1'd1;
					next_data_tx = data_rx;
				end
				next_state = data_rx;
			end
			else 
			begin
				next_state = state;
			end
			if(data_ready_rx && (data_rx == SOLAR_MODE || data_rx == SOLAR_COOLDOWN_MODE || data_rx == SOLAR_HEATUP_MODE || data_rx == GREENHOUSE_COOLDOWN_MODE || data_rx == GREENHOUSE_HEATUP_MODE || data_rx == AMBIENT_COOLDOWN_MODE || data_rx == AMBIENT_HEATUP_MODE || data_rx == GEOTHERMAL_COOLDOWN_MODE || data_rx == GEOTHERMAL_HEATUP_MODE))
			begin
				if(idle_ready_tx)
				begin
					next_start_tx = 1'd1;
					next_data_tx = data_rx;
				end
				next_mode = data_rx;
			end
			else 
			begin 
				next_mode = mode;
			end

		end
		STATE_INCREMENT:
		begin
			next_state = STATE_IDLE;
			case(mode)
				SOLAR_MODE: if(actual_solar_th < 16'd5000) next_actual_solar_th = actual_solar_th + 16'd50;
				SOLAR_COOLDOWN_MODE: if(actual_solar_cooldown_th < 8'd50) next_actual_solar_cooldown_th = actual_solar_cooldown_th + 16'd1;
				SOLAR_HEATUP_MODE: if(actual_solar_heatup_th < 8'd27) next_actual_solar_heatup_th = actual_solar_heatup_th + 16'd1;
				GREENHOUSE_COOLDOWN_MODE: if(actual_greenhouse_cooldown_th < 8'd50) next_actual_greenhouse_cooldown_th = actual_greenhouse_cooldown_th + 16'd1;
				GREENHOUSE_HEATUP_MODE: if(actual_greenhouse_heatup_th < 8'd27) next_actual_greenhouse_heatup_th = actual_greenhouse_heatup_th + 16'd1;
				AMBIENT_COOLDOWN_MODE: if(actual_ambient_cooldown_th < 8'd50) next_actual_ambient_cooldown_th =actual_ambient_cooldown_th + 16'd1;
				AMBIENT_HEATUP_MODE: if(actual_ambient_heatup_th < 8'd27) next_actual_ambient_heatup_th = actual_ambient_heatup_th + 16'd1;
				GEOTHERMAL_COOLDOWN_MODE: if(actual_geothermal_cooldown_th < 8'd50) next_actual_geothermal_cooldown_th = actual_geothermal_cooldown_th + 16'd1;
				GEOTHERMAL_HEATUP_MODE: if(actual_geothermal_heatup_th < 8'd27) next_actual_geothermal_heatup_th = actual_geothermal_heatup_th + 16'd1;
			endcase
		end
		STATE_DECREMENT:
		begin
			next_state = STATE_IDLE;
			case(mode)
				SOLAR_MODE: if(actual_solar_th > 16'd50) next_actual_solar_th = actual_solar_th - 16'd50;
				SOLAR_COOLDOWN_MODE: if(actual_solar_cooldown_th > 8'd32) next_actual_solar_cooldown_th = actual_solar_cooldown_th - 16'd1;
				SOLAR_HEATUP_MODE: if(actual_solar_heatup_th > -8'd12) next_actual_solar_heatup_th = actual_solar_heatup_th - 16'd1;
				GREENHOUSE_COOLDOWN_MODE: if(actual_greenhouse_cooldown_th > 8'd32) next_actual_greenhouse_cooldown_th = actual_greenhouse_cooldown_th - 16'd1;
				GREENHOUSE_HEATUP_MODE: if(actual_greenhouse_heatup_th > -8'd12) next_actual_greenhouse_heatup_th = actual_greenhouse_heatup_th - 16'd1;
				AMBIENT_COOLDOWN_MODE: if(actual_ambient_cooldown_th > 8'd32) next_actual_ambient_cooldown_th = actual_ambient_cooldown_th - 16'd1;
				AMBIENT_HEATUP_MODE: if(actual_ambient_heatup_th > -8'd12) next_actual_ambient_heatup_th = actual_ambient_heatup_th - 16'd1;
				GEOTHERMAL_COOLDOWN_MODE: if(actual_geothermal_cooldown_th > 8'd32) next_actual_geothermal_cooldown_th = actual_geothermal_cooldown_th - 16'd1;
				GEOTHERMAL_HEATUP_MODE: if(actual_geothermal_heatup_th > -8'd12) next_actual_geothermal_heatup_th = actual_geothermal_heatup_th - 16'd1;
			endcase
		end
		default:
		begin
			next_state = STATE_IDLE;
		end
	endcase
end
endmodule