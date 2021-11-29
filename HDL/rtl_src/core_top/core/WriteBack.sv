/*
 
 
 
 */
module WriteBack
  import instructions_pkg::*;	  
  (
     input logic                        clk,
     input logic                        rstn,
     input logic  [XLEN-1:0]            AluData,
     input logic  [XLEN-1:0]            pc_pls4,
     input logic [MSB_REG_FILE-1:0]     rd,     
     input logic                        sel_next_pc,
     input logic                        ctrl_reg_wr,

     output logic [XLEN-1:0]            rdData,
     output logic [MSB_REG_FILE-1:0]    rdOut,
     output logic                       writeEn
     );

     assign rdData     = sel_next_pc ? pc_pls4 : AluData;
     assign writeEn    = ctrl_reg_wr;
     assign rdOut      = rd;     

//######### REGISTERS ##############


endmodule // WriteBack
