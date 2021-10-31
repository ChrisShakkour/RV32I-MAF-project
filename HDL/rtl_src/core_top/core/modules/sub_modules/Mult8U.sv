/*///////////////////////////////////////////////////////////////////                                   
  -> Block owner: Chris Shakkour - chrisshakkour@gmail.com
 
 -> Contributers: 
 
 -> Description: 8 bit unsigned multiplier
 
 -> features: 
 
*////////////////////////////////////////////////////////////////////

`timescale 1ps/1ps

module Mult8U #
  (localparam integer WIDTH=8)
   (
    input logic [WIDTH-1:0]    operand_a,
    input logic [WIDTH-1:0]    operand_b, 
    output logic [2*WIDTH-1:0] result
    );

   assign result = $unsigned(operand_a) * $unsigned(operand_b);
endmodule // Mult8U

   
