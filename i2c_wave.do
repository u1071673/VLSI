onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /i2c_tb/sda
add wave -noupdate /i2c_tb/scl
add wave -noupdate /i2c_tb/clk
add wave -noupdate /i2c_tb/uut/state
add wave -noupdate /i2c_tb/addr
add wave -noupdate /i2c_tb/data
add wave -noupdate /i2c_tb/start
add wave -noupdate /i2c_tb/test
add wave -noupdate /i2c_tb/rst
add wave -noupdate /i2c_tb/bytes_written
add wave -noupdate /i2c_tb/uut/latched_data
add wave -noupdate /i2c_tb/uut/latched_addr
add wave -noupdate /i2c_tb/uut/latched_rw
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {154565 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 217
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
WaveRestoreZoom {87172 ps} {207828 ps}
