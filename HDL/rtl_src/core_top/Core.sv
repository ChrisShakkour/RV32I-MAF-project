/*
 
 
 
 */
module Core
  import instructions_pkg::*;
  (
   // inputs
   input logic 		   clk,
   input logic 		   rstn,
   
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
 logic [XLEN-1:0]         AluOut; 
 logic [MSB_REG_FILE-1:0] rd_Ps5;
 logic [XLEN-1:0]         AluOut_Ps6; 
 logic [MSB_REG_FILE-1:0] rd_Ps6;
 e_alu_sel                ctrl_sel_alu;
 logic [XLEN-1:0]         pc_ps2;
 logic [XLEN-1:0]         pc_ps3;
 logic [XLEN-1:0]         pc_pls4_ps2;
 logic [XLEN-1:0]         pc_pls4_ps3;
 logic [XLEN-1:0]         pc_pls4_ps5;
 logic [XLEN-1:0]         pc_pls4_ps6; 
 logic                    sel_next_pc_ps3;
 logic                    sel_next_pc_ps5;
 logic                    sel_next_pc_ps6; 
 logic                    ctrl_lui_inst_ps3;
 logic                    ctrl_mem_wr_ps3;
 logic                    ctrl_reg_wr_ps3;
 logic [1:0]              ctrl_mem_size_ps3;
 logic [XLEN-1:0]         rs2_data_ps3;
 logic                    ctrl_mem_wr_ps5;
 logic                    ctrl_reg_wr_ps5;
 logic [1:0]              ctrl_mem_size_ps5;
 logic [XLEN-1:0]         rs2_data_ps5;
 logic                    ctrl_reg_wr_ps6;

   InstructionFetch 
       InstructionFetch_Ps1
         (
	 .clk           (clk),
	 .rstn          (rstn),
	 .sel_next_pc   (sel_next_pc_ps6),
	 .alu_pc        (AluOut_Ps6),
	 .inst_request  (inst_fetch_port.REQ),
         .pc            (pc_ps2),
	 .pc_pls4       (pc_pls4_ps2)
    );

assign inst_fetch_port.ADDR = pc_ps2;

     Decode
       Decode_Ps2
       (
	 .clk               (clk),
	 .rstn              (rstn),
	 .Instruction       (inst_fetch_port.DATA),
	 .rd_Ps6            (rdWb),        //from ps6
	 .CtrlWriteEn       (EnWb),        //from ps6
	 .DataRd            (DataWb),      //from ps6
         .pc                (pc_ps2),
	 .pc_pls4           (pc_pls4_ps2),	 
	 .AluDataIn1        (AluDataIn1),
	 .AluDataIn2        (AluDataIn2),
	 .rd                (rd_Ps3),   
	 .ctrl_sel_alu      (ctrl_sel_alu),
	 .sel_next_pc_out   (sel_next_pc_ps3),
         .pc_out            (pc_ps3),
	 .pc_pls4_out       (pc_pls4_ps3),
         .ctrl_lui_inst     (ctrl_lui_inst_ps3),
         .ctrl_mem_wr       (ctrl_mem_wr_ps3),  
         .ctrl_reg_wr       (ctrl_reg_wr_ps3),  
         .ctrl_mem_size     (ctrl_mem_size_ps3),
	 .rs2_data_out      (rs2_data_ps3)
       );

     Execute
       ExecuteOne_Ps3
         (
	 .clk                  (clk),
	 .rstn                 (rstn),
         .AluDataIn1           (AluDataIn1),
         .AluDataIn2           (AluDataIn2),
         .rd                   (rd_Ps3),
	 .ctrl_sel_alu         (ctrl_sel_alu),                 	 
         .pc                   (pc_ps3),   
	 .sel_next_pc          (sel_next_pc_ps3),
	 .pc_pls4              (pc_pls4_ps3),
         .ctrl_lui_inst        (ctrl_lui_inst_ps3),
         .ctrl_mem_wr          (ctrl_mem_wr_ps3),  
         .ctrl_reg_wr          (ctrl_reg_wr_ps3),  
         .ctrl_mem_size        (ctrl_mem_size_ps3),
	 .rs2_data             (rs2_data_ps3),	 
         .AluOut               (AluOut),
         .rdOut                (rd_Ps5),
	 .sel_next_pc_out      (sel_next_pc_ps5),
	 .pc_pls4_out          (pc_pls4_ps5),
         .ctrl_mem_wr_out      (ctrl_mem_wr_ps5),  
         .ctrl_reg_wr_out      (ctrl_reg_wr_ps5),  
         .ctrl_mem_size_out    (ctrl_mem_size_ps5),
	 .rs2_data_out         (rs2_data_ps5)	 
    );

     LoadStore
       LoadStore_Ps5
       (
	 .clk               (clk),
	 .rstn              (rstn),
   	 .AluData           (AluOut),
   	 .rd                (rd_Ps5),   
	 .sel_next_pc       (sel_next_pc_ps5),	 
	 .pc_pls4           (pc_pls4_ps5),
         .ctrl_mem_wr       (ctrl_mem_wr_ps5),  
         .ctrl_reg_wr       (ctrl_reg_wr_ps5),  
         .ctrl_mem_size     (ctrl_mem_size_ps5),
	 .rs2_data          (rs2_data_ps5),	 	 
   	 .AluOut            (AluOut_Ps6),
   	 .rdOut             (rd_Ps6),
	 .sel_next_pc_out   (sel_next_pc_ps6),
	 .pc_pls4_out       (pc_pls4_ps6),
         .ctrl_reg_wr_out   (ctrl_reg_wr_ps6),  	 	 
         .load_store_port   (load_store_port)	 
	);

   WriteBack
       WriteBack_Ps6
         (
	 .clk           (clk),
	 .rstn          (rstn),
         .AluData       (AluOut_Ps6),
         .rd            (rd_Ps6),
	 .sel_next_pc   (sel_next_pc_ps6),	 
	 .pc_pls4       (pc_pls4_ps6),	
         .ctrl_reg_wr   (ctrl_reg_wr_ps6),  	 
         .rdData        (DataWb),
         .rdOut         (rdWb),
	 .writeEn       (EnWb)
	);
   
endmodule // Core
