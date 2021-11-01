/*
 
 
 
 
 */

module InstructionFetch 
  (
   input logic clk,
  <<<<<<< Chris-initial_pipe_bring_up
     input logic rstn
     );

  =======
     input logic rstn,
     input logic Pc_ps1_rstn, // program counter reset

     output t_xlen Pc_ps1, // progarm counter

     );

     //Program counter
     always_ff @(posedge clk or negedge (Pc_ps1_rstn & rstn)) 
       begin
         if (!(Pc_ps1_rstn & rstn)))
           Pc_ps1 <= t_xlen'b0;
         else
           Pc_ps1 <= Pc_ps1 + t_xlen'd4;
       end
  >>>>>>> main




endmodule // InstructionFetch
