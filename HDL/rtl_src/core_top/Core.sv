/*
 
 
 
 */
`include "../../packages/defines.sv"
module Core
  (
   input  logic                 clk,
   input  logic                 rstn,
   input  logic                 pc_rstn,    
   input  logic  [X_LEN-1:0]    FirstInstAdd,
   
   output logic  [X_LEN-1:0]    pc
   );
     
   InstructionFetch 
       InstructionFetch_Ps1
         (
	 .clk           (clk),
	 .rstn          (rstn),
         .pc_rstn       (pc_rstn), 
         .FirstInstAdd  (FirstInstAdd),

         .pc            (pc)
    );

     Decode
       Decode_Ps2
       (
	 .clk           (clk),
	 .rstn          (rstn),
	 .Instruction   (Instruction),
	 .rd_Ps6        (rdWb),        //from ps6
	 .CtrlWriteEn   (EnWb),        //from ps6
	 .DataRd        (DataWb),      //from ps6
	 
	 .AluDataIn1    (AluDataIn1),
	 .AluDataIn2    (AluDataIn2),
	 .rd            (rd_Ps3),   
	 .ir            (ir_Ps3)           
       );

     Execute
       ExecuteOne_Ps3
         (
	 .clk           (clk),
	 .rstn          (rstn),
         .ir            (ir_Ps3),
         .AluDataIn1    (AluDataIn1),
         .AluDataIn2    (AluDataIn2),
         .rd            (rd_Ps3),   
                    
         .AluOut        (AluOut),
         .rdOut         (rd_Ps5),   
         .irOut         (ir_Ps5)
    );

     LoadStore
       LoadStore_Ps4
       (
	 .clk           (clk),
	 .rstn          (rstn),
   	 .AluData       (AluOut),
   	 .rd            (rd_Ps5),   
   	 .ir            (ir_Ps5),

   	 .AluOut        (AluOut_Ps6),
   	 .rdOut         (rd_Ps6),   
   	 .irOut         (ir_Ps6)
	);

   WriteBack
       WriteBack_Ps6
         (
	 .clk           (clk),
	 .rstn          (rstn),
         .AluData       (AluOut_Ps6),
         .rd            (rd_Ps6),   
         .ir            (ir_Ps6),

         .rdData        (DataWb),
         .rdOut         (rdWb),
	 .writeEn       (EnWb)
	);
   
endmodule // Core
