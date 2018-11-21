`define SOLAR_ADDR 7'b1001000
`define GREENHOUSE_ADDR 7'b1001001
`define AMBIENT_ADDR 7'b1001010
`define GEOTHERMAL_ADDR 7'b1001011
`define NORTH_ADDR 7'b1000100
`define EAST_ADDR 7'b1000101
`define SOUTH_ADDR 7'b1000110
`define WEST_ADDR 7'b1000111

module i2c_control (
	input clk,
	input rst,
	output [7:0] solar_celcius,
	output [7:0] greenhouse_celcius,
	output [7:0] ambient_celcius,
	output [7:0] geothermal_celcius,
	output [7:0] n_lux,
	output [7:0] e_lux,
	output [7:0] s_lux,
	output [7:0] w_lux
	);

reg [7:0] STATE_IDLE = 8'd0, STATE_SOLAR = 8'd1, STATE_GREENHOUSE = 8'd2, STATE_AMBIENT = 8'd3, STATE_GEOTHERMAL = 8'd4, STATE_NORTH = 8'd5, STATE_EAST = 8'd6, STATE_SOUTH = 8'd7, STATE_WEST = 8'd7; 

wire [7:0] next_state;
wire [7:0] next_state;
wire [7:0] next_write_data;
wire [6:0] next_slave_addr;
wire next_start_solar;
wire next_start_greenhouse;
wire next_start_ambient;
wire next_start_geothermal;
wire next_start_north;
wire next_start_east;
wire next_start_south;
wire next_start_west;
wire next_initialized_solar;
wire next_initialized_greenhouse;
wire next_initialized_ambient;
wire next_initialized_geothermal;
wire next_initialized_north;
wire next_initialized_east;
wire next_initialized_south;
wire next_initialized_west;
wire ready;
wire sda;
wire scl;

reg [7:0] latched_solar_celcius; 
reg [7:0] latched_greenhouse_celcius; 
reg [7:0] latched_ambient_celcius; 
reg [7:0] latched_geothermal_celcius; 
reg [7:0] latched_n_lux; 
reg [7:0] latched_e_lux; 
reg [7:0] latched_s_lux; 
reg [7:0] latched_w_lux; 

// SOLAR REGS
reg [7:0] state;
reg [7:0] write_data;
reg [7:0] read_data;
reg [6:0] slave_addr;
reg start;
reg two_bytes;
reg rw;
reg initialized;
reg initialized_solar;
reg initialized_greenhouse;
reg initialized_ambient;
reg initialized_geothermal
reg initialized_north;
reg initialized_east;
reg initialized_south;
reg initialized_west;

i2c solar_ts (
	.write_data(write_data), /* Set this to the write_data we want to send to the slave. If we are reading this should be 16'd0 */
	.slave_addr(slave_addr), /* Set this to the address of the slave. */
	.clk(clk),
	.rst(rst),
	.start(start_solar),
	.two_bytes(two_bytes), /* Set this to 1 for reading or writing two write_data bytes. 0 means only read or write one write_data byte */
	.rw(rw), /* 0 = write, 1 = read */
	.sda(sda),
	.scl(scl),
	.read_data(read_data), /* This is set to the write_data retrieved from the slave */
	.ready(ready)
	);
i2c greenhouse_ts (
	.write_data(write_data), /* Set this to the write_data we want to send to the slave. If we are reading this should be 16'd0 */
	.slave_addr(slave_addr), /* Set this to the address of the slave. */
	.clk(clk),
	.rst(rst),
	.start(start_greenhouse),
	.two_bytes(two_bytes), /* Set this to 1 for reading or writing two write_data bytes. 0 means only read or write one write_data byte */
	.rw(rw), /* 0 = write, 1 = read */
	.sda(sda),
	.scl(scl),
	.read_data(read_data), /* This is set to the write_data retrieved from the slave */
	.ready(ready)
	);
i2c ambient_ts (
	.write_data(write_data), /* Set this to the write_data we want to send to the slave. If we are reading this should be 16'd0 */
	.slave_addr(slave_addr), /* Set this to the address of the slave. */
	.clk(clk),
	.rst(rst),
	.start(start_ambient),
	.two_bytes(two_bytes), /* Set this to 1 for reading or writing two write_data bytes. 0 means only read or write one write_data byte */
	.rw(rw), /* 0 = write, 1 = read */
	.sda(sda),
	.scl(scl),
	.read_data(read_data), /* This is set to the write_data retrieved from the slave */
	.ready(ready)
	);
i2c geothermal_ts (
	.write_data(write_data), /* Set this to the write_data we want to send to the slave. If we are reading this should be 16'd0 */
	.slave_addr(slave_addr), /* Set this to the address of the slave. */
	.clk(clk),
	.rst(rst),
	.start(start_geothermal),
	.two_bytes(two_bytes), /* Set this to 1 for reading or writing two write_data bytes. 0 means only read or write one write_data byte */
	.rw(rw), /* 0 = write, 1 = read */
	.sda(sda),
	.scl(scl),
	.read_data(read_data), /* This is set to the write_data retrieved from the slave */
	.ready(ready)
	);
i2c north_ts (
	.write_data(write_data), /* Set this to the write_data we want to send to the slave. If we are reading this should be 16'd0 */
	.slave_addr(slave_addr), /* Set this to the address of the slave. */
	.clk(clk),
	.rst(rst),
	.start(start_north),
	.two_bytes(two_bytes), /* Set this to 1 for reading or writing two write_data bytes. 0 means only read or write one write_data byte */
	.rw(rw), /* 0 = write, 1 = read */
	.sda(sda),
	.scl(scl),
	.read_data(read_data), /* This is set to the write_data retrieved from the slave */
	.ready(ready)
	);
i2c east_ls (
	.write_data(write_data), /* Set this to the write_data we want to send to the slave. If we are reading this should be 16'd0 */
	.slave_addr(slave_addr), /* Set this to the address of the slave. */
	.clk(clk),
	.rst(rst),
	.start(start_east),
	.two_bytes(two_bytes), /* Set this to 1 for reading or writing two write_data bytes. 0 means only read or write one write_data byte */
	.rw(rw), /* 0 = write, 1 = read */
	.sda(sda),
	.scl(scl),
	.read_data(read_data), /* This is set to the write_data retrieved from the slave */
	.ready(ready)
	);
i2c south_ls (
	.write_data(write_data), /* Set this to the write_data we want to send to the slave. If we are reading this should be 16'd0 */
	.slave_addr(slave_addr), /* Set this to the address of the slave. */
	.clk(clk),
	.rst(rst),
	.start(start_south),
	.two_bytes(two_bytes), /* Set this to 1 for reading or writing two write_data bytes. 0 means only read or write one write_data byte */
	.rw(rw), /* 0 = write, 1 = read */
	.sda(sda),
	.scl(scl),
	.read_data(read_data), /* This is set to the write_data retrieved from the slave */
	.ready(ready)
	);
i2c west_ls (
	.write_data(write_data), /* Set this to the write_data we want to send to the slave. If we are reading this should be 16'd0 */
	.slave_addr(slave_addr), /* Set this to the address of the slave. */
	.clk(clk),
	.rst(rst),
	.start(start_west),
	.two_bytes(two_bytes), /* Set this to 1 for reading or writing two write_data bytes. 0 means only read or write one write_data byte */
	.rw(rw), /* 0 = write, 1 = read */
	.sda(sda),
	.scl(scl),
	.read_data(read_data), /* This is set to the write_data retrieved from the slave */
	.ready(ready)
	);

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
	if(rst) initialized <= 1'd0;
	else if (initialized)
	begin
		state <= next_state;
		start_solar <= next_start_solar;
		start_greenhouse <= next_start_greenhouse;
		start_ambient <= next_start_ambient;
		start_geothermal <= next_start_geothermal;
		start_north <= next_start_north;
		start_east <= next_start_east;
		start_south <= next_start_south;
		start_west <= next_start_west;

		switch(state)
		STATE_SOLAR:
		begin
			if(ready) latched_solar_celcius <= read_data;
		end
		STATE_GREENHOUSE:
		begin
			if(ready) latched_greenhouse_celcius <= read_data;
		end
		STATE_AMBIENT:
		begin
			if(ready) latched_ambient_celcius <= read_data;
		end
		STATE_GEOTHERMAL:
		begin
			if(ready) latched_geothermal_celcius <= read_data;
		end
		STATE_NORTH:
		begin
			if(ready) latched_n_lux <= read_data;
		end
		STATE_EAST:
		begin
			if(ready) latched_e_lux <= read_data;
		end
		STATE_SOUTH:
		begin
			if(ready) latched_s_lux <= read_data;
		end
		STATE_WEST:
		begin
			if(ready) latched_w_lux <= read_data;
		end
		endcase
	end
  	else // initialize
	begin
		state <= STATE_IDLE;
		write_data <= 8'd0;
		slave_addr <= 8'd0;
		read_data <= 8'd0;
		start <= 1'd0;
		two_bytes <= 1'd0;
		rw <= 1'd0;
		start_solar <= 1'd0;
		start_greenhouse <= 1'd0;
		start_ambient <= 1'd0;
		start_geothermal <= 1'd0;
		start_north <= 1'd0;
		start_east <= 1'd0;
		start_south <= 1'd0;
		start_west <= 1'd0;
		initialized_solar <= 1'd0;
		initialized_greenhouse <= 1'd0;
		initialized_ambient <= 1'd0;
		initialized_geothermal <= 1'd0;
		initialized_north <= 1'd0;
		initialized_east <= 1'd0;
		initialized_south <= 1'd0;
		initialized_west <= 1'd0;
		initialized <= 1'd1;
	end
end

// NEXT STATE COMBINATIONAL LOGIC (Only set 'next_' wires)
always@(state or ready or initialized_solar or initialized_greenhouse or initialized_ambient or initialized_geothermal or initialized_north or initialized_east or initialized_south or initialized_west)
begin
	next_start_solar = 1'd0;
	next_start_greenhouse = 1'd0;
	next_start_ambient = 1'd0;
	next_start_geothermal = 1'd0;
	next_start_north = 1'd0;
	next_start_east = 1'd0;
	next_start_south = 1'd0;
	next_start_west = 1'd0;
	next_slave_addr = 7'd0;
	next_rw = 1'd0;
	next_two_bytes = 1'd0;
	next_data = 8'd0; // We never write

	switch(state)
	STATE_IDLE:
	begin
		if(ready)
		begin 
			next_state = STATE_SOLAR;
			next_slave_addr = `SOLAR_ADDR;
			next_start_solar = 1'd1;
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
			next_start_greenhouse = 1'd1;
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
			next_start_ambient = 1'd1;
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
			next_start_geothermal = 1'd1;
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
			next_start_north = 1'd1;
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
			next_start_east = 1'd1;
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
			next_slave_addr = `SOURTH_ADDR;
			next_start_south = 1'd1;
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
			next_start_west = 1'd1;
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