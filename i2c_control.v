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
	output wire [8:0] solar_celcius,
	output wire [8:0] greenhouse_celcius,
	output wire [8:0] ambient_celcius,
	output wire [8:0] geothermal_celcius,
	output wire [15:0] n_lux,
	output wire [15:0] e_lux,
	output wire [15:0] s_lux,
	output wire [15:0] w_lux
	);

localparam [7:0] STATE_IDLE = 8'd0, STATE_SOLAR = 8'd1, STATE_GREENHOUSE = 8'd2, STATE_AMBIENT = 8'd3, STATE_GEOTHERMAL = 8'd4, STATE_NORTH = 8'd5, STATE_EAST = 8'd6, STATE_SOUTH = 8'd7, STATE_WEST = 8'd7; 

wire [15:0] solar_read_data;
wire [15:0] greenhouse_read_data;
wire [15:0] ambient_read_data;
wire [15:0] geothermal_read_data;
wire [15:0] north_read_data;
wire [15:0] east_read_data;
wire [15:0] south_read_data;
wire [15:0] west_read_data;
wire [15:0] n_lsb_size;
wire [15:0] e_lsb_size;
wire [15:0] s_lsb_size;
wire [15:0] w_lsb_size;
wire [11:0] n_fractional;
wire [11:0] e_fractional;
wire [11:0] s_fractional;
wire [11:0] w_fractional;
wire [3:0] n_exponent;
wire [3:0] e_exponent;
wire [3:0] s_exponent;
wire [3:0] w_exponent;
wire solar_ready;
wire greenhouse_ready;
wire ambient_ready;
wire geothermal_ready;
wire north_ready;
wire east_ready;
wire south_ready;
wire west_ready;
wire ready;
wire sda;
wire scl;

reg [15:0] next_write_data;
reg [7:0] next_state;
reg [6:0] next_slave_addr;
reg next_solar_start;
reg next_greenhouse_start;
reg next_ambient_start;
reg next_geothermal_start;
reg next_north_start;
reg next_east_start;
reg next_south_start;
reg next_west_start;
reg next_rw;
reg next_two_bytes;

reg [15:0] write_data;
reg [15:0] latched_n_lux; 
reg [15:0] latched_e_lux; 
reg [15:0] latched_s_lux; 
reg [15:0] latched_w_lux;
reg [8:0] latched_solar_celcius; 
reg [8:0] latched_greenhouse_celcius; 
reg [8:0] latched_ambient_celcius; 
reg [8:0] latched_geothermal_celcius; 
reg [7:0] state;
reg [6:0] slave_addr;
reg solar_start;
reg greenhouse_start;
reg ambient_start;
reg geothermal_start;
reg north_start;
reg east_start;
reg south_start;
reg west_start;
reg two_bytes;
reg rw;
reg initialized;

assign ready = solar_ready && greenhouse_ready && ambient_ready && geothermal_ready && north_ready && east_ready && south_ready && west_ready;
assign n_exponent = north_read_data[15:12];
assign e_exponent = east_read_data[15:12];
assign s_exponent = south_read_data[15:12];
assign w_exponent = west_read_data[15:12];
assign n_fractional = north_read_data[11:0];
assign e_fractional = east_read_data[11:0];
assign s_fractional = south_read_data[11:0];
assign w_fractional = west_read_data[11:0];
assign n_lsb_size = (16'd1 << {12'd0, n_exponent}) / 16'd100;
assign e_lsb_size = (16'd1 << {12'd0, e_exponent}) / 16'd100;
assign s_lsb_size = (16'd1 << {12'd0, s_exponent}) / 16'd100;
assign w_lsb_size = (16'd1 << {12'd0, w_exponent}) / 16'd100;
assign calulated_n_lux = n_lsb_size * {4'd0, n_fractional};
assign calulated_e_lux = e_lsb_size * {4'd0, e_fractional};
assign calulated_s_lux = s_lsb_size * {4'd0, s_fractional};
assign calulated_w_lux = w_lsb_size * {4'd0, w_fractional};

i2c solar_ts (
	.data(write_data), /* Set this to the write_data we want to send to the slave. If we are reading this should be 16'd0 */
	.addr(slave_addr), /* Set this to the address of the slave. */
	.clk(clk),
	.rst(rst),
	.start(solar_start),
	.two_bytes(two_bytes), /* Set this to 1 for reading or writing two write_data bytes. 0 means only read or write one write_data byte */
	.rw(rw), /* 0 = write, 1 = read */
	.sda(sda),
	.scl(scl),
	.read_data(solar_read_data), /* This is set to the write_data retrieved from the slave */
	.ready(solar_ready)
	);
i2c greenhouse_ts (
	.data(write_data), /* Set this to the write_data we want to send to the slave. If we are reading this should be 16'd0 */
	.addr(slave_addr), /* Set this to the address of the slave. */
	.clk(clk),
	.rst(rst),
	.start(greenhouse_start),
	.two_bytes(two_bytes), /* Set this to 1 for reading or writing two write_data bytes. 0 means only read or write one write_data byte */
	.rw(rw), /* 0 = write, 1 = read */
	.sda(sda),
	.scl(scl),
	.read_data(greenhouse_read_data), /* This is set to the write_data retrieved from the slave */
	.ready(greenhouse_ready)
	);
i2c ambient_ts (
	.data(write_data), /* Set this to the write_data we want to send to the slave. If we are reading this should be 16'd0 */
	.addr(slave_addr), /* Set this to the address of the slave. */
	.clk(clk),
	.rst(rst),
	.start(ambient_start),
	.two_bytes(two_bytes), /* Set this to 1 for reading or writing two write_data bytes. 0 means only read or write one write_data byte */
	.rw(rw), /* 0 = write, 1 = read */
	.sda(sda),
	.scl(scl),
	.read_data(ambient_read_data), /* This is set to the write_data retrieved from the slave */
	.ready(ambient_ready)
	);
i2c geothermal_ts (
	.data(write_data), /* Set this to the write_data we want to send to the slave. If we are reading this should be 16'd0 */
	.addr(slave_addr), /* Set this to the address of the slave. */
	.clk(clk),
	.rst(rst),
	.start(geothermal_start),
	.two_bytes(two_bytes), /* Set this to 1 for reading or writing two write_data bytes. 0 means only read or write one write_data byte */
	.rw(rw), /* 0 = write, 1 = read */
	.sda(sda),
	.scl(scl),
	.read_data(geothermal_read_data), /* This is set to the write_data retrieved from the slave */
	.ready(geothermal_ready)
	);
i2c north_ts (
	.wata(write_data), /* Set this to the write_data we want to send to the slave. If we are reading this should be 16'd0 */
	.addr(slave_addr), /* Set this to the address of the slave. */
	.clk(clk),
	.rst(rst),
	.start(north_start),
	.two_bytes(two_bytes), /* Set this to 1 for reading or writing two write_data bytes. 0 means only read or write one write_data byte */
	.rw(rw), /* 0 = write, 1 = read */
	.sda(sda),
	.scl(scl),
	.read_data(north_read_data), /* This is set to the write_data retrieved from the slave */
	.ready(north_ready)
	);
i2c east_ls (
	.data(write_data), /* Set this to the write_data we want to send to the slave. If we are reading this should be 16'd0 */
	.slave_addr(slave_addr), /* Set this to the address of the slave. */
	.clk(clk),
	.rst(rst),
	.start(east_start),
	.two_bytes(two_bytes), /* Set this to 1 for reading or writing two write_data bytes. 0 means only read or write one write_data byte */
	.rw(rw), /* 0 = write, 1 = read */
	.sda(sda),
	.scl(scl),
	.read_data(east_read_data), /* This is set to the write_data retrieved from the slave */
	.ready(east_ready)
	);
i2c south_ls (
	.data(write_data), /* Set this to the write_data we want to send to the slave. If we are reading this should be 16'd0 */
	.addr(slave_addr), /* Set this to the address of the slave. */
	.clk(clk),
	.rst(rst),
	.start(south_start),
	.two_bytes(two_bytes), /* Set this to 1 for reading or writing two write_data bytes. 0 means only read or write one write_data byte */
	.rw(rw), /* 0 = write, 1 = read */
	.sda(sda),
	.scl(scl),
	.read_data(south_read_data), /* This is set to the write_data retrieved from the slave */
	.ready(south_ready)
	);
i2c west_ls (
	.data(write_data), /* Set this to the write_data we want to send to the slave. If we are reading this should be 16'd0 */
	.addr(slave_addr), /* Set this to the address of the slave. */
	.clk(clk),
	.rst(rst),
	.start(west_start),
	.two_bytes(two_bytes), /* Set this to 1 for reading or writing two write_data bytes. 0 means only read or write one write_data byte */
	.rw(rw), /* 0 = write, 1 = read */
	.sda(sda),
	.scl(scl),
	.read_data(west_read_data), /* This is set to the write_data retrieved from the slave */
	.ready(west_ready)
	);

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
	if(rst) initialized <= 1'd0;
	else if (initialized)
	begin
		state <= next_state;
		solar_start <= next_solar_start;
		greenhouse_start <= next_greenhouse_start;
		ambient_start <= next_ambient_start;
		geothermal_start <= next_geothermal_start;
		north_start <= next_north_start;
		east_start <= next_east_start;
		south_start <= next_south_start;
		west_start <= next_west_start;

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
		write_data <= 8'd0;
		slave_addr <= 8'd0;
		two_bytes <= 1'd0;
		rw <= 1'd0;
		solar_start <= 1'd0;
		greenhouse_start <= 1'd0;
		ambient_start <= 1'd0;
		geothermal_start <= 1'd0;
		north_start <= 1'd0;
		east_start <= 1'd0;
		south_start <= 1'd0;
		west_start <= 1'd0;
		initialized <= 1'd1;
	end
end

// NEXT STATE COMBINATIONAL LOGIC (Only set 'next_' wires)
always@(state or ready)
begin
	next_solar_start = 1'd0;
	next_greenhouse_start = 1'd0;
	next_ambient_start = 1'd0;
	next_geothermal_start = 1'd0;
	next_north_start = 1'd0;
	next_east_start = 1'd0;
	next_south_start = 1'd0;
	next_west_start = 1'd0;
	next_slave_addr = 7'd0;
	next_rw = 1'd0;
	next_two_bytes = 1'd0;
	next_write_data = 8'd0; // We never write

	case(state)
	STATE_IDLE:
	begin
		if(ready)
		begin 
			next_state = STATE_SOLAR;
			next_slave_addr = `SOLAR_ADDR;
			next_solar_start = 1'd1;
		end
		else 
		begin
			next_state = STATE_IDLE;
		end
		next_rw = 1'd1; // Reading from device
		next_two_bytes = 1'd1;
	end
	STATE_SOLAR:
	begin
		if(ready) 
		begin 
			next_state = STATE_GREENHOUSE;
			next_slave_addr = `GREENHOUSE_ADDR;
			next_greenhouse_start = 1'd1;
		end
		else 
		begin
			next_state = STATE_SOLAR;
			next_slave_addr = `SOLAR_ADDR;
		end
		next_rw = 1'd1; // Reading from device
		next_two_bytes = 1'd1;
	end
	STATE_GREENHOUSE:
	begin
		if(ready) 
		begin 
			next_state = STATE_AMBIENT;
			next_slave_addr = `AMBIENT_ADDR;
			next_ambient_start = 1'd1;
		end
		else 
		begin
			next_state = STATE_GREENHOUSE;
			next_slave_addr = `GREENHOUSE_ADDR;
		end
		next_rw = 1'd1; // Reading from device
		next_two_bytes = 1'd1;
	end
	STATE_AMBIENT:
	begin
		
		if(ready) 
		begin 
			next_state = STATE_GEOTHERMAL;
			next_slave_addr = `GEOTHERMAL_ADDR;
			next_geothermal_start = 1'd1;
		end
		else
		begin
			next_state = STATE_AMBIENT;
			next_slave_addr = `AMBIENT_ADDR;
		end
		next_rw = 1'd1; // Reading from device
		next_two_bytes = 1'd1;
	end
	STATE_GEOTHERMAL:
	begin
		if(ready) 
		begin 
			next_state = STATE_NORTH;
			next_slave_addr = `NORTH_ADDR;
			next_north_start = 1'd1;
		end
		else 
		begin 
			next_state = STATE_GEOTHERMAL;
			next_slave_addr = `GEOTHERMAL_ADDR;
		end
		next_rw = 1'd1; // Reading from device
		next_two_bytes = 1'd1;
	end
	STATE_NORTH:
	begin
		if(ready) 
		begin 
			next_state = STATE_EAST;
			next_slave_addr = `EAST_ADDR;
			next_east_start = 1'd1;
		end
		else 
		begin	
			next_state = STATE_NORTH;
			next_slave_addr = `NORTH_ADDR;
		end
		next_rw = 1'd1; // Reading from device
		next_two_bytes = 1'd1;
	end
	STATE_EAST:
	begin
		if(ready) 
		begin 
			next_state = STATE_SOUTH;
			next_slave_addr = `SOUTH_ADDR;
			next_south_start = 1'd1;
		end
		else 
		begin
			next_state = STATE_EAST;
			next_slave_addr = `EAST_ADDR;
		end
		next_rw = 1'd1; // Reading from device
		next_two_bytes = 1'd1;
	end
	STATE_SOUTH:
	begin
		if(ready) 
		begin 
			next_state = STATE_WEST;
			next_slave_addr = `WEST_ADDR;
			next_west_start = 1'd1;
		end
		else 
		begin	
			next_state = STATE_SOUTH;
			next_slave_addr = `SOUTH_ADDR;
		end
		next_rw = 1'd1; // Reading from device
		next_two_bytes = 1'd1;
	end
	STATE_WEST:
	begin

		if(ready) 
		begin 
			next_state = STATE_IDLE;
		end
		else 
		begin	
			next_state = STATE_WEST;
			next_slave_addr = `WEST_ADDR;
		end 
	end
	endcase
end
endmodule 