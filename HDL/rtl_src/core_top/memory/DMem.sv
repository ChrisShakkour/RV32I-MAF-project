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
  #(
    parameter integer  DMEM_SIZE=memory_pkg::DMEM_BYTES,
    parameter integer  START_ADDR=memory_pkg::IMEM_BYTES,
    parameter integer  ADDR_W=memory_pkg::MEM_ADDR_WIDTH,
    localparam integer WORD_W=memory_pkg::MEM_WORD_WIDTH
    )
   (
    input logic 	      clk,
    input logic 	      req,
    input logic 	      write_en,
    input logic 	      n_bytes, 
    input logic [ADDR_W-1:0]  addr,
    input logic [WORD_W-1:0]  w_data,
    output logic 	      addr_err,
    output logic [WORD_W-1:0] r_data
    );


   // instruction memory starts
   // from 0x0000_000 and ends
   // in 0x0000_4000, ~16KByte
   logic [7:0] 		      dmem_ram [DMEM_SIZE-1:IMEM_SIZE];
   logic 		      valid_addr;
   logic 		      valid_read;
   logic 		      valid_write;
   logic 		      l_byte;
   logic 		      l_hword;
   
    
   assign valid_addr  = (addr inside{[IMEM_SIZE:DMEM_SIZE-1]});
   assign valid_read  = (req & valid_addr & ~write_en);
   assign valid_write = (req & valid_addr & write_en);
   
   assign l_byte  = (n_bytes == 2'b01);
   assign l_hword = (n_bytes == 2'b10);
   
   always_ff @(posedge clk)
     addr_err <= (req & ~valid_addr);

   // load - little endianess
   always_ff @(posedge clk)
     if(valid_read) r_data = {}

   // store - little endianess
   always_ff @(posedge clk)
     if(valid_write) begin 
	Imem[addr]   = w_data[7:0]; //lsb
	Imem[addr+1] = (~l_byte) ? w_data[7:0] : {8} ;
	Imem[addr+2] = (n_bytes[1]);
	Imem[addr+3] = (n_bytes[1]);      //msb
     end
       
endmodule // DMem
