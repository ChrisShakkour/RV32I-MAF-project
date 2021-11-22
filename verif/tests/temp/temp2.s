	.file	"simple_test.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	towerOfHanoi
	.type	towerOfHanoi, @function
towerOfHanoi:
	addi	x1,x0,0
	addi	x2,x0,0
	addi	x3,x0,0
	addi	x4,x0,0
	addi	x5,x0,0
	addi	x6,x0,0
	addi	x7,x0,0
	addi	x8,x0,0
	addi	x9,x0,0
	addi	x10,x0,0
	addi	x11,x0,0
	addi	x12,x0,0
	addi	x13,x0,0
	addi	x14,x0,0
	addi	x15,x0,0
	addi	x1,x0,5
	addi	x2,x0,10
	add	x3,x1,x2
	sub	x4,x3,x2
	addi	x5,x4,-5

	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	mv	a5,a1
	mv	a4,a3
	sb	a5,-21(s0)
	mv	a5,a2
	sb	a5,-22(s0)
	mv	a5,a4
	sb	a5,-23(s0)
	lw	a4,-20(s0)
	li	a5,1
	beq	a4,a5,.L4
	lw	a5,-20(s0)
	addi	a5,a5,-1
	lbu	a3,-22(s0)
	lbu	a2,-23(s0)
	lbu	a4,-21(s0)
	mv	a1,a4
	mv	a0,a5
	call	towerOfHanoi
	lw	a5,-20(s0)
	addi	a5,a5,-1
	lbu	a3,-21(s0)
	lbu	a2,-22(s0)
	lbu	a4,-23(s0)
	mv	a1,a4
	mv	a0,a5
	call	towerOfHanoi
	j	.L1
.L4:
	nop
.L1:
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	towerOfHanoi, .-towerOfHanoi
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	li	a5,4
	sw	a5,-20(s0)
	li	a3,66
	li	a2,67
	li	a1,65
	lw	a0,-20(s0)
	call	towerOfHanoi
	li	a5,0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
