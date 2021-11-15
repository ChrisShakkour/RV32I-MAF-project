/*
 
 
 
 
 */

`timescale 1ns/1ns

module CoreTop_TB();
   //import CoreTop_verif_pkg::*;

   /* IMAGE set in the sim command */
   parameter string LOADED_MEM_IMAGE="DEADBEEF";
   parameter string STORED_MEM_IMAGE="BAD00DAD";
   parameter FIRST_FETCH_ADDR = 0;
   parameter IMEM_START_ADDR = 0; 
   parameter DMEM_START_ADDR = memory_pkg::IMEM_BYTES; 

   
   /* safty watchdog timer in cycles*/
   localparam integer WATCHDOG_TIM=1000;
   localparam integer WATCHDOG_W=$clog2(WATCHDOG_TIM);
   
   /* f=100[MHz], T=10[ns] */
   localparam HALFCLK=5;
   localparam PERIOD=(2*HALFCLK);
   
   /* env signals*/
   logic [WATCHDOG_W-1:0] watchdog_counter; 
   logic 		  watchdog_clk;
   logic 		  watchdog_enable;
   logic 		  watchdog_clear;		  
   logic 		  watchdog_rstn;
   logic 		  watchdog_expired;
   
   /* stimuli signals */
   logic clk;
   logic tb_clk_en;
   logic cg_clk_en;
   logic gated_clk;
   logic rstn;

   /* tb free running clock control */
   always #HALFCLK clk = (tb_clk_en) ? ~clk : 1'b0;

   /* rtl main clock gate */
   ClockGate
     Tailung_Chains
       (.clock       (clk),
	.enable      (cg_clk_en),
	.gated_clock (gated_clk)
	);
 
/*/////////////////////////////////////////
   _____       _  _
  |_   _|__ _ (_)| |   _  _  _ _   __ _
    | | / _` || || |__| || || ' \ / _` |
    |_| \__,_||_||____|\_,_||_||_|\__, |
                                   |___/ 
  
 */////////////////////////////////////////
   
   CoreTop
     TaiLung
       (
	.clk  (gated_clk),
	.rstn ()
	
	);

 /*//////////////////////////////////////////////
                  _        _        _
   __ __ __ __ _ | |_  __ | |_   __| | ___  __ _
   \ V  V // _` ||  _|/ _|| ' \ / _` |/ _ \/ _` |
    \_/\_/ \__,_| \__|\__||_||_|\__,_|\___/\__, |
                                            |___/ 
  
  /*//////////////////////////////////////////////
   
   UpCounter
     #(.INCREMENT_RATE(1),
       .WIDTH(WATCHDOG_W)
       )
   watchdog_Timer
     (
      .clk       (watchdog_clk),
      .rstn      (warchdog_rstn),
      .en        (watchdog_en),
      .clear     (watchdog_clear),
      .overflow  (watchdog_expired),
      .count_val (watchdog_counter)
      );
   
   assign watchdog_clk = clk; 
   assign watchdog_rstn = rstn;
   
   
 /*/////////////////////////////////
    ___  _    _              _  _ 
   / __|| |_ (_) _ __  _  _ | |(_)
   \__ \|  _|| || '  \| || || || |
   |___/ \__||_||_|_|_|\_,_||_||_|
                                  
*///////////////////////////////////

   task delay(int cycles);
      #(cycles*PERIOD);
   endtask // delay

   
   task init();
      /* clock domain*/
      clk       = 1'b0;
      tb_clk_en = 1'b0;
      cg_clk_en = 1'b0;
      rstn      = 1'b1;
      
      /* CoreTop signals */
      
   endtask // init


   task reset();
      rstn=1'b0;
      delay(6);
      rstn=1'b1;
   endtask // reset


   task load_instruction_mem;
      input string mem_file;
      input string start_addr;
      //$display("time=%0t[ns]: Loading instruction memory from file: %s\n", $time, m\em_file);
      //$readmemh(mem_file, TaiLung.Memory_inst.instruction_memory.imem_ram, start_ad\dr);
   endtask; // load_instruction_mem





   
   /* to be built in verif package
    task display_instructions
    task display_verbose    
    */

   initial begin
      // print start of test settings
      delay(2); init();
      delay(4); reset();
      //delay(2); load_data_mem(LOADED_MEM_IMAGE, DMEM_START_ADDR);
      //delay(2); load_instruction_mem(LOADED_MEM_IMAGE, IMEM_START_ADDR);
      // load static memory
      //
      // stimuli
      //
      /* end of test routine */
      delay(20);
      //delay(2) dump_data_mem(STORED_MEM_IMAGE, DMEM_START_ADDR);
      $finish;
   end
  
endmodule // CoreTop_TB
