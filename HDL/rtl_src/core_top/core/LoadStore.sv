/*
 
 
 
 */
module LoadStore 
  import instructions_pkg::*;
  import memory_pkg::*;  
  (
   input logic                       clk,
   input logic                       rstn,
   input logic [XLEN-1:0]            AluData,
   input logic [MSB_REG_FILE-1:0]    rd,   
   input logic                       sel_next_pc,
   input logic [XLEN-1:0]            pc_pls4,   
   input logic                       ctrl_mem_wr  ,
   input logic                       ctrl_reg_wr  ,
   input logic [1:0]                 ctrl_mem_size,
   input logic [XLEN-1:0]            rs2_data,

   output logic [XLEN-1:0]           AluOut,
   output logic [MSB_REG_FILE-1:0]   rdOut,
   output logic                      sel_next_pc_out,
   output logic [XLEN-1:0]           pc_pls4_out,
   output logic                      ctrl_reg_wr_out,
   mem_read_write.core_side          load_store_port   
);


assign load_store_port.REQ      = ctrl_mem_wr;
assign load_store_port.WRITE_EN = ctrl_mem_wr;
assign load_store_port.N_BYTES  = ctrl_mem_size;
assign load_store_port.ADDR     = AluData;
assign load_store_port.W_DATA   = rs2_data;

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
	if(!rstn)
	sel_next_pc_out <= 1'b0;
	else
	sel_next_pc_out <= sel_next_pc;

endmodule
