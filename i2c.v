
module i2c (
input wire clk,
input wire rst,
output reg sda,
output reg scl
);

parameter [7:0] STATE_START = 8'd0, STATE_ADDR = 8'd1, S_RW = 8'd2, STATE_IDLE = 8'd3;

reg [7:0] state, count;
reg [6:0] addr;

always @(posedge clk)
begin
  if(rst)
  begin
    state <=

  end
  else
  begin
    case(state)

      default: // STATE_IDLE
      begin
        sda <= 1;
        state <= STATE_START;
      end
    endcase
  end

endmodule
