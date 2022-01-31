/*///////////////////////////////////////////////////////////////////
 
 -> Block owner: Chris Shakkour - chrisshakkour@gmail.com
 -> Contributers: Shahar Dror -  

 -> Description: Core testbench
                 
 -> features:
 
 -> module:
   _____          _    ___                 _    
  |_   _|___  ___| |_ | _ ) ___  _ _   __ | |_  
    | | / -_)(_-<|  _|| _ \/ -_)| ' \ / _|| ' \ 
    |_| \___|/__/ \__||___/\___||_||_|\__||_||_|

 /*///////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

`define IMEM_PATH TaiLung.Memory_inst.instruction_memory.imem_ram 
`define DMEM_PATH TaiLung.Memory_inst.data_memory.dmem_ram

module CoreTop_TB;

   //################################
   /* Paths set in the sim command */
   parameter string LOADED_MEM_IMAGE;
   parameter string STORED_MEM_IMAGE;
   //################################
   localparam integer CYCLE_CNT_W=32;
   
   parameter IMEM_START_ADDR = 0;
   parameter IMEM_SIZE       = memory_pkg::IMEM_BYTES;
   parameter DMEM_START_ADDR = memory_pkg::IMEM_BYTES;
   parameter DMEM_SIZE       = memory_pkg::DMEM_BYTES;
   parameter DMEM_END_ADDR   = DMEM_START_ADDR+DMEM_SIZE-1;
   parameter ADDR_W          = memory_pkg::MEM_ADDR_WIDTH;  
   
   
   /* safty watchdog timer in cycles*/
   localparam integer WATCHDOG_TIM=200;
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
   logic 		  first_fetch_trigger;

   logic [CYCLE_CNT_W-1:0] cycle_count;

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
/*
   always @(posedge clk iff (rstn))
     if(watchdog_expired) $stop;
*/
   logic [31:0] 	  decode_instruction;
   bit 			  test_undone;
   
   initial begin
      test_undone = 1'b1;      
   end

   assign decode_instruction = TaiLung.Core_inst.Decode_inst.instruction;
   
   always @(posedge clk iff(rstn))
     if(decode_instruction == 'h6f)
       test_undone <= 1'b0;
   
/*////////////////////////////
   _____           _       
  |_   _|__ _  ___| |__ ___
    | | / _` |(_-<| / /(_-<
    |_| \__,_|/__/|_\_\/__/
                           
*/////////////////////////////   

   task delay(int cycles);
      #(cycles*PERIOD);
   endtask // delay

   task print(string str);
      $display("-I- time=%0t[ns]: %s\n",
	       $time, str);
   endtask // printTerminal
   
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
      first_fetch_trigger=1'b0;
   endtask // init

   task cpu_go();
      print("CPU GO initiated");
      first_fetch_trigger=1'b1;
      delay(1);
      first_fetch_trigger=1'b0;
   endtask // cpu_go
   
   
   task reset();
      print("Reset initiated");
      rstn=1'b0;
      delay(LONG__STEP);
      rstn=1'b1;
      print("Out of Reset");
   endtask // reset
   
   
   //###############
   /* CLOCK TASKS */
   //###############
   
   task open_main_clock();
      tb_clk_en = 1'b1;
      print("Tb clock started");
   endtask // open_main_clock
   
   task close_main_clock();
      tb_clk_en = 1'b0;
      print("Tb clock stopped");
   endtask // close_main_clock
   
   task open_core_clock();
      cg_clk_en = 1'b1;
      print("Core clock started");
   endtask // open_core_clock

   task close_core_clock();
      cg_clk_en = 1'b0;
      print("Core clock stopped");
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
      print({"Loading instruction memory from file: ", mem_file});
      $readmemh(mem_file, `IMEM_PATH, IMEM_START_ADDR, IMEM_SIZE-1);
   endtask // load_instruction_mem

   task load_data_mem;
      input string mem_file;
      print({"Loading data memory from file: ", mem_file});
      $readmemh(mem_file, `DMEM_PATH, DMEM_START_ADDR, DMEM_END_ADDR);
   endtask // load_data_mem

   task get_mem_image;
      input string mem_file;
      print({"Storing data memory to file: ", mem_file});
      $writememh(mem_file, `DMEM_PATH, DMEM_START_ADDR, DMEM_END_ADDR);
   endtask // get_mem_image


 /*///////////////////////////////////////////
    _____                _                 
   |_   _|_ _  __ _  __ | |__ ___  _ _  ___
     | | | '_|/ _` |/ _|| / // -_)| '_|(_-<
     |_| |_|  \__,_|\__||_\_\\___||_|  /__/
                                              
  *///////////////////////////////////////////

`ifndef TRACKERS_OFF
   
   Trackers 
     #(.CYCLE_CNT_W(CYCLE_CNT_W))
   Trackers_inst
     (
      .trigger       (first_fetch_trigger),
      .test_undone   (test_undone),
      .cycle_count   (cycle_count),
      .enable        (cg_clk_en)
      );
`else
`endif

   
   UpCounter
     #(.INCREMENT_RATE(1),
       .WIDTH(CYCLE_CNT_W)
       )
   cycle_counter
     (
      .clk       (gated_clk),
      .rstn      (rstn),
      .en        (cg_clk_en),
      .clear     (1'b0),
      .overflow  (),
      .count_val (cycle_count)
      );

   
 /*/////////////////////////////////
    ___  _    _              _  _ 
   / __|| |_ (_) _ __  _  _ | |(_)
   \__ \|  _|| || '  \| || || || |
   |___/ \__||_||_|_|_|\_,_||_||_|
                                  
*///////////////////////////////////
   
   initial begin
      $display("\n################################################\n");
      $display("-I- time=%0t[ns]: STARTING STIMULI \n", $time);
      delay(SHORT_STEP); init();
      delay(SHORT_STEP); reset();
      delay(SHORT_STEP); open_main_clock();
      delay(SHORT_STEP); start_watchdog();
      delay(SHORT_STEP); load_instruction_mem({LOADED_MEM_IMAGE, ".I"});
      delay(SHORT_STEP); load_data_mem({LOADED_MEM_IMAGE, ".D"});
      delay(LONG__STEP); open_core_clock();
      delay(LONG__STEP); cpu_go();

      fork
	 /*proccess 1 wait for end 
	  of test trigger from core*/
	 begin
	    while(test_undone)
	      @(posedge clk);
	    print("CPU Done Execution");
	 end
	 
	 /*proccess 2 watchdog timer*/
	 begin
	    delay(5000);
	    print("Watchdog timer expired, Ending test");
	 end
      join_any
      
      /* end of test routine */
      delay(LONG__STEP); close_core_clock();
      delay(SHORT_STEP); stop_watchdog();
      delay(SHORT_STEP); get_mem_image({STORED_MEM_IMAGE, ".D"});
      delay(SHORT_STEP); close_main_clock();
      $display("\n################################################\n");
      delay(LONG__STEP); $finish;
   end
  
endmodule // CoreTop_TB
