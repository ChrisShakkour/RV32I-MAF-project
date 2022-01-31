

`timescale 1ns/1ns

module DataMemTrans_trk
  #(parameter string DEST_FILE,
    localparam integer CYCLE_CNT_W=32,
    localparam integer ADDR_W=instructions_pkg::XLEN,
    localparam integer DATA_W=instructions_pkg::XLEN)
   (
    input logic 		  trigger,
    input logic 		  test_undone,
    input logic [CYCLE_CNT_W-1:0] cycle_count,
    input logic 		  enable
    );

   bit 		       trigger_arrived;
   int 		       filePtr;
   
   logic 	       clk;
   logic 	       req;
   logic 	       write_en;
   logic 	       response;      
   logic [ADDR_W-1:0]  addr;
   logic [DATA_W-1:0]  data_in;
   logic [DATA_W-1:0]  data_out;
    
   assign clk      = TaiLung.Memory_inst.data_memory.clk;
   assign req      = TaiLung.Memory_inst.data_memory.req;
   assign write_en = TaiLung.Memory_inst.data_memory.write_en;
   assign addr     = TaiLung.Memory_inst.data_memory.addr;
   assign data_in  = TaiLung.Memory_inst.data_memory.store_data;
   assign data_out = TaiLung.Memory_inst.data_memory.load_data;
		    
   always_ff @(posedge clk)
     response <= req & ~write_en;
   
   task print_header();
      $fwrite(filePtr, "---------------------------------------");
      $fwrite(filePtr, "----------------------------------------\n");
      $fwrite(filePtr, "| Time [ns] |    cycle   | R | RES | W |");
      $fwrite(filePtr, "  address   |   W data   |   R data   |\n");
      $fwrite(filePtr, "---------------------------------------");
      $fwrite(filePtr, "----------------------------------------\n");
   endtask // print_header

   task append_row;
      input logic [CYCLE_CNT_W-1:0] cycle;
      input logic 		    read;
      input logic 		    response;    
      input logic 		    write;
      input logic [ADDR_W-1:0] 	    addr;
      input logic [DATA_W-1:0] 	    data_in;
      input logic [DATA_W-1:0] 	    data_out;
      $fwrite(filePtr, "| %9t | %d | %d | %2d  | %d | 0x%h | 0x%h | 0x%h |\n", 
	      $time, cycle, read, response, write, addr, data_in, data_out);
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
	 @(posedge clk)
	   if(req || response)  
	     append_row(cycle_count, req & ~write_en, response, 
			req & write_en, addr, data_in, data_out);
      end
      
      $fclose(filePtr);   
   end // initial begin
endmodule 
