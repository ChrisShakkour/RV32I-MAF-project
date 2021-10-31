'''

-march=         arch
-mabi=          abi
-T              linker
-nostartfiles   ?
-o              output

Ex. flow
riscv32-unknown-elf-gcc -S test.c -march=rv32i -mabi=ilp32
riscv32-unknown-elf-gcc -c test.s -march=rv32i -mabi=ilp32 -T $LINKER -o test.elf
riscv32-unknown-elf-objdump -gd test.elf > test.txt
riscv32-unknown-elf-objcopy --srec-len 1 --output-target=verilog test.elf test.sv
'''

import argparse
import os
import sys


c_2_asm   = 'riscv32-unknown-elf-gcc -S {} -ffreestanding -march={} -mabi={} -o {}'                       # + c_file + march + mabi + other options
asm_2_elf = 'riscv32-unknown-elf-gcc -O3 -nostartfiles -D__riscv_ {} -march={} -mabi={} -T {} -o {}'           # + asm_file + march + mabi + linker  
elf_2_txt = 'riscv32-unknown-elf-objdump -gd {} > {}'
elf_2_sv  = 'riscv32-unknown-elf-objcopy --srec-len 1 --output-target=verilog {} {}' # + elf file


'''
file extention checking
'''
def CheckExt(choices):
    class Act(argparse.Action):
        def __call__(self,parser,namespace,fname,option_string=None):
            ext = os.path.splitext(fname)[1][1:]
            if ext not in choices:
                option_string = '({})'.format(option_string) if option_string else ''
                parser.error("file doesn't end with one of {}{}".format(choices,option_string))
            else:
                setattr(namespace,self.dest,fname)
    return Act


'''
parse user arguments
'''
def parse_args():
    parser = argparse.ArgumentParser(description='GCC compiler script for risc-v, compiles c and asm code to systemverilog mem file')

    parser.add_argument('--src_file', '-src', dest='file', required=True, action=CheckExt({'c', 'S', 's'})\
                        , help='Enter the path to a c or asm file with .s or .S or .c extention')

    parser.add_argument('--ARCH', '-arch', dest='arch' ,required=False, default='rv32i'\
                        ,choices={'rv32i', 'rv32im', 'rv32ia', 'rv32if', 'rv32ima', 'rv32imf', 'rv32imaf'}\
                        , help='enter arch flavure meaning supported hardware, rv32i by defualt + m, a, f')

    parser.add_argument('--ABI', '-abi', dest='abi', required=False, default='ilp32'\
                        ,choices={'ilp32', 'ilp32f'}, help='enter software flavure, defualt ilp32')

    parser.add_argument('--elf', '-elf', dest='elf', required=False, action='store_true'\
                        ,help='add -elf to generate an executable program')
    
    parser.add_argument('--txt', '-txt', dest='txt', required=False, action='store_true'\
                        ,help='add -txt generate human readabale text asm')

    parser.add_argument('--gen_mem', '-mem', dest='mem', required=False, action='store_true'\
                        ,help='add -mem to generate systemverilog mem file')

    parser.add_argument('--output_dir', '-od', dest='output_dir', required=False\
                        ,help='output directory path')

    parser.add_argument('--name', '-n', dest='name', required=False\
                        ,help='output file names')
    
    parser.add_argument('--linker', '-l', dest='linker', required=False, default="$LINKER"\
                        ,help='output file names')
    
    args=parser.parse_args()
    return args


'''
check if path exists
'''
def path_exists(src_file):
    if os.path.exists(src_file):
        return os.path.realpath(src_file)
    else: print('src file does not exist')
    exit(1)

    
'''
check if dir exists
'''
def dir_exist(src_dir):
    if os.path.isdir(src_dir):
        return os.path.realpath(src_dir)
    else: print('output directory does not exist')
    exit(1)


'''
get extension .<ext>
'''
def get_extension(full_path):
    return full_path[-1]


'''
get filename
'''
def get_filename(full_path):
    name=full_path.split('/')[-1]
    return name.split('.')[0]


'''
run assemble 
generation command
'''
def gen_asm(c_file, arch, abi, dest):
    print('generating asemble file...')
    cmd=c_2_asm.format(c_file, arch, abi, dest)
    print('command : %s' %(cmd))
    os.system(cmd)
    return 0

'''
run executable
generation command
'''
def gen_elf(asm_file, arch, abi, linker, dest):
    print('generating executable file...')
    cmd=asm_2_elf.format(asm_file, arch, abi, linker, dest)
    print('command : %s' %(cmd))
    os.system(cmd)
    return 0

'''
run text
generation command
'''
def gen_txt(elf_file, dest):
    print('generating text file...')
    os.system(elf_2_txt.format(elf_file, dest))
    return 0


'''
run generate memory image,
systemverilog file
'''
def gen_mem(elf_file, dest):
    print('generating memory file...')
    os.system(elf_2_sv.format(elf_file, dest))
    return 0


'''
main:)
'''
def main():
    args=parse_args()

    src_realpath=path_exists(args.file)
    ext=get_extension(src_realpath)
    filename=get_filename(src_realpath)
    print('\n%s, %s, %s\n' %(src_realpath, ext, filename))

    if args.output_dir is not None:
        dest_realpath=dir_exist(args.output_dir)
    else: dest_realpath = src_realpath.replace('/'+filename+'.'+ext, '')
    print('destination directory : {}\n'.format(dest_realpath))
    if args.name is not None:
        dest_realpath=dest_realpath+'/'+args.name
    else: dest_realpath=dest_realpath+'/'+filename

    if ext == 'c':
        gen_asm(src_realpath, args.arch, args.abi, dest_realpath+'.s')
    if args.elf is not None:
        gen_elf(dest_realpath+'.s', args.arch, args.abi, '{}'.format(os.getenv('LINKER')), dest_realpath+'.elf')
    if args.txt is not None:
        gen_txt(dest_realpath+'.elf', dest_realpath+'.txt')
    if args.mem is not None:
        gen_mem(dest_realpath+'.elf', dest_realpath+'.sv')
        
    
        
if __name__ == "__main__":
    main()
