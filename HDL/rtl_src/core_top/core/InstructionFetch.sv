/*
 
 
 
 
 */

`include "../../../packages/defines.sv"
module InstructionFetch 
  import instructions_pkg::*;
  (
   input  logic                 clk,
   input  logic                 rstn,
   input  logic                 pc_rstn, 
   input  logic  [X_LEN-1:0]    FirstInstAdd,

   output logic  [X_LEN-1:0]    pc
     );

     assign pc_nxt = pc + 4;

//######## REGISTERS ########################

     always_ff @(posedge clk or negedge (pc_rstn & rstn)) 
       begin
         if (!(pc_rstn & rstn))
           pc <= FirstInstAdd;
         else
           pc <= pc_nxt;
       end
endmodule // InstructionFetch
