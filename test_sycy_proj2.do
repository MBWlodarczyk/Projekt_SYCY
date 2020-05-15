restart -nowave -force
add wave -radix unsigned *
force clk 0 0, 1 10 -r 20
force rst 1 0, 0 1
force ena 1 0
force start 0 0, 1 40, 0 60
force data 10#65026726066765405 0,10#0 80
force key 10#252670361465327591276678215264683063301 0, 10#0 80
run 8000

