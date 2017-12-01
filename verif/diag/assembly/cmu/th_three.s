#define THREAD_COUNT 2
#define ADDR1 0xfff0c2c000
#define ADDR0 0x9a00000000
#define MASK 0x00e00000
#define SHARED  0x0006002180
#define FINISH  0x0006002190
#define LOCK_ADDR 0x0006002100
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
	setx LOCK_ADDR, %l6, %i4
	clr [%i4]			!sets initial mutex to 0
	setx SHARED, %l6, %g5
	clr [%g5]
	setx FINISH, %l6, %g6
	clr [%g6]
	ta T_RD_THID
	nop
	mov %o1, %l7
	cmp %l7, 0
	be th_main_0
	nop
	cmp %l7, 2
	be th_main_2
	nop

	ta T_BAD_TRAP
	nop

th_main_0:
	setx 150, %l6, %i3
loop_0:
	
	call lock_acquire	!Lock and wait to get lock
	nop

	!Protected Section: Increment mem addr
	ld [%g5], %l3
	inc %l3
	st %l3, [%g5]

	call lock_release	!Unlock
	nop
	dec %i3
	cmp %i3, 0
	bne loop_0
	nop

	!Increment our FINISH counter
	call lock_acquire
	nop

	ld [%g6], %l3
	inc %l3
	st %l3, [%g6]

	call lock_release
	nop
	ba spin_wait
	nop
	
spin_wait:
	!Wait till FINISH counter is at 2, that way we know we're done with both threads
	ld [%g6], %l3
	cmp %l3, 2
	bne spin_wait
	nop
	ba th_end
	nop

th_main_2:
	setx 100, %l6, %i3
loop_2:
	call lock_acquire	!Lock
	nop

	!Protection Section: Increment mem addr
	ld [%g5], %l3
	inc %l3
	st %l3, [%g5]

	call lock_release	!Unlock
	nop
	dec %i3
	cmp %i3, 0
	bne loop_2
	nop

	!Increment our FINISH counter
	call lock_acquire
	nop

	ld [%g6], %l3
	inc %l3
	st %l3, [%g6]

	call lock_release
loose tie	nop
	ba spin_wait
	nop

th_end:
	setx SHARED, %l6, %g5
	ld [%g5], %g3
	mov %g3, %o0
	!call uart_reg_print
	nop
	ta T_GOOD_TRAP
	nop





#MUTEXES BY CHRIS
	.align 4
	.global mutex_getlock
mutex_getlock:
	setx LOCK_ADDR, %l6, %i4
	ldstub [%l1], %l4	!stores a byte of test reg into mem

	tst %l4		!check if it is 0
	bne mutex_getlock	!wait if it is not
	nop

	retl	!now we are locked
	nop

	.align 4
	.global mutex_unlock
mutex_unlock:
	clr [%o4]	!resets the lock area
	retl
	nop




#MUTEXES BY KATIE
	.align 4
	.global lock_acquire
lock_acquire:
	save     %sp, -96, %sp
	membar  #Sync
lock_loop:
	mov     1, %l0
	casx   [%i0], %g0, %l0
	cmp     %l0, 0
	bne     lock_loop
	nop
	membar  #Sync
	retl
	nop

	.align 4
	.global lock_release
 lock_release:
	save     %sp, -96, %sp
	membar  #Sync
	mov     1, %l0
	casx   [%i0], %l0, %g0
	membar  #Sync
	retl
	nop









	.align 4
	.global uart_reg_print
uart_reg_print:
	mov %o0, %l2
	mov 0x4, %l1
loop_print:
	and %l2, 0x7, %l4
	add %l4, 48, %l4
	mov %l4, %o0
	call uart_char_print
	nop
	srl %l2, 3, %l2
	cmp %l2, 0
	bne loop_print
	nop
	ta T_GOOD_TRAP
!	retl
	nop

	
	.align 4
	.global uart_char_print
uart_char_print:
	setx ADDR1, %l6, %l5
	mov %o0, %l3
	stb %l3, [%l5]
	setx 0x5420,%l6,%l4
loop_10: 
	dec %l4
    	cmp %l4, 0
   	bne loop_10
	nop
	retl
	nop
