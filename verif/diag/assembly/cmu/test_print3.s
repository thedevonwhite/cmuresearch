
#define ADDR1 0xfff0c2c000
#define ADDR0 0x9a00000000
#include "boot.s"
#include "libc.s"

.text
.global main
main:
        setx active_thread, %l1, %o5   
        jmpl    %o5, %o7
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
!
!   We enter with L2 up and in LRU mode, Priv. state is user (none)
!
!	
active_thread:	
        ta      T_CHANGE_HPRIV          ! enter Hyper mode
        nop
th_main_0:
	save	%sp, -176, %sp
	mov	68, %o0
	call	uart_char_print, 0
	 nop
	mov	69, %o0
	call	uart_char_print, 0
	 nop
	mov	86, %o0
	call	uart_char_print, 0
	 nop
	mov	79, %o0
	call	uart_char_print, 0
	 nop
	mov	78, %o0
	call	uart_char_print, 0
	 nop
	mov	60, %o0
	call	uart_char_print, 0
	 nop
	mov	51, %o0
	call	uart_char_print, 0
	 nop
	call	pass, 0
	 nop
	mov	0, %g1
	sra	%g1, 0, %g1
	mov	%g1, %i0
	return	%i7+8
	 nop
