onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+nave_amarilla_red -L xpm -L blk_mem_gen_v8_4_4 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.nave_amarilla_red xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {nave_amarilla_red.udo}

run -all

endsim

quit -force
