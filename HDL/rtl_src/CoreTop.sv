

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

    )
    (
     input logic clk,
     input logic rstn,
     // fetch signals.
     input logic first_fetch_addr,
     input logic first_fetch_en
     // CSR's
    
     );
   
   // memory inerface 
   mem_read_only inst_fetch_interface();
   mem_read_write load_store_interface();
   
   
   Core
     Core_inst
       (
	.clk             (clk),
	.rstn            (rstn),
	// memory ports.
	.inst_fetch_port (inst_fetch_interface.core_side()),
	.load_store_port (load_store_interface.core_side())
	);
   
   /* memory model*/
   Memory 
     Memeory_inst
       (
	.clk             (clk),
	.rstn            (rstn),
	// memory ports.
	.inst_fetch_port (inst_fetch_interface.mem_side()),
	.load_store_port (load_store_interface.mem_side())
	);


   // CSR instance
   
endmodule // CoreTop
