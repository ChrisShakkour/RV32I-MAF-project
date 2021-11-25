'''
Example use:
compile_hdl -top <name of block> -lint-defines <Ex. -define SYNTHISIS -define FPGA -define> -cmd


Commands:
vlib.exe $OUTPUT/work
vlog.exe -f $VFILES/testbench/IMem_TB.vfile -outf $OUTPUT/compile/compile_hdl.args -l $OUTPUT/compile/compile_hdl.log -skipsynthoffregion  -lint -work $OUTPUT/work/ -warning [] -fatal [] -note [] -error [] +define+FPGA +define+SYNTHISIS
'''


import argparse
import os
import sys


cmd     ="vlog.exe -f {} -outf {} -l {} -work {} -skipsynthoffregion -lint -warning {} -fatal {} -note {} -error {} "

work      = "$OUTPUT/work"
vfilePath = "$VFILES/{}/{}.vfile"
log       = "$OUTPUT/compile/compile_hdl.log"
cmdArgs   = "$OUTPUT/compile/compile_hdl.args"
W         = "[]"
E         = "[]"
F         = "[]"
N         = "[]"
defines   = "+define+ SYNTHISIS"

'''
parse user arguments
'''
def parse_args():
    parser = argparse.ArgumentParser(description='compile script using modelsim compiler')
    parser.add_argument('--top', '-top', dest='top', required=True, default='CoreTop',help='module name')
    parser.add_argument('--cmd', '-cmd', dest='cmd', required=False, action='store_true',help='module name')
    args=parser.parse_args()
    return args


'''
check if path exists
'''
def path_exists(src_file):
    if os.path.exists(os.path.realpath(src_file)): return 1
    return 0

def main():
    args=parse_args();
    
    vfile=vfilePath.format("design",args.top)
    if(not path_exists(os.path.expandvars(vfile))):
        vfile=vfilePath.format("testbench",args.top)
        
    if(not path_exists(os.path.expandvars(vfile))):
       print('-E- {} file does not exist'.format(vfile))
       exit(1)
       
    command=cmd.format(vfile, cmdArgs, log, work, W, E, F, N)
    if(args.cmd): print(command)
    else: os.system(command)
    
if __name__ == "__main__":
    main()
