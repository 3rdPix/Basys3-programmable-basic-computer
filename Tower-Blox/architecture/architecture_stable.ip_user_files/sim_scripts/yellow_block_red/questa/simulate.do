onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib yellow_block_red_opt

do {wave.do}

view wave
view structure
view signals

do {yellow_block_red.udo}

run -all

quit -force
