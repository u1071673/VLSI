onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /i2c_control_tb/test
add wave -noupdate /i2c_control_tb/pull_sda_low
add wave -noupdate /i2c_control_tb/rst
add wave -noupdate /i2c_control_tb/clk
add wave -noupdate /i2c_control_tb/solar_celcius
add wave -noupdate /i2c_control_tb/greenhouse_celcius
add wave -noupdate /i2c_control_tb/ambient_celcius
add wave -noupdate /i2c_control_tb/geothermal_celcius
add wave -noupdate /i2c_control_tb/n_lux
add wave -noupdate /i2c_control_tb/e_lux
add wave -noupdate /i2c_control_tb/s_lux
add wave -noupdate /i2c_control_tb/w_lux
add wave -noupdate -radix decimal /i2c_control_tb/uut/state
add wave -noupdate /i2c_control_tb/uut/i2c_module/sda
add wave -noupdate /i2c_control_tb/uut/i2c_module/scl
add wave -noupdate /i2c_control_tb/uut/i2c_module/ready
add wave -noupdate -radix decimal /i2c_control_tb/uut/i2c_module/state
add wave -noupdate /i2c_control_tb/uut/start
add wave -noupdate /i2c_control_tb/uut/rw
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8859 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 322
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
WaveRestoreZoom {0 ps} {122974 ps}
