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
    input logic [NOP_CNT_WIDTH-1:0] pc_stall_count, 

    //
    input 			    e_branch_result branch_result,
    input logic 		    jump_request,
    input logic [XLEN-1:0] 	    calculated_pc,

    output logic 		    inst_request, //instruction request
    output logic [XLEN-1:0] 	    inst_addr, //instruction address

    output logic [XLEN-1:0] 	    pc_out, //pc   going to pipeline
    output logic [XLEN-1:0] 	    pc_pls4_out   //pc+4 going to pipeline
    );
   
   
   logic 		    pc_select;
   logic [XLEN-1:0] 	    pc;   
   logic [XLEN-1:0] 	    pc_nxt;
   logic [XLEN-1:0] 	    pc_pls4;
   logic 		    pc_stall;
   
   logic 		    fetch_enable;
   logic 		    pc_enable;



 /*//////////////////////////////////////////////////////
    ___   ___    ___            _              _ 
   | _ \ / __|  / __| ___  _ _ | |_  _ _  ___ | |
   |  _/| (__  | (__ / _ \| ' \|  _|| '_|/ _ \| |
   |_|   \___|  \___|\___/|_||_|\__||_|  \___/|_|
  
  *//////////////////////////////////////////////////////

   DownCounter
     #(.WIDTH(NOP_CNT_WIDTH))
   DownCounter_inst
     (
      .clk    (clk),
      .rstn   (rstn),
      .enable (1'b1),
      .set    (pc_stall_set),
      .count  (pc_stall_count),
      .status ()
      );

   assign pc_stall = pc_stall_set;
   assign pc_enable = fetch_enable & ~pc_stall;
   assign inst_request = pc_enable | pc_select; 
   
   assign inst_addr = (pc_select) ? calculated_pc : pc ;
   assign pc_select = jump_request | (branch_result == BRANCH_TAKEN);
   
   assign pc_pls4 = inst_addr + 4;

   
   //TODO: create a state machine for controling the PC
   //states: IDLE, CPU_GO, FLUSH, STALL, CPU_DONE   
   always_ff @(posedge clk or negedge rstn)
     if(~rstn)                    fetch_enable <= 1'b0;
     else if(first_fetch_trigger) fetch_enable <= 1'b1;

   /* internal pc reg */
   always_ff @(posedge clk or negedge rstn)
     if (!rstn)         pc <= '0;
     else if(pc_enable) pc <= pc_pls4;

   /* output pc register to decode stage*/
   always_ff @(posedge clk) begin
      pc_out      <= inst_addr;
      pc_pls4_out <= pc_pls4;
   end
   
endmodule // InstructionFetch
