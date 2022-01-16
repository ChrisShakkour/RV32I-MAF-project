


`timescale 1ns/1ns

module LoadHazzardUnit
  #(parameter integer ADDR_WIDTH=instructions_pkg::MSB_REG_FILE)
  (
   input logic 			load_req,
   input logic 			load_enable,
   input logic [ADDR_WIDTH-1:0] rd,
   input logic [1:0] 		rsx_active, 
   input logic [ADDR_WIDTH-1:0] rs1,
   input logic [ADDR_WIDTH-1:0] rs2,
   output logic 		load_hazzard_stall,
   output logic 		nop_req		
   ); 			

   logic 			load_trigger;
   logic 			rs1_hazzard;
   logic 			rs2_hazzard;
   
   assign load_trigger = load_req & load_enable;
   assign rs1_hazzard = ((rd==rs1) & rsx_active[0]);
   assign rs2_hazzard = ((rd==rs2) & rsx_active[1]);

   assign nop_req = (load_trigger & (rs1_hazzard | rs2_hazzard));
   assign load_hazzard_stall = nop_req;
      
endmodule // LoadHazzardUnit
   
