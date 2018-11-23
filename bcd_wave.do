onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /bcd_tb/test
add wave -noupdate -radix unsigned -childformat {{{/bcd_tb/binary[7]} -radix decimal} {{/bcd_tb/binary[6]} -radix decimal} {{/bcd_tb/binary[5]} -radix decimal} {{/bcd_tb/binary[4]} -radix decimal} {{/bcd_tb/binary[3]} -radix decimal} {{/bcd_tb/binary[2]} -radix decimal} {{/bcd_tb/binary[1]} -radix decimal} {{/bcd_tb/binary[0]} -radix decimal}} -subitemconfig {{/bcd_tb/binary[7]} {-height 16 -radix decimal} {/bcd_tb/binary[6]} {-height 16 -radix decimal} {/bcd_tb/binary[5]} {-height 16 -radix decimal} {/bcd_tb/binary[4]} {-height 16 -radix decimal} {/bcd_tb/binary[3]} {-height 16 -radix decimal} {/bcd_tb/binary[2]} {-height 16 -radix decimal} {/bcd_tb/binary[1]} {-height 16 -radix decimal} {/bcd_tb/binary[0]} {-height 16 -radix decimal}} /bcd_tb/binary
add wave -noupdate /bcd_tb/clk
add wave -noupdate /bcd_tb/rst
add wave -noupdate /bcd_tb/sign
add wave -noupdate /bcd_tb/hundreds
add wave -noupdate /bcd_tb/tens
add wave -noupdate /bcd_tb/ones
add wave -noupdate /bcd_tb/data_ready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {269 ns} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1 us}
