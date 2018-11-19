

module uart_tx (
input wire clk,
input wire rst,
input wire start,
input wire [7:0] data, /* Set this to the data we want to send to the reciever */
output wire tx,
output wire ready
);

localparam [1:0] STATE_IDLE = 2'd0, STATE_START = 2'd1, STATE_DATA = 2'd2;
reg [7:0] count, next_count, latched_data;
reg [1:0] state, next_state;
reg initialized, bit, next_bit;
// OUTPUT COMBINATIONAL LOGIC
assign ready = (state == STATE_IDLE) && !(rst);
assign tx = bit;

// UPDATE STATE SEQUENTIAL LOGIC
always@(posedge clk)
begin
  if(rst) // TODO: verify
  begin
    initialized <= 1'd0;
    bit <= 1'd1;
  end
  else if (initialized)
  begin
    if(state == STATE_IDLE)
    begin
	latched_data <= data;
    end
    state <= next_state;
    count <= next_count;
    bit <= next_bit;
  end
  else // initialize
  begin
    state <= STATE_IDLE;
    count <= 8'd0;
    latched_data <= 8'd0;
    bit <= 1'd1;
    initialized <= 1'd1;
  end
end

// NEXT STATE COMBINATIONAL LOGIC (Only set 'next_' wires)
always@(state or start or count or bit or latched_data)
begin
    next_count = 1'b0;
    next_bit = 1'b1;
    case(state)
    STATE_IDLE:
    begin
	if(start)
	begin
	  next_state = STATE_START;
	  next_bit = 1'b0;
	end
        else next_state = STATE_IDLE;
    end

    STATE_START:
    begin
        next_state = STATE_DATA;
        next_count = 8'd0;
	next_bit = latched_data[next_count];
    end

    STATE_DATA:
    begin
      if(count == 8'd7)
      begin 
	next_state = STATE_IDLE;
      end
      else 
      begin
	next_state = STATE_DATA;
	next_count = count + 8'd1;
        next_bit = latched_data[next_count]; // has to be after count - 1
      end
    end

    default:
    begin
       next_state = STATE_IDLE;
    end

    endcase

end

endmodule