	.build_version macos, 26, 0	sdk_version 26, 4
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN3aes10make_armv8Ev          ; -- Begin function _ZN3aes10make_armv8Ev
	.p2align	2
__ZN3aes10make_armv8Ev:                 ; @_ZN3aes10make_armv8Ev
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
	mov	w0, #192                        ; =0xc0
	bl	__Znwm
Lloh0:
	adrp	x8, __ZTVN3aes12_GLOBAL__N_18AesArmv8E@PAGE+16
Lloh1:
	add	x8, x8, __ZTVN3aes12_GLOBAL__N_18AesArmv8E@PAGEOFF+16
	stp	x8, xzr, [x0]
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x0, #16]
	stp	q0, q0, [x0, #48]
	stp	q0, q0, [x0, #80]
	stp	q0, q0, [x0, #112]
	stp	q0, q0, [x0, #144]
	str	q0, [x0, #176]
	str	x0, [x19]
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
	.loh AdrpAdd	Lloh0, Lloh1
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_18AesArmv8D1Ev
__ZN3aes12_GLOBAL__N_18AesArmv8D1Ev:    ; @_ZN3aes12_GLOBAL__N_18AesArmv8D1Ev
	.cfi_startproc
; %bb.0:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_18AesArmv8D0Ev
__ZN3aes12_GLOBAL__N_18AesArmv8D0Ev:    ; @_ZN3aes12_GLOBAL__N_18AesArmv8D0Ev
	.cfi_startproc
; %bb.0:
	b	__ZdlPv
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_18AesArmv87set_keyEPKh
__ZN3aes12_GLOBAL__N_18AesArmv87set_keyEPKh: ; @_ZN3aes12_GLOBAL__N_18AesArmv87set_keyEPKh
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #224
	stp	x20, x19, [sp, #192]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #208]            ; 16-byte Folded Spill
	add	x29, sp, #208
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x8, x1
	mov	x19, x0
Lloh2:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh3:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh4:
	ldr	x9, [x9]
	stur	x9, [x29, #-24]
	add	x1, sp, #8
	mov	x0, x8
	bl	__ZN3aes13expand_key_ctEPKhPh
	ldur	q0, [sp, #136]
	ldur	q1, [sp, #152]
	stp	q0, q1, [x19, #144]
	ldur	q0, [sp, #168]
	str	q0, [x19, #176]
	ldur	q0, [sp, #72]
	ldur	q1, [sp, #88]
	stp	q0, q1, [x19, #80]
	ldur	q0, [sp, #120]
	ldur	q1, [sp, #104]
	stp	q1, q0, [x19, #112]
	ldur	q0, [sp, #8]
	ldur	q1, [sp, #24]
	stp	q0, q1, [x19, #16]
	ldur	q0, [sp, #56]
	ldur	q1, [sp, #40]
	stp	q1, q0, [x19, #48]
Lloh5:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh6:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh7:
	ldr	x8, [x8]
	ldur	x9, [x29, #-24]
	cmp	x8, x9
	b.ne	LBB3_2
; %bb.1:
	ldp	x29, x30, [sp, #208]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #192]            ; 16-byte Folded Reload
	add	sp, sp, #224
	ret
LBB3_2:
	bl	___stack_chk_fail
	.loh AdrpLdrGotLdr	Lloh5, Lloh6, Lloh7
	.loh AdrpLdrGotLdr	Lloh2, Lloh3, Lloh4
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNK3aes12_GLOBAL__N_18AesArmv813encrypt_blockEPKhPh
__ZNK3aes12_GLOBAL__N_18AesArmv813encrypt_blockEPKhPh: ; @_ZNK3aes12_GLOBAL__N_18AesArmv813encrypt_blockEPKhPh
	.cfi_startproc
; %bb.0:
	ldr	q0, [x1]
	ldp	q1, q2, [x0, #16]
	aese.16b	v1, v0
	aesmc.16b	v1, v1
	aese.16b	v2, v1
	aesmc.16b	v2, v2
	ldp	q0, q1, [x0, #48]
	aese.16b	v0, v2
	aesmc.16b	v0, v0
	aese.16b	v1, v0
	aesmc.16b	v1, v1
	ldp	q0, q2, [x0, #80]
	aese.16b	v0, v1
	aesmc.16b	v0, v0
	aese.16b	v2, v0
	aesmc.16b	v2, v2
	ldp	q0, q1, [x0, #112]
	aese.16b	v0, v2
	aesmc.16b	v0, v0
	aese.16b	v1, v0
	aesmc.16b	v1, v1
	ldp	q0, q2, [x0, #144]
	aese.16b	v0, v1
	aesmc.16b	v0, v0
	ldr	q1, [x0, #176]
	aese.16b	v2, v0
	eor.16b	v0, v1, v2
	str	q0, [x2]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNK3aes12_GLOBAL__N_18AesArmv814encrypt_blocksEPKhPhm
__ZNK3aes12_GLOBAL__N_18AesArmv814encrypt_blocksEPKhPhm: ; @_ZNK3aes12_GLOBAL__N_18AesArmv814encrypt_blocksEPKhPhm
	.cfi_startproc
; %bb.0:
	cmp	x3, #4
	b.hs	LBB5_2
; %bb.1:
	mov	x11, #0                         ; =0x0
	b	LBB5_4
LBB5_2:
	mov	x10, #0                         ; =0x0
	add	x8, x2, #32
	add	x9, x1, #32
LBB5_3:                                 ; =>This Inner Loop Header: Depth=1
	ldp	q3, q2, [x9, #-32]
	ldp	q1, q0, [x9], #64
	ldp	q4, q5, [x0, #16]
	aese.16b	v3, v4
	aesmc.16b	v3, v3
	aese.16b	v2, v4
	aesmc.16b	v2, v2
	aese.16b	v1, v4
	aesmc.16b	v1, v1
	aese.16b	v0, v4
	aesmc.16b	v0, v0
	aese.16b	v3, v5
	aesmc.16b	v3, v3
	aese.16b	v2, v5
	aesmc.16b	v2, v2
	aese.16b	v1, v5
	aesmc.16b	v1, v1
	aese.16b	v0, v5
	aesmc.16b	v0, v0
	ldp	q4, q5, [x0, #48]
	aese.16b	v3, v4
	aesmc.16b	v3, v3
	aese.16b	v2, v4
	aesmc.16b	v2, v2
	aese.16b	v1, v4
	aesmc.16b	v1, v1
	aese.16b	v0, v4
	aesmc.16b	v0, v0
	aese.16b	v3, v5
	aesmc.16b	v3, v3
	aese.16b	v2, v5
	aesmc.16b	v2, v2
	aese.16b	v1, v5
	aesmc.16b	v1, v1
	aese.16b	v0, v5
	aesmc.16b	v0, v0
	ldp	q4, q5, [x0, #80]
	aese.16b	v3, v4
	aesmc.16b	v3, v3
	aese.16b	v2, v4
	aesmc.16b	v2, v2
	aese.16b	v1, v4
	aesmc.16b	v1, v1
	aese.16b	v0, v4
	aesmc.16b	v0, v0
	aese.16b	v3, v5
	aesmc.16b	v3, v3
	aese.16b	v2, v5
	aesmc.16b	v2, v2
	aese.16b	v1, v5
	aesmc.16b	v1, v1
	aese.16b	v0, v5
	aesmc.16b	v0, v0
	ldp	q4, q5, [x0, #112]
	aese.16b	v3, v4
	aesmc.16b	v3, v3
	aese.16b	v2, v4
	aesmc.16b	v2, v2
	aese.16b	v1, v4
	aesmc.16b	v1, v1
	aese.16b	v0, v4
	aesmc.16b	v0, v0
	aese.16b	v3, v5
	aesmc.16b	v3, v3
	aese.16b	v2, v5
	aesmc.16b	v2, v2
	aese.16b	v1, v5
	aesmc.16b	v1, v1
	aese.16b	v0, v5
	aesmc.16b	v0, v0
	ldp	q4, q5, [x0, #144]
	aese.16b	v3, v4
	aesmc.16b	v3, v3
	aese.16b	v2, v4
	aesmc.16b	v2, v2
	aese.16b	v1, v4
	aesmc.16b	v1, v1
	aese.16b	v0, v4
	aesmc.16b	v0, v0
	ldr	q4, [x0, #176]
	aese.16b	v3, v5
	eor.16b	v3, v4, v3
	aese.16b	v2, v5
	eor.16b	v2, v2, v4
	aese.16b	v1, v5
	eor.16b	v1, v1, v4
	aese.16b	v0, v5
	eor.16b	v0, v0, v4
	stp	q3, q2, [x8, #-32]
	add	x11, x10, #4
	add	x12, x10, #8
	stp	q1, q0, [x8], #64
	mov	x10, x11
	cmp	x12, x3
	b.ls	LBB5_3
LBB5_4:
	subs	x8, x3, x11
	b.ls	LBB5_7
; %bb.5:
	lsl	x10, x11, #4
	add	x9, x1, x10
	add	x10, x2, x10
LBB5_6:                                 ; =>This Inner Loop Header: Depth=1
	ldr	q0, [x9], #16
	ldp	q1, q2, [x0, #16]
	aese.16b	v1, v0
	aesmc.16b	v1, v1
	aese.16b	v2, v1
	aesmc.16b	v2, v2
	ldp	q0, q1, [x0, #48]
	aese.16b	v0, v2
	aesmc.16b	v0, v0
	aese.16b	v1, v0
	aesmc.16b	v1, v1
	ldp	q0, q2, [x0, #80]
	aese.16b	v0, v1
	aesmc.16b	v0, v0
	aese.16b	v2, v0
	aesmc.16b	v2, v2
	ldp	q0, q1, [x0, #112]
	aese.16b	v0, v2
	aesmc.16b	v0, v0
	aese.16b	v1, v0
	aesmc.16b	v1, v1
	ldp	q0, q2, [x0, #144]
	aese.16b	v0, v1
	aesmc.16b	v0, v0
	ldr	q1, [x0, #176]
	aese.16b	v2, v0
	eor.16b	v0, v1, v2
	str	q0, [x10], #16
	subs	x8, x8, #1
	b.ne	LBB5_6
LBB5_7:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNK3aes12_GLOBAL__N_18AesArmv84nameEv
__ZNK3aes12_GLOBAL__N_18AesArmv84nameEv: ; @_ZNK3aes12_GLOBAL__N_18AesArmv84nameEv
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
	.section	__DATA,__const
	.p2align	3, 0x0                          ; @_ZTVN3aes12_GLOBAL__N_18AesArmv8E
__ZTVN3aes12_GLOBAL__N_18AesArmv8E:
	.quad	0
	.quad	__ZTIN3aes12_GLOBAL__N_18AesArmv8E
	.quad	__ZN3aes12_GLOBAL__N_18AesArmv8D1Ev
	.quad	__ZN3aes12_GLOBAL__N_18AesArmv8D0Ev
	.quad	__ZN3aes12_GLOBAL__N_18AesArmv87set_keyEPKh
	.quad	__ZNK3aes12_GLOBAL__N_18AesArmv813encrypt_blockEPKhPh
	.quad	__ZNK3aes12_GLOBAL__N_18AesArmv814encrypt_blocksEPKhPhm
	.quad	__ZNK3aes12_GLOBAL__N_18AesArmv84nameEv

	.p2align	3, 0x0                          ; @_ZTIN3aes12_GLOBAL__N_18AesArmv8E
__ZTIN3aes12_GLOBAL__N_18AesArmv8E:
	.quad	__ZTVN10__cxxabiv120__si_class_type_infoE+16
	.quad	__ZTSN3aes12_GLOBAL__N_18AesArmv8E
	.quad	__ZTIN3aes6Aes128E

	.section	__TEXT,__const
__ZTSN3aes12_GLOBAL__N_18AesArmv8E:     ; @_ZTSN3aes12_GLOBAL__N_18AesArmv8E
	.asciz	"N3aes12_GLOBAL__N_18AesArmv8E"

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
	.asciz	"armv8"

.subsections_via_symbols
