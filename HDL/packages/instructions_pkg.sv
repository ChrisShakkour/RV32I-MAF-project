/*
 
 
 
 NOP = ADDI, x0, x0, 0
 
*/

package instructions_pkg;

   parameter integer OPCODE_W=7;
   parameter integer FUNCT3_W=3;
   parameter integer FUNCT5_W=5;
   parameter integer FUNCT7_W=7;


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
   


   /* M-extension funct3 codes */
   typedef enum logic [FUNCT3_W-1:0]
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



   /* immediate funct3 codes */
   typedef enum logic [FUNCT3_W-1:0]
   {
    ADDI  = 3'b000,
    SLTI  = 3'b010,
    SLTIU = 3'b011,
    XORI  = 3'b100,
    ORI   = 3'b110,
    ANDI  = 3'b111,
    SLLI  = 3'b001,
    SRLAI  = 3'b101    //SRAI + SRLI
    } e_imm_funct3;



   
   // RV32I = 47
   // M = 8
   // A = 11
   // F = 26  
  /* parameter integer N_INSTRUCTIONS=92;
   localparam integer INST_WIDTH=$clog2(N_INSTRUCTIONS);
   typedef enum logic [INST_WIDTH-1:0] 
   {
   MUL = 2'b00
    } e_micro_instructions;
   */


endpackage // instructions_pkg
   
