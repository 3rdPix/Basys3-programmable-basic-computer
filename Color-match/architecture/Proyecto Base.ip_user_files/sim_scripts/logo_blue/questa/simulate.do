onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib logo_blue_opt

do {wave.do}

view wave
view structure
view signals

do {logo_blue.udo}

run -all

quit -force
