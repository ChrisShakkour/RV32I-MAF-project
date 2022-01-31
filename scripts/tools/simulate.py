'''
Example use:
simulate -test -heir -gui 

-work : work libarary
-l    : sim log
-gui  : gui mode
-G    : overrite parameters.
-t    : 1ns
-hazards

vsim.exe work.CoreTop_TB -G LOADED_MEM_IMAGE="\home\christians\git\RV32I-MAF-project\verif\tests\temp\temp2.mem" -c -do "run -all" -l $OUTPUT/simulate/simulate.log

vsim.exe -Ldir "\home\christians\git\RV32I-MAF-project\OUTPUT" work.CoreTop_TB -G LOADED_MEM_IMAGE="\home\christians\git\RV32I-MAF-project\verif\tests\temp\temp2.mem" -c -do "run -all" -l $OUTPUT/simulate/simulate.log

vsim.exe -Ldir \home\christians\git\RV32I-MAF-project\OUTPUT work.CoreTop -t 1ns -G LOADED_MEM_IMAGE="\home\christians\git\RV32I-MAF-project\verif\tests\CharacterOcurrences\CharacterOcurrences.mem" -G STORED_MEM_IMAGE="\home\christians\git\RV32I-MAF-project\OUTPUT\simulate\CoreTop.mem" -gui -do "add wave -r ./*" -do "run -all" -l $OUTPUT/simulate/simulate.log
'''

import argparse
import os
import sys


cmd='vsim.exe -Ldir "{}" {} -t 1ns -G LOADED_MEM_IMAGE="{}" -G STORED_MEM_IMAGE="{}" {} -do "run -all" -l {} -suppress 8315,3584,8233,3408'

inst      = "work.{}"
gui       = "-gui"
waves     = ' -do "add wave -r ./*"'
lib       = "$OUTPUT"
work      = "$OUTPUT/work"
sim       = "$OUTPUT/simulate"
lMemPath  = "$VERIF/tests/{}.mem"
sMemPath  = "$OUTPUT/simulate/{}.mem"
log       = "$OUTPUT/simulate/simulate.log"
exe       = "$OUTPUT/simulate/simulate.exe"


'''
parse user arguments
'''
def parse_args():
    parser = argparse.ArgumentParser(description='compile script using modelsim compiler')
    parser.add_argument('--top', '-top', dest='top', required=False, default='CoreTop_TB', help='module name')
    parser.add_argument('--cmd', '-cmd', dest='cmd', required=False, action='store_true', help='print command only')
    parser.add_argument('--gui', '-gui', dest='gui', required=False, action='store_true',help='run gui mode')
    parser.add_argument('--waves', '-waves', dest='waves', required=False, action='store_true', help='add waves in gui mode')
    parser.add_argument('--test', '-test', dest='test', required=True, help='Test name')
    args=parser.parse_args()
    return args


'''
check if path exists
'''
def path_exists(src_file):
    if os.path.exists(os.path.realpath(src_file)): return 1
    return 0


'''
check if dir exists
'''
def dir_exist(src_dir):
    if os.path.isdir(src_dir): return 1
    return 0


'''
swap this "/" to this "\" 
ASCII chr(47) = /
ASCII chr(92) = \
'''
def reverse_backslash(path):
    str_=path.replace(chr(47), chr(92))
    return str_


'''
main :)
'''
def main():
    args=parse_args()

    if(not dir_exist(os.path.expandvars('$OUTPUT'))):
        print("-E- OUTPUT dirictory does not exist, execute >> source source_me.sh")
        exit(1)

    if(not dir_exist(os.path.expandvars(work))):
        print("-E- work dirictory does not exist, compile a module first!")
        exit(1)

    if(not dir_exist(os.path.expandvars(sim))):
        os.system("mkdir {}".format(sim))

    if(not dir_exist(os.path.expandvars(sim+'/trackers'))):
        os.system("mkdir {}".format(sim+'/trackers'))

    lib_=reverse_backslash(os.path.expandvars(lib))
    inst_=inst.format(args.top)
    sMemPath_ = reverse_backslash(os.path.expandvars(sMemPath.format(args.top)))
    
    path=lMemPath.format(args.test+"/"+args.test)
    if(not path_exists(os.path.expandvars(path))):
        path=lMemPath.format("ISA_tests/"+args.test)        
    if(not path_exists(os.path.expandvars(path))):
        print('-E- {} Test does not exist'.format(args.test))
        exit(1)

    lMemPath_ = reverse_backslash(os.path.expandvars(path))
    if(args.gui):
        if(args.waves):
            command=cmd.format(lib_, inst_, lMemPath_, sMemPath_, gui+waves, log)
        else:
            command=cmd.format(lib_, inst_, lMemPath_, sMemPath_, gui, log)
    else: 
        command=cmd.format(lib_, inst_, lMemPath_, sMemPath_, "-c", log)

    if(args.cmd): print(command)
    else: os.system(command)

    original_stdout = sys.stdout
    with open(os.path.expandvars(exe), "+w") as f:
        sys.stdout = f
        print(command)
        sys.stdout = original_stdout

    #os.system('echo "{}" > {}'.format(command, exe))
    os.system('chmod u+x {}'.format(exe))


if __name__ == "__main__":
    main()
