/*///////////////////////////////////////////////////////////////////
 
 -> Block owner: Chris Shakkour - chrisshakkour@gmail.com
 -> Contributers:
 
 -> Description: Up counter that counts always up in a 
                 parametrized rate INCREMENT_RATE
                 default is 1.
 -> features:
    1. async reset.
    2. sync clear anytime.
                    
 *///////////////////////////////////////////////////////////////////


module UpCounter
  #(
    parameter integer INCREMENT_RATE=1,
    parameter integer WIDTH=8
    ) 
   (
    input logic 	     clk,
    input logic 	     rstn,
    input logic 	     en,
    input logic 	     clear,
    output logic 	     overflow,
    output logic [WIDTH-1:0] count_val
    );

   logic [WIDTH:0] 	     next_value;

   assign next_value = count_val + INCREMENT_RATE;

   always_ff @(posedge clk or negedge rstn)
     if(~rstn)       {overflow, count_val} <= '0;
     else if (clear) {overflow, count_val} <= '0;
     else if(en)     {overflow, count_val} <=  next_value;
   
endmodule
