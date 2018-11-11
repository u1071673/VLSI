onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /i2c_tb/sda
add wave -noupdate /i2c_tb/scl
add wave -noupdate /i2c_tb/clk
add wave -noupdate /i2c_tb/rst
add wave -noupdate /i2c_tb/utt/state
add wave -noupdate /i2c_tb/utt/count
add wave -noupdate /i2c_tb/utt/scl_enable
add wave -noupdate /i2c_tb/utt/next_state
add wave -noupdate /i2c_tb/utt/next_count
add wave -noupdate /i2c_tb/utt/next_scl_enable
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12 ns} 0}
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
WaveRestoreZoom {10 ns} {18 ns}
