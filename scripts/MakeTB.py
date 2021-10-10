'''
python script for making a quick testbench
reads a system verilog design file and makes
a simple testbench shell as follows below.

<modulename>_TB.sv file content
/*
Description:
module path:
*/

`timescale x/y

module <name>();
   parameters
   IO decliration;
   instance

   always <clk>
   task init()
   task reset()

   initial begin
      init();
      reset();
      $finish;
   end
endmodule
'''

import logging
import argparse
import sys
import re
import os


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
    logging.info('started parsing arguments parse_args()')
    parser = argparse.ArgumentParser(description='Testbench shell generator for single design module')
    parser.add_argument('--file', '-f', dest='file', required=True, action=CheckExt({'sv'})\
                        , help='Enter the path to a systemverilog design file with .sv extention')
    parser.add_argument('--half_clk', '-p', dest='half_clk' ,required=False, default=5, type=int\
                        , help='Enter an integer. half_clk will be  (half_clk*timeunit) rounded by timeprecision)')
    parser.add_argument('--name', '-n', dest='name', required=False\
                        , help='testbench module name')
    parser.add_argument('--clock', '-clk', dest='clk', required=False\
                        ,help='Enter module clock name')

    
    args=parser.parse_args()
    logging.info('file path: %s' %(args.file))
    logging.info('input half_clk: %s' %(str(args.half_clk)))
    logging.info('testbench module name: %s' %(str(args.name)))
    return args


'''
creating a logging file
for info and debug.
'''
def make_logger():
    logging.basicConfig(
        filename='MakeTB.log',
        filemode='w+',
        format='%(asctime)s - %(levelname)s : %(message)s',
        datefmt='%m/%d/%Y %I:%M:%S',
        level=logging.DEBUG
    )
    logging.info('created logging file')


'''
reading design file
'''
def readfile(path):
    realpath=os.path.realpath(path)
    logging.info('opening file %s' %(path))
    try:
        with open(path, "r", encoding='UTF-8') as f:
            logging.info('file opened successfully')
            logging.info('reading file')
            try:
                content=f.read()
                logging.info('content read successfully')
                return content
            except RuntimeError:
                logging.error('unable to read file')
                sys.exit(1)
    except FileNotFoundError:
        logging.error('unable to open file')
        sys.exit(1)
'''
gets the module name
inputs a design
outputs module name
'''
def get_module_name(design):
    logging.info('searching for module name')
    regexp="module.+"
    search=str(re.findall(regexp, design))
    name= search.split()[1]
    if name is not None:
        logging.info('module name: %s' %(name))
    else:
        logging.error('module name not found')
        sys.exit(1)
    return name


'''
gets the timescale of a
design module or timeunit
and timeprecision if both
appear timeunit and precision
will be taken.
inputs a design
outputs two vars
{timeunit, timeprecision}
'''
def get_time(design):
    logging.info('searching timescale')
    regexp=["`timescale.+","timeunit.+","timeprecision.+"]
    timescale=''.join(re.findall(regexp[0], design))
    timeunit=re.findall(regexp[1], design)
    timeprecision=re.findall(regexp[2], design)
    if timescale: logging.info('found timescale: %s' %(timescale))
    if timeunit: logging.info('found timeunit: %s' %(timeunit))
    if timeprecision: logging.info('found timprecision: %s' %(timeprecision))
    return [timescale, timeunit, timeprecision]
    

'''
discover I/O of a module
inputs design
outputs two lists:
1. inputs[]
2. outputs[]
''' 
def get_IO_signals(design):
    logging.info('searching I/O')
    regexp=['input.+', 'output.+']
    inputs=re.findall(regexp[0], design)
    outputs=re.findall(regexp[1], design)
    logging.info('### input signals ###')
    for i in inputs: logging.info(i)
    logging.info('### output signals ###')
    for i in outputs: logging.info(i)
    return [inputs, outputs]


'''
discovers module parameters
inputs a design
outputs a list of parameter
'''
def get_parameters(design):
    logging.info('searching parameters')
    regexp=['parameter.+', 'localparam.+']
    params=re.findall(regexp[0], design)
    logging.info('### parameters found ###')
    for i in params: logging.info(i)
    localparams=re.findall(regexp[1], design)
    logging.info('### localparams found ###')
    for i in localparams: logging.info(i)
    return [params, localparams]



'''
gets the name of the clock 
signal searches for clk and
clock expression
'''
def get_clk(inputs):
    logging.info('starting clock signal search')
    regexp=['clk', 'clock']
    clk=''.join(re.findall(regexp[0], ''.join(inputs)))
    logging.info('found clk name: %s' %(clk))
    if len(clk):
        logging.info('found clk name: %s' %(clk))
        return clk
    else:
        logging.warning('could not find clk signal')
        return None

'''
gets the name of the reset
signal searches for rstn and
reset expression
'''
def get_reset(inputs):
    logging.info('starting reset signal search')
    regexp=['rstn', 'reset']
    rst=''.join(re.findall(regexp[0], ''.join(inputs)))
    if len(rst):
        logging.info('found reset name: %s' %(clk))
        return rst
    else:
        logging.warning('no reset signal found')
        return None
    

'''
main
'''
def main():
    make_logger()
    args=parse_args()
    realpath=os.path.realpath(args.file)
    designf=readfile(realpath)
    module_name=get_module_name(designf)
    time=get_time(designf)
    parameters=get_parameters(designf)
    IO=get_IO_signals(designf)
    with open(module_name+'_TB.sv', 'w+') as tbfile:
        tbfile.writelines(chr(47)+chr(42)+'\n'+\
                          '\n'+\
                          'description: \n'+\
                          'design file: '+realpath+'\n'+\
                          '\n'+\
                          chr(42)+chr(47)+'\n'+'\n')
        tbfile.write(time[0]+'\n'+'\n')
        if args.name is not None:
            tbfile.write('module '+args.name+'(); \n \n')
        else:
            tbfile.write('module '+module_name+'_TB(); \n \n')

        # parameters section:
        param_list=[]
        for j in parameters:
            for s in j:
                if s[-1]==chr(44):
                    new_s=s.replace(",", ";") 
                elif s[-1]==")":
                    new_s=s[:-1]+";"
                else: new_s=s
                tbfile.write(new_s+'\n')
                if new_s[0]=='p':
                    param_list.append((new_s.split()[-1]).split('=')[0])
        logging.info('parameter list:')            
        logging.info(param_list)
        del(parameters)

        # HALF_CLK and PERIOD parameter
        tbfile.write('localparam HALF_CLK=%s; \n' %(str(args.half_clk)))
        tbfile.write('localparam PERIOD=(2*HALF_CLK); \n \n')

        input_signal_list=[]
        output_signal_list=[]
        # signal decleration here:
        for j in IO:
            for s in j:
                if s[-1] ==",":
                    new_s=s.replace(",", ";")
                elif s[-1]==";" and s[-2]==")":
                    new_s=s[:-2]+";"
                elif s[-1]==")":
                    new_s=s[:-1]+";"
                else:
                    new_s=s+";"
                if new_s[0]=="i":
                    new_s=new_s.lstrip('input ')
                    input_signal_list.append((new_s.split()[-1])[:-1])
                else:
                    new_s=new_s.lstrip('output ')
                    output_signal_list.append((new_s.split()[-1])[:-1])
                tbfile.write(new_s+'\n')
        logging.info(input_signal_list)
        logging.info(output_signal_list)

        clk=get_clk(IO[0]);
        rst=get_reset(IO[0]);
        del IO
        
        # module instance here

        #always #() clk = ~clk section
        if clk is not None:
            tbfile.write('\n logic %s_en;' %(clk))
            tbfile.write('\n always #HALF_CLK %s = (%s) ? ~%s : %s; \n \n' %(clk, clk+'_en', clk, clk))
        '''
        except:
            logging.error('found more than one clock signal,\n \
            enter clock signal manually via -clk or --clock argument')
            for i in clk: logging.error(clk)
            delete_file()
            sys.exit('error')
        '''

        tbfile.write(module_name+" #\n")
        tbfile.write('\t(\n')
        for i in param_list:
            if i==param_list[-1]:
                tbfile.write("\t.%s(%s)\n" %(i, i))
            else:
                tbfile.write("\t.%s(%s),\n" %(i, i))
        tbfile.write('\t)\n')
        
        tbfile.write("DUT_%s\n" %(module_name))
        tbfile.write("\t(\n")
        tbfile.write('\t// inputs\n')
        for i in input_signal_list:
            tbfile.write("\t.%s(%s),\n" %(i, i))

        tbfile.write('\t// outputs\n')
        for i in output_signal_list:
            if i==output_signal_list[-1]:
                tbfile.write("\t.%s(%s)\n" %(i, i))
            else:
                tbfile.write("\t.%s(%s),\n" %(i, i))
        tbfile.write("\t);\n \n")
        

        tbfile.write('task init();\n')
        for i in input_signal_list:
            tbfile.write("%s='0;\n" %(i))
        tbfile.write('endtask // init()\n \n')
        
        tbfile.write('task reset();\n')
        tbfile.write('endtask // reset()\n \n')

        tbfile.write('initial begin\n')
        tbfile.write('init();\n')
        tbfile.write('#(4*PERIOD) $finish;\n')
        tbfile.write('end\n')
        tbfile.write('endmodule\n')
        

if __name__ == "__main__":
    main()
