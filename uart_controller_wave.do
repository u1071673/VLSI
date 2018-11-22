onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /uart_controller_tb/uut/clk
add wave -noupdate -radix decimal /uart_controller_tb/test
add wave -noupdate -radix ascii -childformat {{{/uart_controller_tb/uut/mode[7]} -radix ascii} {{/uart_controller_tb/uut/mode[6]} -radix ascii} {{/uart_controller_tb/uut/mode[5]} -radix ascii} {{/uart_controller_tb/uut/mode[4]} -radix ascii} {{/uart_controller_tb/uut/mode[3]} -radix ascii} {{/uart_controller_tb/uut/mode[2]} -radix ascii} {{/uart_controller_tb/uut/mode[1]} -radix ascii} {{/uart_controller_tb/uut/mode[0]} -radix ascii}} -subitemconfig {{/uart_controller_tb/uut/mode[7]} {-height 16 -radix ascii} {/uart_controller_tb/uut/mode[6]} {-height 16 -radix ascii} {/uart_controller_tb/uut/mode[5]} {-height 16 -radix ascii} {/uart_controller_tb/uut/mode[4]} {-height 16 -radix ascii} {/uart_controller_tb/uut/mode[3]} {-height 16 -radix ascii} {/uart_controller_tb/uut/mode[2]} {-height 16 -radix ascii} {/uart_controller_tb/uut/mode[1]} {-height 16 -radix ascii} {/uart_controller_tb/uut/mode[0]} {-height 16 -radix ascii}} /uart_controller_tb/uut/mode
add wave -noupdate -radix ascii -childformat {{{/uart_controller_tb/uut/state[7]} -radix ascii} {{/uart_controller_tb/uut/state[6]} -radix ascii} {{/uart_controller_tb/uut/state[5]} -radix ascii} {{/uart_controller_tb/uut/state[4]} -radix ascii} {{/uart_controller_tb/uut/state[3]} -radix ascii} {{/uart_controller_tb/uut/state[2]} -radix ascii} {{/uart_controller_tb/uut/state[1]} -radix ascii} {{/uart_controller_tb/uut/state[0]} -radix ascii}} -subitemconfig {{/uart_controller_tb/uut/state[7]} {-height 16 -radix ascii} {/uart_controller_tb/uut/state[6]} {-height 16 -radix ascii} {/uart_controller_tb/uut/state[5]} {-height 16 -radix ascii} {/uart_controller_tb/uut/state[4]} {-height 16 -radix ascii} {/uart_controller_tb/uut/state[3]} {-height 16 -radix ascii} {/uart_controller_tb/uut/state[2]} {-height 16 -radix ascii} {/uart_controller_tb/uut/state[1]} {-height 16 -radix ascii} {/uart_controller_tb/uut/state[0]} {-height 16 -radix ascii}} /uart_controller_tb/uut/state
add wave -noupdate -radix decimal -childformat {{{/uart_controller_tb/uut/state[7]} -radix ascii} {{/uart_controller_tb/uut/state[6]} -radix ascii} {{/uart_controller_tb/uut/state[5]} -radix ascii} {{/uart_controller_tb/uut/state[4]} -radix ascii} {{/uart_controller_tb/uut/state[3]} -radix ascii} {{/uart_controller_tb/uut/state[2]} -radix ascii} {{/uart_controller_tb/uut/state[1]} -radix ascii} {{/uart_controller_tb/uut/state[0]} -radix ascii}} -subitemconfig {{/uart_controller_tb/uut/state[7]} {-height 16 -radix ascii} {/uart_controller_tb/uut/state[6]} {-height 16 -radix ascii} {/uart_controller_tb/uut/state[5]} {-height 16 -radix ascii} {/uart_controller_tb/uut/state[4]} {-height 16 -radix ascii} {/uart_controller_tb/uut/state[3]} {-height 16 -radix ascii} {/uart_controller_tb/uut/state[2]} {-height 16 -radix ascii} {/uart_controller_tb/uut/state[1]} {-height 16 -radix ascii} {/uart_controller_tb/uut/state[0]} {-height 16 -radix ascii}} /uart_controller_tb/uut/state
add wave -noupdate -radix decimal /uart_controller_tb/uut/solar_th
add wave -noupdate -radix decimal /uart_controller_tb/uut/solar_cooldown_th
add wave -noupdate -radix decimal /uart_controller_tb/uut/solar_heatup_th
add wave -noupdate -radix decimal /uart_controller_tb/uut/greenhouse_cooldown_th
add wave -noupdate -radix decimal /uart_controller_tb/uut/greenhouse_heatup_th
add wave -noupdate -radix decimal /uart_controller_tb/uut/ambient_cooldown_th
add wave -noupdate -radix decimal /uart_controller_tb/uut/ambient_heatup_th
add wave -noupdate -radix decimal /uart_controller_tb/uut/geothermal_cooldown_th
add wave -noupdate -radix decimal /uart_controller_tb/uut/geothermal_heatup_th
add wave -noupdate /uart_controller_tb/uut/rx
add wave -noupdate /uart_controller_tb/uut/data_ready_rx
add wave -noupdate -radix ascii /uart_controller_tb/uut/data_rx
add wave -noupdate /uart_controller_tb/uut/idle_ready_tx
add wave -noupdate /uart_controller_tb/uut/start_tx
add wave -noupdate -radix ascii /uart_controller_tb/uut/data_tx
add wave -noupdate -radix hexadecimal -childformat {{{/uart_controller_tb/uut/data_tx[7]} -radix hexadecimal} {{/uart_controller_tb/uut/data_tx[6]} -radix hexadecimal} {{/uart_controller_tb/uut/data_tx[5]} -radix hexadecimal} {{/uart_controller_tb/uut/data_tx[4]} -radix hexadecimal} {{/uart_controller_tb/uut/data_tx[3]} -radix hexadecimal} {{/uart_controller_tb/uut/data_tx[2]} -radix hexadecimal} {{/uart_controller_tb/uut/data_tx[1]} -radix hexadecimal} {{/uart_controller_tb/uut/data_tx[0]} -radix hexadecimal}} -subitemconfig {{/uart_controller_tb/uut/data_tx[7]} {-height 16 -radix hexadecimal} {/uart_controller_tb/uut/data_tx[6]} {-height 16 -radix hexadecimal} {/uart_controller_tb/uut/data_tx[5]} {-height 16 -radix hexadecimal} {/uart_controller_tb/uut/data_tx[4]} {-height 16 -radix hexadecimal} {/uart_controller_tb/uut/data_tx[3]} {-height 16 -radix hexadecimal} {/uart_controller_tb/uut/data_tx[2]} {-height 16 -radix hexadecimal} {/uart_controller_tb/uut/data_tx[1]} {-height 16 -radix hexadecimal} {/uart_controller_tb/uut/data_tx[0]} {-height 16 -radix hexadecimal}} /uart_controller_tb/uut/data_tx
add wave -noupdate /uart_controller_tb/uut/tx
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8139 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 346
configure wave -valuecolwidth 39
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
WaveRestoreZoom {0 ns} {132 ns}
