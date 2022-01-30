

`timescale 1ns/1ns

module DecodedInstruction_trk
  #(parameter string DEST_FILE,
    localparam integer CYCLE_CNT_W=32,
    localparam integer INST_W=instructions_pkg::XLEN)
   (
    input logic 		  trigger,
    input logic 		  test_undone,
    input logic [CYCLE_CNT_W-1:0] cycle_count,
    input logic 		  enable
    );

   bit 		       trigger_arrived;
   int 		       filePtr;

   /* tracking signals */
   logic 	       clk;
   logic 	       rstn;
   logic [INST_W-1:0]  instruction;
   
   assign clk = TaiLung.Core_inst.Decode_inst.clk;
   assign rstn = TaiLung.Core_inst.Decode_inst.rstn;
   assign instruction = TaiLung.Core_inst.Decode_inst.instruction;    
   
   task print_header();
      $fwrite(filePtr, "---------------------------------------\n");
      $fwrite(filePtr, "| Time [ns] |    cycle   |   instr    |\n");
      $fwrite(filePtr, "---------------------------------------\n");
   endtask // print_header

   task append_row;
      input logic [CYCLE_CNT_W-1:0] cycle;
      input logic [INST_W-1:0] 	instruction;
      $fwrite(filePtr, "| %9t | %d | 0x%h |\n", $time, cycle, instruction);
   endtask // print_line

   
   initial begin
      trigger_arrived = 1'b0;
      @(posedge clk iff(enable));
      
      filePtr = $fopen(DEST_FILE, "w");
      print_header();
      
      fork
	 /*proccess-1: wait for trigger*/
	 begin
	    @(posedge clk iff(trigger));
	    trigger_arrived=1'b1;
	 end
	 /*proccess-2: watchdog*/
	 begin
	    #1000;
	 end
      join_any
      
      while(test_undone && trigger_arrived) begin
	 @(posedge clk iff(rstn))
	   append_row(cycle_count, instruction);
      end
      
      $fclose(filePtr);   
   end // initial begin
endmodule // DecodedInstruction_trk

