onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib good_ammo_blue_opt

do {wave.do}

view wave
view structure
view signals

do {good_ammo_blue.udo}

run -all

quit -force
