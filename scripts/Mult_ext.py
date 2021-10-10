'''



'''


import argparse
from bitstring import BitArray

def parse_args():
    parser = argparse.ArgumentParser(description='Testbench shell generator for single design module')
    parser.add_argument('--func', '-f', dest='function', required=True, choices=['MUL', 'MULH', 'MULHU', 'MULHSU', 'DIV', 'DIVU', 'REM', 'REMU']\
                        , help="Enter Mul extension command, MUL, MULH, MULHU, MULHSU, DIV, DIVU, REM, REMU")
    parser.add_argument('--OP_A', '-a', dest='OP_A' ,required=True, default=0, type=int\
                        , help='Enter operand A, type int [-2^31, (2^31)-1]')
    parser.add_argument('--OP_B', '-b', dest='OP_B', required=True, default=0, type=int\
                        , help='Enter operand B, type int [-2^31, (2^31)-1]')    
    args=parser.parse_args()
    return args

def get_bin(x, n=0):
    return'{0:{fill}{width}b}'.format((x + 2**n) % 2**n, fill='0', width=n)

def get_hex(x, n=8):
    val='0x{0:08X}'.format(x)
    return val

class Mult_operations():

    def func_selector(self, func, op_a, op_b):
        return getattr(self, func)(op_a, op_b)
    
    '''
    available resources here
    '''
    def Adder32bit(self, op_a, op_b):
        int_a=BitArray(bin=op_a).int
        int_b=BitArray(bin=op_b).int
        result= int_a + int_b
        return get_bin(result, 32)
    
    def Mult16x16U(self, op_a, op_b):
        int_a=int(op_a, 2)
        int_b=int(op_b, 2)
        result= int_a*int_b
        return get_bin(result, 32)

    def split16(self, operand):
        MSB=operand[:16]
        LSB=operand[16:]
        print("%s %s" %(MSB, LSB))
        return [LSB, MSB]

    def negate(self, operand):
        int_op=BitArray(bin=operand).int
        int_op=-int_op
        return get_bin(int_op, 32)

    def bitwise_not(self, operand):
        temp=operand.replace("0", "x")
        temp=temp.replace("1", "0")
        temp=temp.replace("x", "1")
        return temp
    
    def shift(self, operand, direction):
        if direction is "RIGHT":
            return(operand[16:]+get_bin(0, 16))
        else:
            return(get_bin(0, 16)+operand[:16])
                
    '''
    M-Extension commands
    '''
    def MUL(self, op_a, op_b):
        print('\n running MUL algorithim\n')
        a_sign=op_a[0]
        b_sign=op_b[0]
        result_sign="0" if(a_sign==b_sign) else "1"
        A=self.split16(self.negate(op_a) if(a_sign=="1") else op_a)
        B=self.split16(self.negate(op_b) if(b_sign=="1") else op_b)
        ''' cycle-1 '''
        mult=self.Mult16x16U(A[0], B[0])
        print('\n\t---- cycle-1 ----')
        print(" multipling %s x %s\n result=%s" %(A[0], B[0], mult))
        '''cycle-2'''
        adder=self.Adder32bit(mult, get_bin(0, 32))
        print('\n\t---- cycle-2 ----')
        print(" adding %s + %s\n result=%s" %(mult, get_bin(0, 32), adder))
        mult=self.Mult16x16U(A[0], B[1])
        print(" multipling %s x %s\n result=%s" %(A[0], B[1], mult))
        '''cycle-3'''
        temp=self.shift(mult, "RIGHT")
        print('\n\t---- cycle-3 ----')
        print(" adding %s + %s" %(adder, temp))
        adder=self.Adder32bit(adder, temp)
        print(" result = %s" %(adder))
        mult=self.Mult16x16U(A[1], B[0])
        print(" multipling %s x %s\n result=%s" %(A[1], B[0], mult))
        ''' cycle-4 '''
        temp=self.shift(mult, "RIGHT")
        print('\n\t---- cycle-4 ----')
        print(" adding %s + %s" %(adder, temp))
        adder=self.Adder32bit(adder, temp)
        print(" result = %s" %(adder))
        return self.negate(adder) if result_sign=="1" else adder
    
    def MULH(self, op_a, op_b):
        print('\n running MULH algorithim')
        ''' cycle-1 '''
        a_sign=op_a[0]
        b_sign=op_b[0]
        result_sign="1" if(a_sign!=b_sign) else "0"
        A=self.split16(self.negate(op_a) if(a_sign=="1") else op_a)
        B=self.split16(self.negate(op_b) if(b_sign=="1") else op_b)
        mult=self.Mult16x16U(A[0], B[0])
        trig1=1 if mult[16:]==get_bin(0, 16) else 0;
        print('\n\t---- cycle-1 ----')
        print(" multipling %s x %s\n result=%s" %(A[0], B[0], mult))
        '''cycle-2'''
        adder=self.Adder32bit(mult, get_bin(0, 32))
        print('\n\t---- cycle-2 ----')
        print(" adding %s + %s\n result=%s" %(mult, get_bin(0, 32), adder))
        mult=self.Mult16x16U(A[0], B[1])
        print(" multipling %s x %s\n result=%s" %(A[0], B[1], mult))
        '''cycle-3'''
        temp=self.shift(adder, "LEFT")
        print('\n\t---- cycle-3 ----')
        print(" adding %s + %s" %(mult, temp))
        adder=self.Adder32bit(mult, temp)
        print(" result = %s" %(adder))
        mult=self.Mult16x16U(A[1], B[0])
        print(" multipling %s x %s\n result=%s" %(A[1], B[0], mult))
        ''' cycle-4 '''
        print('\n\t---- cycle-4 ----')
        print(" adding %s + %s" %(adder, mult))
        adder=self.Adder32bit(mult, adder)
        print(" result = %s" %(adder))
        mult=self.Mult16x16U(A[1], B[1])
        print(" multipling %s x %s\n result=%s" %(A[1], B[1], mult))
        ''' cycle-5 '''
        trig2=1 if adder[16:]==get_bin(0, 16) else 0
        temp=self.shift(adder, "LEFT")
        print('\n\t---- cycle-5 ----')
        print(" adding %s + %s" %(mult, temp))
        adder=self.Adder32bit(mult, temp)
        print(" result = %s" %(adder))
        if (trig1 and trig2):
            return self.negate(adder) if result_sign=="1" else adder
        else:
            return self.bitwise_not(adder) if result_sign=="1" else adder
    
    def MULHU(self, op_a, op_b):
        print(' running MULHU algorithim')
        A=self.split16(op_a)
        B=self.split16(op_b)
        mult=self.Mult16x16U(A[0], B[0])
        print('\n\t---- cycle-1 ----')
        print(" multipling %s x %s\n result=%s" %(A[0], B[0], mult))
        '''cycle-2'''
        adder=self.Adder32bit(mult, get_bin(0, 32))
        print('\n\t---- cycle-2 ----')
        print(" adding %s + %s\n result=%s" %(mult, get_bin(0, 32), adder))
        mult=self.Mult16x16U(A[0], B[1])
        print(" multipling %s x %s\n result=%s" %(A[0], B[1], mult))
        '''cycle-3'''
        temp=self.shift(adder, "LEFT")
        print('\n\t---- cycle-3 ----')
        print(" adding %s + %s" %(mult, temp))
        adder=self.Adder32bit(mult, temp)
        print(" result = %s" %(adder))
        mult=self.Mult16x16U(A[1], B[0])
        print(" multipling %s x %s\n result=%s" %(A[1], B[0], mult))
        ''' cycle-4 '''
        print('\n\t---- cycle-4 ----')
        print(" adding %s + %s" %(adder, mult))
        adder=self.Adder32bit(mult, adder)
        print(" result = %s" %(adder))
        mult=self.Mult16x16U(A[1], B[1])
        print(" multipling %s x %s\n result=%s" %(A[1], B[1], mult))
        ''' cycle-5 '''
        temp=self.shift(adder, "LEFT")
        print('\n\t---- cycle-5 ----')
        print(" adding %s + %s" %(mult, temp))
        adder=self.Adder32bit(mult, temp)
        print(" result = %s" %(adder))
        return adder

    def MULHSU(self, op_a, op_b):
        print('running MULHSU algorithim')
        return self.MULH(op_a, op_b)
    
    def DIV(self, op_a, op_b):
        print('running DIV algorithim')
        pass
    
    def DIVU(self, op_a, op_b):
        print('running DIVU algorithim')
        pass
    
    def REM(self, op_a, op_b):
        print('running REM algorithim')
        pass
    
    def REMU(self, op_a, op_b):
        print('running REMU algorithim')
        pass

    
def main():
    print('running main...')
    args = parse_args();
    A=args.OP_A
    A_bin=get_bin(A, 32)
    B=args.OP_B
    B_bin=get_bin(B, 32)
    func=args.function
    print("operands recieved:")
    print("\tOP_A = %s, %s, %s" %(A, get_hex(A), A_bin))
    print("\tOP_B = %s, %s, %s" %(B, get_hex(B), B_bin))
    mult = Mult_operations()
    res=mult.func_selector(func, A_bin, B_bin)
    print("\n######## OUTPUT ########")
    print(res)
    soft=get_bin(A*B, 64)
    print("%s %s" %(soft[:32], soft[32:]))

    
if __name__ == "__main__":
    main()
