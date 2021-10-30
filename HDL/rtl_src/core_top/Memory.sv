
/*
 
 
 
 
 
 
 */

import memory_pkg::*;
import memory_interface::*;

module Memory
  #(
    parameter integer ADDR_W=MEM_ADDR_WIDTH,
    parameter integer MEM_SIZE=MEM_BYTES,     //0x0001_0000 = 32,768 bytes 32K
    parameter integer IMEM_SIZE=IMEM_BYTES)   //0x0000_4000 = 16,384 bytes 16K
   (
    input logic clk,
    mem_read_only.mem_side inst_fetch_port(),
    mem_read_write.mem_side load_store_port(),
    );

   /* instruction memoty module */
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
       .MEM_SIZE  (SIZE),
       .IMEM_SIZE (IMEM_SIZE),
       .ADDR_W    (ADDR_W)
       )
   data_memory
     (
      .clk      (clk),
      .req      (load_store_port.REQ),
      .write_en (load_store_port.WRITE_EN),
      .n_bytes  (load_store_port.N_BYTES),
      .addr_err (load_store_port.ADDR_ERR),
      .addr     (load_store_port.ADDR),
      .w_data   (load_store_port.W_DATA),
      .r_data   (load_store_port.R_DATA),
      );	       

endmodule
