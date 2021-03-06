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

export LINKER=$SCRIPTS/linker/linker.ld
echo "LINKER = $LINKER"

export CRT0=$SCRIPTS/crt0/crt0.S
echo "CRT0 = $CRT0"


if [ ! -d "$GIT_ROOT/OUTPUT" ]
then
    mkdir $GIT_ROOT/OUTPUT
fi   
export OUTPUT=$GIT_ROOT/OUTPUT
echo "OUTPUT = $OUTPUT"


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

alias rmtilda="find . -type f -name '*~' -exec rm -f '{}' \;"
echo "rmtilda = find . -type f -name '*~' -exec rm -f '{}' \;"
