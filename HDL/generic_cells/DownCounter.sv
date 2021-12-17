

`timescale 1ns/1ns

module DownCounter
  #(
    parameter integer WIDTH=3)
   (
    input logic 	    clk,
    input logic 	    rstn,

    input logic 	    enable,
    input logic 	    set,
    input logic [WIDTH-1:0] count,
    output logic 	    status
    );

   logic [WIDTH-1:0] 	    curr_value;
   logic [WIDTH-1:0] 	    next_value;
   
   always_comb begin      
      status     = 1'b0;
      next_value = '0;      
      if(curr_value != '0) begin
	 status     = 1'b1;
	 next_value = curr_value-1;	 
      end
   end   
   
   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn) curr_value <= '0;
      else if(enable)
	if(set) curr_value <= count;
	else    curr_value <= next_value;
   end
   
endmodule // DownCounter
