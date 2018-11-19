
module uart_rx (
input wire clk, /*input clock must be 9600 baud rate*/
input wire rst,
input wire rx,
output wire [7:0] data,
output wire ready
);

localparam [1:0] STATE_IDLE = 2'd0, STATE_DATA = 2'd1, STATE_STOP = 2'd2;
reg [7:0] count, next_count, latched_data;
reg [1:0] state, next_state;
reg initialized;
// OUTPUT COMBINATIONAL LOGIC
assign ready = (state == STATE_IDLE) && !(rst);
assign data = latched_data;

//UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
  if(rst)
  begin
    initialized <= 1'd0;
  end
  else if (initialized)
  begin
    state <= next_state;
    count <= next_count;
    if (state == STATE_DATA) latched_data[count] = rx;
  end
  else
  begin
    state <= STATE_IDLE;
    count <= 8'd0;
    latched_data <= 8'd0;
    initialized <= 1'd1;
  end
end

// NEXT STATE COMBINATIONAL LOGIC (Only set 'next_' wires)
always@(state or count or rx)
begin
  next_count = 1'b0;
  case(state)
  STATE_IDLE:
  begin
    if(~rx)
    begin
      next_state = STATE_DATA;
    end
    else next_state = STATE_IDLE;
  end

  STATE_DATA:
  begin
    if (count == 8'd7)
    begin
      next_state = STATE_STOP;
    end
    else
    begin
      next_state = STATE_DATA;
      next_count = count + 8'd1;
    end
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
