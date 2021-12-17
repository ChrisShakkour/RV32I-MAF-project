/*
 
 
 
 
 */

module InstructionFetch 
  import instructions_pkg::*;
   (
    input logic 	    clk,
    input logic 	    rstn,
    input logic 	    sel_next_pc,
    input logic [XLEN-1:0]  alu_pc,
    
    output logic 	    inst_request, //instruction request
    output logic [XLEN-1:0] pc,           //instruction address
    output logic [XLEN-1:0] pc_out,       //pc   going to pipeline
    output logic [XLEN-1:0] pc_pls4_out   //pc+4 going to pipeline
    );

   logic [XLEN-1:0] 	    pc_nxt;
   logic [XLEN-1:0] 	    pc_pls4;
   
   assign pc_pls4 = pc + 4; 

   //TODO: create a state machine for controling the PC
   //states: IDLE, CPU_GO, FLUSH, STALL, CPU_DONE
   assign pc_nxt = sel_next_pc ? alu_pc : pc_pls4;
   assign inst_request = 1'b1; 

   //######## REGISTERS ########################
   
   always_ff @(posedge clk or negedge rstn)
     if (!rstn) pc <= '0;
     else       pc <= pc_nxt;
   
   always_ff @(posedge clk) begin
      pc_out      <= pc;
      pc_pls4_out <= pc_pls4;
   end
   
endmodule // InstructionFetch
