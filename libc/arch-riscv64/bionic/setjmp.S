/*
 * Copyright (C) 2013 The Android Open Source Project
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#include <private/bionic_asm.h>
#include <private/bionic_constants.h>

ENTRY(setjmp)
__BIONIC_WEAK_ASM_FOR_NATIVE_BRIDGE(setjmp)
	li	a1, 1
#ifdef __PIC__
	auipc	a2, 0
	/* FIXME:riscv */
	jalr    x0, 42(a2)
#else
	j	sigsetjmp
#endif

END(setjmp)

ENTRY(_setjmp)
__BIONIC_WEAK_ASM_FOR_NATIVE_BRIDGE(_setjmp)
	li	a1, 0
#ifdef __PIC__
	auipc	a2, 0
	jalr    x0, 18(a2)
#else
	j	sigsetjmp
#endif
END(_setjmp)

// int sigsetjmp(sigjmp_buf env, int save_signal_mask);
ENTRY(sigsetjmp)
__BIONIC_WEAK_ASM_FOR_NATIVE_BRIDGE(sigsetjmp)
	addi	sp, sp, -24
	sd	a0, 8(sp)
	sd	ra, 16(sp)

	mv	a0, a1
#ifdef __PIC__
	call	__bionic_setjmp_cookie_get@plt
#else
	j	__bionic_setjmp_cookie_get
#endif
	mv	a1, a0
	ld      a0, 8(sp)
	sd	a1, 0(a0)

	beqz	a1, 1f
	sd	a1, 0(sp)

	li	a1, 0
	addi	a2, a0, 8
#ifdef __PIC__
	call	sigprocmask@plt
#else
	j	sigprocmask
#endif
	ld	a1, 0(sp)
1:
	ld	a0, 8(sp)
	ld	ra, 16(sp)
	addi	sp, sp, 24

        sd	ra, 16(a0)
        sd	s0, 24(a0)
        sd	s1, 32(a0)
        sd	s2, 40(a0)
        sd	s3, 48(a0)
        sd	s4, 56(a0)
        sd	s5, 64(a0)
        sd	s6, 72(a0)
        sd	s7, 80(a0)
        sd	s8, 88(a0)
        sd	s9, 96(a0)
        sd	s10, 104(a0)
        sd	s11, 112(a0)
        sd	sp, 120(a0)

        fsd	fs0, 128(a0)
        fsd	fs1, 136(a0)
        fsd	fs2, 144(a0)
        fsd	fs3, 152(a0)
        fsd	fs4, 160(a0)
        fsd	fs5, 168(a0)
        fsd	fs6, 176(a0)
        fsd	fs7, 184(a0)
        fsd	fs8, 192(a0)
        fsd	fs9, 200(a0)
        fsd	fs10, 208(a0)
        fsd	fs11, 216(a0)

	li	a0, 0
	ret
END(sigsetjmp)

// void siglongjmp(sigjmp_buf env, int value);
ENTRY(siglongjmp)
__BIONIC_WEAK_ASM_FOR_NATIVE_BRIDGE(siglongjmp)
	ld	a2, 0(a0)
	beqz	a1, 1f

	addi	sp, sp, -16
	sd	a0, 0(sp)
	sd	ra, 8(sp)

	mv	t0, a1

	mv	a2, a0
	li	a0, 2
	addi	a1, a2, 8
	li	a2, 0
#ifdef __PIC__
	call	sigprocmask@plt
#else
	j	sigprocmask
#endif
	mv	a1, t0

	ld	a0, 0(sp)
	ld	ra, 8(sp)
	addi	sp, sp, 16

	ld      a2, 0(a0)
1:
        ld	ra, 16(a0)
        ld	s0, 24(a0)
        ld	s1, 32(a0)
        ld	s2, 40(a0)
        ld	s3, 48(a0)
        ld	s4, 56(a0)
        ld	s5, 64(a0)
        ld	s6, 72(a0)
        ld	s7, 80(a0)
        ld	s8, 88(a0)
        ld	s9, 96(a0)
        ld	s10, 104(a0)
        ld	s11, 112(a0)
        ld	sp, 120(a0)

	addi	sp, sp, -24
	sd	ra, 0(sp)
	sd	a0, 8(sp)
	sd	a1, 16(sp)
	ld	a0, 0(a0)
#ifdef __PIC__
	call	__bionic_setjmp_cookie_check@plt
#else
	jal	__bionic_setjmp_cookie_check
#endif
	ld	ra, 0(sp)
	ld	a0, 8(sp)
	ld	a1, 16(sp)
	addi	sp, sp, 24

        fld	fs0, 128(a0)
        fld	fs1, 136(a0)
        fld	fs2, 144(a0)
        fld	fs3, 152(a0)
        fld	fs4, 160(a0)
        fld	fs5, 168(a0)
        fld	fs6, 176(a0)
        fld	fs7, 184(a0)
        fld	fs8, 192(a0)
        fld	fs9, 200(a0)
        fld	fs10, 208(a0)
        fld	fs11, 216(a0)

	// Set return value.
	beqz	a1, 2f
	li	a0, 1
2:
	mv	a0, a1
	ret
END(siglongjmp)

ALIAS_SYMBOL(longjmp, siglongjmp)
__BIONIC_WEAK_ASM_FOR_NATIVE_BRIDGE(longjmp)
ALIAS_SYMBOL(_longjmp, siglongjmp)
__BIONIC_WEAK_ASM_FOR_NATIVE_BRIDGE(_longjmp)
