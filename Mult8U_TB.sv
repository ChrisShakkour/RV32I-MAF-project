/*

description: 
design file: /home/christians/git/RV32I-MAF-Mult/rtl_src/core/modules/sub_modules/Mult8U.sv

*/

`timescale 1ps/1ps

module Mult8U_TB(); 
 
localparam integer WIDTH=8;
localparam HALF_CLK=5; 
localparam PERIOD=(2*HALF_CLK); 
 
logic [WIDTH-1:0]    operand_a;
logic [WIDTH-1:0]    operand_b, ;
logic [2*WIDTH-1:0] result;
Mult8U #
	(
	)
DUT_Mult8U
	(
	// inputs
	.operand_a(operand_a),
	.(),
	// outputs
	.result(result)
	);
 
task init();
operand_a='0;
='0;
endtask // init()
 
task reset();
endtask // reset()
 
initial begin
init();
#(4*PERIOD) $finish;
end
endmodule
