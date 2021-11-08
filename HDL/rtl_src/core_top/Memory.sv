/*///////////////////////////////////////////////////////////////////
 
 -> Block owner: Chris Shakkour - chrisshakkour@gmail.com
 -> Contributers:
 
 -> Description: instruction + data 
                 memory design, supports
                 single instruction load port,
                 and single read/write port.
 
 -> Features:
    1. resetless registers.
    2. single data Read or write operation.
    3. instruction and data memory seperated
       instruction memory space 0x0000-0x3FFF 25%
       data memory space 0x4000-0xFFFF        75%
 
 -> requirments:
    1. memory_interface
    2. memory_pkg
 
 -> module:
   __  __                             
  |  \/  | ___  _ __   ___  _ _  _  _ 
  | |\/| |/ -_)| '  \ / _ \| '_|| || |
  |_|  |_|\___||_|_|_|\___/|_|   \_, |
                                 |__/  

 *////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

module Memory
  import memory_pkg::*;
   #(
     parameter integer 	IMEM_SIZE=memory_pkg::IMEM_BYTES, 
     parameter integer 	DMEM_SIZE=memory_pkg::DMEM_BYTES, 
     parameter integer 	ADDR_W=memory_pkg::MEM_ADDR_WIDTH,
     localparam integer WORD_W=memory_pkg::MEM_WORD_WIDTH
     )
   (
    input logic clk,
    mem_read_only.mem_side inst_fetch_port,
    mem_read_write.mem_side load_store_port
    // monitors/csr ports
    );

   /* instruction memory module */
   IMem 
     #(
       .IMEM_SIZE (IMEM_SIZE),
       .ADDR_W    (ADDR_W)
       )
   instruction_memory
     (
      .clk      (clk),
      .req      (inst_fetch_port.REQ),
      .addr     (inst_fetch_port.ADDR),
      .data     (inst_fetch_port.DATA),
      .addr_err (inst_fetch_port.ADDR_ERR)
      );

   
   /* data memory module */
   DMem 
     #(
       .DMEM_SIZE  (DMEM_SIZE),
       .START_ADDR (IMEM_SIZE),
       .ADDR_W     (ADDR_W) 
       )
   data_memory
     (
      .clk        (clk),
      .req        (load_store_port.REQ),
      .write_en   (load_store_port.WRITE_EN),
      .l_unsigned (load_store_port.L_UNSIGNED),
      .n_bytes    (load_store_port.N_BYTES),
      .addr_err   (load_store_port.ADDR_ERR),
      .addr       (load_store_port.ADDR),
      .store_data (load_store_port.W_DATA),
      .load_data  (load_store_port.R_DATA)
      );	       

endmodule
