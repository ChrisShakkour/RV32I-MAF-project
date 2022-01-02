/*

description: 
design file: /home/christians/git/RV32I-MAF-project/HDL/rtl_src/core_top/core/execute/BranchComparator.sv

*/

`timescale 1ns/1ns

module BranchComparator_TB; 

   import control_pkg::*;
   
   parameter integer DATA_W=instructions_pkg::XLEN;
   localparam HALF_CLK=5; 
   localparam PERIOD=(2*HALF_CLK); 
   
   logic [DATA_W-1:0] rs1_data;
   logic [DATA_W-1:0] rs2_data;
   logic 	      branch_enable;
   
   e_branch_operation_sel operation;
   e_branch_result result_masked;

   BranchComparator #
     (
      .DATA_W(DATA_W)
      )
   DUT_BranchComparator
     (
       // inputs
       .rs1_data      (rs1_data),
       .rs2_data      (rs2_data),
       .enable (branch_enable),
       .operation     (operation),
       // outputs
       .result_masked (result_masked)
       );
 
   task init();
      rs1_data='0;
      rs2_data='0;
      branch_enable='0;
      operation=CMP_BEQ;
   endtask // init()
   
   task reset();
   endtask // reset()


   task set_branch;
      input logic [DATA_W-1:0] a, b;
      input e_branch_operation_sel op;
      
      rs1_data = a;
      rs2_data = b;
      operation = op;
      branch_enable=1'b1;
      #PERIOD;
      branch_enable=1'b0;
   endtask // set_branch
   
      
   initial begin
      #(4*PERIOD) init();
      
      #(4*PERIOD);
      set_branch('h00, 'h00, CMP_BEQ);  //TAKEN
      set_branch('h00, 'h00, CMP_BNE);  //NOT TAKEN
      set_branch('h00, 'h00, CMP_BLT);  //NOT TAKEN
      set_branch('h00, 'h00, CMP_BLTU); //NOT TAKEN
      set_branch('h00, 'h00, CMP_BGE);  //TAKEN
      set_branch('h00, 'h00, CMP_BGEU); //TAKEN
      #(4*PERIOD);
      
      #(4*PERIOD);
      set_branch($signed(-50), $signed(-51), CMP_BEQ);  //NOT TAKEN
      set_branch($signed(-50), $signed(-51), CMP_BNE);  //TAKEN
      set_branch($signed(-50), $signed(-51), CMP_BLT);  //NOT TAKEN
      set_branch($signed(-50), $signed(-51), CMP_BLTU); //NOT TAKEN
      set_branch($signed(-50), $signed(-51), CMP_BGE);  //TAKEN
      set_branch($signed(-50), $signed(-51), CMP_BGEU); //TAKEN
      #(4*PERIOD);

      #(4*PERIOD);      
      set_branch($signed(-50), $unsigned(51), CMP_BEQ);  //NOT TAKEN
      set_branch($signed(-50), $unsigned(51), CMP_BNE);  //TAKEN
      set_branch($signed(-50), $unsigned(51), CMP_BLT);  //TAKEN
      set_branch($signed(-50), $unsigned(51), CMP_BLTU); //NOT TAKEN
      set_branch($signed(-50), $unsigned(51), CMP_BGE);  //NOT TAKEN
      set_branch($signed(-50), $unsigned(51), CMP_BGEU); //TAKEN
      #(4*PERIOD);

      #(4*PERIOD);
      set_branch('h80000000, 'h80000001, CMP_BLT);  //TAKEN      negative < negative
      set_branch('h80000000, 'h00000001, CMP_BLT);  //TAKEN      negative < positive
      set_branch('h00000000, 'h80000000, CMP_BLT);  //NOT TAKEN  positive < negative
      set_branch('h00000000, 'h00000001, CMP_BLT);  //TAKEN      positive < positive
      #(4*PERIOD);

      #(4*PERIOD);
      set_branch('h80000000, 'h80000001, CMP_BGE);  //NOT TAKEN  negative >= negative
      set_branch('h80000000, 'h00000001, CMP_BGE);  //NOT TAKEN  negative >= positive
      set_branch('h00000000, 'h80000000, CMP_BGE);  //TAKEN      positive >= negative
      set_branch('h00000000, 'h00000001, CMP_BGE);  //NOT TAKEN  positive >= positive
      #(4*PERIOD);      
      
      #(4*PERIOD) $finish;
   end
endmodule
