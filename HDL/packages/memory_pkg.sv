/* memory package
 
 MAX Memory size:
 (2^32) bytes = 4294967296 bytes

 the memory used in this project 
 will be 16 bit address 1048576 Bytes
 a little more than = 64K bytes
 
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

 
 word signal encoding:
 // 00: 4 bytes (word).
 // 01: 2 bytes (half word).
 // 10: 1 bytes (byte). 
 		 
 // 11: to be declared later;
 
 */


package memory_pkg;

   parameter integer MEM_WORD_WIDTH=32;  //32 bit
   parameter integer MEM_ADDR_WIDTH=32;  // address space [(2*32)-1:0
   parameter integer ERR_ENUMS_WIDTH=2;
   /*   
   typedef enum [ERR_ENUMS_WIDTH-1:0] logic
				      {	       

				       } e_memory_error_codes;
   */
   
endpackage // memory_pkg
   
   
   
