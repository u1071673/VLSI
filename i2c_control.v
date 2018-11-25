`define SOLAR_ADDR 7'b1001000
`define GREENHOUSE_ADDR 7'b1001001
`define AMBIENT_ADDR 7'b1001010
`define GEOTHERMAL_ADDR 7'b1001011
`define NORTH_ADDR 7'b1000100
`define EAST_ADDR 7'b1000101
`define SOUTH_ADDR 7'b1000110
`define WEST_ADDR 7'b1000111

module i2c_control (
	input wire clk,
	input wire rst,
	inout wire sda,
	inout wire scl,
	output wire signed [7:0] solar_celcius,
	output wire signed [7:0] greenhouse_celcius,
	output wire signed [7:0] ambient_celcius,
	output wire signed [7:0] geothermal_celcius,
	output wire [15:0] n_lux,
	output wire [15:0] e_lux,
	output wire [15:0] s_lux,
	output wire [15:0] w_lux
	);

localparam [7:0] STATE_IDLE = 8'd0, STATE_IDLE_BUFFER = 8'd1, STATE_SOLAR = 8'd2, STATE_SOLAR_BUFFER = 8'd3, STATE_GREENHOUSE = 8'd4, STATE_GREENHOUSE_BUFFER = 8'd5, STATE_AMBIENT = 8'd6, STATE_AMBIENT_BUFFER = 8'd7, STATE_GEOTHERMAL = 8'd8, STATE_GEOTHERMAL_BUFFER = 8'd9, STATE_NORTH = 8'd10, STATE_NORTH_BUFFER = 8'd11, STATE_EAST = 8'd12, STATE_EAST_BUFFER = 8'd13, STATE_SOUTH = 8'd14, STATE_SOUTH_BUFFER = 8'd15, STATE_WEST = 8'd16, STATE_WEST_BUFFER = 8'd17;

wire [15:0] read_data;
wire ready;
wire [15:0] calulated_lux;
wire [15:0] lsb_size;
wire [11:0] fractional;
wire [3:0] exponent;
wire slave_acknowledged;

reg [15:0] next_write_data;
reg [7:0] next_state;
reg [6:0] next_slave_addr;
reg next_start;
reg next_rw;
reg next_two_bytes;

reg [15:0] write_data;
reg [15:0] latched_n_lux;
reg [15:0] latched_e_lux;
reg [15:0] latched_s_lux;
reg [15:0] latched_w_lux;
reg signed [8:0] latched_solar_celcius; 
reg signed [8:0] latched_greenhouse_celcius; 
reg signed [8:0] latched_ambient_celcius; 
reg signed [8:0] latched_geothermal_celcius; 
reg [7:0] state;
reg [6:0] slave_addr;
reg start;
reg two_bytes;
reg rw;
reg initialized;

assign exponent = read_data[15:12];
assign fractional = read_data[11:0];
assign lsb_size = (16'd1 << {12'd0, exponent}) / 16'd100;
assign calulated_lux = lsb_size * {4'd0, fractional};

assign solar_celcius = $signed(latched_solar_celcius[8:1]);
assign greenhouse_celcius = $signed(latched_greenhouse_celcius[8:1]);
assign ambient_celcius = $signed(latched_ambient_celcius[8:1]);
assign geothermal_celcius = $signed(latched_geothermal_celcius[8:1]);
assign n_lux = latched_n_lux;
assign e_lux = latched_e_lux;
assign s_lux = latched_s_lux;
assign w_lux = latched_w_lux;

i2c i2c_module(
	.data(write_data), /* Set this to the write_data we want to send to the slave. If we are reading this should be 16'd0 */
	.addr(slave_addr), /* Set this to the address of the slave. */
	.clk(clk),
	.rst(rst),
	.start(start),
	.two_bytes(two_bytes), /* Set this to 1 for reading or writing two write_data bytes. 0 means only read or write one write_data byte */
	.rw(rw), /* 0 = write, 1 = read */
	.sda(sda),
	.scl(scl),
	.read_data(read_data), /* This is set to the write_data retrieved from the slave */
	.ready(ready),
	.got_acknowledge(slave_acknowledged)
	);


// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk or posedge rst)
begin
	if(rst) initialized <= 1'd0;
	else if (initialized)
	begin
		state <= next_state;
		start <= next_start;
		slave_addr <= next_slave_addr;
		rw <= next_rw;
		two_bytes <= next_two_bytes;
		write_data <= next_write_data;
		case(state)
			STATE_SOLAR:
			begin
				if(ready && slave_acknowledged) latched_solar_celcius <= $signed(read_data[15:7]);
			end
			STATE_GREENHOUSE:
			begin
				if(ready && slave_acknowledged) latched_greenhouse_celcius <=  $signed(read_data[15:7]);
			end
			STATE_AMBIENT:
			begin
				if(ready && slave_acknowledged) latched_ambient_celcius <=  $signed(read_data[15:7]);
			end
			STATE_GEOTHERMAL:
			begin
				if(ready && slave_acknowledged) latched_geothermal_celcius <=  $signed(read_data[15:7]);
			end
			STATE_NORTH:
			begin
				if(ready && slave_acknowledged) latched_n_lux <= calulated_lux;
			end
			STATE_EAST:
			begin
				if(ready && slave_acknowledged) latched_e_lux <= calulated_lux;
			end
			STATE_SOUTH:
			begin
				if(ready && slave_acknowledged) latched_s_lux <= calulated_lux;
			end
			STATE_WEST:
			begin
				if(ready && slave_acknowledged) latched_w_lux <= calulated_lux;
			end
		endcase
	end
  	else // initialize
  	begin
  		state <= STATE_IDLE;
  		write_data <= 8'd0;
  		slave_addr <= 8'd0;
  		two_bytes <= 1'd0;
  		latched_solar_celcius <= 9'sd0;
  		latched_greenhouse_celcius <= 9'sd0;
  		latched_ambient_celcius <= 9'sd0;
  		latched_geothermal_celcius <= 9'sd0;
  		latched_n_lux <= 16'd0;
  		latched_e_lux <= 16'd0;
  		latched_s_lux <= 16'd0;
  		latched_w_lux <= 16'd0;
  		rw <= 1'd0;
  		start <= 1'd0;
  		initialized <= 1'd1;
  	end
  end

// NEXT STATE COMBINATIONAL LOGIC (Only set 'next_' wires)
always@(state or ready)
begin
	next_start = 1'd0;
	next_slave_addr = 7'd0;
	next_rw = 1'd0;
	next_two_bytes = 1'd0;
	next_write_data = 8'd0; // We never write 
	next_state = STATE_IDLE;
	case(state)
		STATE_IDLE:
		begin
			if(ready)
			begin 
				next_state = STATE_IDLE_BUFFER;
				next_slave_addr = `SOLAR_ADDR;
				next_start = 1'd1;
			end
			else 
			begin
				next_state = STATE_IDLE;
			end
		next_rw = 1'd1; // Reading from device
		next_two_bytes = 1'd1;
	end
	STATE_IDLE_BUFFER:
	begin
		next_state = STATE_SOLAR;
		next_slave_addr = `SOLAR_ADDR;
	       next_rw = 1'd1; // Reading from device
	       next_two_bytes = 1'd1;
	   end
	   STATE_SOLAR:
	   begin
	   	if(ready) 
	   	begin 
	   		next_state = STATE_SOLAR_BUFFER;
	   		next_slave_addr = `GREENHOUSE_ADDR;
	   		next_start = 1'd1;
	   	end
	   	else 
	   	begin
	   		next_state = STATE_SOLAR;
	   		next_slave_addr = `SOLAR_ADDR;
	   	end
		next_rw = 1'd1; // Reading from device
		next_two_bytes = 1'd1;
	end
	STATE_SOLAR_BUFFER:
	begin
		next_state = STATE_GREENHOUSE;
		next_slave_addr = `GREENHOUSE_ADDR;
	       next_rw = 1'd1; // Reading from device
	       next_two_bytes = 1'd1;
	   end
	   STATE_GREENHOUSE:
	   begin
	   	if(ready) 
	   	begin 
	   		next_state = STATE_GREENHOUSE_BUFFER;
	   		next_slave_addr = `AMBIENT_ADDR;
	   		next_start = 1'd1;
	   	end
	   	else 
	   	begin
	   		next_state = STATE_GREENHOUSE;
	   		next_slave_addr = `GREENHOUSE_ADDR;
	   	end
		next_rw = 1'd1; // Reading from device
		next_two_bytes = 1'd1;
	end
	STATE_GREENHOUSE_BUFFER:
	begin
		next_state = STATE_AMBIENT;
		next_slave_addr = `AMBIENT_ADDR;
	       next_rw = 1'd1; // Reading from device
	       next_two_bytes = 1'd1;
	   end
	   STATE_AMBIENT:
	   begin

	   	if(ready) 
	   	begin 
	   		next_state = STATE_AMBIENT_BUFFER;
	   		next_slave_addr = `GEOTHERMAL_ADDR;
	   		next_start = 1'd1;
	   	end
	   	else
	   	begin
	   		next_state = STATE_AMBIENT;
	   		next_slave_addr = `AMBIENT_ADDR;
	   	end
		next_rw = 1'd1; // Reading from device
		next_two_bytes = 1'd1;
	end
	STATE_AMBIENT_BUFFER:
	begin
		next_state = STATE_GEOTHERMAL;
		next_slave_addr = `GEOTHERMAL_ADDR;
	       next_rw = 1'd1; // Reading from device
	       next_two_bytes = 1'd1;
	   end
	   STATE_GEOTHERMAL:
	   begin
	   	if(ready) 
	   	begin 
	   		next_state = STATE_GEOTHERMAL_BUFFER;
	   		next_slave_addr = `NORTH_ADDR;
	   		next_start = 1'd1;
	   	end
	   	else 
	   	begin 
	   		next_state = STATE_GEOTHERMAL;
	   		next_slave_addr = `GEOTHERMAL_ADDR;
	   	end
		next_rw = 1'd1; // Reading from device
		next_two_bytes = 1'd1;
	end
	STATE_GEOTHERMAL_BUFFER:
	begin
		next_state = STATE_NORTH;
		next_slave_addr = `NORTH_ADDR;
	       next_rw = 1'd1; // Reading from device
	       next_two_bytes = 1'd1;
	   end
	   STATE_NORTH:
	   begin
	   	if(ready) 
	   	begin 
	   		next_state = STATE_NORTH_BUFFER;
	   		next_slave_addr = `EAST_ADDR;
	   		next_start = 1'd1;
	   	end
	   	else 
	   	begin	
	   		next_state = STATE_NORTH;
	   		next_slave_addr = `NORTH_ADDR;
	   	end
		next_rw = 1'd1; // Reading from device
		next_two_bytes = 1'd1;
	end
	STATE_NORTH_BUFFER:
	begin
		next_state = STATE_EAST;
		next_slave_addr = `EAST_ADDR;
	       next_rw = 1'd1; // Reading from device
	       next_two_bytes = 1'd1;
	   end
	   STATE_EAST:
	   begin
	   	if(ready) 
	   	begin 
	   		next_state = STATE_EAST_BUFFER;
	   		next_slave_addr = `SOUTH_ADDR;
	   		next_start = 1'd1;
	   	end
	   	else 
	   	begin
	   		next_state = STATE_EAST;
	   		next_slave_addr = `EAST_ADDR;
	   	end
		next_rw = 1'd1; // Reading from device
		next_two_bytes = 1'd1;
	end
	STATE_EAST_BUFFER:
	begin
		next_state = STATE_SOUTH;
		next_slave_addr = `SOUTH_ADDR;
	       next_rw = 1'd1; // Reading from device
	       next_two_bytes = 1'd1;
	   end
	   STATE_SOUTH:
	   begin
	   	if(ready) 
	   	begin 
	   		next_state = STATE_SOUTH_BUFFER;
	   		next_slave_addr = `WEST_ADDR;
	   		next_start = 1'd1;
	   	end
	   	else 
	   	begin	
	   		next_state = STATE_SOUTH;
	   		next_slave_addr = `SOUTH_ADDR;
	   	end
		next_rw = 1'd1; // Reading from device
		next_two_bytes = 1'd1;
	end
	STATE_SOUTH_BUFFER:
	begin
		next_state = STATE_WEST;
		next_slave_addr = `WEST_ADDR;
	      next_rw = 1'd1; // Reading from device
	      next_two_bytes = 1'd1;
	  end
	  STATE_WEST:
	  begin

	  	if(ready) 
	  	begin 
	  		next_state = STATE_WEST_BUFFER;
	  	end
	  	else 
	  	begin	
	  		next_state = STATE_WEST;
	  		next_slave_addr = `WEST_ADDR;
	  	end 
	  end
	  STATE_WEST_BUFFER:
	  begin
	  	next_state = STATE_IDLE;
	  end
	endcase
end
endmodule 
