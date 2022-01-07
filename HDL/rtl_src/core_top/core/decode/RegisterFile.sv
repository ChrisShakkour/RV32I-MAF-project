/*///////////////////////////////////////////////////////////////////
  
 -> Block owner: Chris Shakkour - chrisshakkour@gmail.com       
                          
 -> Contributers: Shahar Dror - <mail>
 
 -> Description: parametric register file design,
    supports single write port, dual read ports.

 -> features:
    1. resetless registers.
    2. forwording when reading and writing to the same address
 
 */////////////////////////////////////////////////////////////////

`timescale 1ps/1ps

module RegisterFile #
  (parameter N_REGS=32,
   parameter R_WIDTH=32,
   localparam W_ADDR=$clog2(N_REGS))
   (
    input logic 	       clk,
    // Port 0 Write only:
    input logic 	       rs0_write,
    input logic [R_WIDTH-1:0]  rs0_data_in,
    input logic [W_ADDR-1:0]   rs0_addr,
    // Port 1 Read only:
    output logic [R_WIDTH-1:0] rs1_data_out,
    input logic [W_ADDR-1:0]   rs1_addr,
    // Port 2 Read only:
    output logic [R_WIDTH-1:0] rs2_data_out,
    input logic [W_ADDR-1:0]   rs2_addr
   );
   
   logic [N_REGS-1:0][R_WIDTH-1:0] internal_regs;
   
   /* reg x0 always Zero */
   always_ff @(posedge clk)
     internal_regs[0] <= '0;
   
   /* rs0 write port */
   always_ff @(posedge clk) 
     if(rs0_write && rs0_addr!=0) internal_regs[rs0_addr] <= rs0_data_in;
   
   /* rs1 read port */
   assign rs1_data_out = ((rs0_addr == rs1_addr) && (rs0_write)) ?
			  rs0_data_in : internal_regs[rs1_addr];
   
   /* rs2 read port */
   assign rs2_data_out = ((rs0_addr == rs2_addr) && (rs0_write)) ?
	  		  rs0_data_in : internal_regs[rs2_addr];
   
endmodule
