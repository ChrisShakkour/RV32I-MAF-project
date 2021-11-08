/*

description: 
design file: /home/christians/git/RV32I-MAF-project/HDL/rtl_src/core_top/memory/DMem.sv

*/

`timescale 1ns/1ns

module DMem_TB;
   import memory_pkg::*;

   parameter string DEADBEEF="DEADBEEF";
   parameter string ACED="ACED";
   
   parameter string DMEM_IMAGE;
   parameter integer DMEM_SIZE=memory_pkg::DMEM_BYTES;
   parameter integer START_ADDR=memory_pkg::IMEM_BYTES;
   parameter integer ADDR_W=memory_pkg::MEM_ADDR_WIDTH;
   localparam integer WORD_W=memory_pkg::MEM_WORD_WIDTH;
   
   localparam HALF_CLK=5; 
   localparam PERIOD=(2*HALF_CLK); 

   logic 	      clk;
   logic 	      req;
   logic 	      write_en;
   logic 	      l_unsigned;
   logic [1:0] 	      n_bytes;
   logic [ADDR_W-1:0] addr;
   logic [WORD_W-1:0] store_data;
   logic 	      addr_err;
   logic [WORD_W-1:0] load_data;                                      

   logic 	      clk_en;
   always #HALF_CLK clk = (clk_en) ? ~clk : clk; 
   
   DMem #
     (
      .DMEM_SIZE(DMEM_SIZE),
      .START_ADDR(START_ADDR),
      .ADDR_W(ADDR_W)
      )
   DUT_DMem
   (
    // inputs
    .clk        (clk),
    .req        (req),
    .addr       (addr),
    .write_en   (write_en),
    .l_unsigned (l_unsigned),
    .n_bytes    (n_bytes),
    .store_data (store_data),
    // outputs
    .addr_err   (addr_err),
    .load_data  (load_data)
    );
   
   task init();
      clk='0;
      clk_en='0;
      req='0;
      addr='0;
      l_unsigned='0;
      n_bytes='0;
      store_data='0;
   endtask // init()
   
   task reset();
   endtask // reset()

   task load_mem();
      $display("time=%0t[ns]: Loading data memory from file: %s\n", $time, DMEM_IMAGE);
      $readmemh(DMEM_IMAGE, DUT_DMem.dmem_ram, START_ADDR);
   endtask // load_mem
   
   task display(int addr, reg [WORD_W-1:0] load_data, store_data);
      $display("time=%t[ns]: address=0x_%h, load=0x_%h, store=0x_%h", $time, addr, load_data, store_data);
   endtask // display
   
   always @(posedge clk) 
     display(addr, load_data, store_data);

   
   task test_begun();
      $display("\n #############################");
      $display(" Starting testbench stimuli\n");
   endtask
   
   task end_of_test();
      $display("\n End of test");
      $display(" #############################\n");
   endtask


   task LW(int address);
      req        =1'b1;
      addr       =address;
      write_en   =1'b0;
      l_unsigned =1'b0;
      n_bytes    =LS_WORD;
      #(PERIOD)  req=1'b0;
   endtask

   task LH(int address);
      req        =1'b1;
      addr       =address;
      write_en   =1'b0;
      l_unsigned =1'b0;
      n_bytes    =LS_HALFWORD;
      #(PERIOD)  req=1'b0;
   endtask

   task LHU(int address);
      req        =1'b1;
      addr       =address;
      write_en   =1'b0;
      l_unsigned =1'b1;
      n_bytes    =LS_HALFWORD;
      #(PERIOD)  req=1'b0;
   endtask

   task LB(int address);
      req        =1'b1;
      addr       =address;
      write_en   =1'b0;
      l_unsigned =1'b0;
      n_bytes    =LS_SINGLE;
      #(PERIOD)  req=1'b0;
   endtask

   task LBU(int address);
      req        =1'b1;
      addr       =address;
      write_en   =1'b0;
      l_unsigned =1'b1;
      n_bytes    =LS_SINGLE;
      #(PERIOD)  req=1'b0;
   endtask

   task SW(int address, reg [WORD_W-1:0] data);
      req        =1'b1;
      addr       =address;
      write_en   =1'b1;
      l_unsigned =1'b0;
      n_bytes    =LS_WORD;
      store_data =data;
      #(PERIOD)  req=1'b0;
   endtask
   
   task SH(int address, reg [WORD_W-1:0] data);
      req        =1'b1;
      addr       =address;
      write_en   =1'b1;
      l_unsigned =1'b0;
      n_bytes    =LS_HALFWORD;
      store_data =data;
      #(PERIOD)  req=1'b0;
   endtask

   task SB(int address, reg [WORD_W-1:0] data);
      req        =1'b1;
      addr       =address;
      write_en   =1'b1;
      l_unsigned =1'b0;
      n_bytes    =LS_SINGLE;
      store_data =data;
      #(PERIOD)  req=1'b0;
   endtask

        
   initial begin
      test_begun();
      #(PERIOD) init();
      #(2*PERIOD) load_mem;
      #(2*PERIOD) clk_en=1'b1;
      #(4.5*PERIOD);
      for(int i=0; i<8; i++)
	#(PERIOD) SB(START_ADDR+i, DEADBEEF[i]);
      #(6*PERIOD)
      for(int i=0; i<8; i++) begin
	 LB(START_ADDR+i);
	 #(1*PERIOD);
      end
      
      SB(START_ADDR+20, 32'hDEADBEEF);
      #(1*PERIOD);
      SH(START_ADDR+24, 32'hDEADBEEF);
      #(1*PERIOD);
      SW(START_ADDR+28, 32'hDEADBEEF);
      #(1*PERIOD);

      LB(START_ADDR+20);
      #(1*PERIOD);
      LBU(START_ADDR+20);
      #(1*PERIOD);
      LH(START_ADDR+24);
      #(1*PERIOD);
      LHU(START_ADDR+24);
      #(1*PERIOD);
      LW(START_ADDR+28);
      #(1*PERIOD);
      display(addr, load_data, store_data);
	
      #(4*PERIOD);
      end_of_test();
      $finish;
   end
endmodule
