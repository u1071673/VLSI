onerror {resume}
quietly virtual signal -install /seven_segment_controller_tb { (context /seven_segment_controller_tb )&{anode3_en , anode2_en , anode1_en , anode0_en }} anodes
quietly virtual signal -install /seven_segment_controller_tb { (context /seven_segment_controller_tb )&{a_out , b_out , c_out , d_out , e_out , f_out , g_out }} led_out
quietly WaveActivateNextPane {} 0
add wave -noupdate /seven_segment_controller_tb/test
add wave -noupdate /seven_segment_controller_tb/clk
add wave -noupdate /seven_segment_controller_tb/rst
add wave -noupdate -radix hexadecimal /seven_segment_controller_tb/binary
add wave -noupdate -radix binary /seven_segment_controller_tb/anodes
add wave -noupdate -radix hexadecimal /seven_segment_controller_tb/led_out
add wave -noupdate -radix unsigned /seven_segment_controller_tb/uut/state
add wave -noupdate -radix unsigned /seven_segment_controller_tb/uut/count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1105700 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 255
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
WaveRestoreZoom {0 ns} {20017770 ns}
