/*

description: 
design file: /home/christians/git/RV32I-MAF-project/HDL/rtl_src/core_top/memory/IMem.sv

*/

`timescale 1ns/1ns

module IMem_TB;

   parameter string IMEM_IMAGE;
   parameter integer IMEM_SIZE=memory_pkg::IMEM_BYTES;
   parameter integer ADDR_W=memory_pkg::MEM_ADDR_WIDTH;
   localparam integer WORD_W=memory_pkg::MEM_WORD_WIDTH;
   
   localparam HALF_CLK=5; 
   localparam PERIOD=(2*HALF_CLK); 
   
   logic 	      clk;
   logic 	      req;
   logic [ADDR_W-1:0] addr;
   logic 	      addr_err;
   logic [WORD_W-1:0] data;

   logic 	      clk_en;
   always #HALF_CLK clk = (clk_en) ? ~clk : clk; 
   
   IMem #
     (
      .IMEM_SIZE(IMEM_SIZE),
      .ADDR_W(ADDR_W)
      )
   DUT_IMem
   (
    // inputs
    .clk(clk),
    .req(req),
    .addr(addr),
    // outputs
    .addr_err(addr_err),
    .data(data)
    );
   
   task init();
      clk='0;
      clk_en='0;
      req='0;
      addr='0;
   endtask // init()
   
   task reset();
   endtask // reset()

   task load_mem();
      $display("time=%0t[ns]: Loading instruction memory from file: %s\n", $time, IMEM_IMAGE);
      $readmemh(IMEM_IMAGE, DUT_IMem.imem_ram, 0);
   endtask // load_mem
   
   task read_instruction(int address); //32bit unsigned address;
      req=1'b1;
      addr=address;
      #(PERIOD) req=1'b0;
   endtask // read_instruction   

   task display(int addr, reg [WORD_W-1:0] data);
      $display("time=%t[ns]: address=0x_%h -> instruction=0x_%h", $time, addr, data);
   endtask // display

   always @(posedge clk) 
     if(req) display(addr, data);

   task test_begun();
      $display("\n #############################");
      $display(" Starting testbench stimuli\n");
   endtask
   
   task end_of_test();
      $display("\n End of test");
      $display(" #############################\n");
   endtask
      
        
   initial begin
      test_begun();
      #(PERIOD) init();
      #(2*PERIOD) load_mem;
      #(2*PERIOD) clk_en=1'b1;
      #(2.5*PERIOD);
      for(int i=0; i<20; i++)
	read_instruction(32'h00000000+(4*i));
      #(2*PERIOD) read_instruction(32'h00010000);
      //assert shall fail on unavailable address
      #(2*PERIOD) read_instruction(32'h00004001);
      // assert shall fail on unvalid instruction,
      // address shall be divided by 4 with zero remainder.
      #(4*PERIOD);
      end_of_test();
      $finish;
   end
endmodule
