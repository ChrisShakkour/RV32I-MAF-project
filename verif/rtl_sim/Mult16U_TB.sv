/*

description: 
design file: /home/christians/git/RV32I-MAF-Mult/rtl_src/core/modules/sub_modules/Mult16U.sv

*/

`timescale 1ps/1ps

module Mult16U_TB; 
 
   localparam integer WIDTH=16;
   localparam HALF_CLK=5; 
   localparam PERIOD=(2*HALF_CLK); 
 
   logic [WIDTH-1:0]  operand_a;
   logic [WIDTH-1:0]  operand_b;
   logic [2*WIDTH-1:0] result;

   Mult16U 
     DUT_Mult16U
       (
	// inputs
	.operand_a(operand_a),
	.operand_b(operand_b),
	// outputs
	.result(result)
	);
   
   task init();
      operand_a='0;
      operand_b='0;
   endtask // init()
   
   task reset();
   endtask // reset()
   
   initial begin
      init();
      for(int i=0; i<10; i++) begin
	 #(4*PERIOD);
	 operand_a = $random;
	 operand_b = $random;
      end
      #(4*PERIOD);
      operand_a='1;
      operand_b='1;
      //#(4*PRIOD);
      #(4*PERIOD) $finish;
   end
endmodule
