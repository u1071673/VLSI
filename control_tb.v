module control_tb;

  // INPUTS (reg)
  reg clk;
  reg rst;
  reg [7:0] gt;
  reg t_g_gt;

  // OUTPUTS (wire)
  wire out;

  // INSTANTIATE THE UNIT UNDER TEST (UUT)
control wgs(
.clk(clk),
.rst(rst),
.gt(gt),
.t_g_gt(t_g_gt),
.out(out)
);

  always #1 clk = ~clk;

  initial begin
    // INITIALIZE INPUTS
    clk = 0;
    rst = 0;
    t_g_gt = 0;
    gt = 0;
    // WAIT 100ns FOR GLOBAL RESET TO FINISH
   
    #10;
    // ADD STIMULUS HERE
    // TODO: Test 1
    #10;
    // TODO: Test 2
    #10;

    #100;

  end

endmodule