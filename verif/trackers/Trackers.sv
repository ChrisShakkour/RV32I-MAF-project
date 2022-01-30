/*
 
 */

module Trackers
  #(parameter integer CYCLE_CNT_W=32)
   (
   input logic 			 trigger,
   input logic 			 test_undone,
   input logic [CYCLE_CNT_W-1:0] cycle_count,
   input logic 			 enable 			 
   );

   
   DecodedInstruction_trk
     #(.DEST_FILE("OUTPUT/simulate/trackers/DecodedInstruction_trk.log"),
       .CYCLE_CNT_W(CYCLE_CNT_W))
   DecodedInstruction_trk_inst
     (
      .trigger     (trigger),
      .test_undone (test_undone),
      .cycle_count (cycle_count),
      .enable      (enable)
      );
   

   DataMemTrans_trk
     #(.DEST_FILE("OUTPUT/simulate/trackers/DataMemTrans_trk.log"),
       .CYCLE_CNT_W(CYCLE_CNT_W))
   DataMemTrans_trk_inst
     (
      .trigger     (trigger),
      .test_undone (test_undone),
      .cycle_count (cycle_count),
      .enable      (enable)
      );

   
  
endmodule // trackers_binds
