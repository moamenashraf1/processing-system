vlib work
vlog -f sourcefile.txt
vsim -voptargs=+accs work.SYS_TOP_TB
add wave *
run -all