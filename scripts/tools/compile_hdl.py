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


cmd     ="vlog.exe -f {} -outf {} -l {} -work {} -skipsynthoffregion -lint -source -warning {} -fatal {} -note {} -error {} "

work      = "$OUTPUT/work"
comp      = "$OUTPUT/compile"
vfilePath = "$VFILES/{}/{}.vfile"
log       = "$OUTPUT/compile/compile_hdl.log"
cmdArgs   = "$OUTPUT/compile/compile_hdl.args"
exe       = "$OUTPUT/compile/compile_hdl.exe"
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


'''
check if dir exists
'''
def dir_exist(src_dir):
    if os.path.isdir(src_dir): return 1
    return 0


'''
create work library
'''
def make_vlib():
    os.system("vlib.exe {}".format(work))


'''
main :)
'''
def main():
    args=parse_args();
    
    if(not dir_exist(os.path.expandvars('$OUTPUT'))):
        print("-E- OUTPUT dirictory does not exist, execute >> source source_me.sh")
        exit(1)

    if(not dir_exist(os.path.expandvars(work))):
        make_vlib()

    if(not dir_exist(os.path.expandvars(comp))):
        os.system("mkdir {}".format(comp))
    
    vfile=vfilePath.format("design",args.top)
    if(not path_exists(os.path.expandvars(vfile))):
        vfile=vfilePath.format("testbench",args.top)
        
    if(not path_exists(os.path.expandvars(vfile))):
       print('-E- {} file does not exist'.format(vfile))
       exit(1)
       
    command=cmd.format(vfile, cmdArgs, log, work, W, E, F, N)
    if(args.cmd): print(command)
    else: os.system(command)

    os.system('echo "{}" > {}'.format(command, exe))
    os.system('chmod u+x {}'.format(exe))

    
if __name__ == "__main__":
    main()
