restart -nowave -force
add wave -radix unsigned *
force clk 0 0, 1 10 -r 20
force rst 1 0, 0 1
force start 0 0, 1 40
force data 16#EA7C7D9678D836A8 0
run 800000

