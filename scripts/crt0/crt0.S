/*////////////////////////////////////////////////
	
 -> Description:
	the crt is an execution startup routines asm
	file that get linked into a C program to
	perform any initialization work required
	before calling the program's main function

 -> Name:	
    ___  ___  _____  __
   / __|| _ \|_   _|/  \
  | (__ |   /  | | | () |
   \___||_|_\  |_|  \__/
	                 
*/////////////////////////////////////////////////

//.......................................
/* Fixed adresses for special handlers */	
//.......................................

.org 0x00
jal x0, _start
	
.org 0x04
jal x0, reset_handler

.org 0x08
jal x0, call_main_handler

.org 0x0C
jal x0, end_of_main_handler

// TODO: add handler
.org 0x10
nop
//jal x0, illegal_instruction_handler

// TODO: add handler
.org 0x14
nop
//jal x0, copy_rf_to_mem

.org 0x18
jal x0, idle_handler

// stuck at, indicator
// of end of execution.
idle_handler:
	.org 0x1C
	nop
	jal x0, idle_handler

	
//.......................................
/* handler functions                   */	
//.......................................	
.section .text	


// starts with nop
// operations and jumps
// to reset handler
_start:		
	.global _start	
	.rept 10
	nop
	.endr
	jal x0, reset_handler


// Zero all registers
// init stack pointer
reset_handler:
	mv  x1, x0
	mv  x2, x0
	mv  x3, x0
	mv  x4, x0
	mv  x5, x0
	mv  x6, x0
	mv  x7, x0
	mv  x8, x0
	mv  x9, x0
	mv x10, x0
	mv x11, x0
	mv x12, x0
	mv x13, x0
	mv x14, x0
	mv x15, x0
	mv x16, x0
	mv x17, x0
	mv x18, x0
	mv x19, x0
	mv x20, x0
	mv x21, x0
	mv x22, x0
	mv x23, x0
	mv x24, x0
	mv x25, x0
	mv x26, x0
	mv x27, x0
	mv x28, x0
	mv x29, x0
	mv x30, x0
	mv x31, x0
	/* stack initilization */
	la   x2, 0xFFFF
	jal x0, call_main_handler


// jump to main program
// (argc = argv = 0)
call_main_handler:
	addi x10, x0, 0
	addi x11, x0, 0
	jal x1, main
	jal x0, end_of_main_handler
	


// move main function
// status/return value)
// from a0 to saved
// register s0.
end_of_main_handler:
	mv s0, a0
	jal x0, idle_handler
	
	
		

	
	
	
	

	
