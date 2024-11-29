onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib indicate_2_blue_opt

do {wave.do}

view wave
view structure
view signals

do {indicate_2_blue.udo}

run -all

quit -force
