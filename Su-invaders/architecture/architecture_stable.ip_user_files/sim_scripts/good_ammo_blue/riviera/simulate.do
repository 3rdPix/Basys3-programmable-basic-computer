onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+good_ammo_blue -L xpm -L blk_mem_gen_v8_4_4 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.good_ammo_blue xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {good_ammo_blue.udo}

run -all

endsim

quit -force
