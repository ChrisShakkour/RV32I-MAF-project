module Forwarding_unit
  import instructions_pkg::*;
   import control_pkg::*;
   import memory_pkg::*;
   (
   input logic                    clk,
   input logic [MSB_REG_FILE-1:0] rs1_addr,
   input logic [MSB_REG_FILE-1:0] rs2_addr,
   input logic [MSB_REG_FILE-1:0] rd_Ps5,
   input logic [XLEN-1:0] 	  rs2_data_ps3,
   input logic [XLEN-1:0] 	  rs1_data_ps3,
   input logic [XLEN-1:0] 	  AluOut, 
   input logic [MSB_REG_FILE-1:0] rd_Ps6,
   input logic [XLEN-1:0] 	  DataWb,
   
   output logic [XLEN-1:0] 	  aluin_1_post,
   output logic [XLEN-1:0] 	  aluin_2_post

   );

   logic [MSB_REG_FILE-1:0] rs1_addr_s;
   logic [MSB_REG_FILE-1:0] rs2_addr_s;

   // Data hazard
   always_comb begin
   	if(rs1_addr_s == rd_Ps5)
	  aluin_1_post = AluOut;
        else if (rs1_addr_s == rd_Ps6)
	  aluin_1_post = DataWb;
        else
          aluin_1_post = rs1_data_ps3;
   end   

   always_comb begin
   	if(rs2_addr_s == rd_Ps5)
	  aluin_2_post = AluOut;
        else if (rs2_addr_s == rd_Ps6)
	  aluin_2_post = DataWb;
        else
          aluin_2_post = rs2_data_ps3;
   end   

   always_ff @(posedge clk) begin
	   rs1_addr_s <= rs1_addr;
	   rs2_addr_s <= rs2_addr;
   end

  endmodule
