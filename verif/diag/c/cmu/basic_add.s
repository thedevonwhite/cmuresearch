#include "boot.s"
#include "libc.s"

	.file	"basic.c"
	.section	".text"
	.align 4
	.global main
	.type	main, #function
	.proc	04
main:
	save	%sp, -192, %sp
	mov	2, %g1
	st	%g1, [%fp+2043]
	call	pass, 0
	 nop
	mov	0, %g1
	sra	%g1, 0, %g1
	mov	%g1, %i0
	return	%i7+8
	 nop
	.size	main, .-main
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.1) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
