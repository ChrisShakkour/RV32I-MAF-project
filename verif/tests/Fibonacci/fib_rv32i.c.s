	.file	"fib.c"
	.option nopic
	.text
	.align	2
	.globl	fib
	.type	fib, @function
fib:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	sw	s1,20(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	lw	a4,-20(s0)
	li	a5,1
	nop
	bgt	a4,a5,.L2
	lw	a5,-20(s0)
	j	.L3
.L2:
	lw	a5,-20(s0)
	nop
	nop
	addi	a5,a5,-1
	mv	a0,a5
	call	fib
	mv	s1,a0
	lw	a5,-20(s0)
	nop
	nop
	addi	a5,a5,-2
	mv	a0,a5
	call	fib
	mv	a5,a0
	add	a5,s1,a5
.L3:
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	lw	s1,20(sp)
	addi	sp,sp,32
	jr	ra
	.size	fib, .-fib
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	li	a5,9
	sw	a5,-20(s0)
	sw	zero,-24(s0)
	lw	a0,-20(s0)
	call	fib
	sw	a0,-24(s0)
	li	a5,0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: (xPack GNU RISC-V Embedded GCC, 64-bit) 10.1.0"
