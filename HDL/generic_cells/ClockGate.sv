/*///////////////////////////////////////////////////////////////////                                                   
 
 -> Block owner: Chris Shakkour - chrisshakkour@gmail.com
 -> Contributers:
  
 -> Description: active low clock gate.
 
 *///////////////////////////////////////////////////////////////////

module ClockGate
  (
   input logic clock,
   input logic enable,
   output logic gated_clock
   );

   logic 	latched_en;
   always_latch
     if(~clock) latched_en <= enable;
   assign gated_clock = latched_en & clock;

endmodule // ClockGate
