onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /i2c_tb/test
add wave -noupdate -radix unsigned /i2c_tb/uut/state
add wave -noupdate /i2c_tb/sda
add wave -noupdate /i2c_tb/scl
add wave -noupdate /i2c_tb/bytes_written
add wave -noupdate /i2c_tb/two_bytes
add wave -noupdate /i2c_tb/read_data
add wave -noupdate /i2c_tb/rw
add wave -noupdate -radix hexadecimal -childformat {{{/i2c_tb/addr[6]} -radix hexadecimal} {{/i2c_tb/addr[5]} -radix hexadecimal} {{/i2c_tb/addr[4]} -radix hexadecimal} {{/i2c_tb/addr[3]} -radix hexadecimal} {{/i2c_tb/addr[2]} -radix hexadecimal} {{/i2c_tb/addr[1]} -radix hexadecimal} {{/i2c_tb/addr[0]} -radix hexadecimal}} -subitemconfig {{/i2c_tb/addr[6]} {-height 16 -radix hexadecimal} {/i2c_tb/addr[5]} {-height 16 -radix hexadecimal} {/i2c_tb/addr[4]} {-height 16 -radix hexadecimal} {/i2c_tb/addr[3]} {-height 16 -radix hexadecimal} {/i2c_tb/addr[2]} {-height 16 -radix hexadecimal} {/i2c_tb/addr[1]} {-height 16 -radix hexadecimal} {/i2c_tb/addr[0]} {-height 16 -radix hexadecimal}} /i2c_tb/addr
add wave -noupdate -radix hexadecimal -childformat {{{/i2c_tb/data[15]} -radix hexadecimal} {{/i2c_tb/data[14]} -radix hexadecimal} {{/i2c_tb/data[13]} -radix hexadecimal} {{/i2c_tb/data[12]} -radix hexadecimal} {{/i2c_tb/data[11]} -radix hexadecimal} {{/i2c_tb/data[10]} -radix hexadecimal} {{/i2c_tb/data[9]} -radix hexadecimal} {{/i2c_tb/data[8]} -radix hexadecimal} {{/i2c_tb/data[7]} -radix hexadecimal} {{/i2c_tb/data[6]} -radix hexadecimal} {{/i2c_tb/data[5]} -radix hexadecimal} {{/i2c_tb/data[4]} -radix hexadecimal} {{/i2c_tb/data[3]} -radix hexadecimal} {{/i2c_tb/data[2]} -radix hexadecimal} {{/i2c_tb/data[1]} -radix hexadecimal} {{/i2c_tb/data[0]} -radix hexadecimal}} -subitemconfig {{/i2c_tb/data[15]} {-height 16 -radix hexadecimal} {/i2c_tb/data[14]} {-height 16 -radix hexadecimal} {/i2c_tb/data[13]} {-height 16 -radix hexadecimal} {/i2c_tb/data[12]} {-height 16 -radix hexadecimal} {/i2c_tb/data[11]} {-height 16 -radix hexadecimal} {/i2c_tb/data[10]} {-height 16 -radix hexadecimal} {/i2c_tb/data[9]} {-height 16 -radix hexadecimal} {/i2c_tb/data[8]} {-height 16 -radix hexadecimal} {/i2c_tb/data[7]} {-height 16 -radix hexadecimal} {/i2c_tb/data[6]} {-height 16 -radix hexadecimal} {/i2c_tb/data[5]} {-height 16 -radix hexadecimal} {/i2c_tb/data[4]} {-height 16 -radix hexadecimal} {/i2c_tb/data[3]} {-height 16 -radix hexadecimal} {/i2c_tb/data[2]} {-height 16 -radix hexadecimal} {/i2c_tb/data[1]} {-height 16 -radix hexadecimal} {/i2c_tb/data[0]} {-height 16 -radix hexadecimal}} /i2c_tb/data
add wave -noupdate /i2c_tb/clk
add wave -noupdate /i2c_tb/start
add wave -noupdate /i2c_tb/ready
add wave -noupdate /i2c_tb/rst
add wave -noupdate -radix unsigned /i2c_tb/uut/count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {917500 ps} 0}
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
WaveRestoreZoom {849006 ps} {965994 ps}
