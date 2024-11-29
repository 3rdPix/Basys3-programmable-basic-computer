onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib yellow_block_green_opt

do {wave.do}

view wave
view structure
view signals

do {yellow_block_green.udo}

run -all

quit -force
