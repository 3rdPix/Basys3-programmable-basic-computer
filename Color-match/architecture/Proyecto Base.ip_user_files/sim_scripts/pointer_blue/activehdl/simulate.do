onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+pointer_blue -L xpm -L blk_mem_gen_v8_4_4 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.pointer_blue xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {pointer_blue.udo}

run -all

endsim

quit -force
