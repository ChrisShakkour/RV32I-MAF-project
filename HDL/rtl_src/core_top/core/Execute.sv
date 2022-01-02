/*///////////////////////////////////////////////////////////////////
 
 -> Block owner:  Shahar Dror - add your email if you wish 
 -> Contributers: Chris Shakkour - chrisshakkour@gmail.com
 
 -> Description: Execution macine.
 
 -> Features: 2-stage,
              ALU,
              integer MUL/DIV unit
              float   MUL/DIV unit
 
 -> module:
   ___                      _        
  | __|__ __ ___  __  _  _ | |_  ___ 
  | _| \ \ // -_)/ _|| || ||  _|/ -_)
  |___|/_\_\\___|\__| \_,_| \__|\___|
                                                                      
 *////////////////////////////////////////////////////////////////////

module Execute
  import instructions_pkg::*;
   import control_pkg::*;
  (
   input logic 			   clk,
   input logic 			   rstn,
   // alu control signals
   input 			   e_alu_operation_sel ctrl_alu_op_sel,
   input 			   e_alu_operand_a_sel ctrl_alu_a_sel, 
   input 			   e_alu_operand_b_sel ctrl_alu_b_sel,
   //
   input 			   e_regfile_wb_sel ctrl_wb_to_rf_sel_in, 
   output 			   e_regfile_wb_sel ctrl_wb_to_rf_sel,
   input logic 			   set_alu_lsb_bit_zero,
   // data comming from decoder
   input logic [XLEN-1:0] 	   pc,
   input logic [XLEN-1:0] 	   pc_pls4,
   input logic [XLEN-1:0] 	   rs1_data,
   input logic [XLEN-1:0] 	   rs2_data,
   input logic [MSB_REG_FILE-1:0]  rd_addr,
   input logic [XLEN-1:0] 	   immediate, 
   
   input logic 			   ctrl_reg_wr, 
   // data memory control signals
   // input from decode stage
   input logic 			   ctrl_dmem_req_in, 
   input logic 			   ctrl_dmem_write_in, 
   input logic 			   ctrl_dmem_l_unsigned_in, 
   input logic [1:0] 		   ctrl_dmem_n_bytes_in,
   // output to LoadStore stage
   output logic 		   ctrl_dmem_req, 
   output logic 		   ctrl_dmem_write, 
   output logic 		   ctrl_dmem_l_unsigned, 
   output logic [1:0] 		   ctrl_dmem_n_bytes,
   //
   output logic [XLEN-1:0] 	   AluOut,
   output logic [MSB_REG_FILE-1:0] rdOut,
   output logic [XLEN-1:0] 	   pc_pls4_out,
   output logic 		   ctrl_reg_wr_out ,
   output logic [XLEN-1:0] 	   rs2_data_out,

   // branch compare 
   // ctrl and status
   input logic 			   branch_enable,
   input 			   e_branch_operation_sel branch_operation, 
   output 			   e_branch_result branch_result_masked,

   input logic 			   ctrl_jump_request_in,
   output logic 		   ctrl_jump_request   
   );

   // branch pre smapled result
   e_branch_result branch_result_masked_pre;   
   
   logic [XLEN-1:0] 		   AluOut_nxt;
   logic [XLEN-1:0] 		   AluOut_nxt_lsb_set;
   
   logic [XLEN-1:0] AluDataIn1;
   logic [XLEN-1:0] AluDataIn2;
   

   // Operand A MUX select
   always_comb begin
      unique case(ctrl_alu_a_sel)
	ALU_ZERO:
	  AluDataIn1 = '0;
	ALU_RS1:
	  AluDataIn1 = rs1_data;
	ALU_PC:
	  AluDataIn1 = pc;
	default:
	  AluDataIn1 = '0;
      endcase   
   end


   // Operand B MUX select
   always_comb begin
      unique case(ctrl_alu_b_sel)
	ALU_RS2:
	  AluDataIn2 = rs2_data;
	ALU_IMM:
	  AluDataIn2 = immediate;
      endcase
   end

   
/*/////////////////////
     _    _    _   _ 
    /_\  | |  | | | |
   / _ \ | |__| |_| |
  /_/ \_\|____|\___/ 
 
 */////////////////////
   
always_comb begin
   
   case (ctrl_alu_op_sel)
		ALU_ADD : AluOut_nxt = AluDataIn1 +    AluDataIn2;
		ALU_SUB : AluOut_nxt = AluDataIn1 -    AluDataIn2;
		ALU_SLT : AluOut_nxt = $signed(AluDataIn1) < $signed(AluDataIn2) ? 32'd1 : 32'b0; 
		ALU_SLTU: AluOut_nxt = AluDataIn1 <    AluDataIn2                ? 32'd1 : 32'b0; 
		ALU_OR  : AluOut_nxt = AluDataIn1 |    AluDataIn2;
		ALU_AND : AluOut_nxt = AluDataIn1 &    AluDataIn2;
		ALU_XOR : AluOut_nxt = AluDataIn1 ^    AluDataIn2;
		ALU_SLL : AluOut_nxt = AluDataIn1 <<   AluDataIn2[4:0];
		ALU_SRL : AluOut_nxt = AluDataIn1 >>   AluDataIn2[4:0];
		ALU_SRA : AluOut_nxt = $signed(AluDataIn1) >>>  AluDataIn2[4:0]; //TODO check
	endcase 
end // always_comb

   
   assign AluOut_nxt_lsb_set = AluOut_nxt & {{XLEN-1{1'b1}}, ~set_alu_lsb_bit_zero};
  
   
/*///////////////////////////////////////////////////
   ___                       _                      
  | _ ) _ _  __ _  _ _   __ | |_    __  _ __   _ __ 
  | _ \| '_|/ _` || ' \ / _|| ' \  / _|| '  \ | '_ \
  |___/|_|  \__,_||_||_|\__||_||_| \__||_|_|_|| .__/
                                              |_|   
  BranchComparator Unit
 *////////////////////////////////////////////////////

   BranchComparator
     BranchComparator_inst
       (
	.rs1_data      (rs1_data),
	.rs2_data      (rs2_data),
    	.enable        (branch_enable),
	.operation     (branch_operation), 
	.result_masked (branch_result_masked_pre)	     
	);

      
/*////////////////////////////////////////////
    ___  ___   _  _  _____  ___   ___   _    
   / __|/ _ \ | \| ||_   _|| _ \ / _ \ | |   
  | (__| (_) || .` |  | |  |   /| (_) || |__ 
   \___|\___/ |_|\_|  |_|  |_|_\ \___/ |____|
                                             
   Async Reset registers
 *////////////////////////////////////////////

   always_ff @(posedge clk or negedge rstn)
     if(~rstn) branch_result_masked <= BRANCH_NOT_TAKEN; //1'b0
     else      branch_result_masked <= branch_result_masked_pre;
   
   always_ff @(posedge clk)
     rs2_data_out <= rs2_data;
   always_ff @(posedge clk)
     ctrl_reg_wr_out   <= ctrl_reg_wr; 

   // data memory control signals sampling
   always_ff @(posedge clk) begin       	
      if(~rstn) begin
	 ctrl_dmem_req        <= '0;
	 ctrl_dmem_write      <= '0;
	 ctrl_dmem_l_unsigned <= '0;
	 ctrl_dmem_n_bytes    <= '0;     
      end
      else begin
	 ctrl_dmem_req        <= ctrl_dmem_req_in;
	 ctrl_dmem_write      <= ctrl_dmem_write_in;
	 ctrl_dmem_l_unsigned <= ctrl_dmem_l_unsigned_in;
	 ctrl_dmem_n_bytes    <= ctrl_dmem_n_bytes_in;     
      end
   end
   
   always_ff @(posedge clk or negedge rstn)
     if(~rstn) ctrl_wb_to_rf_sel <= WB_ALU_OUT;
     else      ctrl_wb_to_rf_sel <= ctrl_wb_to_rf_sel_in;


   always_ff @(posedge clk or negedge rstn)
     if(~rstn) ctrl_jump_request <= 1'b0;
     else      ctrl_jump_request <= ctrl_jump_request_in;   
   
   
/*///////////////////////
   ___    _  _____  _                        
  |   \  /_\|_   _|/_\                       
  | |) |/ _ \ | | / _ \                      
  |___//_/ \_\|_|/_/ \_\                     
                         
   Ressetless registers                    
 *///////////////////////

   always_ff @(posedge clk)
     AluOut <= AluOut_nxt_lsb_set;

   always_ff @(posedge clk)
     rdOut <= rd_addr;

   always_ff @(posedge clk)
     pc_pls4_out <= pc_pls4;
   
endmodule 

