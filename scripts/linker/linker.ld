/*

 -> project : Tai Lung RV32I-MAF Core
 
  _  _        _             
 | |(_) _ _  | |__ ___  _ _ 
 | || || ' \ | / // -_)| '_|
 |_||_||_||_||_\_\\___||_|  
                            
I_MEM: instruction memory, 0x4000 -> 16K
D_MEM: data memory       , 0xC000 -> 48K

see memory_address_map.txt
*/


MEMORY {
       I_MEM (rx)  : ORIGIN = 0x00000000 , LENGTH = 16K
       D_MEM (!rx) : ORIGIN = 0x00004000 , LENGTH = 48K
}      

SECTIONS {

	 . = ORIGIN(I_MEM);
	 .text : {
		 *(.text);	 
	 } > I_MEM

	 . = ORIGIN(D_MEM);	 
	 .rodata : {	
	 	   *(.srodata);
	       	   *(.rodata);
		   *(.rdata);
	 } > D_MEM

	 . = ALIGN(4);
	 .data : {
	       	 *(.sdata);
	       	 *(.data);
	 } > D_MEM

	 . = ALIGN(4);
	 .bss :  {
		 *(.sbss);
		 *(.bss);
	 } > D_MEM
}
