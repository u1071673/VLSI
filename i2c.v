
module i2c (
input wire clk,
input wire rst,
input wire start,
input wire [6:0] addr, /* Set this to the address of the slave. */
input wire [7:0] data, /* Set this to the data we want to send to the slave */
input wire rw, /* 0 = write, 1 = read */
inout sda,
inout scl,
output ready
);

localparam [7:0] STATE_IDLE = 8'd0, STATE_START = 8'd1, STATE_ADDR = 8'd2, STATE_RW = 8'd3, STATE_SLAVE_WACK = 8'd4, STATE_WDATA = 8'd5, STATE_RDATA = 8'd6, STATE_MASTER_WACK = 8'd7, STATE_STOP = 8'd8;
reg [7:0] state, next_state, count, next_count, latched_data;
reg [6:0] latched_addr;
reg scl_enable, next_scl_enable, sda_enable, next_sda_enable, latched_rw;

// OUTPUT COMBINATIONAL LOGIC
assign sda = sda_enable ? 1'b0 : 1'bz;
assign scl = scl_enable && clk ? 1'b0 : 1'bz;
assign ready = (state == STATE_IDLE) && !(rst);

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
  if(rst) // TODO: verify
  begin
    state = STATE_IDLE;
    count = 8'd0;
    scl_enable = 1'b0;
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
    sda_enable = next_sda_enable;
    scl_enable = next_scl_enable;
  end
end

// NEXT STATE COMBINATIONAL LOGIC (Only set 'next_' wires)
always@(state or start or count)
begin
    next_sda_enable = 1'b0;
    next_scl_enable = 1'b0;
    case(state)
    STATE_IDLE:
    begin
	if(start)
	begin
		next_state = STATE_START;
		next_sda_enable = 1'b1;
	end
        else next_state = STATE_IDLE;
    end

    STATE_START:
    begin
        next_state = STATE_ADDR;
        next_count = 8'd6;
	next_sda_enable = ~latched_addr[next_count];
      	next_scl_enable = 1'b1;
    end

    STATE_ADDR:
    begin
      if(count == 0)
      begin 
	next_state = STATE_RW;
	next_sda_enable = ~latched_rw;
      end
      else 
      begin
	next_state = STATE_ADDR;
	next_count = count - 8'd1;
        next_sda_enable = ~latched_addr[next_count]; // has to be after count - 1
      end
      next_scl_enable = 1'b1;
    end

    STATE_RW:
    begin
      next_state = STATE_SLAVE_WACK;
      next_scl_enable = 1'b1;
    end

    STATE_SLAVE_WACK: // slave pulls sda low for ack.
    begin
      if(sda) // ~ACK
      begin
         next_state = STATE_STOP;
      end
      else // ACK
      begin
         next_state = STATE_WDATA;
         next_count = 8'd7;
         next_sda_enable = ~latched_data[next_count];
      end
      next_scl_enable = 1'b1;
    end

    STATE_MASTER_WACK:
    begin
	next_state = STATE_WDATA;
	next_scl_enable = 1'b1;
	next_sda_enable = 1'b1;
    end

    STATE_WDATA:
    begin
      if(count == 0)
      begin 
	next_state = STATE_SLAVE_WACK;
      end
      else 
      begin
	next_count = count - 8'd1;
        next_sda_enable = ~latched_data[next_count];
      end
      next_scl_enable = 1'b1;
    end


    STATE_RDATA:
    begin
      if(count == 0)
      begin 
	next_state = STATE_MASTER_WACK;
      end
      else 
      begin
	next_count = count - 8'd1;
        next_sda_enable = ~latched_data[next_count];
      end
      next_scl_enable = 1'b1;
    end

    STATE_STOP:
    begin
      next_state = STATE_IDLE;
    end

    default:
    begin
       next_state = STATE_IDLE;
    end


    endcase

end

endmodule
