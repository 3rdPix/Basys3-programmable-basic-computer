onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+yellow_block_green -L xpm -L blk_mem_gen_v8_4_4 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.yellow_block_green xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {yellow_block_green.udo}

run -all

endsim

quit -force
