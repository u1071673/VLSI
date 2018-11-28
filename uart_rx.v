
module uart_rx (
  input wire clk, /*input clock must be 9600 baud rate*/
  input wire rst,
  input wire rx,
  output wire [7:0] data,
  output wire data_ready
  );

localparam [3:0] STATE_IDLE = 4'd0, STATE_DATA = 4'd1, STATE_DATA_READY = 4'd2, STATE_STOP = 4'd3;
reg [7:0] count, next_count, latched_data;
reg [3:0] state, next_state;
reg initialized;
// OUTPUT COMBINATIONAL LOGIC
assign data_ready = (state == STATE_DATA_READY);
assign data = latched_data;

//UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk or posedge rst)
begin
  if(rst)
  begin
    initialized <= 1'd0;
  end
  else if (initialized)
  begin
    state <= next_state;
    count <= next_count;
    if (state == STATE_DATA) latched_data[count] <= rx;
    if (state == STATE_STOP) latched_data <= 8'd0;
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
  next_state = state;
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
        next_state = STATE_DATA_READY;
      end
      else
      begin
        next_state = STATE_DATA;
        next_count = count + 8'd1;
      end
    end

    STATE_DATA_READY:
    begin
      next_state = STATE_STOP;
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
