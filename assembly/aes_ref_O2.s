	.build_version macos, 26, 0	sdk_version 26, 4
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN3aes3ref9sub_bytesEPh       ; -- Begin function _ZN3aes3ref9sub_bytesEPh
	.p2align	2
__ZN3aes3ref9sub_bytesEPh:              ; @_ZN3aes3ref9sub_bytesEPh
	.cfi_startproc
; %bb.0:
	ldrb	w9, [x0]
Lloh0:
	adrp	x8, __ZN3aes4SBOXE@GOTPAGE
Lloh1:
	ldr	x8, [x8, __ZN3aes4SBOXE@GOTPAGEOFF]
	ldrb	w9, [x8, x9]
	strb	w9, [x0]
	ldrb	w9, [x0, #1]
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #1]
	ldrb	w9, [x0, #2]
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #2]
	ldrb	w9, [x0, #3]
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #3]
	ldrb	w9, [x0, #4]
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #4]
	ldrb	w9, [x0, #5]
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #5]
	ldrb	w9, [x0, #6]
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #6]
	ldrb	w9, [x0, #7]
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #7]
	ldrb	w9, [x0, #8]
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #8]
	ldrb	w9, [x0, #9]
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #9]
	ldrb	w9, [x0, #10]
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #10]
	ldrb	w9, [x0, #11]
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #11]
	ldrb	w9, [x0, #12]
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #12]
	ldrb	w9, [x0, #13]
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #13]
	ldrb	w9, [x0, #14]
	ldrb	w9, [x8, x9]
	strb	w9, [x0, #14]
	ldrb	w9, [x0, #15]
	ldrb	w8, [x8, x9]
	strb	w8, [x0, #15]
	ret
	.loh AdrpLdrGot	Lloh0, Lloh1
	.cfi_endproc
                                        ; -- End function
	.globl	__ZN3aes3ref10shift_rowsEPh     ; -- Begin function _ZN3aes3ref10shift_rowsEPh
	.p2align	2
__ZN3aes3ref10shift_rowsEPh:            ; @_ZN3aes3ref10shift_rowsEPh
	.cfi_startproc
; %bb.0:
	ldrb	w8, [x0, #5]
	ldrb	w9, [x0, #10]
	ldrb	w10, [x0, #15]
	ldrb	w11, [x0, #9]
	ldrb	w12, [x0, #14]
	ldrb	w13, [x0, #3]
	ldrb	w14, [x0, #13]
	ldrb	w15, [x0, #2]
	ldrb	w16, [x0, #7]
	ldrb	w17, [x0, #1]
	ldrb	w1, [x0, #6]
	ldrb	w2, [x0, #11]
	strb	w8, [x0, #1]
	strb	w9, [x0, #2]
	strb	w10, [x0, #3]
	strb	w11, [x0, #5]
	strb	w12, [x0, #6]
	strb	w13, [x0, #7]
	strb	w14, [x0, #9]
	strb	w15, [x0, #10]
	strb	w16, [x0, #11]
	strb	w17, [x0, #13]
	strb	w1, [x0, #14]
	strb	w2, [x0, #15]
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; -- Begin function _ZN3aes3ref11mix_columnsEPh
lCPI2_0:
	.byte	1                               ; 0x1
	.byte	2                               ; 0x2
	.byte	3                               ; 0x3
	.byte	3                               ; 0x3
	.byte	5                               ; 0x5
	.byte	6                               ; 0x6
	.byte	7                               ; 0x7
	.byte	7                               ; 0x7
	.byte	9                               ; 0x9
	.byte	10                              ; 0xa
	.byte	11                              ; 0xb
	.byte	11                              ; 0xb
	.byte	13                              ; 0xd
	.byte	14                              ; 0xe
	.byte	15                              ; 0xf
	.byte	15                              ; 0xf
lCPI2_1:
	.byte	1                               ; 0x1
	.byte	2                               ; 0x2
	.byte	1                               ; 0x1
	.byte	1                               ; 0x1
	.byte	5                               ; 0x5
	.byte	6                               ; 0x6
	.byte	5                               ; 0x5
	.byte	5                               ; 0x5
	.byte	9                               ; 0x9
	.byte	10                              ; 0xa
	.byte	9                               ; 0x9
	.byte	9                               ; 0x9
	.byte	13                              ; 0xd
	.byte	14                              ; 0xe
	.byte	13                              ; 0xd
	.byte	13                              ; 0xd
lCPI2_2:
	.byte	2                               ; 0x2
	.byte	0                               ; 0x0
	.byte	0                               ; 0x0
	.byte	0                               ; 0x0
	.byte	6                               ; 0x6
	.byte	4                               ; 0x4
	.byte	4                               ; 0x4
	.byte	4                               ; 0x4
	.byte	10                              ; 0xa
	.byte	8                               ; 0x8
	.byte	8                               ; 0x8
	.byte	8                               ; 0x8
	.byte	14                              ; 0xe
	.byte	12                              ; 0xc
	.byte	12                              ; 0xc
	.byte	12                              ; 0xc
lCPI2_3:
	.byte	255                             ; 0xff
	.byte	3                               ; 0x3
	.byte	3                               ; 0x3
	.byte	2                               ; 0x2
	.byte	255                             ; 0xff
	.byte	7                               ; 0x7
	.byte	7                               ; 0x7
	.byte	6                               ; 0x6
	.byte	255                             ; 0xff
	.byte	11                              ; 0xb
	.byte	11                              ; 0xb
	.byte	10                              ; 0xa
	.byte	255                             ; 0xff
	.byte	15                              ; 0xf
	.byte	15                              ; 0xf
	.byte	14                              ; 0xe
lCPI2_4:
	.byte	1                               ; 0x1
	.byte	16                              ; 0x10
	.byte	17                              ; 0x11
	.byte	0                               ; 0x0
	.byte	5                               ; 0x5
	.byte	20                              ; 0x14
	.byte	21                              ; 0x15
	.byte	4                               ; 0x4
	.byte	9                               ; 0x9
	.byte	24                              ; 0x18
	.byte	25                              ; 0x19
	.byte	8                               ; 0x8
	.byte	13                              ; 0xd
	.byte	28                              ; 0x1c
	.byte	29                              ; 0x1d
	.byte	12                              ; 0xc
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN3aes3ref11mix_columnsEPh
	.p2align	2
__ZN3aes3ref11mix_columnsEPh:           ; @_ZN3aes3ref11mix_columnsEPh
	.cfi_startproc
; %bb.0:
	ldr	q0, [x0]
	add	x8, x0, #8
	ldr	d1, [x0]
	ld1.s	{ v1 }[2], [x8]
	ldrsb	w8, [x0, #12]
	mov	b2, v1[0]
	mov.b	v2[2], v1[4]
	mov.b	v2[4], v1[8]
	mov.h	v2[3], w8
	shl.4h	v1, v2, #8
	add.4h	v2, v2, v2
	cmlt.4h	v1, v1, #0
	movi.4h	v3, #27
	and.8b	v1, v1, v3
	eor.8b	v1, v1, v2
Lloh2:
	adrp	x8, lCPI2_0@PAGE
Lloh3:
	ldr	q2, [x8, lCPI2_0@PAGEOFF]
	tbl.16b	v2, { v0 }, v2
	add.16b	v3, v2, v2
	cmlt.16b	v2, v2, #0
	movi.16b	v4, #27
	and.16b	v2, v2, v4
	eor.16b	v3, v2, v3
Lloh4:
	adrp	x8, lCPI2_1@PAGE
Lloh5:
	ldr	q4, [x8, lCPI2_1@PAGEOFF]
	tbl.16b	v4, { v0 }, v4
Lloh6:
	adrp	x8, lCPI2_2@PAGE
Lloh7:
	ldr	q5, [x8, lCPI2_2@PAGEOFF]
	tbl.16b	v5, { v0 }, v5
Lloh8:
	adrp	x8, lCPI2_3@PAGE
Lloh9:
	ldr	q6, [x8, lCPI2_3@PAGEOFF]
	tbl.16b	v0, { v0 }, v6
	ushll.4s	v1, v1, #0
	movi.2d	v6, #0xffffff00ffffff00
	mov.16b	v2, v6
	bsl.16b	v2, v0, v1
Lloh10:
	adrp	x8, lCPI2_4@PAGE
Lloh11:
	ldr	q0, [x8, lCPI2_4@PAGEOFF]
	tbl.16b	v0, { v2, v3 }, v0
	eor3.16b	v0, v4, v5, v0
	eor3.16b	v0, v0, v2, v3
	str	q0, [x0]
	ret
	.loh AdrpLdr	Lloh10, Lloh11
	.loh AdrpAdrp	Lloh8, Lloh10
	.loh AdrpLdr	Lloh8, Lloh9
	.loh AdrpAdrp	Lloh6, Lloh8
	.loh AdrpLdr	Lloh6, Lloh7
	.loh AdrpAdrp	Lloh4, Lloh6
	.loh AdrpLdr	Lloh4, Lloh5
	.loh AdrpAdrp	Lloh2, Lloh4
	.loh AdrpLdr	Lloh2, Lloh3
	.cfi_endproc
                                        ; -- End function
	.globl	__ZN3aes3ref13add_round_keyEPhPKh ; -- Begin function _ZN3aes3ref13add_round_keyEPhPKh
	.p2align	2
__ZN3aes3ref13add_round_keyEPhPKh:      ; @_ZN3aes3ref13add_round_keyEPhPKh
	.cfi_startproc
; %bb.0:
	ldrb	w8, [x1]
	ldrb	w9, [x0]
	eor	w8, w9, w8
	strb	w8, [x0]
	ldrb	w8, [x1, #1]
	ldrb	w9, [x0, #1]
	eor	w8, w9, w8
	strb	w8, [x0, #1]
	ldrb	w8, [x1, #2]
	ldrb	w9, [x0, #2]
	eor	w8, w9, w8
	strb	w8, [x0, #2]
	ldrb	w8, [x1, #3]
	ldrb	w9, [x0, #3]
	eor	w8, w9, w8
	strb	w8, [x0, #3]
	ldrb	w8, [x1, #4]
	ldrb	w9, [x0, #4]
	eor	w8, w9, w8
	strb	w8, [x0, #4]
	ldrb	w8, [x1, #5]
	ldrb	w9, [x0, #5]
	eor	w8, w9, w8
	strb	w8, [x0, #5]
	ldrb	w8, [x1, #6]
	ldrb	w9, [x0, #6]
	eor	w8, w9, w8
	strb	w8, [x0, #6]
	ldrb	w8, [x1, #7]
	ldrb	w9, [x0, #7]
	eor	w8, w9, w8
	strb	w8, [x0, #7]
	ldrb	w8, [x1, #8]
	ldrb	w9, [x0, #8]
	eor	w8, w9, w8
	strb	w8, [x0, #8]
	ldrb	w8, [x1, #9]
	ldrb	w9, [x0, #9]
	eor	w8, w9, w8
	strb	w8, [x0, #9]
	ldrb	w8, [x1, #10]
	ldrb	w9, [x0, #10]
	eor	w8, w9, w8
	strb	w8, [x0, #10]
	ldrb	w8, [x1, #11]
	ldrb	w9, [x0, #11]
	eor	w8, w9, w8
	strb	w8, [x0, #11]
	ldrb	w8, [x1, #12]
	ldrb	w9, [x0, #12]
	eor	w8, w9, w8
	strb	w8, [x0, #12]
	ldrb	w8, [x1, #13]
	ldrb	w9, [x0, #13]
	eor	w8, w9, w8
	strb	w8, [x0, #13]
	ldrb	w8, [x1, #14]
	ldrb	w9, [x0, #14]
	eor	w8, w9, w8
	strb	w8, [x0, #14]
	ldrb	w8, [x1, #15]
	ldrb	w9, [x0, #15]
	eor	w8, w9, w8
	strb	w8, [x0, #15]
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__ZN3aes8make_refEv             ; -- Begin function _ZN3aes8make_refEv
	.p2align	2
__ZN3aes8make_refEv:                    ; @_ZN3aes8make_refEv
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
Lloh12:
	adrp	x8, __ZTVN3aes12_GLOBAL__N_16AesRefE@PAGE+16
Lloh13:
	add	x8, x8, __ZTVN3aes12_GLOBAL__N_16AesRefE@PAGEOFF+16
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
	.loh AdrpAdd	Lloh12, Lloh13
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_16AesRefD1Ev
__ZN3aes12_GLOBAL__N_16AesRefD1Ev:      ; @_ZN3aes12_GLOBAL__N_16AesRefD1Ev
	.cfi_startproc
; %bb.0:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_16AesRefD0Ev
__ZN3aes12_GLOBAL__N_16AesRefD0Ev:      ; @_ZN3aes12_GLOBAL__N_16AesRefD0Ev
	.cfi_startproc
; %bb.0:
	b	__ZdlPv
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_16AesRef7set_keyEPKh
__ZN3aes12_GLOBAL__N_16AesRef7set_keyEPKh: ; @_ZN3aes12_GLOBAL__N_16AesRef7set_keyEPKh
	.cfi_startproc
; %bb.0:
	mov	x8, x1
	add	x1, x0, #8
	mov	x0, x8
	b	__ZN3aes10expand_keyEPKhPh
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNK3aes12_GLOBAL__N_16AesRef13encrypt_blockEPKhPh
__ZNK3aes12_GLOBAL__N_16AesRef13encrypt_blockEPKhPh: ; @_ZNK3aes12_GLOBAL__N_16AesRef13encrypt_blockEPKhPh
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
Lloh14:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh15:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh16:
	ldr	x8, [x8]
	str	x8, [sp, #24]
	ldr	q0, [x1]
	str	q0, [sp]
	ldur	q0, [x0, #8]
	ldr	q1, [sp]
	eor.16b	v0, v1, v0
	mov	w22, #24                        ; =0x18
Lloh17:
	adrp	x21, __ZN3aes4SBOXE@GOTPAGE
Lloh18:
	ldr	x21, [x21, __ZN3aes4SBOXE@GOTPAGEOFF]
LBB8_1:                                 ; =>This Inner Loop Header: Depth=1
	umov.b	w8, v0[0]
	ldrb	w8, [x21, x8]
	umov.b	w9, v0[1]
	ldrb	w9, [x21, x9]
	umov.b	w10, v0[2]
	ldrb	w10, [x21, x10]
	umov.b	w11, v0[3]
	ldrb	w11, [x21, x11]
	umov.b	w12, v0[4]
	ldrb	w12, [x21, x12]
	strb	w8, [sp]
	strb	w12, [sp, #4]
	umov.b	w8, v0[5]
	ldrb	w8, [x21, x8]
	umov.b	w12, v0[6]
	ldrb	w12, [x21, x12]
	umov.b	w13, v0[7]
	ldrb	w13, [x21, x13]
	umov.b	w14, v0[8]
	ldrb	w14, [x21, x14]
	umov.b	w15, v0[9]
	ldrb	w15, [x21, x15]
	umov.b	w16, v0[10]
	ldrb	w16, [x21, x16]
	umov.b	w17, v0[11]
	ldrb	w17, [x21, x17]
	strb	w14, [sp, #8]
	umov.b	w14, v0[12]
	ldrb	w14, [x21, x14]
	strb	w14, [sp, #12]
	umov.b	w14, v0[13]
	ldrb	w14, [x21, x14]
	umov.b	w0, v0[14]
	ldrb	w0, [x21, x0]
	umov.b	w1, v0[15]
	ldrb	w1, [x21, x1]
	strb	w8, [sp, #1]
	strb	w16, [sp, #2]
	strb	w1, [sp, #3]
	strb	w15, [sp, #5]
	strb	w0, [sp, #6]
	strb	w11, [sp, #7]
	strb	w14, [sp, #9]
	strb	w10, [sp, #10]
	strb	w13, [sp, #11]
	strb	w9, [sp, #13]
	strb	w12, [sp, #14]
	strb	w17, [sp, #15]
	mov	x0, sp
	bl	__ZN3aes3ref11mix_columnsEPh
	ldr	q0, [x20, x22]
	ldr	q1, [sp]
	eor.16b	v0, v1, v0
	str	q0, [sp]
	add	x22, x22, #16
	cmp	x22, #168
	b.ne	LBB8_1
; %bb.2:
	umov.b	w12, v0[0]
	umov.b	w8, v0[1]
	add	x8, x21, w8, uxtb
	umov.b	w9, v0[2]
	umov.b	w10, v0[3]
	add	x9, x21, w9, uxtb
	add	x11, x21, w10, uxtb
	umov.b	w10, v0[4]
	umov.b	w13, v0[5]
	add	x14, x21, w10, uxtb
	add	x13, x21, w13, uxtb
	umov.b	w10, v0[6]
	umov.b	w15, v0[7]
	add	x10, x21, w10, uxtb
	add	x15, x21, w15, uxtb
	umov.b	w16, v0[8]
	umov.b	w17, v0[9]
	add	x16, x21, w16, uxtb
	add	x17, x21, w17, uxtb
	umov.b	w0, v0[10]
	umov.b	w1, v0[11]
	add	x0, x21, w0, uxtb
	add	x1, x21, w1, uxtb
	umov.b	w2, v0[12]
	umov.b	w3, v0[13]
	add	x2, x21, w2, uxtb
	add	x3, x21, w3, uxtb
	umov.b	w4, v0[14]
	umov.b	w5, v0[15]
	add	x4, x21, w4, uxtb
	add	x5, x21, w5, uxtb
	ldr	b0, [x21, x12]
	ld1.b	{ v0 }[1], [x13]
	ld1.b	{ v0 }[2], [x0]
	ld1.b	{ v0 }[3], [x5]
	ld1.b	{ v0 }[4], [x14]
	ld1.b	{ v0 }[5], [x17]
	ld1.b	{ v0 }[6], [x4]
	ld1.b	{ v0 }[7], [x11]
	ld1.b	{ v0 }[8], [x16]
	ld1.b	{ v0 }[9], [x3]
	ld1.b	{ v0 }[10], [x9]
	ld1.b	{ v0 }[11], [x15]
	ld1.b	{ v0 }[12], [x2]
	ld1.b	{ v0 }[13], [x8]
	ldur	q1, [x20, #168]
	ld1.b	{ v0 }[14], [x10]
	ld1.b	{ v0 }[15], [x1]
	eor.16b	v0, v1, v0
	str	q0, [sp]
	ldr	q0, [sp]
	str	q0, [x19]
	ldr	x8, [sp, #24]
Lloh19:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh20:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh21:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB8_4
; %bb.3:
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #48]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #80
	ret
LBB8_4:
	bl	___stack_chk_fail
	.loh AdrpLdrGot	Lloh17, Lloh18
	.loh AdrpLdrGotLdr	Lloh14, Lloh15, Lloh16
	.loh AdrpLdrGotLdr	Lloh19, Lloh20, Lloh21
	.cfi_endproc
                                        ; -- End function
	.globl	__ZNK3aes6Aes12814encrypt_blocksEPKhPhm ; -- Begin function _ZNK3aes6Aes12814encrypt_blocksEPKhPhm
	.weak_def_can_be_hidden	__ZNK3aes6Aes12814encrypt_blocksEPKhPhm
	.p2align	2
__ZNK3aes6Aes12814encrypt_blocksEPKhPhm: ; @_ZNK3aes6Aes12814encrypt_blocksEPKhPhm
	.cfi_startproc
; %bb.0:
	cbz	x3, LBB9_4
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
LBB9_2:                                 ; =>This Inner Loop Header: Depth=1
	ldr	x8, [x22]
	ldr	x8, [x8, #24]
	mov	x0, x22
	mov	x1, x21
	mov	x2, x20
	blr	x8
	add	x21, x21, #16
	add	x20, x20, #16
	subs	x19, x19, #1
	b.ne	LBB9_2
; %bb.3:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp], #48             ; 16-byte Folded Reload
LBB9_4:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNK3aes12_GLOBAL__N_16AesRef4nameEv
__ZNK3aes12_GLOBAL__N_16AesRef4nameEv:  ; @_ZNK3aes12_GLOBAL__N_16AesRef4nameEv
	.cfi_startproc
; %bb.0:
Lloh22:
	adrp	x0, l_.str@PAGE
Lloh23:
	add	x0, x0, l_.str@PAGEOFF
	ret
	.loh AdrpAdd	Lloh22, Lloh23
	.cfi_endproc
                                        ; -- End function
	.section	__DATA,__const
	.p2align	3, 0x0                          ; @_ZTVN3aes12_GLOBAL__N_16AesRefE
__ZTVN3aes12_GLOBAL__N_16AesRefE:
	.quad	0
	.quad	__ZTIN3aes12_GLOBAL__N_16AesRefE
	.quad	__ZN3aes12_GLOBAL__N_16AesRefD1Ev
	.quad	__ZN3aes12_GLOBAL__N_16AesRefD0Ev
	.quad	__ZN3aes12_GLOBAL__N_16AesRef7set_keyEPKh
	.quad	__ZNK3aes12_GLOBAL__N_16AesRef13encrypt_blockEPKhPh
	.quad	__ZNK3aes6Aes12814encrypt_blocksEPKhPhm
	.quad	__ZNK3aes12_GLOBAL__N_16AesRef4nameEv

	.p2align	3, 0x0                          ; @_ZTIN3aes12_GLOBAL__N_16AesRefE
__ZTIN3aes12_GLOBAL__N_16AesRefE:
	.quad	__ZTVN10__cxxabiv120__si_class_type_infoE+16
	.quad	__ZTSN3aes12_GLOBAL__N_16AesRefE
	.quad	__ZTIN3aes6Aes128E

	.section	__TEXT,__const
__ZTSN3aes12_GLOBAL__N_16AesRefE:       ; @_ZTSN3aes12_GLOBAL__N_16AesRefE
	.asciz	"N3aes12_GLOBAL__N_16AesRefE"

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
	.asciz	"ref"

.subsections_via_symbols
