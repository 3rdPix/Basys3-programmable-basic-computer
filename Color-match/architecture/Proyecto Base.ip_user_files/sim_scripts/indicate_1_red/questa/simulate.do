onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib indicate_1_red_opt

do {wave.do}

view wave
view structure
view signals

do {indicate_1_red.udo}

run -all

quit -force
