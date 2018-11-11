
module i2c (
input wire clk,
input wire rst,
input reg [6:0] addr, /* Set this to the address of the slave. */
input reg [6:0] data, /* Set this to the data we want to send to the slave */
output sda,
output scl
);

parameter [7:0] STATE_IDLE = 8'd0, STATE_START = 8'd1, STATE_ADDR = 8'd2, STATE_RW = 8'd3, STATE_WACK1 = 8'd4, STATE_DATA = 8'd5, STATE_WACK2 = 8'd6, STATE_STOP = 8'd7;

reg [7:0] state, next_state, count, next_count;

// OUTPUT COMBINATIONAL LOGIC
assign sda = (state == STATE_IDLE)   || /* Set sda high when in STATE_IDLE */
  (state == STATE_START)  || /* Set sda high when in STATE_START */
  (state == STATE_RW)     || /* Set sda high when in STATE_RW */
  (state == STATE_STOP)   || /* Set sda high when in STATE_STOP */
  (
  (state == STATE_ADDR) ? addr[count] : /* When in STATE_ADDR set sda to addr[count] */
  (state == STATE_DATA) ? data[count] : /* When in STATE_DATA set sda to data[count] */
  1'd0 /* Set sda low when none of the conditions above are met */
  );

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
	if(rst)
  begin
    state = STATE_IDLE;
    count = 0;
  end
	else
  begin
    state = next_state;
    count = next_count;
  end
end

// NEXT STATE COMBINATIONAL LOGIC
always@(state)
begin
	case(state)
		STATE_IDLE:
		begin
			next_state = STATE_START;
		end

    STATE_START:
		begin
			next_state = STATE_ADDR;
      next_count = 6;
		end

    STATE_ADDR:
    begin
      if(count == 0) next_state = STATE_WACK1;
      else next_count = count - 1;
    end

    STATE_RW:
    begin
      state = STATE_WACK1;
    end

    STATE_WACK1:
    begin
      state = STATE_DATA;
      next_count = 7;
    end

    STATE_DATA:
    begin
      if(count == 0) next_state = STATE_WACK2;
      else next_count = count - 1;
    end

    STATE_WACK2:
    begin
      next_state = STATE_STOP;
    end

    STATE_STOP:
    begin
      next_state = STATE_IDLE;
    end
	endcase

end

endmodule
