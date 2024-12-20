# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.cache/wt [current_project]
set_property parent.project_path /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.xpr [current_project]
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files /home/claudio/U/24.2/arqui/g21/Tower-Blox/resources/yellow_block/yellow_block_RED.coe
add_files /home/claudio/U/24.2/arqui/g21/Tower-Blox/resources/yellow_block/yellow_block_GREEN.coe
add_files /home/claudio/U/24.2/arqui/g21/Tower-Blox/resources/yellow_block/yellow_block_BLUE.coe
read_vhdl -library xil_defaultlib {
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/Clock_Halfener.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/Display_Controller.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/Timer.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/Xelor.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/adder_16b.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/address_multiplexor.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/arithmetic_logic_unit.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/basys3_CPU.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/basys3_Clock_Divider.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/basys3_LUT_RAM.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/basys3_LUT_ROM.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/basys3_Programmer.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/basys3_RTX2060.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/basys3_basicIO.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/button_debouncer.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/control_unit.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/data_multiplexor.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/demuxer_output.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/full_adder_1b.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/generic_16b_register.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/generic_4t1_multiplexor.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/half_adder_1b.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/muxer_input.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/program_counter.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/program_counter_multiplexor.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/register_status.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/special_adder_sp_to_ram.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/stack_pointer.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/uart.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/yellow_block_rom.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/new/yellow_block_sprite.vhd
  /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/imports/new/Basys3.vhd
}
read_ip -quiet /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/ip/yellow_block_red/yellow_block_red.xci
set_property used_in_implementation false [get_files -all /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/ip/yellow_block_red/yellow_block_red_ooc.xdc]

read_ip -quiet /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/ip/yellow_block_green/yellow_block_green.xci
set_property used_in_implementation false [get_files -all /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/ip/yellow_block_green/yellow_block_green_ooc.xdc]

read_ip -quiet /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/ip/yellow_block_blue/yellow_block_blue.xci
set_property used_in_implementation false [get_files -all /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/sources_1/ip/yellow_block_blue/yellow_block_blue_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/constrs_1/imports/new/Basys3.xdc
set_property used_in_implementation false [get_files /home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.srcs/constrs_1/imports/new/Basys3.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top Basys3 -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef Basys3.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file Basys3_utilization_synth.rpt -pb Basys3_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
