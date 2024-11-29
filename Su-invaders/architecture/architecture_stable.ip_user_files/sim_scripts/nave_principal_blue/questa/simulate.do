onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib nave_principal_blue_opt

do {wave.do}

view wave
view structure
view signals

do {nave_principal_blue.udo}

run -all

quit -force
