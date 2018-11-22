onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /uart_controller_tb/test
add wave -noupdate /uart_controller_tb/clk
add wave -noupdate /uart_controller_tb/rst
add wave -noupdate /uart_controller_tb/test_start
add wave -noupdate -radix ascii /uart_controller_tb/data_tx
add wave -noupdate -radix decimal /uart_controller_tb/solar_th
add wave -noupdate -radix decimal /uart_controller_tb/solar_cooldown_th
add wave -noupdate -radix decimal /uart_controller_tb/solar_heatup_th
add wave -noupdate -radix decimal /uart_controller_tb/greenhouse_cooldown_th
add wave -noupdate -radix decimal /uart_controller_tb/greenhouse_heatup_th
add wave -noupdate -radix decimal /uart_controller_tb/ambient_cooldown_th
add wave -noupdate -radix decimal /uart_controller_tb/ambient_heatup_th
add wave -noupdate -radix decimal /uart_controller_tb/geothermal_cooldown_th
add wave -noupdate -radix decimal /uart_controller_tb/geothermal_heatup_th
add wave -noupdate /uart_controller_tb/tx
add wave -noupdate /uart_controller_tb/test_tx
add wave -noupdate /uart_controller_tb/idle_ready_tx
add wave -noupdate /uart_controller_tb/start
add wave -noupdate -radix decimal -childformat {{{/uart_controller_tb/uut/state[3]} -radix ascii} {{/uart_controller_tb/uut/state[2]} -radix ascii} {{/uart_controller_tb/uut/state[1]} -radix ascii} {{/uart_controller_tb/uut/state[0]} -radix ascii}} -subitemconfig {{/uart_controller_tb/uut/state[3]} {-height 16 -radix ascii} {/uart_controller_tb/uut/state[2]} {-height 16 -radix ascii} {/uart_controller_tb/uut/state[1]} {-height 16 -radix ascii} {/uart_controller_tb/uut/state[0]} {-height 16 -radix ascii}} /uart_controller_tb/uut/state
add wave -noupdate -radix decimal -childformat {{{/uart_controller_tb/uut/mode[3]} -radix ascii} {{/uart_controller_tb/uut/mode[2]} -radix ascii} {{/uart_controller_tb/uut/mode[1]} -radix ascii} {{/uart_controller_tb/uut/mode[0]} -radix ascii}} -subitemconfig {{/uart_controller_tb/uut/mode[3]} {-height 16 -radix ascii} {/uart_controller_tb/uut/mode[2]} {-height 16 -radix ascii} {/uart_controller_tb/uut/mode[1]} {-height 16 -radix ascii} {/uart_controller_tb/uut/mode[0]} {-height 16 -radix ascii}} /uart_controller_tb/uut/mode
add wave -noupdate /uart_controller_tb/uut/data_ready_rx
add wave -noupdate /uart_controller_tb/uut/data_rx
add wave -noupdate -radix decimal /uart_controller_tb/uut/uart_module/rx_module/data
add wave -noupdate /uart_controller_tb/uut/uart_module/rx_module/data_ready
add wave -noupdate /uart_controller_tb/uut/uart_module/rx_module/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 470
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {165 ns}
