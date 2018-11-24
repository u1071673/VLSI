
module i2c (
input wire [15:0] data, /* Set this to the data we want to send to the slave. If we are reading this should be 16'd0 */
input wire [6:0] addr, /* Set this to the address of the slave. */
input wire clk,
input wire rst,
input wire start,
input wire two_bytes, /* Set this to 1 for reading or writing two data bytes. 0 means only read or write one data byte */
input wire rw, /* 0 = write, 1 = read */
inout wire sda,
inout wire scl,
output wire [15:0] read_data, /* This is set to the data retrieved from the slave */
output wire ready,
output wire got_acknowledge
);

localparam [7:0] STATE_IDLE = 8'd0, STATE_START = 8'd1, STATE_ADDR = 8'd2, STATE_RW = 8'd3, STATE_SLAVE_WACK = 8'd4, STATE_W_LSBYTE = 8'd5, STATE_W_MSBYTE = 8'd6, STATE_R_LSBYTE = 8'd7, STATE_R_MSBYTE = 8'd8, STATE_MASTER_WACK = 8'd9, STATE_STOP1 = 8'd10, STATE_STOP2 = 8'd11;
reg [15:0] latched_data;
reg [7:0] state, next_state, count, next_count;
reg [6:0] latched_addr;
reg latched_two_bytes;
reg scl_enable, next_scl_enable, sda_enable, next_sda_enable, latched_rw;
reg initialized;
reg slave_acknowledged;

wire sda_and_scl_high = (sda == 1'b1) && (scl == 1'b1);
  
// OUTPUT COMBINATIONAL LOGIC
assign sda = sda_enable ? 1'b0 : 1'bz;
assign scl = scl_enable && clk ? 1'b0 : 1'bz;
assign ready = (state == STATE_IDLE) && !(rst) && sda_and_scl_high;
assign read_data = latched_rw ? latched_data : 16'bxxxxxxxxxxxxxxxx;
assign got_acknowledge = slave_acknowledged;

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk or posedge rst)
begin
  if(rst) initialized <= 1'd0;
  else if (initialized)
  begin
    state <= next_state;
    count <= next_count;
    sda_enable <= next_sda_enable;
    scl_enable <= next_scl_enable;
    case(state)
      STATE_IDLE:
      begin
        latched_addr <= addr;
        latched_data <= data;
        latched_rw <= rw;
        latched_two_bytes <= two_bytes;
      end
      STATE_START:
      begin
        slave_acknowledged <= 1'b0;
      end
      STATE_W_MSBYTE, STATE_W_LSBYTE:
      begin
        latched_two_bytes <= 1'b0;
        slave_acknowledged <= 1'b1;
      end
      STATE_R_MSBYTE, STATE_R_LSBYTE:
      begin
        slave_acknowledged <= 1'b1;
        latched_data[count] <= (sda == 1'b1);
      end
      STATE_MASTER_WACK:
      begin
        latched_two_bytes <= 1'b0;
      end
      default:
      begin
        // Do nothing.
      end
    endcase
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
    latched_two_bytes <= 1'd0;
    slave_acknowledged <= 1'd0;
    initialized <= 1'd1;
  end
end

// NEXT STATE COMBINATIONAL LOGIC (Only set 'next_' wires)
always@(sda or scl or state or start or count or latched_rw or latched_data or latched_addr or latched_two_bytes or sda_and_scl_high)
begin
  next_sda_enable = 1'b0;
  next_scl_enable = 1'b0;
  next_count = 1'b0;
  case(state)
    STATE_IDLE:
    begin
      if(start && sda_and_scl_high)
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
    next_scl_enable = 1'b1;
    if(sda == 1'b1) // ~ACK
    begin
      next_state = STATE_STOP1;
      next_sda_enable = 1'b1;
      next_scl_enable = 1'b1;
    end
    else // ACK
    begin
      if(latched_rw) // reading (1 = reading)
      begin
        if(latched_two_bytes)
        begin
          next_state = STATE_R_MSBYTE;
          next_count = 8'd15;
        end
        else
        begin
          next_state = STATE_R_LSBYTE;
          next_count = 8'd7;
        end
      end
      else // writing (0 = writing)
      begin
        if(latched_two_bytes)
        begin
          next_state = STATE_W_MSBYTE;
          next_count = 8'd15;
          next_sda_enable = ~latched_data[next_count];
        end
        else
        begin
          next_state = STATE_W_LSBYTE;
          next_count = 8'd7;
          next_sda_enable = ~latched_data[next_count];
        end
      end
    end
  end

  STATE_W_MSBYTE:
  begin
    if(count == 8)
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

  STATE_W_LSBYTE:
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

  STATE_R_MSBYTE:
  begin
    if(count == 8)
    begin
      next_state = STATE_MASTER_WACK; // Go to acknowledge
      next_sda_enable = 1'b1; // Pull sda low for acknowlege because we want to read one more byte.
    end
    else next_count = count - 8'd1;
    next_scl_enable = 1'b1;
  end

  STATE_R_LSBYTE:
  begin
    if(count == 0) next_state = STATE_MASTER_WACK; // Go to acknowledge and don't pull sda low because we're done reading bytes.
    else next_count = count - 8'd1;
    next_scl_enable = 1'b1;
  end

  STATE_MASTER_WACK:
  begin
    next_scl_enable = 1'b1;
    if(latched_two_bytes) // read another byte.
    begin
      next_state = STATE_R_LSBYTE;
      next_count = 8'd7;
    end
    else 
    begin
      next_sda_enable = 1'b1;
      next_state = STATE_STOP1; 
    end
  end

  STATE_STOP1:
  begin
    next_sda_enable = 1'b1; // Keep sda low and let scl high so we can do start bit.
    next_state = STATE_STOP2;
  end

  STATE_STOP2:
  begin
    next_state = STATE_IDLE; // Here, scl is already high, now release sda to signal stop bit and go back to idle.
  end

  default:
  begin
    next_state = STATE_IDLE;
  end

endcase

end

endmodule     
