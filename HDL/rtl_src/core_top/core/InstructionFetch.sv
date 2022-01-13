/*
 
 
 
 
 */

module InstructionFetch 
  import instructions_pkg::*;
   import control_pkg::*;
   (
    input logic 		    clk,
    input logic 		    rstn,

    //
    input logic 		    first_fetch_trigger,

    // pc stall control
    input logic 		    pc_stall_set,
    input logic 		    load_hazzard_stall,

    //
    input 			    e_branch_result branch_result,
    input logic 		    jump_request,
    input logic [XLEN-1:0] 	    calculated_pc,

    output logic 		    inst_request, //instruction request
    output logic [XLEN-1:0] 	    inst_addr, //instruction address

    output logic [XLEN-1:0] 	    pc_out, //pc   going to pipeline
    output logic [XLEN-1:0] 	    pc_pls4_out   //pc+4 going to pipeline
    );
   
   
   logic 		    calc_pc_sel;
   logic [XLEN-1:0] 	    pc;   
   logic [XLEN-1:0] 	    pc_pls4;

   logic 		    prev_pc_stall_set;
   logic 		    pc_stall;
   logic 		    pc_enable;

   logic 		    branch_stall;
   logic 		    branch_taken;
   
   logic 		    fetch_enable;
   logic 		    fetch_stall;

   /* branch taken internal signal */
   assign branch_taken = (branch_result == BRANCH_TAKEN);
   
   /* pc mux selector */
   assign calc_pc_sel = jump_request | branch_taken;

   /* pc+4 adder */
   assign pc_pls4 = inst_addr + 4;
   
   /* address of next instruction */
   assign inst_addr = (calc_pc_sel) ? calculated_pc : pc ;
   assign inst_request = fetch_enable & ~fetch_stall; 

   /* stall fetching */
   assign fetch_stall = pc_stall;
  
   /* pc stall logic */
   assign pc_enable = fetch_enable & ~pc_stall;
   assign pc_stall = branch_stall | load_hazzard_stall;
   assign branch_stall = pc_stall_set | (prev_pc_stall_set & ~branch_taken);

   
   
 /*//////////////////////////////////////////////////////
    ___   ___    ___            _              _ 
   | _ \ / __|  / __| ___  _ _ | |_  _ _  ___ | |
   |  _/| (__  | (__ / _ \| ' \|  _|| '_|/ _ \| |
   |_|   \___|  \___|\___/|_||_|\__||_|  \___/|_|
  
  *//////////////////////////////////////////////////////

      
   //TODO: create a state machine for controling the PC
   //states: IDLE, CPU_GO, FLUSH, STALL, CPU_DONE   
   always_ff @(posedge clk or negedge rstn)
     if(~rstn)                    fetch_enable <= 1'b0;
     else if(first_fetch_trigger) fetch_enable <= 1'b1;

   /* internal pc reg */
   always_ff @(posedge clk or negedge rstn)
     if (!rstn)         pc <= '0;
     else if(pc_enable) pc <= pc_pls4;

   always_ff @(posedge clk or negedge rstn)
     if(~rstn) prev_pc_stall_set <= 1'b0;
     else      prev_pc_stall_set <= pc_stall_set;
   
   /* output pc register to decode stage*/
   always_ff @(posedge clk) begin
      pc_out      <= inst_addr;
      pc_pls4_out <= pc_pls4;
   end
   
endmodule // InstructionFetch
