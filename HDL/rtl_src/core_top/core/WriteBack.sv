/*
 
 
 
 */
module WriteBack
  import instructions_pkg::*;
   import memory_pkg::*;
   import control_pkg::*;
   (
    input logic 		     clk,
    input logic 		     rstn,
    input logic [XLEN-1:0] 	     AluData,
    input logic [XLEN-1:0] 	     pc_pls4,
    input logic [MSB_REG_FILE-1:0]   rd, 

    // TODO: add data memory 
    // address error signal + logic
    input logic [MEM_WORD_WIDTH-1:0] dmem_load_data,
    //
    input logic 		     ctrl_reg_wr,
    input 			     e_regfile_wb_sel ctrl_wb_to_rf_sel_in,   
   
    output logic [XLEN-1:0] 	     rdData,
    output logic [MSB_REG_FILE-1:0]  rdOut,
    output logic 		     writeEn
    );

   assign writeEn    = ctrl_reg_wr;
   assign rdOut      = rd;     

   always_comb begin
      unique case(ctrl_wb_to_rf_sel_in)
	WB_ALU_OUT:
	  rdData = AluData;
	WB_MEM_LOAD:
	  rdData = dmem_load_data;
	WB_PC_PLS4:
	  rdData = pc_pls4;
	default
	  rdData = AluData;
      endcase // unique case (ctrl_wb_to_rf_sel_in)
   end // always_comb
   
endmodule // WriteBack
