module seven_segment_controller_tb;

  localparam [3:0] TEST1 = 4'd1, TEST2 = 4'd2, TEST3 = 4'd3, TEST4 = 4'd4, TEST5 = 4'd5, TEST6 = 4'd6, TEST7 = 4'd7, TEST8 = 4'd8, TEST9 = 4'd9, TEST10 = 4'd10, TEST11 = 4'd11;
  reg [3:0] test; 

  // INPUTS (reg)
  reg clk;
  reg rst;
  reg signed [7:0] binary;
 
  // OUTPUTS (wire)
  wire anode0_en;
  wire anode1_en;
  wire anode2_en;
  wire anode3_en;
  wire a_out;
  wire b_out;
  wire c_out;
  wire d_out;
  wire e_out;
  wire f_out;
  wire g_out;

  // INSTANTIATE THE UNIT UNDER TEST (UUT)
seven_segment_controller uut(
  .clk(clk),
  .rst(rst),
  .binary(binary), /* Value to display on all segments */
  .anode0_en(anode0_en),
  .anode1_en(anode1_en),
  .anode2_en(anode2_en),
  .anode3_en(anode3_en),
  .a_out(a_out),
  .b_out(b_out),
  .c_out(c_out),
  .d_out(d_out),
  .e_out(e_out),
  .f_out(f_out),
  .g_out(g_out)
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
    binary = -16'd126;
    #20000000;
    test = TEST2;
    binary = 16'd38;
    #20000000;
    #100;

  end

endmodule