#define ADDR0 0x9a00000000
!AutoGenerated by Perl
#include "boot.s"
!End of AutoGen by Perl

.text
.global main
main:
        setx	active_thread, %l1, %o5 
        jmpl    %o5, %o7
        nop

!

!
!       Note that this 8KB segment should be mapped VA==PA==RA
!
SECTION .FIRST_THREAD_SEC TEXT_VA=0x0000000040008000
   attr_text {
        Name = .FIRST_THREAD_SEC,
        VA= 0x0000000040008000,
        PA= ra2pa(0x0000000040008000,0),
        RA= 0x0000000040008000,
        part_0_i_ctx_nonzero_ps0_tsb,
        part_0_d_ctx_nonzero_ps0_tsb,
        TTE_G=1, TTE_Context=PCONTEXT, TTE_V=1,  TTE_Size=0, TTE_NFO=0,
        TTE_IE=0, TTE_Soft2=0, TTE_Diag=0, TTE_Soft=0,
        TTE_L=0, TTE_CP=1, TTE_CV=1, TTE_E=0, TTE_P=0, TTE_W=1
        }
   attr_text {
        Name = .FIRST_THREAD_SEC,
        hypervisor
        }

.global active_thread

active_thread:
       ta      T_CHANGE_HPRIV          ! enter Hyper mode
       nop

after_user:                   !  test enters here from boot in user mode
	save	%sp, -192, %sp
	set	0x2, %g1
	set	0x50000,%l0
	stb	%g1,[%l0+0]
!	setx	ADDR0, %g6, %g5
!	stb	%g1, [%g5 + 4]
	ba	good_pass
	nop
	mov	0, %g1
	sra	%g1, 0, %g1
	mov	%g1, %i0
	return	%i7+8
	 nop

good_pass:
        ta      T_GOOD_TRAP
        nop
