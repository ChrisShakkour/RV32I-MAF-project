/*///////////////////////////////////////////////////////////////////                                                             
 -> Block owner: Chris Shakkour - chrisshakkour@gmail.com       
                          
 -> Contributers: Shahar Dror - <mail>
 
 -> Description: parametric register file design,
    supports single write port, dual read ports.

 -> features:
    1. resetless registers.
    2. forwording when reading and writing to the same address
    3. error interrupt when addr is out of range. 
 
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
    output logic 	       rs0_addr_error,
    // Port 1 Read only:
    input logic 	       rs1_read,
    output logic [R_WIDTH-1:0] rs1_data_out,
    input logic [W_ADDR-1:0]   rs1_addr,
    output logic 	       rs1_addr_error,
    // Port 2 Read only:
    input logic 	       rs2_read,
    output logic [R_WIDTH-1:0] rs2_data_out,
    input logic [W_ADDR-1:0]   rs2_addr,
    output logic 	       rs2_addr_error
   );
   
   logic [N_REGS-1:0][R_WIDTH-1:0] internal_regs;
   logic 			   rs0_valid_addr;
   logic 			   rs1_forward;
   logic 			   rs1_valid_addr;
   logic 			   rs2_forward;
   logic 			   rs2_valid_addr;

   assign rs0_valid_addr = (rs0_addr inside{[0:N_REGS-1]});
   assign rs1_valid_addr = (rs1_addr inside{[0:N_REGS-1]});
   assign rs2_valid_addr = (rs2_addr inside{[0:N_REGS-1]});
   
   assign rs1_forward = ((rs1_addr==rs0_addr)
   	  	       &&(rs1_read)
		       &&(rs0_write));
   
   assign rs2_forward = ((rs2_addr==rs0_addr)
   	  	       &&(rs1_read)
		       &&(rs0_write));

   always_ff @(posedge clk)
     if(rs1_valid_addr & rs1_forward)   rs1_data_out <= rs0_data_in;
     else if(rs1_valid_addr & rs1_read) rs1_data_out <= internal_regs[rs1_addr];
 
   always_ff @(posedge clk)
     if(rs2_valid_addr & rs2_forward)   rs2_data_out = rs0_data_in;
     else if(rs2_valid_addr & rs2_read) rs2_data_out <= internal_regs[rs2_addr];
   
   always_ff @(posedge clk)
     internal_regs[0] <= '0;
   
   always_ff @(posedge clk)
     if(rs0_write && rs0_addr!=0) internal_regs[rs0_addr] <= rs0_data_in;
   
   always_ff @(posedge clk)
     if(~rs0_valid_addr & rs0_write) rs0_addr_error <= 1'b1;
     else                            rs0_addr_error <= 1'b0;
   
   always_ff @(posedge clk)
     if(~rs1_valid_addr & rs1_read) rs1_addr_error <= 1'b1;
     else                           rs1_addr_error <= 1'b0;

   always_ff @(posedge clk)
     if(~rs2_valid_addr & rs2_read) rs2_addr_error <= 1'b1;
     else                           rs2_addr_error <= 1'b0;
   
endmodule
