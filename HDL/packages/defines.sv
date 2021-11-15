// all the OP_CODE of Flot instructions 
`define F_OP {7'b0000111,7'b0100111,7'b1000011,7'b1000111,7'b1001011,7'b1001111,7'b1010011}	   

`define TYPE_BITS    5 : 3
`define ALU_SEL_BITS 2 : 0
`define FUNC3_BITS   14:12
`define RD_BITS      11: 7
`define RS1_BITS     19:15
`define RS2_BITS     24:20
`define IMM_BITS     31:20
`define SHAMT_BITS   24:20
         
parameter X_LEN        = 32;
parameter MSB_REG_FILE = 5;   
parameter MSB_I_MEM    = 9;
