/*///////////////////////////////////////////////////////////////////
 
 -> Block owner: Chris Shakkour - chrisshakkour@gmail.com
 -> Contributers:
 
 -> Description: data memory design,
                 supports single Read
                 and single Write port,
                 one at a time.
 
 
 -> Features:
    1. resetless registers.

 -> module:
   ___   __  __             
  |   \ |  \/  | ___  _ __  
  | |) || |\/| |/ -_)| '  \ 
  |___/ |_|  |_|\___||_|_|_|
                            
 *////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

module DMem
  import memory_pkg::*;
  #(
    parameter integer  DMEM_SIZE=memory_pkg::DMEM_BYTES,
    parameter integer  START_ADDR=memory_pkg::IMEM_BYTES,
    parameter integer  ADDR_W=memory_pkg::MEM_ADDR_WIDTH,
    localparam integer WORD_W=memory_pkg::MEM_WORD_WIDTH
    )
   (
    input logic 	      clk,         // clock
    input logic 	      req,         // request
    input logic 	      write_en,    // write enable  
    input logic 	      l_unsigned,  // load unsigned, LBU, LHU
    input logic [1:0] 	      n_bytes,     // number of bytes, Byte, Hafword, Word
    input logic [ADDR_W-1:0]  addr,        // address
    input logic [WORD_W-1:0]  store_data,  // stored data
    output logic 	      addr_err,    // address error
    output logic [WORD_W-1:0] load_data    // loaded data
    );


   // data memory starts
   // from 0x0000_4000 and ends
   // in 0x0000_FFFF, ~48KByte
   logic [7:0] 		      dmem_ram [DMEM_SIZE-1:START_ADDR];
   logic 		      valid_addr;
   logic 		      valid_read;
   logic 		      valid_write;
   logic 		      s_byte;
   logic 		      s_hword;

   // valid indication signals 
   // before Load/Store operations
   assign valid_addr  = (addr inside{[START_ADDR:DMEM_SIZE-1]});
   assign valid_read  = (valid_addr & ~write_en);
   assign valid_write = (valid_addr & write_en);
   
   assign s_byte  = (n_bytes == LS_SINGLE);
   assign s_hword = (n_bytes == LS_HALFWORD);

   // report error if address
   // is out of range
   always_ff @(posedge clk)
     addr_err <= (req & ~valid_addr);

   // load - little endianess
   always_ff @(posedge clk)
     if(req & valid_read) begin
	unique case(n_bytes)
	  LS_SINGLE:
	    if(l_unsigned) load_data <= $unsigned(dmem_ram[addr]);
	    else           load_data <= $signed(dmem_ram[addr]);
	  LS_HALFWORD: 
	    if(l_unsigned) load_data <= $unsigned({dmem_ram[addr+1], dmem_ram[addr]});
	    else           load_data <= $signed({dmem_ram[addr+1], dmem_ram[addr]});
	  LS_WORD:  
	    load_data <= {dmem_ram[addr+3], dmem_ram[addr+2], 
			  dmem_ram[addr+1], dmem_ram[addr]};
	  default;
	endcase
     end

   // store - little endianess
   always_ff @(posedge clk)
     if(req & valid_write) begin 
	                        dmem_ram[addr]   <= store_data[7:0];   //lsb
	if(~s_byte)             dmem_ram[addr+1] <= store_data[15:8];
	if(~(s_byte | s_hword)) dmem_ram[addr+2] <= store_data[23:16];
	if(~(s_byte | s_hword)) dmem_ram[addr+3] <= store_data[31:24]; //msb
     end
       
endmodule // DMem
