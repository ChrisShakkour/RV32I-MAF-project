/*
 
 
 */

package control_pkg;

   // ALU operations number
   parameter integer ALU_OP_N = 10;
   parameter integer ALU_OP_W = $clog2(ALU_OP_N);
   
   //parameter integer BRANCH_TAKEN = 1'b1;
   //parameter integer BRANCH_NOT_TAKEN = 1'b0;
   
   
   /* ALU select operation options*/
   typedef enum logic [ALU_OP_W-1:0]
   {
    ALU_ADD  = 4'b0000 ,
    ALU_SUB  = 4'b1000 ,
    ALU_SLT  = 4'b0010 ,
    ALU_SLTU = 4'b0011 ,
    ALU_SLL  = 4'b0001 , 
    ALU_SRL  = 4'b0101 ,
    ALU_SRA  = 4'b1101 ,
    ALU_XOR  = 4'b0100 ,
    ALU_OR   = 4'b0110 ,
    ALU_AND  = 4'b0111
    } e_alu_operation_sel;

   
   // ALU select operand A
   typedef enum logic [1:0]
   {
    ALU_RS1  = 2'b00,
    ALU_PC   = 2'b01,
    ALU_ZERO = 2'b10
    } e_alu_operand_a_sel;

   
   // ALU select operand B
   typedef enum logic [0:0]
   {
    ALU_RS2 = 1'b0,
    ALU_IMM = 1'b1
    } e_alu_operand_b_sel;


   // RegisterFile data 
   // writeback select
   typedef enum logic [1:0]
   {
    WB_ALU_OUT  = 2'b00,
    WB_MEM_LOAD = 2'b01,
    WB_PC_PLS4  = 2'b10
    } e_regfile_wb_sel;
   

   /*branch operation select
    for branch compare unit*/
   typedef enum logic [2:0]
   {
    CMP_BEQ  = 3'b000,
    CMP_BNE  = 3'b001,
    CMP_BLT  = 3'b100,
    CMP_BGE  = 3'b101,
    CMP_BLTU = 3'b110,
    CMP_BGEU = 3'b111
    } e_branch_operation_sel;
   

   /*branch result*/
   typedef enum logic [0:0]
   {
    BRANCH_NOT_TAKEN = 1'b0,
    BRANCH_TAKEN     = 1'b1
    } e_branch_result;


   /*forwarding unit*/
   typedef enum logic [1:0]
   {
    NO_HAZARD  = 2'b00,
    FROM_EXE   = 2'b01,
    FROM_LS    = 2'b10,
    FROM_WB    = 2'b11
    } e_data_hazard;

   
   
		
   
endpackage // control_pkg

   
