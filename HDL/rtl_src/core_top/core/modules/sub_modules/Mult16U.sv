/*///////////////////////////////////////////////////////////////////
 -> Block owner: Chris Shakkour - chrisshakkour@gmail.com
 
 -> Contributers:
 
 -> Description: 16x16 bit multiplyer using 4 8x8 multiplyer, 
                 single cycle.
 -> features:
 
 *//////////////////////////////////////////////////////////////////

`timescale 1ps/1ps

module Mult16U #
  (localparam integer WIDTH=16)
   (
    input logic [WIDTH-1:0]  operand_a,
    input logic [WIDTH-1:0]  operand_b,
    output logic [2*WIDTH-1:0] result
    );

   logic [1:0][7:0] 	     partition_a;
   logic [1:0][7:0] 	     partition_b;
   logic [3:0][15:0] 	     partial_mult;
   logic [16:0] 	     partial_sum_1;
   logic [24:0] 	     partial_sum_2;
   logic [24:0] 	     partial_sum_3; 	     

   assign partition_a[0] = operand_a[7:0];
   assign partition_a[1] = operand_a[15:8];
   assign partition_b[0] = operand_b[7:0];
   assign partition_b[1] = operand_b[15:8];
   
   assign partial_sum_1 = {{8{1'b0}}, partial_mult[0][15:8]} + partial_mult[1];       //16bit+16bit = 16bit+carry
   assign partial_sum_2 = {partial_mult[3], {8{1'b0}}} + {{8{1'b0}}, partial_mult[2]};   //24bit+24bit = 24bit+carry
   assign partial_sum_3 = {{7{1'b0}}, partial_sum_1} + partial_sum_2;               //(24bit+carry)+24bit = 24bit+carry
   assign result = {partial_sum_3, partial_mult[0][7:0]};
   
			 
   Mult8U Mult8U_00_inst
     (.operand_a(partition_a[0]),
      .operand_b(partition_b[0]),
      .result(partial_mult[0]));

   Mult8U Mult8U_01_inst
     (.operand_a(partition_a[0]),
      .operand_b(partition_b[1]),
      .result(partial_mult[1]));

   Mult8U Mult8U_10_inst
     (.operand_a(partition_a[1]),
      .operand_b(partition_b[0]),
      .result(partial_mult[2]));

   Mult8U Mult8U_11_inst
     (.operand_a(partition_a[1]),
      .operand_b(partition_b[1]),
      .result(partial_mult[3]));

endmodule
