/*
 
 
 
 */




module Core
  (
   input logic clk,
   input logic rstn
   );

   Decode
     Decode_Ps1
       (
	.clk(clk),
	.rstn(rstn)
	);
   
   InstructionFetch 
     InstructionFetch_Ps2
       (
	.clk   (clk),
	.rstn  (rstn)
	);

   ExecuteOne
     ExecuteOne_Ps3
       (
	.clk   (clk),
	.rstn  (rstn)
	);
   
   ExecuteTwo
     ExecuteTwo_Ps4
       (
	.clk   (clk),
	.rstn  (rstn)
	);
   
   LoadStore
     LoadStore_Ps5
       (
	.clk   (clk),
	.rstn  (rstn)
	);

   WriteBack
     WriteBack_Ps6
       (
	.clk   (clk),
	.rstn  (rstn)
	);
   
   IDMemory
     IDMemory_inst
       (
	.clk(clk),
	.rstn(rstn)
	);

endmodule // Core
