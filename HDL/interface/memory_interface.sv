/*
 ##################################
 ### interface modport explained:
 ##################################
                    
                     |
  mem_read_port   -> | -> ext_read_port
                     |
   <Memory side>     |   <Design side> 
                     |
  mem_write_port  <- | <- ext_write_port
                     |
 */


import memory_pkg::*;

interface mem_read_only;
   
   logic 		      REQ;
   logic 		      ADDR_ERR;
   logic [MEM_ADDR_WIDTH-1:0] ADDR;
   logic [MEM_WORD_WIDTH-1:0] DATA;

   
   /* read memory side */
   modport mem_side
     (
      // inputs:
      input  REQ,
      input  ADDR,
      // outputs:
      output DATA,
      output ADDR_ERR
      );

   /* read ext side*/
   modport core_side
     (
      // inputs;
      input  DATA,
      input  ADDR_ERR,
      // outputs:
      output REQ,
      output ADDR
      );

endinterface // mem_read_only



interface mem_read_write;
   
   logic                      REQ;
   logic                      WRITE_EN;
   logic                      ADDR_ERR;
   logic [1:0]                N_BYTES;
   logic [MEM_ADDR_WIDTH-1:0] ADDR;
   logic [MEM_WORD_WIDTH-1:0] W_DATA;
   logic [MEM_WORD_WIDTH-1:0] R_DATA;
   
   
   /* write memory side */
   modport mem_side
     (
      // inputs;
      input  REQ,
      input  WRITE_EN,
      input  N_BYTES,
      input  ADDR,
      input  W_DATA,
      // outputs:
      output ADDR_ERR,
      output R_DATA
      );

   /* write ext side*/
   modport core_side
     (
      // inputs:
      input  ADDR_ERR,
      input  R_DATA,
      // outputs;
      output REQ,
      output WRITE_EN,
      output N_BYTES,
      output ADDR,
      output W_DATA
      );

endinterface // mem_write


   
