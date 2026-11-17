	.build_version macos, 26, 0	sdk_version 26, 4
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN3aes16control_workloadEh    ; -- Begin function _ZN3aes16control_workloadEh
	.p2align	2
__ZN3aes16control_workloadEh:           ; @_ZN3aes16control_workloadEh
	.cfi_startproc
; %bb.0:
	mov	w8, #64                         ; =0x40
	mov	w9, #26125                      ; =0x660d
	movk	w9, #25, lsl #16
	mov	w10, #62303                     ; =0xf35f
	movk	w10, #15470, lsl #16
LBB0_1:                                 ; =>This Inner Loop Header: Depth=1
	madd	w0, w0, w9, w10
	; InlineAsm Start
	; InlineAsm End
	subs	w8, w8, #1
	b.ne	LBB0_1
; %bb.2:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__ZN3aes10leaky_gateEh          ; -- Begin function _ZN3aes10leaky_gateEh
	.p2align	2
__ZN3aes10leaky_gateEh:                 ; @_ZN3aes10leaky_gateEh
	.cfi_startproc
; %bb.0:
	tbnz	w0, #7, LBB1_2
; %bb.1:
	b	__ZN3aes16control_workloadEh
LBB1_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__ZN3aes9twin_gateEh            ; -- Begin function _ZN3aes9twin_gateEh
	.p2align	2
__ZN3aes9twin_gateEh:                   ; @_ZN3aes9twin_gateEh
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
	mov	x19, x0
	lsl	w20, w0, #24
	bl	__ZN3aes16control_workloadEh
	bic	w8, w0, w20, asr #31
	neg	w9, w19, lsr #7
	and	w9, w9, w19
	orr	w0, w8, w9
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__ZN3aes14make_pos_leakyEv      ; -- Begin function _ZN3aes14make_pos_leakyEv
	.p2align	2
__ZN3aes14make_pos_leakyEv:             ; @_ZN3aes14make_pos_leakyEv
Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception0
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
	mov	w0, #32                         ; =0x20
	bl	__Znwm
	mov	x20, x0
Lloh0:
	adrp	x9, __ZTVN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEE@PAGE+16
Lloh1:
	add	x9, x9, __ZTVN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEE@PAGEOFF+16
	mov	x8, x0
	str	x9, [x8], #8
Ltmp0:
	bl	__ZN3aes10make_armv8Ev
Ltmp1:
; %bb.1:
	strb	wzr, [x20, #16]
Lloh2:
	adrp	x8, l_.str@PAGE
Lloh3:
	add	x8, x8, l_.str@PAGEOFF
	str	x8, [x20, #24]
	str	x20, [x19]
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB3_2:
Ltmp2:
	mov	x19, x0
	mov	x0, x20
	bl	__ZdlPv
	mov	x0, x19
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh0, Lloh1
	.loh AdrpAdd	Lloh2, Lloh3
Lfunc_end0:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table3:
Lexception0:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end0-Lcst_begin0
Lcst_begin0:
	.uleb128 Lfunc_begin0-Lfunc_begin0      ; >> Call Site 1 <<
	.uleb128 Ltmp0-Lfunc_begin0             ;   Call between Lfunc_begin0 and Ltmp0
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp0-Lfunc_begin0             ; >> Call Site 2 <<
	.uleb128 Ltmp1-Ltmp0                    ;   Call between Ltmp0 and Ltmp1
	.uleb128 Ltmp2-Lfunc_begin0             ;     jumps to Ltmp2
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp1-Lfunc_begin0             ; >> Call Site 3 <<
	.uleb128 Lfunc_end0-Ltmp1               ;   Call between Ltmp1 and Lfunc_end0
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end0:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN3aes13make_pos_twinEv       ; -- Begin function _ZN3aes13make_pos_twinEv
	.p2align	2
__ZN3aes13make_pos_twinEv:              ; @_ZN3aes13make_pos_twinEv
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception1
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
	mov	w0, #32                         ; =0x20
	bl	__Znwm
	mov	x20, x0
Lloh4:
	adrp	x9, __ZTVN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEE@PAGE+16
Lloh5:
	add	x9, x9, __ZTVN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEE@PAGEOFF+16
	mov	x8, x0
	str	x9, [x8], #8
Ltmp3:
	bl	__ZN3aes10make_armv8Ev
Ltmp4:
; %bb.1:
	strb	wzr, [x20, #16]
Lloh6:
	adrp	x8, l_.str.1@PAGE
Lloh7:
	add	x8, x8, l_.str.1@PAGEOFF
	str	x8, [x20, #24]
	str	x20, [x19]
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
LBB4_2:
Ltmp5:
	mov	x19, x0
	mov	x0, x20
	bl	__ZdlPv
	mov	x0, x19
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpAdd	Lloh6, Lloh7
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table4:
Lexception1:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end1-Lcst_begin1
Lcst_begin1:
	.uleb128 Lfunc_begin1-Lfunc_begin1      ; >> Call Site 1 <<
	.uleb128 Ltmp3-Lfunc_begin1             ;   Call between Lfunc_begin1 and Ltmp3
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp3-Lfunc_begin1             ; >> Call Site 2 <<
	.uleb128 Ltmp4-Ltmp3                    ;   Call between Ltmp3 and Ltmp4
	.uleb128 Ltmp5-Lfunc_begin1             ;     jumps to Ltmp5
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp4-Lfunc_begin1             ; >> Call Site 3 <<
	.uleb128 Lfunc_end1-Ltmp4               ;   Call between Ltmp4 and Lfunc_end1
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end1:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED1Ev
__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED1Ev: ; @_ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED1Ev
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #8]
	str	xzr, [x0, #8]
	cbz	x8, LBB5_2
; %bb.1:
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	ldr	x9, [x8]
	ldr	x9, [x9, #8]
	mov	x19, x0
	mov	x0, x8
	blr	x9
	mov	x0, x19
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
LBB5_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED0Ev
__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED0Ev: ; @_ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED0Ev
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #8]
	str	xzr, [x0, #8]
	cbz	x8, LBB6_2
; %bb.1:
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	ldr	x9, [x8]
	ldr	x9, [x9, #8]
	mov	x19, x0
	mov	x0, x8
	blr	x9
	mov	x0, x19
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
LBB6_2:
	b	__ZdlPv
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE7set_keyEPKh
__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE7set_keyEPKh: ; @_ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE7set_keyEPKh
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
	mov	x19, x1
	mov	x20, x0
	ldr	x0, [x0, #8]
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	ldrb	w8, [x19]
	strb	w8, [x20, #16]
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE13encrypt_blockEPKhPh
__ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE13encrypt_blockEPKhPh: ; @_ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE13encrypt_blockEPKhPh
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x20, x19, [sp, #16]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x1
	mov	x20, x0
	ldr	x0, [x0, #8]
	ldr	x8, [x0]
	ldr	x8, [x8, #24]
	blr	x8
	ldrb	w8, [x19]
	ldrb	w9, [x20, #16]
	eor	w8, w9, w8
	and	x8, x8, #0xff
Lloh8:
	adrp	x9, __ZN3aes4SBOXE@GOTPAGE
Lloh9:
	ldr	x9, [x9, __ZN3aes4SBOXE@GOTPAGEOFF]
	ldrb	w0, [x9, x8]
	bl	__ZN3aes10leaky_gateEh
	str	w0, [sp, #12]
	add	x8, sp, #12
	; InlineAsm Start
	; InlineAsm End
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.loh AdrpLdrGot	Lloh8, Lloh9
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
	.p2align	2                               ; -- Begin function _ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE4nameEv
__ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE4nameEv: ; @_ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE4nameEv
	.cfi_startproc
; %bb.0:
	ldr	x0, [x0, #24]
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED1Ev
__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED1Ev: ; @_ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED1Ev
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #8]
	str	xzr, [x0, #8]
	cbz	x8, LBB11_2
; %bb.1:
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	ldr	x9, [x8]
	ldr	x9, [x9, #8]
	mov	x19, x0
	mov	x0, x8
	blr	x9
	mov	x0, x19
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
LBB11_2:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED0Ev
__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED0Ev: ; @_ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED0Ev
	.cfi_startproc
; %bb.0:
	ldr	x8, [x0, #8]
	str	xzr, [x0, #8]
	cbz	x8, LBB12_2
; %bb.1:
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	ldr	x9, [x8]
	ldr	x9, [x9, #8]
	mov	x19, x0
	mov	x0, x8
	blr	x9
	mov	x0, x19
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
LBB12_2:
	b	__ZdlPv
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE7set_keyEPKh
__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE7set_keyEPKh: ; @_ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE7set_keyEPKh
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
	mov	x19, x1
	mov	x20, x0
	ldr	x0, [x0, #8]
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	ldrb	w8, [x19]
	strb	w8, [x20, #16]
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE13encrypt_blockEPKhPh
__ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE13encrypt_blockEPKhPh: ; @_ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE13encrypt_blockEPKhPh
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x20, x19, [sp, #16]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x1
	mov	x20, x0
	ldr	x0, [x0, #8]
	ldr	x8, [x0]
	ldr	x8, [x8, #24]
	blr	x8
	ldrb	w8, [x19]
	ldrb	w9, [x20, #16]
	eor	w8, w9, w8
	and	x8, x8, #0xff
Lloh10:
	adrp	x9, __ZN3aes4SBOXE@GOTPAGE
Lloh11:
	ldr	x9, [x9, __ZN3aes4SBOXE@GOTPAGEOFF]
	ldrb	w0, [x9, x8]
	bl	__ZN3aes9twin_gateEh
	str	w0, [sp, #12]
	add	x8, sp, #12
	; InlineAsm Start
	; InlineAsm End
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.loh AdrpLdrGot	Lloh10, Lloh11
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE4nameEv
__ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE4nameEv: ; @_ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE4nameEv
	.cfi_startproc
; %bb.0:
	ldr	x0, [x0, #24]
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"pos_leaky"

l_.str.1:                               ; @.str.1
	.asciz	"pos_twin"

	.section	__DATA,__const
	.p2align	3, 0x0                          ; @_ZTVN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEE
__ZTVN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEE:
	.quad	0
	.quad	__ZTIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEE
	.quad	__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED1Ev
	.quad	__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED0Ev
	.quad	__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE7set_keyEPKh
	.quad	__ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE13encrypt_blockEPKhPh
	.quad	__ZNK3aes6Aes12814encrypt_blocksEPKhPhm
	.quad	__ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE4nameEv

	.p2align	3, 0x0                          ; @_ZTIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEE
__ZTIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEE:
	.quad	__ZTVN10__cxxabiv120__si_class_type_infoE+16
	.quad	__ZTSN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEE
	.quad	__ZTIN3aes6Aes128E

	.section	__TEXT,__const
__ZTSN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEE: ; @_ZTSN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEE
	.asciz	"N3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEE"

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

	.section	__DATA,__const
	.p2align	3, 0x0                          ; @_ZTVN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEE
__ZTVN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEE:
	.quad	0
	.quad	__ZTIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEE
	.quad	__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED1Ev
	.quad	__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED0Ev
	.quad	__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE7set_keyEPKh
	.quad	__ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE13encrypt_blockEPKhPh
	.quad	__ZNK3aes6Aes12814encrypt_blocksEPKhPhm
	.quad	__ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE4nameEv

	.p2align	3, 0x0                          ; @_ZTIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEE
__ZTIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEE:
	.quad	__ZTVN10__cxxabiv120__si_class_type_infoE+16
	.quad	__ZTSN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEE
	.quad	__ZTIN3aes6Aes128E

	.section	__TEXT,__const
__ZTSN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEE: ; @_ZTSN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEE
	.asciz	"N3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEE"

.subsections_via_symbols
