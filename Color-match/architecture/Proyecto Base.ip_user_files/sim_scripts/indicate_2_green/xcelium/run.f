-makelib xcelium_lib/xpm -sv \
  "/home/claudio/apps/vivado/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "/home/claudio/apps/vivado/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/blk_mem_gen_v8_4_4 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../Proyecto Base.srcs/sources_1/ip/indicate_2_green/sim/indicate_2_green.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

