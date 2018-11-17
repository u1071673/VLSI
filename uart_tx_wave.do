onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /uart_tx_tb/bytes_written
add wave -noupdate /uart_tx_tb/clk
add wave -noupdate /uart_tx_tb/tx
add wave -noupdate /uart_tx_tb/ready
add wave -noupdate -radix unsigned /uart_tx_tb/uut/state
add wave -noupdate /uart_tx_tb/data
add wave -noupdate -radix decimal /uart_tx_tb/test
add wave -noupdate /uart_tx_tb/rst
add wave -noupdate /uart_tx_tb/start
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {163 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {264 ps}
