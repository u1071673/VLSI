
module i2c (
input wire clk,
input wire rst,
input wire rw, /* 0 = write, 1 = read */
input wire start,
input wire [6:0] addr, /* Set this to the address of the slave. */
input wire [7:0] data, /* Set this to the data we want to send to the slave */
inout sda,
inout scl,
output ready
);

localparam [7:0] STATE_IDLE = 8'd0, STATE_START = 8'd1, STATE_ADDR = 8'd2, STATE_RW = 8'd3, STATE_WACK1 = 8'd4, STATE_DATA = 8'd5, STATE_WACK2 = 8'd6, STATE_STOP = 8'd7;

reg [7:0] state, next_state, count, next_count, latched_addr;
reg [6:0] latched_data;
reg scl_enable, next_scl_enable, latched_rw;

// OUTPUT COMBINATIONAL LOGIC
assign sda = (state == STATE_IDLE)   || /* Set sda high when in STATE_IDLE */
  (state == STATE_STOP)   || 		/* Set sda high when in STATE_STOP */
  (
  (state == STATE_ADDR) ? latched_addr[count] : /* When in STATE_ADDR set sda to addr[count] */
  (state == STATE_RW) ? latched_rw : 		/* When in STATE_RW set sda to rw */
  (state == STATE_DATA) ? latched_data[count] : /* When in STATE_DATA set sda to data[count] */
  1'd0 /* Set sda low when none of the conditions above are met */
  );

assign scl = scl_enable ? ~clk : 1'd1;
assign ready = (state == STATE_IDLE) && !(rst);

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
  if(rst)
  begin
    state = STATE_IDLE;
    count = 8'd0;
    scl_enable = 1'd0;
  end
  else
  begin
    if(state == STATE_IDLE)
    begin
        latched_addr = addr;
	latched_data = data;
	latched_rw = rw;
    end
    state = next_state;
    count = next_count;
    scl_enable = next_scl_enable;
  end
end

// NEXT STATE COMBINATIONAL LOGIC (Only set 'next_' wires)
always@(state or start or count)
begin
  next_scl_enable = 1'd0;
    case(state)
    STATE_IDLE:
    begin
	if(start) next_state = STATE_START;
        else next_state = STATE_IDLE;
    end

    STATE_START:
    begin
        next_state = STATE_ADDR;
        next_count = 8'd6;
      	next_scl_enable = 1'd1;
    end

    STATE_ADDR:
    begin
      next_scl_enable = 1'd1;
      if(count == 0) next_state = STATE_RW;
      else next_count = count - 8'd1;
    end

    STATE_RW:
    begin
      next_scl_enable = 1'd1;
      next_state = STATE_WACK1;
    end

    STATE_WACK1:
    begin
      next_scl_enable = 1'd1;
      next_state = STATE_DATA;
      next_count = 7;
    end

    STATE_DATA:
    begin
      next_scl_enable = 1'd1;
      if(count == 0) next_state = STATE_WACK2;
      else next_count = count - 8'd1;
    end

    STATE_WACK2:
    begin
      next_scl_enable = 1'd1;
      next_state = STATE_STOP;
    end

    STATE_STOP:
    begin
      next_state = STATE_IDLE;
    end
	endcase

end

endmodule
