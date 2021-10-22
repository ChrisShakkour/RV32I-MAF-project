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

interface mem_read;
   
   logic                      M_CLK;
   logic 		      ENABLE;
   logic 		      ADDR_ERR;
   logic [1:0] 		      WORD;
   logic [MEM_ADDR_WIDTH-1:0] ADDR;
   logic [MEM_WORD_WIDTH-1:0] DATAIN;
   logic [MEM_WORD_WIDTH-1:0] DATAOUT;

   
   /* read memory side */
   modport mem_read_port
     (
      // inputs:
      input  M_CLK,
      input  ENABLE,
      input  WORD,
      input  ADDR,
      // outputs:
      output DATAOUT,
      output ADDR_ERR
      );

   /* read ext side*/
   modport ext_read_port
     (
      // inputs;
      input  DATAIN,
      input  ADDR_ERR,
      // outputs:
      output M_CLK,
      output ENABLE,
      output WORD,
      output ADDR
      );

endinterface // mem_read



interface mem_write;
   
   logic     M_CLK;
   logic     ENABLE;
   logic     ADDR_ERR;
   logic [1:0] WORD;
   logic [MEM_ADDR_WIDTH-1:0] ADDR;
   logic [MEM_WORD_WIDTH-1:0] DATAIN;
   logic [MEM_WORD_WIDTH-1:0] DATAOUT;
   
   
   /* write memory side */
   modport mem_write_port
     (
      // inputs;
      input  M_CLK,
      input  ENABLE,
      input  WORD,
      input  ADDR,
      input  DATAIN,
      // outputs:
      output ADDR_ERR
      );

   /* write ext side*/
   modport ext_write_port
     (
      // inputs:
      input  ADDR_ERR,
      // outputs;
      output M_CLK,
      output ENABLE,
      output WORD,
      output ADDR,
      output DATAOUT
      );

endinterface // mem_write


   
