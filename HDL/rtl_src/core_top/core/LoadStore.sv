/*
 
 
 
 */
`include "../../../packages/defines.sv"
module LoadStore 
  import instructions_pkg::*;
  (
   input logic                       clk,
   input logic                       rstn,
   input logic [XLEN-1:0]            AluData,
   input logic [MSB_REG_FILE-1:0]    rd,   
   input logic [INST_WIDTH-1:0]      ir,

   output logic [XLEN-1:0]           AluOut,
   output logic [MSB_REG_FILE-1:0]   rdOut,   
   output logic [INST_WIDTH-1:0]     irOut
);

//######### REGISTERS ##############

always_ff @(posedge clk)
	AluOut <= AluData;

always_ff @(posedge clk)
	rdOut <= rd;

always_ff @(posedge clk)
	irOut <= ir;


endmodule
