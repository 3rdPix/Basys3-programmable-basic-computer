// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Thu Nov 14 02:58:28 2024
// Host        : debwing running 64-bit Debian GNU/Linux 12 (bookworm)
// Command     : write_verilog -force -mode synth_stub
//               {/home/claudio/U/24.2/arqui/g21/Entrega-3/especial_fase_2_0/Proyecto
//               Base.srcs/sources_1/ip/logo_green/logo_green_stub.v}
// Design      : logo_green
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *)
module logo_green(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[13:0],douta[7:0]" */;
  input clka;
  input [13:0]addra;
  output [7:0]douta;
endmodule