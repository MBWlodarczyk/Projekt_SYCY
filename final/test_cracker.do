restart -nowave -force
add wave -radix unsigned *
force rst 1 0, 0 1
force clk 0 0, 1 10 -r 20
force start 0 0, 1 40
run 250000