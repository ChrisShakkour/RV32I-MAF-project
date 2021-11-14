/*
 
 
 
 */
`include "../../../packages/defines.sv"
module WriteBack
  import instructions_pkg::*;	  
  (
     input logic                        clk,
     input logic                        rstn,
     input logic  [XLEN-1:0]            AluData,
     input logic  [MSB_REG_FILE-1:0]    rd,   
     input logic  [INST_WIDTH-1:0]      ir,

     output logic [XLEN-1:0]            rdData,
     output logic [MSB_REG_FILE-1:0]    rdOut,
     output logic                       writeEn
     );

     assign rdData     = AluData;
     assign writeEn    = 1'b1;
     assign rdOut      = rd;     

//######### REGISTERS ##############


endmodule // WriteBack
