#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/home/claudio/apps/vivado/Vivado/2019.2/ids_lite/ISE/bin/lin64:/home/claudio/apps/vivado/Vivado/2019.2/bin
else
  PATH=/home/claudio/apps/vivado/Vivado/2019.2/ids_lite/ISE/bin/lin64:/home/claudio/apps/vivado/Vivado/2019.2/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/claudio/U/24.2/arqui/g21/Tower-Blox/architecture/architecture_stable.runs/impl_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

# pre-commands:
/bin/touch .init_design.begin.rst
EAStep vivado -log Basys3.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source Basys3.tcl -notrace


