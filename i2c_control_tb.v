`timescale 1ns / 1ps

module i2c_control_tb;

  localparam [3:0] TEST1 = 4'd1, TEST2 = 4'd2, TEST3 = 4'd3, TEST4 = 4'd4, TEST5 = 4'd5, TEST6 = 4'd6, TEST7 = 4'd7, TEST8 = 4'd8, TEST9 = 4'd9, TEST10 = 4'd10, TEST11 = 4'd11;
  reg [3:0] test; 
  reg ack_count;
  wire pull_sda_low;

  // INPUTS
  reg rst;
  reg clk;

  // OUTPUTS
  wire signed [7:0] solar_celcius;
  wire signed [7:0] greenhouse_celcius;
  wire signed [7:0] ambient_celcius;
  wire signed [7:0] geothermal_celcius;
  wire [15:0] n_lux;
  wire [15:0] e_lux;
  wire [15:0] s_lux;
  wire [15:0] w_lux;
  wire sda;
  wire scl;

  // INSTANTIATE THE UNIT UNDER TEST (UUT)
  i2c_control uut(
    .rst(rst),
    .sda(sda),
    .scl(scl),
    .solar_celcius(solar_celcius),
    .greenhouse_celcius(greenhouse_celcius),
    .ambient_celcius(ambient_celcius),
    .geothermal_celcius(geothermal_celcius),
    .n_lux(n_lux),
    .e_lux(e_lux),
    .s_lux(s_lux),
    .w_lux(w_lux),
    .clk(clk)
    );

  always #2.5 clk = ~clk;
  assign pull_sda_low = ((test == TEST5 || test == TEST6) && (uut.i2c_module.state == 4 && ack_count < 1));
  
  assign uut.i2c_module.sda = pull_sda_low ? 1'b0 : 1'bz;
  

  always@(uut.i2c_module.state)
  begin
    if(uut.i2c_module.state == 6 || uut.i2c_module.state == 8)
    begin
      ack_count = ack_count + 1;
      
    end
    if(uut.i2c_module.state == 0) ack_count = 0;
  end
  initial begin
    // INITIALIZE INPUTS
    clk = 0;
    rst = 0;
    test = 0;
    ack_count = 0;
    test = TEST5;
    // WAIT 10ns FOR GLOBAL RESET TO FINISH
    #10;
    // ADD STIMULUS HERE
    

  end

endmodule
