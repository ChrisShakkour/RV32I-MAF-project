/*
 
 
 
 
 */

`timescale 1ns/1ns

module CoreTop_TB;
   //import CoreTop_verif_pkg::*;

   /* IMAGE set in the sim command */
   parameter string LOADED_MEM_IMAGE;
   parameter string STORED_MEM_IMAGE="BAD0DAD0";
   parameter FIRST_FETCH_ADDR = 0;
   parameter IMEM_START_ADDR = 0; 
   parameter DMEM_START_ADDR = memory_pkg::IMEM_BYTES; 
   parameter ADDR_W = memory_pkg::MEM_ADDR_WIDTH;  
   
   
   /* safty watchdog timer in cycles*/
   localparam integer WATCHDOG_TIM=25;
   localparam integer WATCHDOG_W=$clog2(WATCHDOG_TIM);
   
   /* f=100[MHz], T=10[ns] */
   localparam HALFCLK=5;
   localparam PERIOD=(2*HALFCLK);
   localparam SHORT_STEP=4;
   localparam LONG__STEP=10;
   
   /* env signals*/
   logic [WATCHDOG_W-1:0] watchdog_counter; 
   logic 		  watchdog_clk;
   logic 		  watchdog_en;
   logic 		  watchdog_clear;		  
   logic 		  watchdog_rstn;
   logic 		  watchdog_expired;
   
   /* stimuli signals */
   logic 		  clk;
   logic 		  tb_clk_en;
   logic 		  cg_clk_en;
   logic 		  gated_clk;
   logic 		  rstn;
   logic [ADDR_W-1:0] 	  first_fetch_addr;
   logic 		  first_fetch_trigger;
   

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
	.clk                 (gated_clk),
	.rstn                (rstn),
	.first_fetch_addr    (first_fetch_addr),
	.first_fetch_trigger (first_fetch_trigger)
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
      .rstn      (watchdog_rstn),
      .en        (watchdog_en),
      .clear     (watchdog_clear),
      .overflow  (watchdog_expired),
      .count_val (watchdog_counter)
      );
   
   assign watchdog_clk = clk; 
   assign watchdog_rstn = rstn;

   always @(posedge clk iff (rstn))
     if(watchdog_expired) $stop;
   
/*////////////////////////////
   _____           _       
  |_   _|__ _  ___| |__ ___
    | | / _` |(_-<| / /(_-<
    |_| \__,_|/__/|_\_\/__/
                           
*/////////////////////////////   

   task delay(int cycles);
      #(cycles*PERIOD);
   endtask // delay

   task init();
      /* clock domain*/
      clk       = 1'b0;
      tb_clk_en = 1'b0;
      cg_clk_en = 1'b0;
      rstn      = 1'b1;
      /* watchdog */
      watchdog_en=1'b0;
      watchdog_clear=1'b0;
      /* CoreTop signals */
      first_fetch_addr='0;
      first_fetch_trigger=1'b1;
   endtask // init

   task reset();
      rstn=1'b0;
      delay(LONG__STEP);
      rstn=1'b1;
   endtask // reset

   
   //###############
   /* CLOCK TASKS */
   //###############
   
   task open_main_clock();
      tb_clk_en = 1'b1;
   endtask // open_main_clock
   
   task close_main_clock();
      tb_clk_en = 1'b0;
   endtask // close_main_clock
   
   task open_core_clock();
      cg_clk_en = 1'b1;
   endtask // open_core_clock

   task close_core_clock();
      cg_clk_en = 1'b0;
   endtask // close_core_clock

   
   //##################
   /* WATCHDOG TASKS */
   //##################
   
   task start_watchdog();
      watchdog_en=1'b1;
   endtask // start_watchdog

   task stop_watchdog();
      watchdog_en=1'b0;
   endtask // stop_watchdog

   task clear_watchdog();
      watchdog_clear=1'b1;
      delay(1);
      watchdog_clear=1'b0;
   endtask // clear_watchdog

   
   //################
   /* MEMORY TASKS */
   //################
   
   task load_instruction_mem;
      input string mem_file;
      $display("time=%0t[ns]: Loading instruction memory from file: %s\n", $time, mem_file);
      $readmemh(mem_file, TaiLung.Memory_inst.instruction_memory.imem_ram, IMEM_START_ADDR);
   endtask // load_instruction_mem

   task load_data_mem;
      input string mem_file;
      $display("time=%0t[ns]: Loading data memory from file: %s\n", $time, mem_file);
      $readmemh(mem_file, TaiLung.Memory_inst.data_memory.dmem_ram, DMEM_START_ADDR);
   endtask // load_data_mem

   task get_mem_image;
      input string mem_file;
      $display("time=%0t[ns]: Loading data memory from file: %s\n", $time, mem_file);
      $writememh(mem_file, TaiLung.Memory_inst.data_memory.dmem_ram, DMEM_START_ADDR);
   endtask // get_mem_image


   //#################
   /* DISPLAY TASKS */
   //#################

   

   
   /* to be built in verif package
    task display_instructions
    task display_verbose    
    */

 /*/////////////////////////////////
    ___  _    _              _  _ 
   / __|| |_ (_) _ __  _  _ | |(_)
   \__ \|  _|| || '  \| || || || |
   |___/ \__||_||_|_|_|\_,_||_||_|
                                  
*///////////////////////////////////
   
   initial begin
      // print start of test settings
      delay(SHORT_STEP); init();
      delay(SHORT_STEP); reset();
      delay(SHORT_STEP); open_main_clock();
      delay(SHORT_STEP); start_watchdog();
      delay(SHORT_STEP); load_instruction_mem(LOADED_MEM_IMAGE);
      delay(SHORT_STEP); load_data_mem(LOADED_MEM_IMAGE);
      delay(LONG__STEP); open_core_clock();
      
      delay(10); clear_watchdog(); 
      delay(10); clear_watchdog(); 
      delay(10); clear_watchdog();
      
      // load static memory
      //
      // stimuli
      //
      /* end of test routine */
      delay(40);
      //delay(2) dump_data_mem(STORED_MEM_IMAGE, DMEM_START_ADDR);
      delay(LONG__STEP); close_core_clock();
      delay(SHORT_STEP); stop_watchdog();
      delay(SHORT_STEP); close_main_clock();
      delay(LONG__STEP); $finish;
   end
  
endmodule // CoreTop_TB
