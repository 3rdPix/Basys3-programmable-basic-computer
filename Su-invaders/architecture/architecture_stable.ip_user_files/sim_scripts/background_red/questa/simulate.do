onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib background_red_opt

do {wave.do}

view wave
view structure
view signals

do {background_red.udo}

run -all

quit -force
