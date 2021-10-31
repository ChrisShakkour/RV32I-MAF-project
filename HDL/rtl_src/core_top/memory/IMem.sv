/*///////////////////////////////////////////////////////////////////
 
 -> Block owner: Chris Shakkour - chrisshakkour@gmail.com
 -> Contributers: 

 -> Description: instruction memory design,
                 supports single read port.

 -> features:
    1. resetless registers.
    2. assert that address mem devides by 4.
    3. report error when requesting address out of range.
 
 -> module:
   ___  __  __             
  |_ _||  \/  | ___  _ __  
   | | | |\/| |/ -_)| '  \ 
  |___||_|  |_|\___||_|_|_|
                          
 *////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module IMem
  #(
    parameter integer IMEM_SIZE=memory_pkg::IMEM_BYTES,
    parameter integer ADDR_W=memory_pkg::MEM_ADDR_WIDTH,
    localparam integer WORD_W=memory_pkg::MEM_WORD_WIDTH
    )
   (
    input logic 	      clk,
    input logic 	      req,
    input logic [ADDR_W-1:0]  addr,
    output logic 	      addr_err, 
    output logic [WORD_W-1:0] data
    );

   // instruction memory starts 
   // from 0x0000_000 and ends 
   // in 0x0000_4000, ~16KByte
   logic [7:0] 		      imem_ram [IMEM_SIZE-1:0]; 
   logic 		      valid_addr;

   assign valid_addr = (addr < IMEM_SIZE);
   
   always_ff @(posedge clk)
     addr_err <= (req & ~valid_addr);

   always_ff @(posedge clk)
     if(req & valid_addr) data <= {imem_ram[addr+3],
				   imem_ram[addr+2],
				   imem_ram[addr+1],
				   imem_ram[addr]};

/*///////////////////////////////////////////////////
    _    ___  ___  ___  ___  _____  ___  ___   _  _
   /_\  / __|/ __|| __|| _ \|_   _||_ _|/ _ \ | \| |
  / _ \ \__ \\__ \| _| |   /  | |   | || (_) || .` |
 /_/ \_\|___/|___/|___||_|_\  |_|  |___|\___/ |_|\_|

*////////////////////////////////////////////////////

   /* pragma translate_off */
   
`ifdef DISABLE_ASSERTIONS
`else

   // modelsim does not support assertions
   //  except immediate :( following override:
   // non SYNTH code
   always_ff @(posedge clk)
     if(req) begin
	assert((addr % 4)==0);
	assert(valid_addr);
     end

   // not supported
   property unvalid_instruction;
      @(posedge clk) req |-> ((addr % 4)==0);
   endproperty // unvalid_instruction
   
   property unvalid_address;
      @(posedge clk) req |-> valid_addr;
   endproperty // unvalid_address   
   
   requested_instruction_unvalid: assert property(unvalid_instruction);
   requested_address_out_of_range: assert property(unvalid_address);
`endif   

   /* pragma translate_on */
   
endmodule // IMem

