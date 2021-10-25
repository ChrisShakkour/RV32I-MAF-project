#!/bin/bash

echo "###### ENVIRONMENT VARIABLES ######"

export GIT_ROOT=$(pwd)
echo "GIT_ROOT = $GIT_ROOT"

export GENERIC_CELLS=$GIT_ROOT/HDL/generic_cells
echo "GENERIC_CELLS = $GENERIC_CELLS"

export INTERFACE=$GIT_ROOT/HDL/interface
echo "INTERFACE = $INTERFACE"

export PACKAGES=$GIT_ROOT/HDL/packages
echo "PACKAGES = $PACKAGES"

export RTL=$GIT_ROOT/HDL/rtl_src
echo "RTL = $RTL"

export VERIF=$GIT_ROOT/verif
echo "VERIF = $VERIF"

export VFILES=$GIT_ROOT/vfiles
echo "VFILES = $VFILES"

export SCRIPTS=$GIT_ROOT/scripts
echo "SCRIPTS = $SCRIPTS"

export LINKER=$SCRIPTS/linker/basic_linker.ld
echo "LINKER = $LINKER"

echo " "
echo "###### aliases ######"

alias py="python3"
echo "py = python3"

alias simulate="py $SCRIPTS/tools/simulate.py"
echo "simulate =  python3 $SCRIPTS/tools/simulate.py"

alias compile_hdl="py $SCRIPTS/tools/compile_hdl.py"
echo "compile_hdl = python3 $SCRIPTS/tools/compile_hdl.py"

alias compile_gcc="py $SCRIPTS/tools/compile_gcc.py"
echo "compile_gcc = python3 $SCRIPTS/tools/compile_gcc.py"

alias maketb="py $SCRIPTS/tools/MakeTB.py"
echo "maketb = python3 $SCRIPTS/tools/MakeTB.py"
