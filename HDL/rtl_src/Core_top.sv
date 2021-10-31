/*
 
 
 
 */

module Core_top
  (
   input logic clk,
   input logic rstn
   );

   Core i_core(
	   .clk(clk),
	   .rstn(rstn));


endmodule // Core_top
