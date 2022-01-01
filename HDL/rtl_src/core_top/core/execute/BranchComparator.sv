/*///////////////////////////////////////////////////////////////////
 
 -> Block owner: Chris Shakkour - chrisshakkour@gmail.com
 -> Contributers:
 
 -> Description: Branch compare module.
 
 -> Features: xnor comparator 32bit, 
              single unsigned subctractor 32bit,
              2x negate 32bit, 8->1 mux
 
 -> module:
   ___                       _       ___                                   
  | _ ) _ _  __ _  _ _   __ | |_    / __| ___  _ __   _ __  __ _  _ _  ___ 
  | _ \| '_|/ _` || ' \ / _|| ' \  | (__ / _ \| '  \ | '_ \/ _` || '_|/ -_)
  |___/|_|  \__,_||_||_|\__||_||_|  \___|\___/|_|_|_|| .__/\__,_||_|  \___|
                                                     |_|                   
  *////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

module BranchComparator
  import control_pkg::*;
   #(parameter integer DATA_W=instructions_pkg::XLEN)
   (
    input logic [DATA_W-1:0] rs1_data,
    input logic [DATA_W-1:0] rs2_data,
    input logic 	     enable,

    input 		     e_branch_operation_sel operation, 
    output 		     e_branch_result result_masked	     
    );
   
   logic [DATA_W-1:0] 	     operand_a;
   logic [DATA_W-1:0] 	     operand_b;
   logic [DATA_W-1:0] 	     subtraction;
   logic 		     borrow;
   e_branch_result           result;
      
   logic 		     a_equals_b;
   logic 		     a_less_than_b;

   
   // and gate to mask 
   // branch result
   assign result_masked = (enable)? result : BRANCH_NOT_TAKEN;
      
   // bitwise Xnor gate comparator, 
   // bitwise results goes into AND gate 
   assign a_equals_b = &(operand_a ~^ operand_b);
   
   // less than comparator, single unsigned subtractor, 
   // borrow signal is the result.
   assign {borrow, subtraction} = $unsigned(operand_a) - $unsigned(operand_b);
   assign a_less_than_b = borrow;
			 
   always_comb begin
      operand_a = rs1_data ;
      operand_b = rs2_data ;
      result = BRANCH_NOT_TAKEN;
      
      unique case(operation)
	/*xnor signed comparator*/
	CMP_BEQ:
	  if(a_equals_b)
	    result = BRANCH_TAKEN;

	/*xnor signed comparator*/	
	CMP_BNE:
	  if(~a_equals_b)
	    result = BRANCH_TAKEN;

	/*signed subtractor*/
	CMP_BLT: begin
	   operand_a = rs1_data[31] ? -rs1_data : rs1_data ;
	   operand_b = rs2_data[31] ? -rs2_data : rs2_data ;
	   unique case({rs2_data[31], rs1_data[31]})
	     // rs2 positive, rs1 positive
	     2'b00:
	       if(a_less_than_b)
		 result = BRANCH_TAKEN;
	     
	     // rs2 positive, rs1 negative
	     2'b01:
	       result = BRANCH_TAKEN;
	     
	     // rs2 negative, rs1 positive
	     2'b10:
	       result = BRANCH_NOT_TAKEN;
	     
	     // rs2 negative, rs1 negative
	     2'b11:
	       if(~a_less_than_b)
		 result = BRANCH_TAKEN;
	   endcase	   
	end
	
	CMP_BGE: begin
	   operand_a = rs1_data[31] ? -rs1_data : rs1_data ;
	   operand_b = rs1_data[31] ? -rs2_data : rs2_data ;
	   unique case({rs2_data[31], rs1_data[31]})
	     // rs2 positive, rs1 positive
	     2'b00:
	       if(~a_less_than_b)
		 result = BRANCH_TAKEN;
	     
	     // rs2 positive, rs1 negative
	     2'b01:
	       result = BRANCH_NOT_TAKEN;
	     
	     // rs2 negative, rs1 positive
	     2'b10:
	       result = BRANCH_TAKEN;
	     
	     // rs2 negative, rs1 negative
	     2'b11:
	       if(a_less_than_b)
		 result = BRANCH_TAKEN;
	   endcase
	end
	
	CMP_BLTU:
	  if(a_less_than_b)
	    result = BRANCH_TAKEN;
	
	CMP_BGEU:
	  if(~a_less_than_b)
	    result = BRANCH_TAKEN;
	
	default:;
      endcase
   end
   
endmodule // BranchComparator
