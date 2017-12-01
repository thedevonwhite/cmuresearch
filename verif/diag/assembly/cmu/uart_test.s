

th_main_0:
	setx ADDR1,%g6, %g5
!   Print "Hi! I'm Piton chip!"
!   OR
!   Print "Hi! I'm OpenPiton!"
	set 0x48, %g3
	stb %g3, [%g5]
    set 0x69, %g3
    stb %g3, [%g5]
    set 0x21, %g3
    stb %g3, [%g5]
    set 0x20, %g3
    stb %g3, [%g5]
    set 0x49, %g3
    stb %g3, [%g5]
    set 0x27, %g3
    stb %g3, [%g5]
    set 0x6d, %g3
    stb %g3, [%g5]
    set 0x20, %g3
    stb %g3, [%g5]
!    set 0x50, %g3
!    stb %g3, [%g5]
!    set 0x69, %g3
!    stb %g3, [%g5]
!    set 0x74, %g3
!    stb %g3, [%g5]
!    set 0x6f, %g3
!    stb %g3, [%g5]
!    set 0x6e, %g3
!    stb %g3, [%g5]
!    set 0x20, %g3
!    stb %g3, [%g5]
!    set 0x63, %g3
!    stb %g3, [%g5]
!    set 0x68, %g3
!    stb %g3, [%g5]
!    set 0x69, %g3
!    stb %g3, [%g5]
!    set 0x70, %g3
!    stb %g3, [%g5]
!    set 0x21, %g3
!    stb %g3, [%g5]
!=======
    set 0x4f, %g3
    stb %g3, [%g5]
    set 0x70, %g3
    stb %g3, [%g5]
    set 0x65, %g3
    stb %g3, [%g5]
    set 0x6e, %g3
    stb %g3, [%g5]
    set 0x50, %g3
    stb %g3, [%g5]
    set 0x69, %g3
    stb %g3, [%g5]
    set 0x74, %g3
    stb %g3, [%g5]
    set 0x6f, %g3
    stb %g3, [%g5]
    set 0x6e, %g3
    stb %g3, [%g5]
	set 0x21, %g3
	stb %g3, [%g5]
!=======
	set 0xd, %g3
	stb %g3, [%g5]
	set 0xa, %g3
	stb %g3, [%g5]
    setx 0x5420,%g6,%g5
    loop_100: sub %g5, 1, %g5
    cmp %g5, %g0
    bne loop_100
    nop
    nop
    nop
    nop
	ba good_end
	nop
bad_en:
	ta T_BAD_TRAP
	ba end
	nop
good_end:
	ta T_GOOD_TRAP
end:
	nop
	nop

