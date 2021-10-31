
MEMORY {
       i_mem          : ORIGIN = 0x00000000 , LENGTH = 0x40000000
       global_data    : ORIGIN = 0x40000000 , LENGTH = 0xC0000000
}

SECTIONS {
	 . = ORIGIN(i_mem);
	 .text : {
	       . = ALIGN(4);
	       	*(.start);
		*(.text);
		. = ORIGIN(i_mem) + LENGTH(i_mem) - 1;
		BYTE(0);
	 	}  > i_mem
	. = ORIGIN(global_data);
	.data : {
	      . = ALIGN(4);
	      *(.data);
	      *(.rodata);
	      *(.sdata);
	      *(.sbss);
	      } > global_data
	 .bss : {} > global_data
	 }
