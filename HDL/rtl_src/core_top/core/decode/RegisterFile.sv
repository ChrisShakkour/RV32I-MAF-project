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
    input logic 	       rs1_read,
    input logic 	       rs1_forward,
    output logic [R_WIDTH-1:0] rs1_data_out,
    input logic [W_ADDR-1:0]   rs1_addr,
    // Port 2 Read only:
    input logic 	       rs2_read,
    input logic 	       rs2_forward,
    output logic [R_WIDTH-1:0] rs2_data_out,
    input logic [W_ADDR-1:0]   rs2_addr
   );
   
   logic [N_REGS-1:0][R_WIDTH-1:0] internal_regs;
   logic 			   rs1_frwd;
   logic 			   rs2_frwd;
   
   assign rs1_frwd = ((rs1_addr==rs0_addr)
   	  	      &&(rs1_forward)
		      &&(rs1_read)
		      &&(rs0_write));
   
   assign rs2_frwd = ((rs2_addr==rs0_addr)
   	  	      &&(rs2_forward)
		      &&(rs2_read)
		      &&(rs0_write));

   /* rs0 write port */
   always_ff @(posedge clk)
     if(rs0_write && rs0_addr!=0) internal_regs[rs0_addr] <= rs0_data_in;
   
   /* rs1 read port */
   always_ff @(posedge clk)
     if(rs1_frwd)      rs1_data_out <= rs0_data_in;
     else if(rs1_read) rs1_data_out <= internal_regs[rs1_addr];

   /* rs2 read port */
   always_ff @(posedge clk)
     if(rs2_frwd)      rs2_data_out = rs0_data_in;
     else if(rs2_read) rs2_data_out <= internal_regs[rs2_addr];
   
   /* reg x0 always Zero */
   always_ff @(posedge clk)
     internal_regs[0] <= '0;

   
endmodule
