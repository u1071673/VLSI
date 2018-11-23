module bcd_tb;

  localparam [3:0] TEST1 = 4'd1, TEST2 = 4'd2, TEST3 = 4'd3, TEST4 = 4'd4, TEST5 = 4'd5, TEST6 = 4'd6, TEST7 = 4'd7, TEST8 = 4'd8, TEST9 = 4'd9, TEST10 = 4'd10, TEST11 = 4'd11;
  reg [3:0] test; 

  // INPUTS (reg)
  reg [15:0] binary;
  reg clk, rst;

  // OUTPUTS (wire)
  wire sign;
  wire [3:0] hundreds;
  wire [3:0] tens;
  wire [3:0] ones;
  wire data_ready;

  // INSTANTIATE THE UNIT UNDER TEST (UUT)
  bcd #(.N(16)) uut(
    .clk(clk),
    .rst(rst),
    .binary(binary),
    .sign(sign),
    .hundreds(hundreds),
    .tens(tens),
    .ones(ones),
    .data_ready(data_ready)
    );

  always #2.5 clk = ~clk;

  initial begin
    // INITIALIZE INPUTS
    clk = 0;
    rst = 0;
    binary = 0;

    // WAIT 100ns FOR GLOBAL RESET TO FINISH
    #100;
    // ADD STIMULUS HERE
    test = TEST1;
    binary = -16'd162;
    #100;

    test = TEST2;
    binary = 16'd38;
    #100;

    #100;

  end

endmodule