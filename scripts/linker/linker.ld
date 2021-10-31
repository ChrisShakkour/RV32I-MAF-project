

SECTIONS
{
. = 0x00000000;
.text : { *(.text) }
. = 0x00004000;
.data : { *(.data) }
.bss : { *(.bss) }
}
