
module i2c (
input wire clk,
input wire rst,
input wire start,
input wire [6:0] addr, /* Set this to the address of the slave. */
input wire [7:0] data, /* Set this to the data we want to send to the slave */
input wire [3:0] bytes, /* Set this to the number of byte you want to read or right */
input wire rw, /* 0 = write, 1 = read */
inout wire sda,
inout wire scl,
output wire [7:0] read_data,
output wire ready
);

localparam [7:0] STATE_IDLE = 8'd0, STATE_START = 8'd1, STATE_ADDR = 8'd2, STATE_RW = 8'd3, STATE_SLAVE_WACK = 8'd4, STATE_WDATA = 8'd5, STATE_RDATA = 8'd6, STATE_MASTER_WACK = 8'd7, STATE_STOP = 8'd8;
reg [7:0] state, next_state, count, next_count, latched_data;
reg [6:0] latched_addr;
reg [3:0] latched_bytes;
reg scl_enable, next_scl_enable, sda_enable, next_sda_enable, latched_rw;
reg initialized;
// OUTPUT COMBINATIONAL LOGIC
assign sda = sda_enable ? 1'b0 : 1'bz;
assign scl = scl_enable && clk ? 1'b0 : 1'bz;
assign ready = (state == STATE_IDLE) && !(rst);
assign read_data = latched_rw ? latched_data : 8'bxxxxxxxx;

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
  if(rst) // TODO: verify
  begin
    initialized <= 1'd0;
  end
  else if (initialized)
  begin
    if(state == STATE_IDLE)
    begin
        latched_addr <= addr;
	latched_data <= data;
	latched_rw <= rw;
	latched_bytes <= bytes;
    end
    else if(state == STATE_RDATA)
    begin
      latched_data[count] = (sda === 1'bz);
    end
    state <= next_state;
    count <= next_count;
    sda_enable <= next_sda_enable;
    scl_enable <= next_scl_enable;
  end
  else // initialize
  begin
    state <= STATE_IDLE;
    count <= 8'd0;
    sda_enable <= 1'd0;
    scl_enable <= 1'd0;
    latched_addr <= 7'd0;
    latched_data <= 8'd0;
    latched_rw <= 1'd0;
    latched_bytes <= 1'd0;
    initialized <= 1'd1;
  end
end

// NEXT STATE COMBINATIONAL LOGIC (Only set 'next_' wires)
always@(sda or scl or state or start or count or latched_rw or latched_data or latched_addr or latched_bytes)
begin
    next_sda_enable = 1'b0;
    next_scl_enable = 1'b0;
    next_count = 1'b0;
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
      if(sda === 1'bz) // ~ACK	
      begin 
      	next_state = STATE_STOP;
        next_sda_enable = 1'b1;
      end 
      else // ACK
      begin
	next_count = 8'd7;
      	next_scl_enable = 1'b1;
	if(latched_rw) // reading (1 = reading)
        begin
          next_state = STATE_RDATA;
        end
        else // writing (0 = writing)
        begin
          next_state = STATE_WDATA;
          next_sda_enable = ~latched_data[next_count];
        end
      end
    end

    STATE_MASTER_WACK:
    begin
	next_state = STATE_RDATA;
	next_scl_enable = 1'b1;
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
	next_sda_enable = 1'b1;
      end
      else 
      begin
	next_count = count - 8'd1;
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
