/*
 
 
 
 */
`include "../../packages/defines.sv"
module Core
  import instructions_pkg::*;
  (
   // inputs
   input logic 		   clk,
   input logic 		   rstn,
   input logic 		   pc_rstn, 
   input logic [XLEN-1:0]  FirstInstAdd,
   
   // mem interface
   mem_read_only.core_side inst_fetch_port,
   mem_read_write.core_side load_store_port
   );

 logic [MSB_REG_FILE-1:0] rdWb;
 logic                    EnWb; 
 logic [XLEN-1:0]         DataWb;
 logic [XLEN-1:0]         AluDataIn1;
 logic [XLEN-1:0]         AluDataIn2; 
 logic [MSB_REG_FILE-1:0] rd_Ps3;
 logic [INST_WIDTH-1:0]   ir_Ps3;
 logic [XLEN-1:0]         AluOut; 
 logic [MSB_REG_FILE-1:0] rd_Ps5;
 logic [INST_WIDTH-1:0]   ir_Ps5;
 logic [XLEN-1:0]         AluOut_Ps6; 
 logic [MSB_REG_FILE-1:0] rd_Ps6;
 logic [INST_WIDTH-1:0]   ir_Ps6;


   InstructionFetch 
       InstructionFetch_Ps1
         (
	 .clk           (clk),
	 .rstn          (rstn),
         .pc_rstn       (pc_rstn), 
         .FirstInstAdd  (FirstInstAdd),
	 .inst_request  (inst_fetch_port.REQ),
         .pc            (inst_fetch_port.ADDR)
    );

     Decode
       Decode_Ps2
       (
	 .clk           (clk),
	 .rstn          (rstn),
	 .Instruction   (inst_fetch_port.DATA),
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
