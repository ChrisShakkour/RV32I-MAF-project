/*
 
 
 
 
 */

module InstructionFetch 
  import instructions_pkg::*;
  (
   input  logic 	    clk,
   input  logic 	    rstn,
   input  logic             sel_next_pc,
   input  logic [XLEN-1:0]  alu_pc,

   output logic 	    inst_request,
   output logic [XLEN-1:0]  pc,
   output logic [XLEN-1:0]  pc_pls4   
     );
   
   logic [XLEN-1:0] 	       pc_nxt;
   logic [XLEN-1:0] 	       pc_pls4_nxt;

   assign pc_pls4_nxt = pc + 4; 
   assign pc_nxt = sel_next_pc ? alu_pc : pc_pls4_nxt;
   assign inst_request = 1'b1;
   

//######## REGISTERS ########################

     always_ff @(posedge clk or negedge rstn) 
       begin
         if (!rstn)
           pc <= '0;
         else
           pc <= pc_nxt;
       end

       always_ff @(posedge clk)
	   pc_pls4 <= pc_pls4_nxt;

endmodule // InstructionFetch
