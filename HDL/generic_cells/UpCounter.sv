/*///////////////////////////////////////////////////////////////////
 
 -> Block owner: Chris Shakkour - chrisshakkour@gmail.com
 -> Contributers:
 
 -> Description: Up counter that counts always up in a 
                 parametrized rate INCREMENT_RATE
                 default is 1.
                    
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
    output logic 	     overflow,
    output logic [WIDTH-1:0] count_val
    );
   
   always_ff @(posedge clk or negedge rstn)
     if(~rstn)   {overflow, count_val} <= '0;
     else if(en) {overflow, count_val} <= count_val + INCREMENT_RATE; //carry fed into overflow
   
endmodule
