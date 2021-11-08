	.file	"CharacterOcurrences.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	2
.LC0:
	.string	"Hello this is a c code attempting to asave some string value in the D-mem to validate the D-mem functionality"
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-1040
	sw	ra,1036(sp)
	sw	s0,1032(sp)
	addi	s0,sp,1040
	lui	a5,%hi(.LC0)
	addi	a4,a5,%lo(.LC0)
	addi	a5,s0,-1028
	mv	a3,a4
	li	a4,110
	mv	a2,a4
	mv	a1,a3
	mv	a0,a5
	call	memcpy
	addi	a5,s0,-918
	li	a4,890
	mv	a2,a4
	li	a1,0
	mv	a0,a5
	call	memset
	li	a5,97
	sb	a5,-25(s0)
	sw	zero,-24(s0)
	sw	zero,-20(s0)
	j	.L2
.L4:
	lw	a5,-20(s0)
	addi	a5,a5,-16
	add	a5,a5,s0
	lbu	a5,-1012(a5)
	lbu	a4,-25(s0)
	bne	a4,a5,.L3
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L3:
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L2:
	lw	a5,-20(s0)
	addi	a5,a5,-16
	add	a5,a5,s0
	lbu	a5,-1012(a5)
	bne	a5,zero,.L4
	li	a5,0
	mv	a0,a5
	lw	ra,1036(sp)
	lw	s0,1032(sp)
	addi	sp,sp,1040
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
