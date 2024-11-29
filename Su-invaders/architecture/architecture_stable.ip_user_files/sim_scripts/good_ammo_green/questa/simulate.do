onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib good_ammo_green_opt

do {wave.do}

view wave
view structure
view signals

do {good_ammo_green.udo}

run -all

quit -force
