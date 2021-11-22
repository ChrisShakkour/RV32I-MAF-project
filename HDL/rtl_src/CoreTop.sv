

/*///////////////////////////////////////////////////////////////////
 
  -> Block owner: Chris Shakkour - chrisshakkour@gmail.com
  -> Contributers:
 
  -> Description: CoreTop module,
                  wrapping RV-32IMF core
                  and memory modules, 
                  includes CSR registers.
 
  -> Features:
 
 
  -> requirments:
     1. memory_interface
     2. memory_pkg
     3.
 
  -> module:
    ___                _____           
   / __| ___  _ _  ___|_   _|___  _ __ 
  | (__ / _ \| '_|/ -_) | | / _ \| '_ \
   \___|\___/|_|  \___| |_| \___/| .__/
                                 |_|   
 
  *////////////////////////////////////////////////////////////////


`timescale 1ns/1ns

module CoreTop
  #(
    parameter integer ADDR_W=memory_pkg::MEM_ADDR_WIDTH
    )
    (
     input logic 	      clk,
     input logic 	      rstn,
     // fetch signals.
     input logic [ADDR_W-1:0] first_fetch_addr,
     input logic 	      first_fetch_trigger
     // CSR's
     );
   
   // memory inerface 
   mem_read_only inst_fetch_interface();
   mem_read_write load_store_interface();

   //inst_fetch_interface.core_side() inst_fetch_core
   
   Core
     Core_inst
       (
	.clk             (clk),
	.rstn            (rstn),
	.FirstInstAdd    (first_fetch_addr),
	.pc_rstn         (first_fetch_trigger),
	// memory ports.
	.inst_fetch_port (inst_fetch_interface),
	.load_store_port (load_store_interface)
	);
   
   /* memory model*/
   Memory 
     Memory_inst
       (
	.clk             (clk),
	// memory ports.
	.inst_fetch_port (inst_fetch_interface),
	.load_store_port (load_store_interface)
	);


   // CSR instance
   
endmodule // CoreTop
