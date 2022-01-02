/*
 
 
 
 */
module LoadStore 
  import instructions_pkg::*;
   import control_pkg::*;
   import memory_pkg::*;  
   (
   input logic 			     clk,
   input logic 			     rstn,
   input logic [XLEN-1:0] 	     AluData,
   input logic [MSB_REG_FILE-1:0]    rd, 
   input logic [XLEN-1:0] 	     pc_pls4, 
   input logic 			     ctrl_reg_wr,
   input logic [XLEN-1:0] 	     rs2_data,
   // data memory control signals
   input logic 			     ctrl_dmem_req_in, 
   input logic 			     ctrl_dmem_write_in, 
   input logic 			     ctrl_dmem_l_unsigned_in, 
   input logic [1:0] 		     ctrl_dmem_n_bytes_in,
   output logic [MEM_WORD_WIDTH-1:0] dmem_load_data,
   input 			     e_regfile_wb_sel ctrl_wb_to_rf_sel_in, 
   output 			     e_regfile_wb_sel ctrl_wb_to_rf_sel,

   
   output logic [XLEN-1:0] 	     AluOut,
   output logic [MSB_REG_FILE-1:0]   rdOut,
   output logic [XLEN-1:0] 	     pc_pls4_out,
   output logic 		     ctrl_reg_wr_out,
				     mem_read_write.core_side load_store_port   
);
   // inputs to mem
   assign load_store_port.REQ        = ctrl_dmem_req_in;
   assign load_store_port.WRITE_EN   = ctrl_dmem_write_in;
   assign load_store_port.L_UNSIGNED = ctrl_dmem_l_unsigned_in;
   assign load_store_port.N_BYTES    = ctrl_dmem_n_bytes_in;
   assign load_store_port.ADDR       = AluData;
   assign load_store_port.W_DATA     = rs2_data;
   // outputs from mem 
   assign dmem_load_data = load_store_port.R_DATA;
   //assign x = load_store_port.ADDR_ERR; 
   
   

   
//######### REGISTERS ##############

always_ff @(posedge clk)
	AluOut <= AluData;

always_ff @(posedge clk)
	rdOut <= rd;

always_ff @(posedge clk)
	pc_pls4_out <= pc_pls4;

always_ff @(posedge clk)
	ctrl_reg_wr_out <=ctrl_reg_wr;

   always_ff @(posedge clk or negedge rstn)
     if(~rstn) ctrl_wb_to_rf_sel <= WB_ALU_OUT;
     else      ctrl_wb_to_rf_sel <= ctrl_wb_to_rf_sel_in;
   
endmodule
