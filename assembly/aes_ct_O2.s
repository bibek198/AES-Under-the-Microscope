	.build_version macos, 26, 0	sdk_version 26, 4
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN3aes7make_ctEv              ; -- Begin function _ZN3aes7make_ctEv
	.p2align	2
__ZN3aes7make_ctEv:                     ; @_ZN3aes7make_ctEv
	.cfi_startproc
; %bb.0:
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x8
	mov	w0, #184                        ; =0xb8
	bl	__Znwm
Lloh0:
	adrp	x8, __ZTVN3aes12_GLOBAL__N_15AesCtE@PAGE+16
Lloh1:
	add	x8, x8, __ZTVN3aes12_GLOBAL__N_15AesCtE@PAGEOFF+16
	str	x8, [x0]
	movi.2d	v0, #0000000000000000
	stur	q0, [x0, #8]
	stur	q0, [x0, #24]
	stur	q0, [x0, #40]
	stur	q0, [x0, #56]
	stur	q0, [x0, #72]
	stur	q0, [x0, #88]
	stur	q0, [x0, #104]
	stur	q0, [x0, #120]
	stur	q0, [x0, #136]
	stur	q0, [x0, #152]
	stur	q0, [x0, #168]
	str	x0, [x19]
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
	.loh AdrpAdd	Lloh0, Lloh1
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_15AesCtD1Ev
__ZN3aes12_GLOBAL__N_15AesCtD1Ev:       ; @_ZN3aes12_GLOBAL__N_15AesCtD1Ev
	.cfi_startproc
; %bb.0:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_15AesCtD0Ev
__ZN3aes12_GLOBAL__N_15AesCtD0Ev:       ; @_ZN3aes12_GLOBAL__N_15AesCtD0Ev
	.cfi_startproc
; %bb.0:
	b	__ZdlPv
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_15AesCt7set_keyEPKh
__ZN3aes12_GLOBAL__N_15AesCt7set_keyEPKh: ; @_ZN3aes12_GLOBAL__N_15AesCt7set_keyEPKh
	.cfi_startproc
; %bb.0:
	mov	x8, x1
	add	x1, x0, #8
	mov	x0, x8
	b	__ZN3aes13expand_key_ctEPKhPh
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNK3aes12_GLOBAL__N_15AesCt13encrypt_blockEPKhPh
__ZNK3aes12_GLOBAL__N_15AesCt13encrypt_blockEPKhPh: ; @_ZNK3aes12_GLOBAL__N_15AesCt13encrypt_blockEPKhPh
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #80
	stp	x22, x21, [sp, #32]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #48]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #64]             ; 16-byte Folded Spill
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	mov	x19, x2
	mov	x20, x0
Lloh2:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh3:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh4:
	ldr	x8, [x8]
	str	x8, [sp, #24]
	ldr	q0, [x1]
	str	q0, [sp]
	mov	x0, sp
	add	x1, x20, #8
	bl	__ZN3aes3ref13add_round_keyEPhPKh
	add	x21, x20, #24
	mov	w22, #9                         ; =0x9
LBB4_1:                                 ; =>This Inner Loop Header: Depth=1
	ldr	x0, [sp]
	bl	__ZN3aes12_GLOBAL__N_15sbox8Ey
	str	x0, [sp]
	ldr	x0, [sp, #8]
	bl	__ZN3aes12_GLOBAL__N_15sbox8Ey
	str	x0, [sp, #8]
	mov	x0, sp
	bl	__ZN3aes3ref10shift_rowsEPh
	mov	x0, sp
	bl	__ZN3aes3ref11mix_columnsEPh
	mov	x0, sp
	mov	x1, x21
	bl	__ZN3aes3ref13add_round_keyEPhPKh
	add	x21, x21, #16
	subs	x22, x22, #1
	b.ne	LBB4_1
; %bb.2:
	ldr	x0, [sp]
	bl	__ZN3aes12_GLOBAL__N_15sbox8Ey
	str	x0, [sp]
	ldr	x0, [sp, #8]
	bl	__ZN3aes12_GLOBAL__N_15sbox8Ey
	str	x0, [sp, #8]
	mov	x0, sp
	bl	__ZN3aes3ref10shift_rowsEPh
	mov	x0, sp
	add	x1, x20, #168
	bl	__ZN3aes3ref13add_round_keyEPhPKh
	ldr	q0, [sp]
	str	q0, [x19]
	ldr	x8, [sp, #24]
Lloh5:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh6:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh7:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB4_4
; %bb.3:
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #80
	ret
LBB4_4:
	bl	___stack_chk_fail
	.loh AdrpLdrGotLdr	Lloh2, Lloh3, Lloh4
	.loh AdrpLdrGotLdr	Lloh5, Lloh6, Lloh7
	.cfi_endproc
                                        ; -- End function
	.globl	__ZNK3aes6Aes12814encrypt_blocksEPKhPhm ; -- Begin function _ZNK3aes6Aes12814encrypt_blocksEPKhPhm
	.weak_def_can_be_hidden	__ZNK3aes6Aes12814encrypt_blocksEPKhPhm
	.p2align	2
__ZNK3aes6Aes12814encrypt_blocksEPKhPhm: ; @_ZNK3aes6Aes12814encrypt_blocksEPKhPhm
	.cfi_startproc
; %bb.0:
	cbz	x3, LBB5_4
; %bb.1:
	stp	x22, x21, [sp, #-48]!           ; 16-byte Folded Spill
	stp	x20, x19, [sp, #16]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	mov	x19, x3
	mov	x20, x2
	mov	x21, x1
	mov	x22, x0
LBB5_2:                                 ; =>This Inner Loop Header: Depth=1
	ldr	x8, [x22]
	ldr	x8, [x8, #24]
	mov	x0, x22
	mov	x1, x21
	mov	x2, x20
	blr	x8
	add	x21, x21, #16
	add	x20, x20, #16
	subs	x19, x19, #1
	b.ne	LBB5_2
; %bb.3:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
LBB5_4:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNK3aes12_GLOBAL__N_15AesCt4nameEv
__ZNK3aes12_GLOBAL__N_15AesCt4nameEv:   ; @_ZNK3aes12_GLOBAL__N_15AesCt4nameEv
	.cfi_startproc
; %bb.0:
Lloh8:
	adrp	x0, l_.str@PAGE
Lloh9:
	add	x0, x0, l_.str@PAGEOFF
	ret
	.loh AdrpAdd	Lloh8, Lloh9
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; -- Begin function _ZN3aes12_GLOBAL__N_15sbox8Ey
lCPI7_0:
	.quad	2                               ; 0x2
	.quad	1                               ; 0x1
lCPI7_1:
	.quad	3                               ; 0x3
	.quad	4                               ; 0x4
lCPI7_2:
	.quad	-217020518514230020             ; 0xfcfcfcfcfcfcfcfc
	.quad	-72340172838076674              ; 0xfefefefefefefefe
lCPI7_3:
	.quad	-506381209866536712             ; 0xf8f8f8f8f8f8f8f8
	.quad	-1085102592571150096            ; 0xf0f0f0f0f0f0f0f0
lCPI7_4:
	.quad	-6                              ; 0xfffffffffffffffa
	.quad	-7                              ; 0xfffffffffffffff9
lCPI7_5:
	.quad	-5                              ; 0xfffffffffffffffb
	.quad	-4                              ; 0xfffffffffffffffc
	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__ZN3aes12_GLOBAL__N_15sbox8Ey:         ; @_ZN3aes12_GLOBAL__N_15sbox8Ey
	.cfi_startproc
; %bb.0:
	and	x8, x0, #0x101010101010101
	lsl	x9, x8, #8
	sub	x9, x9, x8
	and	x12, x9, x0
	lsl	x8, x0, #1
	and	x11, x8, #0xfefefefefefefefe
	lsr	x8, x0, #7
	and	x10, x8, #0x101010101010101
	mov	w8, #27                         ; =0x1b
	mul	x13, x10, x8
	eor	x13, x13, x11
	lsr	x11, x0, #1
	and	x11, x11, #0x101010101010101
	lsl	x14, x11, #8
	sub	x11, x14, x11
	and	x14, x13, x11
	eor	x14, x14, x12
	lsl	x12, x13, #1
	and	x12, x12, #0xfefefefefefefefe
	lsr	x13, x13, #7
	and	x13, x13, #0x101010101010101
	mul	x13, x13, x8
	eor	x13, x13, x12
	lsr	x12, x0, #2
	and	x12, x12, #0x101010101010101
	lsl	x15, x12, #8
	sub	x12, x15, x12
	and	x15, x13, x12
	eor	x14, x14, x15
	lsl	x15, x13, #1
	and	x15, x15, #0xfefefefefefefefe
	lsr	x13, x13, #7
	and	x13, x13, #0x101010101010101
	mul	x13, x13, x8
	eor	x15, x13, x15
	lsr	x13, x0, #3
	and	x13, x13, #0x101010101010101
	lsl	x16, x13, #8
	sub	x13, x16, x13
	and	x16, x15, x13
	eor	x16, x14, x16
	lsl	x14, x15, #1
	and	x14, x14, #0xfefefefefefefefe
	lsr	x15, x15, #7
	and	x15, x15, #0x101010101010101
	mul	x15, x15, x8
	eor	x15, x15, x14
	lsr	x14, x0, #4
	and	x14, x14, #0x101010101010101
	lsl	x17, x14, #8
	sub	x14, x17, x14
	and	x17, x15, x14
	eor	x16, x16, x17
	lsl	x17, x15, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x15, x15, #7
	and	x15, x15, #0x101010101010101
	mul	x15, x15, x8
	eor	x17, x15, x17
	lsr	x15, x0, #5
	and	x15, x15, #0x101010101010101
	lsl	x1, x15, #8
	sub	x15, x1, x15
	and	x1, x17, x15
	eor	x1, x16, x1
	lsl	x16, x17, #1
	and	x16, x16, #0xfefefefefefefefe
	lsr	x17, x17, #7
	and	x17, x17, #0x101010101010101
	mul	x17, x17, x8
	eor	x17, x17, x16
	lsr	x16, x0, #6
	and	x16, x16, #0x101010101010101
	lsl	x0, x16, #8
	sub	x16, x0, x16
	and	x0, x17, x16
	eor	x0, x1, x0
	lsl	x1, x17, #1
	and	x1, x1, #0xfefefefefefefefe
	lsr	x17, x17, #7
	and	x17, x17, #0x101010101010101
	mul	x17, x17, x8
	eor	x17, x17, x1
	lsl	x1, x10, #8
	sub	x1, x1, x10
	and	x10, x17, x1
	eor	x10, x0, x10
	and	x17, x10, x9
	lsl	x9, x10, #1
	and	x0, x9, #0xfefefefefefefefe
	lsr	x9, x10, #7
	and	x9, x9, #0x101010101010101
	mul	x2, x9, x8
	eor	x0, x2, x0
	and	x11, x0, x11
	eor	x11, x11, x17
	lsl	x17, x0, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x0, x0, #7
	and	x0, x0, #0x101010101010101
	mul	x0, x0, x8
	eor	x17, x0, x17
	and	x12, x17, x12
	eor	x11, x11, x12
	lsl	x12, x17, #1
	and	x12, x12, #0xfefefefefefefefe
	lsr	x17, x17, #7
	and	x17, x17, #0x101010101010101
	mul	x17, x17, x8
	eor	x12, x17, x12
	and	x13, x12, x13
	eor	x11, x11, x13
	lsl	x13, x12, #1
	and	x13, x13, #0xfefefefefefefefe
	lsr	x12, x12, #7
	and	x12, x12, #0x101010101010101
	mul	x12, x12, x8
	eor	x12, x12, x13
	and	x13, x12, x14
	eor	x11, x11, x13
	lsl	x13, x12, #1
	and	x13, x13, #0xfefefefefefefefe
	lsr	x12, x12, #7
	and	x12, x12, #0x101010101010101
	mul	x12, x12, x8
	eor	x12, x12, x13
	and	x13, x12, x15
	eor	x11, x11, x13
	lsl	x13, x12, #1
	and	x13, x13, #0xfefefefefefefefe
	lsr	x12, x12, #7
	and	x12, x12, #0x101010101010101
	mul	x12, x12, x8
	eor	x12, x12, x13
	and	x13, x12, x16
	eor	x11, x11, x13
	lsl	x13, x12, #1
	and	x13, x13, #0xfefefefefefefefe
	lsr	x12, x12, #7
	and	x12, x12, #0x101010101010101
	mul	x12, x12, x8
	eor	x12, x12, x13
	and	x12, x12, x1
	eor	x0, x11, x12
	and	x11, x0, #0x101010101010101
	lsl	x12, x11, #8
	sub	x11, x12, x11
	and	x14, x11, x0
	lsl	x12, x0, #1
	and	x13, x12, #0xfefefefefefefefe
	lsr	x12, x0, #7
	and	x12, x12, #0x101010101010101
	mul	x15, x12, x8
	eor	x15, x15, x13
	lsr	x13, x0, #1
	and	x13, x13, #0x101010101010101
	lsl	x16, x13, #8
	sub	x13, x16, x13
	and	x16, x15, x13
	eor	x16, x16, x14
	lsl	x14, x15, #1
	and	x14, x14, #0xfefefefefefefefe
	lsr	x15, x15, #7
	and	x15, x15, #0x101010101010101
	mul	x15, x15, x8
	eor	x15, x15, x14
	lsr	x14, x0, #2
	and	x14, x14, #0x101010101010101
	lsl	x17, x14, #8
	sub	x14, x17, x14
	and	x17, x15, x14
	eor	x16, x16, x17
	lsl	x17, x15, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x15, x15, #7
	and	x15, x15, #0x101010101010101
	mul	x15, x15, x8
	eor	x17, x15, x17
	lsr	x15, x0, #3
	and	x15, x15, #0x101010101010101
	lsl	x1, x15, #8
	sub	x15, x1, x15
	and	x1, x17, x15
	eor	x1, x16, x1
	lsl	x16, x17, #1
	and	x16, x16, #0xfefefefefefefefe
	lsr	x17, x17, #7
	and	x17, x17, #0x101010101010101
	mul	x17, x17, x8
	eor	x17, x17, x16
	lsr	x16, x0, #4
	and	x16, x16, #0x101010101010101
	lsl	x2, x16, #8
	sub	x16, x2, x16
	and	x2, x17, x16
	eor	x1, x1, x2
	lsl	x2, x17, #1
	and	x2, x2, #0xfefefefefefefefe
	lsr	x17, x17, #7
	and	x17, x17, #0x101010101010101
	mul	x17, x17, x8
	eor	x2, x17, x2
	lsr	x17, x0, #5
	and	x17, x17, #0x101010101010101
	lsl	x3, x17, #8
	sub	x17, x3, x17
	and	x3, x2, x17
	eor	x1, x1, x3
	lsl	x3, x2, #1
	and	x3, x3, #0xfefefefefefefefe
	lsr	x2, x2, #7
	and	x2, x2, #0x101010101010101
	mul	x2, x2, x8
	eor	x2, x2, x3
	lsr	x0, x0, #6
	and	x0, x0, #0x101010101010101
	lsl	x3, x0, #8
	sub	x0, x3, x0
	and	x3, x2, x0
	eor	x3, x1, x3
	lsl	x1, x2, #1
	and	x1, x1, #0xfefefefefefefefe
	lsr	x2, x2, #7
	and	x2, x2, #0x101010101010101
	mul	x2, x2, x8
	eor	x2, x2, x1
	lsl	x1, x12, #8
	sub	x1, x1, x12
	and	x12, x2, x1
	eor	x2, x3, x12
	and	x12, x2, #0x101010101010101
	lsl	x3, x12, #8
	sub	x12, x3, x12
	and	x3, x12, x2
	lsl	x12, x2, #1
	and	x4, x12, #0xfefefefefefefefe
	lsr	x12, x2, #7
	and	x12, x12, #0x101010101010101
	mul	x5, x12, x8
	eor	x4, x5, x4
	lsr	x5, x2, #1
	and	x5, x5, #0x101010101010101
	lsl	x6, x5, #8
	sub	x5, x6, x5
	and	x5, x4, x5
	eor	x3, x5, x3
	lsl	x5, x4, #1
	and	x5, x5, #0xfefefefefefefefe
	lsr	x4, x4, #7
	and	x4, x4, #0x101010101010101
	mul	x4, x4, x8
	eor	x4, x4, x5
	lsr	x5, x2, #2
	and	x5, x5, #0x101010101010101
	lsl	x6, x5, #8
	sub	x5, x6, x5
	and	x5, x4, x5
	eor	x3, x3, x5
	lsl	x5, x4, #1
	and	x5, x5, #0xfefefefefefefefe
	lsr	x4, x4, #7
	and	x4, x4, #0x101010101010101
	mul	x4, x4, x8
	eor	x4, x4, x5
	lsr	x5, x2, #3
	and	x5, x5, #0x101010101010101
	lsl	x6, x5, #8
	sub	x5, x6, x5
	and	x5, x4, x5
	eor	x3, x3, x5
	lsl	x5, x4, #1
	and	x5, x5, #0xfefefefefefefefe
	lsr	x4, x4, #7
	and	x4, x4, #0x101010101010101
	mul	x4, x4, x8
	eor	x4, x4, x5
	lsr	x5, x2, #4
	and	x5, x5, #0x101010101010101
	lsl	x6, x5, #8
	sub	x5, x6, x5
	and	x5, x4, x5
	eor	x3, x3, x5
	lsl	x5, x4, #1
	and	x5, x5, #0xfefefefefefefefe
	lsr	x4, x4, #7
	and	x4, x4, #0x101010101010101
	mul	x4, x4, x8
	eor	x4, x4, x5
	lsr	x5, x2, #5
	and	x5, x5, #0x101010101010101
	lsl	x6, x5, #8
	sub	x5, x6, x5
	and	x5, x4, x5
	eor	x3, x3, x5
	lsl	x5, x4, #1
	and	x5, x5, #0xfefefefefefefefe
	lsr	x4, x4, #7
	and	x4, x4, #0x101010101010101
	mul	x4, x4, x8
	eor	x4, x4, x5
	lsr	x2, x2, #6
	and	x2, x2, #0x101010101010101
	lsl	x5, x2, #8
	sub	x2, x5, x2
	and	x2, x4, x2
	eor	x2, x3, x2
	lsl	x3, x4, #1
	and	x3, x3, #0xfefefefefefefefe
	lsr	x4, x4, #7
	and	x4, x4, #0x101010101010101
	mul	x4, x4, x8
	eor	x3, x4, x3
	lsl	x4, x12, #8
	sub	x12, x4, x12
	and	x12, x3, x12
	eor	x12, x2, x12
	and	x2, x12, x11
	lsl	x11, x12, #1
	and	x3, x11, #0xfefefefefefefefe
	lsr	x11, x12, #7
	and	x11, x11, #0x101010101010101
	mul	x4, x11, x8
	eor	x3, x4, x3
	and	x13, x3, x13
	eor	x13, x13, x2
	lsl	x2, x3, #1
	and	x2, x2, #0xfefefefefefefefe
	lsr	x3, x3, #7
	and	x3, x3, #0x101010101010101
	mul	x3, x3, x8
	eor	x2, x3, x2
	and	x14, x2, x14
	eor	x13, x13, x14
	lsl	x14, x2, #1
	and	x14, x14, #0xfefefefefefefefe
	lsr	x2, x2, #7
	and	x2, x2, #0x101010101010101
	mul	x2, x2, x8
	eor	x14, x2, x14
	and	x15, x14, x15
	eor	x13, x13, x15
	lsl	x15, x14, #1
	and	x15, x15, #0xfefefefefefefefe
	lsr	x14, x14, #7
	and	x14, x14, #0x101010101010101
	mul	x14, x14, x8
	eor	x14, x14, x15
	and	x15, x14, x16
	eor	x13, x13, x15
	lsl	x15, x14, #1
	and	x15, x15, #0xfefefefefefefefe
	lsr	x14, x14, #7
	and	x14, x14, #0x101010101010101
	mul	x14, x14, x8
	eor	x14, x14, x15
	and	x15, x14, x17
	eor	x13, x13, x15
	lsl	x15, x14, #1
	and	x15, x15, #0xfefefefefefefefe
	lsr	x14, x14, #7
	and	x14, x14, #0x101010101010101
	mul	x14, x14, x8
	eor	x14, x14, x15
	and	x15, x14, x0
	eor	x13, x13, x15
	lsl	x15, x14, #1
	and	x15, x15, #0xfefefefefefefefe
	lsr	x14, x14, #7
	and	x14, x14, #0x101010101010101
	mul	x14, x14, x8
	eor	x14, x14, x15
	and	x14, x14, x1
	eor	x14, x13, x14
	and	x13, x14, #0x101010101010101
	lsl	x15, x13, #8
	sub	x13, x15, x13
	and	x15, x13, x14
	lsl	x13, x14, #1
	and	x16, x13, #0xfefefefefefefefe
	lsr	x13, x14, #7
	and	x13, x13, #0x101010101010101
	mul	x17, x13, x8
	eor	x16, x17, x16
	lsr	x17, x14, #1
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x17, x15
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x17, x14, #2
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x15, x17
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x17, x14, #3
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x15, x17
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x17, x14, #4
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x15, x17
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x17, x14, #5
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x15, x17
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x14, x14, #6
	and	x14, x14, #0x101010101010101
	lsl	x17, x14, #8
	sub	x14, x17, x14
	and	x14, x16, x14
	eor	x14, x15, x14
	lsl	x15, x16, #1
	and	x15, x15, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x15, x16, x15
	lsl	x16, x13, #8
	sub	x13, x16, x13
	and	x13, x15, x13
	eor	x14, x14, x13
	and	x13, x14, #0x101010101010101
	lsl	x15, x13, #8
	sub	x13, x15, x13
	and	x15, x13, x14
	lsl	x13, x14, #1
	and	x16, x13, #0xfefefefefefefefe
	lsr	x13, x14, #7
	and	x13, x13, #0x101010101010101
	mul	x17, x13, x8
	eor	x16, x17, x16
	lsr	x17, x14, #1
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x17, x15
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x17, x14, #2
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x15, x17
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x17, x14, #3
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x15, x17
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x17, x14, #4
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x15, x17
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x17, x14, #5
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x15, x17
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x14, x14, #6
	and	x14, x14, #0x101010101010101
	lsl	x17, x14, #8
	sub	x14, x17, x14
	and	x14, x16, x14
	eor	x14, x15, x14
	lsl	x15, x16, #1
	and	x15, x15, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x15, x16, x15
	lsl	x16, x13, #8
	sub	x13, x16, x13
	and	x13, x15, x13
	eor	x14, x14, x13
	and	x13, x14, #0x101010101010101
	lsl	x15, x13, #8
	sub	x13, x15, x13
	and	x15, x13, x14
	lsl	x13, x14, #1
	and	x16, x13, #0xfefefefefefefefe
	lsr	x13, x14, #7
	and	x13, x13, #0x101010101010101
	mul	x17, x13, x8
	eor	x16, x17, x16
	lsr	x17, x14, #1
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x17, x15
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x17, x14, #2
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x15, x17
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x17, x14, #3
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x15, x17
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x17, x14, #4
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x15, x17
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x17, x14, #5
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x15, x17
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x14, x14, #6
	and	x14, x14, #0x101010101010101
	lsl	x17, x14, #8
	sub	x14, x17, x14
	and	x14, x16, x14
	eor	x14, x15, x14
	lsl	x15, x16, #1
	and	x15, x15, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x15, x16, x15
	lsl	x16, x13, #8
	sub	x13, x16, x13
	and	x13, x15, x13
	eor	x14, x14, x13
	and	x13, x14, #0x101010101010101
	lsl	x15, x13, #8
	sub	x13, x15, x13
	and	x15, x13, x14
	lsl	x13, x14, #1
	and	x16, x13, #0xfefefefefefefefe
	lsr	x13, x14, #7
	and	x13, x13, #0x101010101010101
	mul	x17, x13, x8
	eor	x16, x17, x16
	lsr	x17, x14, #1
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x17, x15
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x17, x14, #2
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x15, x17
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x17, x14, #3
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x15, x17
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x17, x14, #4
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x15, x17
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x17, x14, #5
	and	x17, x17, #0x101010101010101
	lsl	x0, x17, #8
	sub	x17, x0, x17
	and	x17, x16, x17
	eor	x15, x15, x17
	lsl	x17, x16, #1
	and	x17, x17, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x16, x16, x17
	lsr	x14, x14, #6
	and	x14, x14, #0x101010101010101
	lsl	x17, x14, #8
	sub	x14, x17, x14
	and	x14, x16, x14
	eor	x14, x15, x14
	lsl	x15, x16, #1
	and	x15, x15, #0xfefefefefefefefe
	lsr	x16, x16, #7
	and	x16, x16, #0x101010101010101
	mul	x16, x16, x8
	eor	x15, x16, x15
	lsl	x16, x13, #8
	sub	x13, x16, x13
	and	x13, x15, x13
	eor	x13, x14, x13
	and	x14, x12, #0x101010101010101
	lsl	x15, x14, #8
	sub	x14, x15, x14
	and	x14, x13, x14
	lsl	x15, x13, #1
	and	x15, x15, #0xfefefefefefefefe
	lsr	x13, x13, #7
	and	x13, x13, #0x101010101010101
	mul	x13, x13, x8
	eor	x13, x13, x15
	lsr	x15, x12, #1
	and	x15, x15, #0x101010101010101
	lsl	x16, x15, #8
	sub	x15, x16, x15
	and	x15, x13, x15
	eor	x14, x15, x14
	lsl	x15, x13, #1
	and	x15, x15, #0xfefefefefefefefe
	lsr	x13, x13, #7
	and	x13, x13, #0x101010101010101
	mul	x13, x13, x8
	eor	x13, x13, x15
	lsr	x15, x12, #2
	and	x15, x15, #0x101010101010101
	lsl	x16, x15, #8
	sub	x15, x16, x15
	and	x15, x13, x15
	eor	x14, x14, x15
	lsl	x15, x13, #1
	and	x15, x15, #0xfefefefefefefefe
	lsr	x13, x13, #7
	and	x13, x13, #0x101010101010101
	mul	x13, x13, x8
	eor	x13, x13, x15
	lsr	x15, x12, #3
	and	x15, x15, #0x101010101010101
	lsl	x16, x15, #8
	sub	x15, x16, x15
	and	x15, x13, x15
	eor	x14, x14, x15
	lsl	x15, x13, #1
	and	x15, x15, #0xfefefefefefefefe
	lsr	x13, x13, #7
	and	x13, x13, #0x101010101010101
	mul	x13, x13, x8
	eor	x13, x13, x15
	lsr	x15, x12, #4
	and	x15, x15, #0x101010101010101
	lsl	x16, x15, #8
	sub	x15, x16, x15
	and	x15, x13, x15
	eor	x14, x14, x15
	lsl	x15, x13, #1
	and	x15, x15, #0xfefefefefefefefe
	lsr	x13, x13, #7
	and	x13, x13, #0x101010101010101
	mul	x13, x13, x8
	eor	x13, x13, x15
	lsr	x15, x12, #5
	and	x15, x15, #0x101010101010101
	lsl	x16, x15, #8
	sub	x15, x16, x15
	and	x15, x13, x15
	eor	x14, x14, x15
	lsl	x15, x13, #1
	and	x15, x15, #0xfefefefefefefefe
	lsr	x13, x13, #7
	and	x13, x13, #0x101010101010101
	mul	x13, x13, x8
	eor	x13, x13, x15
	lsr	x12, x12, #6
	and	x12, x12, #0x101010101010101
	lsl	x15, x12, #8
	sub	x12, x15, x12
	and	x12, x13, x12
	eor	x12, x14, x12
	lsl	x14, x13, #1
	and	x14, x14, #0xfefefefefefefefe
	lsr	x13, x13, #7
	and	x13, x13, #0x101010101010101
	mul	x13, x13, x8
	eor	x13, x13, x14
	lsl	x14, x11, #8
	sub	x11, x14, x11
	and	x11, x13, x11
	eor	x11, x12, x11
	and	x12, x10, #0x101010101010101
	lsl	x13, x12, #8
	sub	x12, x13, x12
	and	x12, x11, x12
	lsl	x13, x11, #1
	and	x13, x13, #0xfefefefefefefefe
	lsr	x11, x11, #7
	and	x11, x11, #0x101010101010101
	mul	x11, x11, x8
	eor	x11, x11, x13
	lsr	x13, x10, #1
	and	x13, x13, #0x101010101010101
	lsl	x14, x13, #8
	sub	x13, x14, x13
	and	x13, x11, x13
	eor	x12, x13, x12
	lsl	x13, x11, #1
	and	x13, x13, #0xfefefefefefefefe
	lsr	x11, x11, #7
	and	x11, x11, #0x101010101010101
	mul	x11, x11, x8
	eor	x11, x11, x13
	lsr	x13, x10, #2
	and	x13, x13, #0x101010101010101
	lsl	x14, x13, #8
	sub	x13, x14, x13
	and	x13, x11, x13
	eor	x12, x12, x13
	lsl	x13, x11, #1
	and	x13, x13, #0xfefefefefefefefe
	lsr	x11, x11, #7
	and	x11, x11, #0x101010101010101
	mul	x11, x11, x8
	eor	x11, x11, x13
	lsr	x13, x10, #3
	and	x13, x13, #0x101010101010101
	lsl	x14, x13, #8
	sub	x13, x14, x13
	and	x13, x11, x13
	eor	x12, x12, x13
	lsl	x13, x11, #1
	and	x13, x13, #0xfefefefefefefefe
	lsr	x11, x11, #7
	and	x11, x11, #0x101010101010101
	mul	x11, x11, x8
	eor	x11, x11, x13
	lsr	x13, x10, #4
	and	x13, x13, #0x101010101010101
	lsl	x14, x13, #8
	sub	x13, x14, x13
	and	x13, x11, x13
	eor	x12, x12, x13
	lsl	x13, x11, #1
	and	x13, x13, #0xfefefefefefefefe
	lsr	x11, x11, #7
	and	x11, x11, #0x101010101010101
	mul	x11, x11, x8
	eor	x11, x11, x13
	lsr	x13, x10, #5
	and	x13, x13, #0x101010101010101
	lsl	x14, x13, #8
	sub	x13, x14, x13
	and	x13, x11, x13
	eor	x12, x12, x13
	lsl	x13, x11, #1
	and	x13, x13, #0xfefefefefefefefe
	lsr	x11, x11, #7
	and	x11, x11, #0x101010101010101
	mul	x11, x11, x8
	eor	x11, x11, x13
	lsr	x10, x10, #6
	and	x10, x10, #0x101010101010101
	lsl	x13, x10, #8
	sub	x10, x13, x10
	and	x10, x11, x10
	eor	x10, x12, x10
	lsl	x12, x11, #1
	and	x12, x12, #0xfefefefefefefefe
	lsr	x11, x11, #7
	and	x11, x11, #0x101010101010101
	mul	x8, x11, x8
	eor	x8, x8, x12
	lsl	x11, x9, #8
	sub	x9, x11, x9
	and	x8, x8, x9
	eor	x8, x10, x8
	dup.2d	v0, x8
Lloh10:
	adrp	x9, lCPI7_0@PAGE
Lloh11:
	ldr	q1, [x9, lCPI7_0@PAGEOFF]
	ushl.2d	v1, v0, v1
Lloh12:
	adrp	x9, lCPI7_1@PAGE
Lloh13:
	ldr	q2, [x9, lCPI7_1@PAGEOFF]
	ushl.2d	v2, v0, v2
Lloh14:
	adrp	x9, lCPI7_2@PAGE
Lloh15:
	ldr	q3, [x9, lCPI7_2@PAGEOFF]
Lloh16:
	adrp	x9, lCPI7_3@PAGE
Lloh17:
	ldr	q4, [x9, lCPI7_3@PAGEOFF]
Lloh18:
	adrp	x9, lCPI7_4@PAGE
Lloh19:
	ldr	q5, [x9, lCPI7_4@PAGEOFF]
	ushl.2d	v5, v0, v5
Lloh20:
	adrp	x9, lCPI7_5@PAGE
Lloh21:
	ldr	q6, [x9, lCPI7_5@PAGEOFF]
	ushl.2d	v0, v0, v6
	bit.16b	v0, v2, v4
	bif.16b	v1, v5, v3
	eor.16b	v0, v1, v0
	ext.16b	v1, v0, v0, #8
	eor.8b	v0, v0, v1
	fmov	x9, d0
	eor	x8, x9, x8
	mov	x9, #6944656592455360608        ; =0x6060606060606060
	orr	x9, x9, #0x303030303030303
	eor	x0, x8, x9
	ret
	.loh AdrpLdr	Lloh20, Lloh21
	.loh AdrpAdrp	Lloh18, Lloh20
	.loh AdrpLdr	Lloh18, Lloh19
	.loh AdrpAdrp	Lloh16, Lloh18
	.loh AdrpLdr	Lloh16, Lloh17
	.loh AdrpAdrp	Lloh14, Lloh16
	.loh AdrpLdr	Lloh14, Lloh15
	.loh AdrpAdrp	Lloh12, Lloh14
	.loh AdrpLdr	Lloh12, Lloh13
	.loh AdrpAdrp	Lloh10, Lloh12
	.loh AdrpLdr	Lloh10, Lloh11
	.cfi_endproc
                                        ; -- End function
	.section	__DATA,__const
	.p2align	3, 0x0                          ; @_ZTVN3aes12_GLOBAL__N_15AesCtE
__ZTVN3aes12_GLOBAL__N_15AesCtE:
	.quad	0
	.quad	__ZTIN3aes12_GLOBAL__N_15AesCtE
	.quad	__ZN3aes12_GLOBAL__N_15AesCtD1Ev
	.quad	__ZN3aes12_GLOBAL__N_15AesCtD0Ev
	.quad	__ZN3aes12_GLOBAL__N_15AesCt7set_keyEPKh
	.quad	__ZNK3aes12_GLOBAL__N_15AesCt13encrypt_blockEPKhPh
	.quad	__ZNK3aes6Aes12814encrypt_blocksEPKhPhm
	.quad	__ZNK3aes12_GLOBAL__N_15AesCt4nameEv

	.p2align	3, 0x0                          ; @_ZTIN3aes12_GLOBAL__N_15AesCtE
__ZTIN3aes12_GLOBAL__N_15AesCtE:
	.quad	__ZTVN10__cxxabiv120__si_class_type_infoE+16
	.quad	__ZTSN3aes12_GLOBAL__N_15AesCtE
	.quad	__ZTIN3aes6Aes128E

	.section	__TEXT,__const
__ZTSN3aes12_GLOBAL__N_15AesCtE:        ; @_ZTSN3aes12_GLOBAL__N_15AesCtE
	.asciz	"N3aes12_GLOBAL__N_15AesCtE"

	.private_extern	__ZTIN3aes6Aes128E      ; @_ZTIN3aes6Aes128E
	.section	__DATA,__const
	.globl	__ZTIN3aes6Aes128E
	.weak_definition	__ZTIN3aes6Aes128E
	.p2align	3, 0x0
__ZTIN3aes6Aes128E:
	.quad	__ZTVN10__cxxabiv117__class_type_infoE+16
	.quad	__ZTSN3aes6Aes128E-9223372036854775808

	.private_extern	__ZTSN3aes6Aes128E      ; @_ZTSN3aes6Aes128E
	.section	__TEXT,__const
	.globl	__ZTSN3aes6Aes128E
	.weak_definition	__ZTSN3aes6Aes128E
__ZTSN3aes6Aes128E:
	.asciz	"N3aes6Aes128E"

	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"ct"

.subsections_via_symbols
