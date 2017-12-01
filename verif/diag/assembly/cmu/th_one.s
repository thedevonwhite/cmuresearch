#define THREAD_COUNT 2
#define ADDR1 0xfff0c2c000
#define ADDR0 0x9a00000000
#include "boot.s"
.text
.global main
main:
        setx active_thread, %l1, %o5 !Store active_thread into %o5
        jmpl    %o5, %o7	     !Jump to %o5, store PC into %o7
        nop

!
!       Note that to simplify ASI cache accesses this segment should be mapped VA==PA==RA
SECTION .ACTIVE_THREAD_SEC TEXT_VA=0x0000000040008000
   attr_text {
        Name = .ACTIVE_THREAD_SEC,
        VA= 0x0000000040008000,
        PA= ra2pa(0x0000000040008000,0),
        RA= 0x0000000040008000,
        part_0_i_ctx_nonzero_ps0_tsb,
        part_0_d_ctx_nonzero_ps0_tsb,
        TTE_G=1, TTE_Context=PCONTEXT, TTE_V=1, TTE_Size=0, TTE_NFO=0,
        TTE_IE=0, TTE_Soft2=0, TTE_Diag=0, TTE_Soft=0,
        TTE_L=0, TTE_CP=1, TTE_CV=1, TTE_E=0, TTE_P=0, TTE_W=1
        }
   attr_text {
        Name = .ACTIVE_THREAD_SEC,
        hypervisor
        }
!
!
!

.text
.global active_thread
.global th_main_0
.global th_main_1
.global th_main_2
!
!   We enter with L2 up and in LRU mode, Priv. state is user (none)
!
!	
active_thread:	
        ta      T_CHANGE_HPRIV          ! enter Hyper mode
        nop
	ta T_RD_THID
	mov %o1, %l7
	cmp %l7, 0
	be th_main_0
	nop
	cmp %l7, 1
	be th_main_1
	nop
	cmp %l7, 2
	be th_main_2
	nop
	ta T_BAD_TRAP
	mov %l7, %o0
	call uart_char_print
	nop

th_main_0:
	mov 48, %o0
	call uart_char_print
	nop
	ba th_main_0
	nop

th_main_1:
	mov 49, %o0
	call uart_char_print
	nop
	ba th_main_1
	nop

th_main_2:
	mov 50, %o0
	call uart_char_print
	nop
	ba th_main_2
	nop

spin_wait:
	ba spin_wait
	nop
	
	.align 4
	.global uart_char_print
uart_char_print:
	setx ADDR1, %i6, %i5
	mov %o0, %i3
	stb %i3, [%i5]
	setx 0x5420,%i6,%i4
loop_10: sub %i4, 1, %i4
    	cmp %i4, %g0
   	bne loop_10
	nop
	retl
	nop
