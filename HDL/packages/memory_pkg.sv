/* memory package
 
 MAX Memory size:
 (2^32) bytes = 4294967296 bytes

 the memory used in this project 
 will be 16 bit address 1048576 Bytes
 
 address space = [(2^32)-1:0]
 Ex.
 0x0000_0000
 0x0000_0004
 0x0000_0008
 0x0000_000C
 0x0000_0010
     .
     .
     .
     .
 0x0000_FFFF

 
 N_BYTES signal encoding:
 // 00: 4 bytes (word).
 // 01: 2 bytes (half word).
 // 10: 1 bytes (byte). 	 
 // 11: to be declared later;
 
 */


package memory_pkg;

   parameter integer MEM_WORD_WIDTH=32;                 //32 bit
   parameter integer MEM_ADDR_WIDTH=32;                 // address space [(2*32)-1:0]
   parameter integer MEM_BYTES=2**16;                   // 0x0001_0000
   parameter integer IMEM_BYTES=2**14;                  // 0x0000_0000 - 0x0000_4000 
   parameter integer DMEM_BYTES=MEM_BYTES-IMEM_BYTES;   // 0x0000_4000 - 0x0001_0000
   
   parameter integer ERR_ENUMS_WIDTH=2;


   // n_bytes signal shall be 
   // driven by the following 
   // byte codes.
   parameter LS_SINGLE=2'b01;    //LoadStore_Single byte, LB, LBU, SB
   parameter LS_HALFWORD=2'b10;  //LoadStore Halfword,    LH, LHU, SH
   parameter LS_WORD=2'b00;      //LoadStore Word,        LW, SW
   parameter L_UNSIGNED=1'b1;    //Load Unsigned,         LBU, LHU
   
		       
   typedef enum logic [1:0]
   {
    WORD     = 2'b00,
    HALFWORD = 2'b10,
    BYTE     = 2'b01
    } e_mem_num_bytes;
   

   

   /*   
   typedef enum [ERR_ENUMS_WIDTH-1:0] logic
				      {	       

				       } e_memory_error_codes;
   */
   
endpackage // memory_pkg
   
   
   
