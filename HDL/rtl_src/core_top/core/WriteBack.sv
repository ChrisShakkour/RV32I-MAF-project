/*
 
 
 
 */

module WriteBack
  (
  <<<<<<< Chris-initial_pipe_bring_up
     input logic clk,
     input logic rstn
     );


  =======
     input  logic	       clk,
     input  logic	       rstn,
     input  t_xlen       Data_ALUout_Ps6,

     output t_xlen       Data_WriteBack_Ps6,
     );

  assign Data_WriteBack_Ps6 = Data_ALUout_Ps6;

endmodule // WriteBack
