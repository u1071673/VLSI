onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /uart_rx_tb/test
add wave -noupdate /uart_rx_tb/start
add wave -noupdate /uart_rx_tb/clk
add wave -noupdate /uart_rx_tb/rst
add wave -noupdate /uart_rx_tb/data_tx
add wave -noupdate /uart_rx_tb/rx
add wave -noupdate /uart_rx_tb/tx
add wave -noupdate /uart_rx_tb/data_rx
add wave -noupdate /uart_rx_tb/ready_tx
add wave -noupdate /uart_rx_tb/ready_rx
add wave -noupdate /uart_rx_tb/uut_rx/data
add wave -noupdate /uart_rx_tb/uut_rx/count
add wave -noupdate /uart_rx_tb/uut_rx/state
add wave -noupdate /uart_rx_tb/uut_rx/initialized
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {88 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 281
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
WaveRestoreZoom {0 ns} {1080 ns}
