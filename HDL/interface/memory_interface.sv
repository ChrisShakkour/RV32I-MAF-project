/*
 ######################################
 ### interface mem_read_only explained:
 ### instruction memory interface
 ######################################
   _________________________________            
                    |
    mem_side     -> | -> core_side
                    |
   ---------------------------------
 */ 
interface mem_read_only;
   import memory_pkg::*;
   
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



/*
 #######################################
 ### interface mem_read_write explained:
 ### data memory interface
 #######################################
   _____________________________________            
                       |
   LOAD:  mem_side  -> | -> core_side
   STORE: mem_side  <- | <- core_side
                       |
   --------------------------------------
 */
interface mem_read_write;
   import memory_pkg::*;
   
   logic                      REQ;
   logic                      WRITE_EN;
   logic                      ADDR_ERR;
   logic 		      L_UNSIGNED;
   logic [1:0]                N_BYTES;
   logic [MEM_ADDR_WIDTH-1:0] ADDR;
   logic [MEM_WORD_WIDTH-1:0] W_DATA;
   logic [MEM_WORD_WIDTH-1:0] R_DATA;
   
   
   /* Memory side */
   modport mem_side
     (
      // inputs;
      input  REQ,
      input  WRITE_EN,
      input  L_UNSIGNED,
      input  N_BYTES,
      input  ADDR,
      input  W_DATA,
      // outputs:
      output ADDR_ERR,
      output R_DATA
      );

   
   /* Core side*/
   modport core_side
     (
      // inputs:
      input  ADDR_ERR,
      input  R_DATA,
      // outputs;
      output REQ,
      output WRITE_EN,
      output L_UNSIGNED,
      output N_BYTES,
      output ADDR,
      output W_DATA
      );

endinterface // mem_write


   
