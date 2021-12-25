/*
 
 
 
 NOP = ADDI, x0, x0, 0
 
*/


package instructions_pkg;

   parameter integer INST_W=32;
   parameter integer ADDR_W=$clog2(INST_W);
   
   parameter integer OPCODE_W=7;
   parameter integer FUNCT3_W=3;
   parameter integer FUNCT5_W=5;
   parameter integer FUNCT7_W=7;
   
   parameter integer MSB_REG_FILE = 5;   
   parameter integer XLEN         = 32;    
   typedef logic [XLEN-1:0] t_xlen;


   parameter integer NOP_CNT_WIDTH = 3;
   parameter         NOP = 'h00000013;
   

   /* R-type commands:
    ADD, SUB, SLL, SLT,
    SLTU, XOR, SRL, SRA,
    OR, AND, MUL, MULH,
    MULHSU, MULHU, DIV,
    DIVU, REM, REMU,
    ATOMIC instructions
    */
   typedef enum logic [OPCODE_W-1:0]
   {
    MUL_AND_INT = 7'b0110011,
    ATOMIC      = 7'b0101111 
    } e_type_r_instruction;


   
   /* I-type commands:
    ADDI, SLTI, SLTIU,
    ANDI, ORI, XORI,
    SLLI, SRLI, SRAI, 
    JALR, LB, LH, LW,
    LBU, LHU
    */
   typedef enum logic [OPCODE_W-1:0]
   {
    LOAD = 7'b0000011,
    JALR = 7'b1100111,
    IMM  = 7'b0010011 
    } e_type_i_instruction;


   
   /* U-type commands:
    LUI, LUIPC
    */
   typedef enum logic [OPCODE_W-1:0]
   {
    LUI   = 7'b0110111,
    AUIPC = 7'b0010111
    } e_type_u_instruction;

   

   /* J-type commands:
    JAL, 
    */
   typedef enum logic [OPCODE_W-1:0]
   {
    JAL = 7'b1101111
    } e_type_j_instruction;
   

	
   /* B-type commands:
    BEQ, BNE, BLT,
    BLTU, BGE, BGEU
    */
   typedef enum logic [OPCODE_W-1:0]
   {
    BRANCH = 7'b1100011
    } e_type_b_instruction;



   /* S-type commands:
    SB, SH, SW 
    */
   typedef enum logic [OPCODE_W-1:0]
   {
    STORE=7'b0100011
    } e_type_s_instruction;

   

   /* instruction type clasification */
   typedef struct
   {
      e_type_r_instruction R_TYPE; 
      e_type_i_instruction I_TYPE;
      e_type_s_instruction S_TYPE;
      e_type_b_instruction B_TYPE;
      e_type_u_instruction U_TYPE;
      e_type_j_instruction J_TYPE;
    } t_type_opcode;
   

   /* I&R funct3 codes */
   typedef enum  logic [FUNCT3_W-1:0]
   {
    ADD_SUB = 3'b000, //SUB if funct7[5] is high
    SLL     = 3'b001,
    SLT     = 3'b010,
    SLTU    = 3'b011,
    XOR     = 3'b100,
    SRL_SRA = 3'b101, //SRA if funct7[5] is high
    OR      = 3'b110,
    AND     = 3'b111
    } e_r2r_funct3;
 
   
   /* I&R funct3 codes */
   typedef enum  logic [FUNCT3_W-1:0]
    {
     ADDI      = 3'b000,
     SLTI      = 3'b010,
     SLTIU     = 3'b011,
     XORI      = 3'b100,
     ORI       = 3'b110,
     ANDI      = 3'b111,
     SLLI      = 3'b001,
     SRLI_SRAI = 3'b101 //SRAI if funct7[5] is high
     } e_imm_funct3;

   /* M-extension funct3 codes */
   typedef enum  logic [FUNCT3_W-1:0]
   {
    MUL    = 3'b000,
    MULH   = 3'b001,
    MULHSU = 3'b010,
    MULHU  = 3'b011,
    DIV    = 3'b100,
    DIVU   = 3'b101,
    REM    = 3'b110,
    REMU   = 3'b111
    } e_mult_funct3;
   

   /* MUL_AND_INT funct 7 codes */
   typedef enum  logic [FUNCT7_W-1:0]
   {
    R_NORMAL    = 7'b0000000,
    R_SPECIALS  = 7'b0100000,
    M_EXTENSION = 7'b0000001
    } e_rtype_funct7;    
   
   /* A-extension funct5 codes */
   typedef enum logic [FUNCT5_W-1:0]
   {
    LR      = 5'b00010,
    SC      = 5'b00011,
    AMOSWAP = 5'b00001,
    AMOADD  = 5'b00000,
    AMOXOR  = 5'b00100,
    AMOAND  = 5'b01100,
    AMOOR   = 5'b01000,
    AMOMIN  = 5'b10000,
    AMOMAX  = 5'b10100,
    AMOMINU = 5'b11000,
    AMOMAXU = 5'b11100
    } e_atomic_funct5;
  

   /* branch funct3 codes */
   typedef enum logic [FUNCT3_W-1:0]
   {
    BEQ  = 3'b000,
    BNE  = 3'b001,
    BLT  = 3'b100,
    BGE  = 3'b101,
    BLTU = 3'b110,
    BGEU = 3'b111
    } e_branch_funct3;


   /* load funct3 codes */
   typedef enum logic [FUNCT3_W-1:0]
   {
    LB  = 3'b000,
    LH  = 3'b001,
    LW  = 3'b010,
    LBU = 3'b100,
    LHU = 3'b101
    } e_load_funct3;
   

   /* store funct3 codes */
   typedef enum logic [FUNCT3_W-1:0]
   {
    SB  = 3'b000,
    SH  = 3'b001,
    SW  = 3'b010
    } e_store_funct3;
   
    

// ##

   typedef enum  logic [8:0]
   {
    INS_ADD   ,         
    INS_SUB   ,      
    INS_SLL   ,       
    INS_SLT   ,       
    INS_SLTU  ,       
    INS_XOR   ,       
    INS_SRL   ,      
    INS_SRA   ,      
    INS_OR    ,       
    INS_AND   ,       
    INS_ADDI  ,       
    INS_SLTI  ,       
    INS_SLTIU ,       
    INS_XORI  ,        
    INS_ORI   ,        
    INS_ANDI  ,        
    INS_SLLI  ,        
    INS_SRLI  ,      
    INS_SRAI  ,      
    INS_MUL   ,      
    INS_MULH  ,      
    INS_MULHSU,      
    INS_MULHU ,      
    INS_DIV   ,      
    INS_DIVU  ,      
    INS_REM   ,      
    INS_REMU  ,      
    INS_BEQ   ,      
    INS_BNE   ,      
    INS_BLT   ,      
    INS_BGE   ,      
    INS_BLTU  ,      
    INS_BGEU  ,      
    INS_LB    ,      
    INS_LH    ,      
    INS_LW    ,      
    INS_LBU   ,      
    INS_LHU   ,      
    INS_SB    ,      
    INS_SH    ,      
    INS_SW    ,
    INS_JALR  ,
    INS_JAL   ,
    INS_LUI   ,
    INS_AUIPC ,
    INS_NOP
    } e_all_inst;

endpackage // instructions_pkg
   
