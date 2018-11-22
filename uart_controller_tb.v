module uart_controller_tb;

  localparam [7:0] TEST1 = 8'd1, TEST2 = 8'd2, TEST3 = 8'd3, TEST4 = 8'd4, TEST5 = 8'd5, TEST6 = 8'd6, TEST7 = 8'd7, TEST8 = 8'd8, TEST9 = 8'd9, TEST10 = 8'd10, TEST11 = 8'd11, TEST12 = 8'd12, TEST13 = 8'd13, TEST14 = 8'd14, TEST15 = 8'd15, TEST16 = 8'd16, TEST17 = 8'd17, TEST18 = 8'd18, TEST19 = 8'd19, TEST20 = 8'd20, TEST21 = 8'd21, TEST22 = 8'd22, TEST23 = 8'd23, TEST24 = 8'd24, TEST25 = 8'd25, TEST26 = 8'd26, TEST27 = 8'd27;
  reg [7:0] test;

  // INPUTS
  reg clk;
  reg rst;
  reg test_start;
  reg [7:0] data_tx; /* Set this to the data we want to send to the uart controller */

  // OUTPUTS
  wire [15:0] solar_th;
  wire signed [7:0] solar_cooldown_th;
  wire signed [7:0] solar_heatup_th;
  wire signed [7:0] greenhouse_cooldown_th;
  wire signed [7:0] greenhouse_heatup_th;
  wire signed [7:0] ambient_cooldown_th;
  wire signed [7:0] ambient_heatup_th;
  wire signed [7:0] geothermal_cooldown_th;
  wire signed [7:0] geothermal_heatup_th;
  wire tx;
  wire test_tx;
  wire idle_ready_tx;
  
  assign start = test_start;


  // INSTANTIATE THE UNIT UNDER TEST (UUT)
  uart_tx uut_tx(
    .clk(clk),
    .rst(rst),
    .start(start),
    .data(data_tx),
    .tx(test_tx),
    .idle_ready(idle_ready_tx)
    );

  uart_controller uut(
    .clk(clk),
    .rst(rst),
    .rx(test_tx),
    .solar_th(solar_th),
    .solar_cooldown_th(solar_cooldown_th),
    .solar_heatup_th(solar_heatup_th),
    .greenhouse_cooldown_th(greenhouse_cooldown_th),
    .greenhouse_heatup_th(greenhouse_heatup_th),
    .ambient_cooldown_th(ambient_cooldown_th),
    .ambient_heatup_th(ambient_heatup_th),
    .geothermal_cooldown_th(geothermal_cooldown_th),
    .geothermal_heatup_th(geothermal_heatup_th),
    .tx(tx)
    );

  always #2.5 clk = ~clk;

  initial begin
    // INITIALIZE INPUTS
    clk = 0;
    rst = 0;
    test_start = 0;
    data_tx = 0;
    // WAIT 10ns FOR GLOBAL RESET TO FINISH
    #100;
    // ADD STIMULUS HERE
    test = TEST1;
    data_tx = "A";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;
    
    test = TEST2;
    data_tx = "w";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;

    test = TEST3;
    data_tx = "s";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;
    test = TEST4;
    data_tx = "B";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;
    
    test = TEST5;
    data_tx = "w";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;

    test = TEST6;
    data_tx = "s";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;
    test = TEST7;
    data_tx = "C";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;
    
    test = TEST8;
    data_tx = "w";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;

    test = TEST9;
    data_tx = "s";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;
    test = TEST10;
    data_tx = "D";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;
    
    test = TEST11;
    data_tx = "w";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;

    test = TEST12;
    data_tx = "s";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;
    test = TEST13;
    data_tx = "E";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;
    
    test = TEST14;
    data_tx = "w";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;

    test = TEST15;
    data_tx = "s";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;
    test = TEST16;
    data_tx = "F";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;
    
    test = TEST17;
    data_tx = "w";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;

    test = TEST18;
    data_tx = "s";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;
    test = TEST19;
    data_tx = "G";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;
    
    test = TEST20;
    data_tx = "w";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;

    test = TEST21;
    data_tx = "s";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;
    test = TEST22;
    data_tx = "H";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;
    
    test = TEST23;
    data_tx = "w";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;

    test = TEST24;
    data_tx = "s";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;
    test = TEST25;
    data_tx = "I";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;
    
    test = TEST26;
    data_tx = "w";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;

    test = TEST27;
    data_tx = "s";
    test_start = 1; #5;
    test_start = 0; #5;

    #100;

  end

endmodule
