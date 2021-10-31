/*
 
 
 
 */

module Core
  (
   input logic clk,
   input logic rstn
   );

   InstructionFetch 
     InstructionFetch_Ps1
       (
	.clk               (clk),
	.rstn              (rstn),
        .Pc_ps1_rstn       (Pc_ps1_rstn),  
        .Pc_ps1            (Pc_ps1) // To ins Mem
       );

   Decode
     Decode_Ps2
       (
        .clk               (clk),
        .rstn              (rstn),
        .InstructionPs2    (InstructionPs2),
        .Ctrl_rd_Ps6       (Ctrl_rd_Ps6),
        .Ctrl_WriteEn_Ps   (Ctrl_WriteEn_Ps6),
        .Data_rd_Ps6       (Data_rd_Ps6),
        .Data_in2_Ps3      (Data_in2_Ps3),
        .Data_in1_Ps3      (Data_in1_Ps3),
        .Ctrl_ALU_Ps3      (Ctrl_ALU_Ps3),
        .Ctrl_rd_Ps3       (Ctrl_rd_Ps3),
        .Ctrl_func7_Ps3    (Ctrl_func7_Ps3)

	);
   
   Execute
     ExecuteOne_Ps3
       (
        .clk               (clk),
        .rstn              (rstn),
        .Date_in2_Ps3      (Date_in2_Ps3),
        .Data_in1_Ps3      (Data_in1_Ps3),
        .Ctrl_ALU_Ps3      (Ctrl_ALU_Ps3), //func3 for now
        .Ctrl_rd_Ps3       (Ctrl_rd_Ps3),
        .Ctrl_func7_Ps4    (Ctrl_func7_Ps4)   	
	);
   
   LoadStore
     LoadStore_Ps4
       (
	.clk   (clk),
	.rstn  (rstn)
	);

   WriteBack
     WriteBack_Ps5
       (
         .clk                (clk),
         .rstn               (rstn),
         .Data_ALUout_Ps6    (Data_ALUout_Ps6),
         .Data_WriteBack_Ps6 (Data_rd_Ps6)
	);
   
   IDMemory
     IDMemory_inst
       (
	.clk(clk),
	.rstn(rstn)
	);

endmodule // Core
