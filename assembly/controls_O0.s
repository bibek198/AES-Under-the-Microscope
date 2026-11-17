	.build_version macos, 26, 0	sdk_version 26, 4
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN3aes16control_workloadEh    ; -- Begin function _ZN3aes16control_workloadEh
	.p2align	2
__ZN3aes16control_workloadEh:           ; @_ZN3aes16control_workloadEh
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	strb	w0, [sp, #15]
	ldrb	w8, [sp, #15]
	str	w8, [sp, #8]
	str	wzr, [sp, #4]
	b	LBB0_1
LBB0_1:                                 ; =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #4]
	subs	w8, w8, #64
	b.ge	LBB0_4
	b	LBB0_2
LBB0_2:                                 ;   in Loop: Header=BB0_1 Depth=1
	ldr	w8, [sp, #8]
	mov	w9, #26125                      ; =0x660d
	movk	w9, #25, lsl #16
	mul	w8, w8, w9
	mov	w9, #62303                      ; =0xf35f
	movk	w9, #15470, lsl #16
	add	w8, w8, w9
	str	w8, [sp, #8]
	ldr	w8, [sp, #8]
	; InlineAsm Start
	; InlineAsm End
	str	w8, [sp, #8]
	b	LBB0_3
LBB0_3:                                 ;   in Loop: Header=BB0_1 Depth=1
	ldr	w8, [sp, #4]
	add	w8, w8, #1
	str	w8, [sp, #4]
	b	LBB0_1
LBB0_4:
	ldr	w0, [sp, #8]
	add	sp, sp, #16
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__ZN3aes10leaky_gateEh          ; -- Begin function _ZN3aes10leaky_gateEh
	.p2align	2
__ZN3aes10leaky_gateEh:                 ; @_ZN3aes10leaky_gateEh
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	sturb	w0, [x29, #-5]
	ldurb	w8, [x29, #-5]
	subs	w8, w8, #128
	b.ge	LBB1_2
	b	LBB1_1
LBB1_1:
	ldurb	w0, [x29, #-5]
	bl	__ZN3aes16control_workloadEh
	stur	w0, [x29, #-4]
	b	LBB1_3
LBB1_2:
	ldurb	w8, [x29, #-5]
	stur	w8, [x29, #-4]
	b	LBB1_3
LBB1_3:
	ldur	w0, [x29, #-4]
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__ZN3aes9twin_gateEh            ; -- Begin function _ZN3aes9twin_gateEh
	.p2align	2
__ZN3aes9twin_gateEh:                   ; @_ZN3aes9twin_gateEh
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	sturb	w0, [x29, #-1]
	ldurb	w0, [x29, #-1]
	bl	__ZN3aes16control_workloadEh
	str	w0, [sp, #8]
	ldurb	w8, [x29, #-1]
	asr	w8, w8, #7
	subs	w8, w8, #1
	str	w8, [sp, #4]
	ldr	w8, [sp, #8]
	ldr	w9, [sp, #4]
	and	w8, w8, w9
	ldurb	w9, [x29, #-1]
	ldr	w10, [sp, #4]
	bic	w9, w9, w10
	orr	w0, w8, w9
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__ZN3aes14make_pos_leakyEv      ; -- Begin function _ZN3aes14make_pos_leakyEv
	.p2align	2
__ZN3aes14make_pos_leakyEv:             ; @_ZN3aes14make_pos_leakyEv
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x8, [sp]                        ; 8-byte Folded Spill
	stur	x8, [x29, #-8]
	add	x8, sp, #16
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	adrp	x0, l_.str@PAGE
	add	x0, x0, l_.str@PAGEOFF
	bl	__ZNSt3__111make_uniqueB9nqe210106IN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEEJRA10_KcELi0EEENS_10unique_ptrIT_NS_14default_deleteIS9_EEEEDpOT0_
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
	bl	__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEC1B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS3_IS9_EEvvEEONS0_IT_T0_EE
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	bl	__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEED1B9nqe210106Ev
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__111make_uniqueB9nqe210106IN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEEJRA10_KcELi0EEENS_10unique_ptrIT_NS_14default_deleteIS9_EEEEDpOT0_
__ZNSt3__111make_uniqueB9nqe210106IN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEEJRA10_KcELi0EEENS_10unique_ptrIT_NS_14default_deleteIS9_EEEEDpOT0_: ; @_ZNSt3__111make_uniqueB9nqe210106IN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEEJRA10_KcELi0EEENS_10unique_ptrIT_NS_14default_deleteIS9_EEEEDpOT0_
Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception0
; %bb.0:
	sub	sp, sp, #64
	stp	x29, x30, [sp, #48]             ; 16-byte Folded Spill
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x8, [sp]                        ; 8-byte Folded Spill
	stur	x8, [x29, #-8]
	stur	x0, [x29, #-16]
	mov	x0, #32                         ; =0x20
	bl	__Znwm
	str	x0, [sp, #8]                    ; 8-byte Folded Spill
	ldur	x1, [x29, #-16]
Ltmp1:
	bl	__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEC1EPKc
Ltmp2:
	b	LBB4_1
LBB4_1:
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	bl	__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEEC1B9nqe210106ILb1EvEEPS4_
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
LBB4_2:
Ltmp3:
	mov	x8, x0
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	str	x8, [sp, #24]
	mov	x8, x1
	str	w8, [sp, #20]
	bl	__ZdlPv
	b	LBB4_3
LBB4_3:
	ldr	x0, [sp, #24]
	bl	__Unwind_Resume
Lfunc_end0:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table4:
Lexception0:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end0-Lcst_begin0
Lcst_begin0:
	.uleb128 Lfunc_begin0-Lfunc_begin0      ; >> Call Site 1 <<
	.uleb128 Ltmp1-Lfunc_begin0             ;   Call between Lfunc_begin0 and Ltmp1
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp1-Lfunc_begin0             ; >> Call Site 2 <<
	.uleb128 Ltmp2-Ltmp1                    ;   Call between Ltmp1 and Ltmp2
	.uleb128 Ltmp3-Lfunc_begin0             ;     jumps to Ltmp3
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp2-Lfunc_begin0             ; >> Call Site 3 <<
	.uleb128 Lfunc_end0-Ltmp2               ;   Call between Ltmp2 and Lfunc_end0
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end0:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEC1B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS3_IS9_EEvvEEONS0_IT_T0_EE
__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEC1B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS3_IS9_EEvvEEONS0_IT_T0_EE: ; @_ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEC1B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS3_IS9_EEvvEEONS0_IT_T0_EE
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldur	x0, [x29, #-8]
	str	x0, [sp, #8]                    ; 8-byte Folded Spill
	ldr	x1, [sp, #16]
	bl	__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEC2B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS3_IS9_EEvvEEONS0_IT_T0_EE
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEED1B9nqe210106Ev
__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEED1B9nqe210106Ev: ; @_ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEED1B9nqe210106Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	ldr	x0, [sp, #8]
	str	x0, [sp]                        ; 8-byte Folded Spill
	bl	__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEED2B9nqe210106Ev
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__ZN3aes13make_pos_twinEv       ; -- Begin function _ZN3aes13make_pos_twinEv
	.p2align	2
__ZN3aes13make_pos_twinEv:              ; @_ZN3aes13make_pos_twinEv
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x8, [sp]                        ; 8-byte Folded Spill
	stur	x8, [x29, #-8]
	add	x8, sp, #16
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	adrp	x0, l_.str.1@PAGE
	add	x0, x0, l_.str.1@PAGEOFF
	bl	__ZNSt3__111make_uniqueB9nqe210106IN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEEJRA9_KcELi0EEENS_10unique_ptrIT_NS_14default_deleteIS9_EEEEDpOT0_
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
	bl	__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEC1B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS3_IS9_EEvvEEONS0_IT_T0_EE
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	bl	__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEED1B9nqe210106Ev
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__111make_uniqueB9nqe210106IN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEEJRA9_KcELi0EEENS_10unique_ptrIT_NS_14default_deleteIS9_EEEEDpOT0_
__ZNSt3__111make_uniqueB9nqe210106IN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEEJRA9_KcELi0EEENS_10unique_ptrIT_NS_14default_deleteIS9_EEEEDpOT0_: ; @_ZNSt3__111make_uniqueB9nqe210106IN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEEJRA9_KcELi0EEENS_10unique_ptrIT_NS_14default_deleteIS9_EEEEDpOT0_
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception1
; %bb.0:
	sub	sp, sp, #64
	stp	x29, x30, [sp, #48]             ; 16-byte Folded Spill
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x8, [sp]                        ; 8-byte Folded Spill
	stur	x8, [x29, #-8]
	stur	x0, [x29, #-16]
	mov	x0, #32                         ; =0x20
	bl	__Znwm
	str	x0, [sp, #8]                    ; 8-byte Folded Spill
	ldur	x1, [x29, #-16]
Ltmp4:
	bl	__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEC1EPKc
Ltmp5:
	b	LBB8_1
LBB8_1:
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	bl	__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEEC1B9nqe210106ILb1EvEEPS4_
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
LBB8_2:
Ltmp6:
	mov	x8, x0
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	str	x8, [sp, #24]
	mov	x8, x1
	str	w8, [sp, #20]
	bl	__ZdlPv
	b	LBB8_3
LBB8_3:
	ldr	x0, [sp, #24]
	bl	__Unwind_Resume
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table8:
Lexception1:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end1-Lcst_begin1
Lcst_begin1:
	.uleb128 Lfunc_begin1-Lfunc_begin1      ; >> Call Site 1 <<
	.uleb128 Ltmp4-Lfunc_begin1             ;   Call between Lfunc_begin1 and Ltmp4
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp4-Lfunc_begin1             ; >> Call Site 2 <<
	.uleb128 Ltmp5-Ltmp4                    ;   Call between Ltmp4 and Ltmp5
	.uleb128 Ltmp6-Lfunc_begin1             ;     jumps to Ltmp6
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp5-Lfunc_begin1             ; >> Call Site 3 <<
	.uleb128 Lfunc_end1-Ltmp5               ;   Call between Ltmp5 and Lfunc_end1
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end1:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEC1B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS3_IS9_EEvvEEONS0_IT_T0_EE
__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEC1B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS3_IS9_EEvvEEONS0_IT_T0_EE: ; @_ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEC1B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS3_IS9_EEvvEEONS0_IT_T0_EE
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldur	x0, [x29, #-8]
	str	x0, [sp, #8]                    ; 8-byte Folded Spill
	ldr	x1, [sp, #16]
	bl	__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEC2B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS3_IS9_EEvvEEONS0_IT_T0_EE
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEED1B9nqe210106Ev
__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEED1B9nqe210106Ev: ; @_ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEED1B9nqe210106Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	ldr	x0, [sp, #8]
	str	x0, [sp]                        ; 8-byte Folded Spill
	bl	__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEED2B9nqe210106Ev
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEC1EPKc
__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEC1EPKc: ; @_ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEC1EPKc
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldur	x0, [x29, #-8]
	str	x0, [sp, #8]                    ; 8-byte Folded Spill
	ldr	x1, [sp, #16]
	bl	__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEC2EPKc
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEEC1B9nqe210106ILb1EvEEPS4_
__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEEC1B9nqe210106ILb1EvEEPS4_: ; @_ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEEC1B9nqe210106ILb1EvEEPS4_
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldur	x0, [x29, #-8]
	str	x0, [sp, #8]                    ; 8-byte Folded Spill
	ldr	x1, [sp, #16]
	bl	__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEEC2B9nqe210106ILb1EvEEPS4_
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEC2EPKc
__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEC2EPKc: ; @_ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEC2EPKc
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception2
; %bb.0:
	sub	sp, sp, #64
	stp	x29, x30, [sp, #48]             ; 16-byte Folded Spill
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	stur	x1, [x29, #-16]
	ldur	x0, [x29, #-8]
	str	x0, [sp, #8]                    ; 8-byte Folded Spill
	bl	__ZN3aes6Aes128C2Ev
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	adrp	x9, __ZTVN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEE@PAGE
	add	x9, x9, __ZTVN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEEE@PAGEOFF
	add	x9, x9, #16
	str	x9, [x8]
Ltmp7:
	add	x8, x8, #8
	bl	__ZN3aes10make_armv8Ev
Ltmp8:
	b	LBB13_1
LBB13_1:
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	strb	wzr, [x0, #16]
	ldur	x8, [x29, #-16]
	str	x8, [x0, #24]
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
LBB13_2:
Ltmp9:
	mov	x8, x0
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	str	x8, [sp, #24]
	mov	x8, x1
	str	w8, [sp, #20]
	bl	__ZN3aes6Aes128D2Ev
	b	LBB13_3
LBB13_3:
	ldr	x0, [sp, #24]
	bl	__Unwind_Resume
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table13:
Lexception2:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Ltmp7-Lfunc_begin2             ; >> Call Site 1 <<
	.uleb128 Ltmp8-Ltmp7                    ;   Call between Ltmp7 and Ltmp8
	.uleb128 Ltmp9-Lfunc_begin2             ;     jumps to Ltmp9
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp8-Lfunc_begin2             ; >> Call Site 2 <<
	.uleb128 Lfunc_end2-Ltmp8               ;   Call between Ltmp8 and Lfunc_end2
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end2:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN3aes6Aes128C2Ev             ; -- Begin function _ZN3aes6Aes128C2Ev
	.weak_def_can_be_hidden	__ZN3aes6Aes128C2Ev
	.p2align	2
__ZN3aes6Aes128C2Ev:                    ; @_ZN3aes6Aes128C2Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	ldr	x0, [sp, #8]
	adrp	x8, __ZTVN3aes6Aes128E@GOTPAGE
	ldr	x8, [x8, __ZTVN3aes6Aes128E@GOTPAGEOFF]
	add	x8, x8, #16
	str	x8, [x0]
	add	sp, sp, #16
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__ZN3aes6Aes128D2Ev             ; -- Begin function _ZN3aes6Aes128D2Ev
	.weak_def_can_be_hidden	__ZN3aes6Aes128D2Ev
	.p2align	2
__ZN3aes6Aes128D2Ev:                    ; @_ZN3aes6Aes128D2Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	ldr	x0, [sp, #8]
	add	sp, sp, #16
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED1Ev
__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED1Ev: ; @_ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED1Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	ldr	x0, [sp, #8]
	str	x0, [sp]                        ; 8-byte Folded Spill
	bl	__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED2Ev
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED0Ev
__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED0Ev: ; @_ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED0Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	ldr	x0, [sp, #8]
	str	x0, [sp]                        ; 8-byte Folded Spill
	bl	__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED1Ev
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	bl	__ZdlPv
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE7set_keyEPKh
__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE7set_keyEPKh: ; @_ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE7set_keyEPKh
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldur	x8, [x29, #-8]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	add	x0, x8, #8
	bl	__ZNKSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEptB9nqe210106Ev
	ldr	x1, [sp, #16]
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	ldr	x8, [sp, #16]
	ldrb	w8, [x8]
	strb	w8, [x9, #16]
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE13encrypt_blockEPKhPh
__ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE13encrypt_blockEPKhPh: ; @_ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE13encrypt_blockEPKhPh
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #64
	stp	x29, x30, [sp, #48]             ; 16-byte Folded Spill
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	stur	x1, [x29, #-16]
	str	x2, [sp, #24]
	ldur	x8, [x29, #-8]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	add	x0, x8, #8
	bl	__ZNKSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEptB9nqe210106Ev
	ldur	x1, [x29, #-16]
	ldr	x2, [sp, #24]
	ldr	x8, [x0]
	ldr	x8, [x8, #24]
	blr	x8
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	ldur	x8, [x29, #-16]
	ldrb	w8, [x8]
	ldrb	w9, [x9, #16]
	eor	w9, w8, w9
                                        ; implicit-def: $x8
	mov	x8, x9
	sxtw	x1, w8
	adrp	x0, __ZN3aes4SBOXE@GOTPAGE
	ldr	x0, [x0, __ZN3aes4SBOXE@GOTPAGEOFF]
	bl	__ZNKSt3__15arrayIhLm256EEixB9nqe210106Em
	ldrb	w8, [x0]
	strb	w8, [sp, #23]
	ldrb	w0, [sp, #23]
	bl	__ZN3aes10leaky_gateEh
	mov	x8, x0
	add	x0, sp, #16
	str	w8, [sp, #16]
	bl	__ZN3aes15do_not_optimizeIjEEvRKT_
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__ZNK3aes6Aes12814encrypt_blocksEPKhPhm ; -- Begin function _ZNK3aes6Aes12814encrypt_blocksEPKhPhm
	.weak_def_can_be_hidden	__ZNK3aes6Aes12814encrypt_blocksEPKhPhm
	.p2align	2
__ZNK3aes6Aes12814encrypt_blocksEPKhPhm: ; @_ZNK3aes6Aes12814encrypt_blocksEPKhPhm
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #64
	stp	x29, x30, [sp, #48]             ; 16-byte Folded Spill
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	stur	x1, [x29, #-16]
	str	x2, [sp, #24]
	str	x3, [sp, #16]
	ldur	x8, [x29, #-8]
	str	x8, [sp]                        ; 8-byte Folded Spill
	str	xzr, [sp, #8]
	b	LBB20_1
LBB20_1:                                ; =>This Inner Loop Header: Depth=1
	ldr	x8, [sp, #8]
	ldr	x9, [sp, #16]
	subs	x8, x8, x9
	b.hs	LBB20_4
	b	LBB20_2
LBB20_2:                                ;   in Loop: Header=BB20_1 Depth=1
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	ldur	x8, [x29, #-16]
	ldr	x10, [sp, #8]
	mov	x9, #16                         ; =0x10
	mul	x10, x9, x10
	add	x1, x8, x10
	ldr	x8, [sp, #24]
	ldr	x10, [sp, #8]
	mul	x9, x9, x10
	add	x2, x8, x9
	ldr	x8, [x0]
	ldr	x8, [x8, #24]
	blr	x8
	b	LBB20_3
LBB20_3:                                ;   in Loop: Header=BB20_1 Depth=1
	ldr	x8, [sp, #8]
	add	x8, x8, #1
	str	x8, [sp, #8]
	b	LBB20_1
LBB20_4:
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE4nameEv
__ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE4nameEv: ; @_ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEE4nameEv
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	ldr	x8, [sp, #8]
	ldr	x0, [x8, #24]
	add	sp, sp, #16
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__ZN3aes6Aes128D1Ev             ; -- Begin function _ZN3aes6Aes128D1Ev
	.weak_def_can_be_hidden	__ZN3aes6Aes128D1Ev
	.p2align	2
__ZN3aes6Aes128D1Ev:                    ; @_ZN3aes6Aes128D1Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp]
	ldr	x8, [sp]
	str	x8, [sp, #8]
	brk	#0x1
	.cfi_endproc
                                        ; -- End function
	.globl	__ZN3aes6Aes128D0Ev             ; -- Begin function _ZN3aes6Aes128D0Ev
	.weak_def_can_be_hidden	__ZN3aes6Aes128D0Ev
	.p2align	2
__ZN3aes6Aes128D0Ev:                    ; @_ZN3aes6Aes128D0Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	brk	#0x1
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED2Ev
__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED2Ev: ; @_ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED2Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	ldr	x8, [sp, #8]
	str	x8, [sp]                        ; 8-byte Folded Spill
	add	x0, x8, #8
	bl	__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEED1B9nqe210106Ev
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	bl	__ZN3aes6Aes128D2Ev
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEED1B9nqe210106Ev ; -- Begin function _ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEED1B9nqe210106Ev
	.globl	__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEED1B9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEED1B9nqe210106Ev
	.p2align	2
__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEED1B9nqe210106Ev: ; @_ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEED1B9nqe210106Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	ldr	x0, [sp, #8]
	str	x0, [sp]                        ; 8-byte Folded Spill
	bl	__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEED2B9nqe210106Ev
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEED2B9nqe210106Ev ; -- Begin function _ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEED2B9nqe210106Ev
	.globl	__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEED2B9nqe210106Ev
	.weak_def_can_be_hidden	__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEED2B9nqe210106Ev
	.p2align	2
__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEED2B9nqe210106Ev: ; @_ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEED2B9nqe210106Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	ldr	x0, [sp, #8]
	str	x0, [sp]                        ; 8-byte Folded Spill
	mov	x1, #0                          ; =0x0
	bl	__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEE5resetB9nqe210106EPS2_
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEE5resetB9nqe210106EPS2_ ; -- Begin function _ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEE5resetB9nqe210106EPS2_
	.globl	__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEE5resetB9nqe210106EPS2_
	.weak_definition	__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEE5resetB9nqe210106EPS2_
	.p2align	2
__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEE5resetB9nqe210106EPS2_: ; @_ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEE5resetB9nqe210106EPS2_
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldur	x9, [x29, #-8]
	str	x9, [sp]                        ; 8-byte Folded Spill
	ldr	x8, [x9]
	str	x8, [sp, #8]
	ldr	x8, [sp, #16]
	str	x8, [x9]
	ldr	x8, [sp, #8]
	cbz	x8, LBB27_2
	b	LBB27_1
LBB27_1:
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	ldr	x1, [sp, #8]
	bl	__ZNKSt3__114default_deleteIN3aes6Aes128EEclB9nqe210106EPS2_
	b	LBB27_2
LBB27_2:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNKSt3__114default_deleteIN3aes6Aes128EEclB9nqe210106EPS2_ ; -- Begin function _ZNKSt3__114default_deleteIN3aes6Aes128EEclB9nqe210106EPS2_
	.globl	__ZNKSt3__114default_deleteIN3aes6Aes128EEclB9nqe210106EPS2_
	.weak_definition	__ZNKSt3__114default_deleteIN3aes6Aes128EEclB9nqe210106EPS2_
	.p2align	2
__ZNKSt3__114default_deleteIN3aes6Aes128EEclB9nqe210106EPS2_: ; @_ZNKSt3__114default_deleteIN3aes6Aes128EEclB9nqe210106EPS2_
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldr	x8, [sp, #16]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	cbz	x8, LBB28_2
	b	LBB28_1
LBB28_1:
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	ldr	x8, [x0]
	ldr	x8, [x8, #8]
	blr	x8
	b	LBB28_2
LBB28_2:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNKSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEptB9nqe210106Ev ; -- Begin function _ZNKSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEptB9nqe210106Ev
	.globl	__ZNKSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEptB9nqe210106Ev
	.weak_definition	__ZNKSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEptB9nqe210106Ev
	.p2align	2
__ZNKSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEptB9nqe210106Ev: ; @_ZNKSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEptB9nqe210106Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	ldr	x8, [sp, #8]
	ldr	x0, [x8]
	add	sp, sp, #16
	ret
	.cfi_endproc
                                        ; -- End function
	.private_extern	__ZNKSt3__15arrayIhLm256EEixB9nqe210106Em ; -- Begin function _ZNKSt3__15arrayIhLm256EEixB9nqe210106Em
	.globl	__ZNKSt3__15arrayIhLm256EEixB9nqe210106Em
	.weak_definition	__ZNKSt3__15arrayIhLm256EEixB9nqe210106Em
	.p2align	2
__ZNKSt3__15arrayIhLm256EEixB9nqe210106Em: ; @_ZNKSt3__15arrayIhLm256EEixB9nqe210106Em
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	str	x1, [sp]
	ldr	x8, [sp, #8]
	ldr	x9, [sp]
	add	x0, x8, x9
	add	sp, sp, #16
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__ZN3aes15do_not_optimizeIjEEvRKT_ ; -- Begin function _ZN3aes15do_not_optimizeIjEEvRKT_
	.weak_definition	__ZN3aes15do_not_optimizeIjEEvRKT_
	.p2align	2
__ZN3aes15do_not_optimizeIjEEvRKT_:     ; @_ZN3aes15do_not_optimizeIjEEvRKT_
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	ldr	x8, [sp, #8]
	ldr	w8, [x8]
	str	w8, [sp, #4]
	add	x8, sp, #4
	; InlineAsm Start
	; InlineAsm End
	add	sp, sp, #16
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEEC2B9nqe210106ILb1EvEEPS4_
__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEEC2B9nqe210106ILb1EvEEPS4_: ; @_ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEEC2B9nqe210106ILb1EvEEPS4_
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	str	x1, [sp]
	ldr	x0, [sp, #8]
	ldr	x8, [sp]
	str	x8, [x0]
	add	sp, sp, #16
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEED2B9nqe210106Ev
__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEED2B9nqe210106Ev: ; @_ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEED2B9nqe210106Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	ldr	x0, [sp, #8]
	str	x0, [sp]                        ; 8-byte Folded Spill
	mov	x1, #0                          ; =0x0
	bl	__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEE5resetB9nqe210106EPS4_
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEE5resetB9nqe210106EPS4_
__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEE5resetB9nqe210106EPS4_: ; @_ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEE5resetB9nqe210106EPS4_
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldur	x9, [x29, #-8]
	str	x9, [sp]                        ; 8-byte Folded Spill
	ldr	x8, [x9]
	str	x8, [sp, #8]
	ldr	x8, [sp, #16]
	str	x8, [x9]
	ldr	x8, [sp, #8]
	cbz	x8, LBB34_2
	b	LBB34_1
LBB34_1:
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	ldr	x1, [sp, #8]
	bl	__ZNKSt3__114default_deleteIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEEEclB9nqe210106EPS4_
	b	LBB34_2
LBB34_2:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNKSt3__114default_deleteIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEEEclB9nqe210106EPS4_
__ZNKSt3__114default_deleteIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEEEclB9nqe210106EPS4_: ; @_ZNKSt3__114default_deleteIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEEEclB9nqe210106EPS4_
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldr	x8, [sp, #16]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	cbz	x8, LBB35_2
	b	LBB35_1
LBB35_1:
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	bl	__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_10leaky_gateEhEEED1Ev
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	bl	__ZdlPv
	b	LBB35_2
LBB35_2:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEC2B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS3_IS9_EEvvEEONS0_IT_T0_EE
__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEC2B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS3_IS9_EEvvEEONS0_IT_T0_EE: ; @_ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEC2B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS3_IS9_EEvvEEONS0_IT_T0_EE
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldur	x8, [x29, #-8]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	ldr	x0, [sp, #16]
	bl	__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEE7releaseB9nqe210106Ev
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	str	x0, [x8]
	ldr	x0, [sp, #16]
	bl	__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEE11get_deleterB9nqe210106Ev
	mov	x1, x0
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	bl	__ZNSt3__114default_deleteIN3aes6Aes128EEC1B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEELi0EEERKNS0_IT_EE
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEE7releaseB9nqe210106Ev
__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEE7releaseB9nqe210106Ev: ; @_ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEE7releaseB9nqe210106Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	ldr	x8, [sp, #8]
	ldr	x9, [x8]
	str	x9, [sp]
                                        ; kill: def $x9 killed $xzr
	str	xzr, [x8]
	ldr	x0, [sp]
	add	sp, sp, #16
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEE11get_deleterB9nqe210106Ev
__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEE11get_deleterB9nqe210106Ev: ; @_ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEENS_14default_deleteIS4_EEE11get_deleterB9nqe210106Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	ldr	x0, [sp, #8]
	add	sp, sp, #16
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__114default_deleteIN3aes6Aes128EEC1B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEELi0EEERKNS0_IT_EE
__ZNSt3__114default_deleteIN3aes6Aes128EEC1B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEELi0EEERKNS0_IT_EE: ; @_ZNSt3__114default_deleteIN3aes6Aes128EEC1B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEELi0EEERKNS0_IT_EE
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldur	x0, [x29, #-8]
	str	x0, [sp, #8]                    ; 8-byte Folded Spill
	ldr	x1, [sp, #16]
	bl	__ZNSt3__114default_deleteIN3aes6Aes128EEC2B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEELi0EEERKNS0_IT_EE
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__114default_deleteIN3aes6Aes128EEC2B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEELi0EEERKNS0_IT_EE
__ZNSt3__114default_deleteIN3aes6Aes128EEC2B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEELi0EEERKNS0_IT_EE: ; @_ZNSt3__114default_deleteIN3aes6Aes128EEC2B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_10leaky_gateEhEEEELi0EEERKNS0_IT_EE
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	str	x1, [sp]
	ldr	x0, [sp, #8]
	add	sp, sp, #16
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEC1EPKc
__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEC1EPKc: ; @_ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEC1EPKc
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldur	x0, [x29, #-8]
	str	x0, [sp, #8]                    ; 8-byte Folded Spill
	ldr	x1, [sp, #16]
	bl	__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEC2EPKc
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEEC1B9nqe210106ILb1EvEEPS4_
__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEEC1B9nqe210106ILb1EvEEPS4_: ; @_ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEEC1B9nqe210106ILb1EvEEPS4_
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldur	x0, [x29, #-8]
	str	x0, [sp, #8]                    ; 8-byte Folded Spill
	ldr	x1, [sp, #16]
	bl	__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEEC2B9nqe210106ILb1EvEEPS4_
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEC2EPKc
__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEC2EPKc: ; @_ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEC2EPKc
Lfunc_begin3:
	.cfi_startproc
	.cfi_personality 155, ___gxx_personality_v0
	.cfi_lsda 16, Lexception3
; %bb.0:
	sub	sp, sp, #64
	stp	x29, x30, [sp, #48]             ; 16-byte Folded Spill
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	stur	x1, [x29, #-16]
	ldur	x0, [x29, #-8]
	str	x0, [sp, #8]                    ; 8-byte Folded Spill
	bl	__ZN3aes6Aes128C2Ev
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	adrp	x9, __ZTVN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEE@PAGE
	add	x9, x9, __ZTVN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEEE@PAGEOFF
	add	x9, x9, #16
	str	x9, [x8]
Ltmp22:
	add	x8, x8, #8
	bl	__ZN3aes10make_armv8Ev
Ltmp23:
	b	LBB43_1
LBB43_1:
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	strb	wzr, [x0, #16]
	ldur	x8, [x29, #-16]
	str	x8, [x0, #24]
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
LBB43_2:
Ltmp24:
	mov	x8, x0
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	str	x8, [sp, #24]
	mov	x8, x1
	str	w8, [sp, #20]
	bl	__ZN3aes6Aes128D2Ev
	b	LBB43_3
LBB43_3:
	ldr	x0, [sp, #24]
	bl	__Unwind_Resume
Lfunc_end3:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table43:
Lexception3:
	.byte	255                             ; @LPStart Encoding = omit
	.byte	255                             ; @TType Encoding = omit
	.byte	1                               ; Call site Encoding = uleb128
	.uleb128 Lcst_end3-Lcst_begin3
Lcst_begin3:
	.uleb128 Ltmp22-Lfunc_begin3            ; >> Call Site 1 <<
	.uleb128 Ltmp23-Ltmp22                  ;   Call between Ltmp22 and Ltmp23
	.uleb128 Ltmp24-Lfunc_begin3            ;     jumps to Ltmp24
	.byte	0                               ;   On action: cleanup
	.uleb128 Ltmp23-Lfunc_begin3            ; >> Call Site 2 <<
	.uleb128 Lfunc_end3-Ltmp23              ;   Call between Ltmp23 and Lfunc_end3
	.byte	0                               ;     has no landing pad
	.byte	0                               ;   On action: cleanup
Lcst_end3:
	.p2align	2, 0x0
                                        ; -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED1Ev
__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED1Ev: ; @_ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED1Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	ldr	x0, [sp, #8]
	str	x0, [sp]                        ; 8-byte Folded Spill
	bl	__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED2Ev
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED0Ev
__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED0Ev: ; @_ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED0Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	ldr	x0, [sp, #8]
	str	x0, [sp]                        ; 8-byte Folded Spill
	bl	__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED1Ev
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	bl	__ZdlPv
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE7set_keyEPKh
__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE7set_keyEPKh: ; @_ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE7set_keyEPKh
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldur	x8, [x29, #-8]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	add	x0, x8, #8
	bl	__ZNKSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEptB9nqe210106Ev
	ldr	x1, [sp, #16]
	ldr	x8, [x0]
	ldr	x8, [x8, #16]
	blr	x8
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	ldr	x8, [sp, #16]
	ldrb	w8, [x8]
	strb	w8, [x9, #16]
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE13encrypt_blockEPKhPh
__ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE13encrypt_blockEPKhPh: ; @_ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE13encrypt_blockEPKhPh
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #64
	stp	x29, x30, [sp, #48]             ; 16-byte Folded Spill
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	stur	x1, [x29, #-16]
	str	x2, [sp, #24]
	ldur	x8, [x29, #-8]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	add	x0, x8, #8
	bl	__ZNKSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEptB9nqe210106Ev
	ldur	x1, [x29, #-16]
	ldr	x2, [sp, #24]
	ldr	x8, [x0]
	ldr	x8, [x8, #24]
	blr	x8
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	ldur	x8, [x29, #-16]
	ldrb	w8, [x8]
	ldrb	w9, [x9, #16]
	eor	w9, w8, w9
                                        ; implicit-def: $x8
	mov	x8, x9
	sxtw	x1, w8
	adrp	x0, __ZN3aes4SBOXE@GOTPAGE
	ldr	x0, [x0, __ZN3aes4SBOXE@GOTPAGEOFF]
	bl	__ZNKSt3__15arrayIhLm256EEixB9nqe210106Em
	ldrb	w8, [x0]
	strb	w8, [sp, #23]
	ldrb	w0, [sp, #23]
	bl	__ZN3aes9twin_gateEh
	mov	x8, x0
	add	x0, sp, #16
	str	w8, [sp, #16]
	bl	__ZN3aes15do_not_optimizeIjEEvRKT_
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE4nameEv
__ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE4nameEv: ; @_ZNK3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEE4nameEv
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	ldr	x8, [sp, #8]
	ldr	x0, [x8, #24]
	add	sp, sp, #16
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED2Ev
__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED2Ev: ; @_ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED2Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	ldr	x8, [sp, #8]
	str	x8, [sp]                        ; 8-byte Folded Spill
	add	x0, x8, #8
	bl	__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEED1B9nqe210106Ev
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	bl	__ZN3aes6Aes128D2Ev
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEEC2B9nqe210106ILb1EvEEPS4_
__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEEC2B9nqe210106ILb1EvEEPS4_: ; @_ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEEC2B9nqe210106ILb1EvEEPS4_
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	str	x1, [sp]
	ldr	x0, [sp, #8]
	ldr	x8, [sp]
	str	x8, [x0]
	add	sp, sp, #16
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEED2B9nqe210106Ev
__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEED2B9nqe210106Ev: ; @_ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEED2B9nqe210106Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #8]
	ldr	x0, [sp, #8]
	str	x0, [sp]                        ; 8-byte Folded Spill
	mov	x1, #0                          ; =0x0
	bl	__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEE5resetB9nqe210106EPS4_
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #32
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEE5resetB9nqe210106EPS4_
__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEE5resetB9nqe210106EPS4_: ; @_ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEE5resetB9nqe210106EPS4_
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldur	x9, [x29, #-8]
	str	x9, [sp]                        ; 8-byte Folded Spill
	ldr	x8, [x9]
	str	x8, [sp, #8]
	ldr	x8, [sp, #16]
	str	x8, [x9]
	ldr	x8, [sp, #8]
	cbz	x8, LBB52_2
	b	LBB52_1
LBB52_1:
	ldr	x0, [sp]                        ; 8-byte Folded Reload
	ldr	x1, [sp, #8]
	bl	__ZNKSt3__114default_deleteIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEEEclB9nqe210106EPS4_
	b	LBB52_2
LBB52_2:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNKSt3__114default_deleteIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEEEclB9nqe210106EPS4_
__ZNKSt3__114default_deleteIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEEEclB9nqe210106EPS4_: ; @_ZNKSt3__114default_deleteIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEEEclB9nqe210106EPS4_
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldr	x8, [sp, #16]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	cbz	x8, LBB53_2
	b	LBB53_1
LBB53_1:
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	bl	__ZN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS_9twin_gateEhEEED1Ev
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	bl	__ZdlPv
	b	LBB53_2
LBB53_2:
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEC2B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS3_IS9_EEvvEEONS0_IT_T0_EE
__ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEC2B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS3_IS9_EEvvEEONS0_IT_T0_EE: ; @_ZNSt3__110unique_ptrIN3aes6Aes128ENS_14default_deleteIS2_EEEC2B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS3_IS9_EEvvEEONS0_IT_T0_EE
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldur	x8, [x29, #-8]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	ldr	x0, [sp, #16]
	bl	__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEE7releaseB9nqe210106Ev
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	str	x0, [x8]
	ldr	x0, [sp, #16]
	bl	__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEE11get_deleterB9nqe210106Ev
	mov	x1, x0
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	bl	__ZNSt3__114default_deleteIN3aes6Aes128EEC1B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEELi0EEERKNS0_IT_EE
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEE7releaseB9nqe210106Ev
__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEE7releaseB9nqe210106Ev: ; @_ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEE7releaseB9nqe210106Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	ldr	x8, [sp, #8]
	ldr	x9, [x8]
	str	x9, [sp]
                                        ; kill: def $x9 killed $xzr
	str	xzr, [x8]
	ldr	x0, [sp]
	add	sp, sp, #16
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEE11get_deleterB9nqe210106Ev
__ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEE11get_deleterB9nqe210106Ev: ; @_ZNSt3__110unique_ptrIN3aes12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEENS_14default_deleteIS4_EEE11get_deleterB9nqe210106Ev
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	ldr	x0, [sp, #8]
	add	sp, sp, #16
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__114default_deleteIN3aes6Aes128EEC1B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEELi0EEERKNS0_IT_EE
__ZNSt3__114default_deleteIN3aes6Aes128EEC1B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEELi0EEERKNS0_IT_EE: ; @_ZNSt3__114default_deleteIN3aes6Aes128EEC1B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEELi0EEERKNS0_IT_EE
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	str	x1, [sp, #16]
	ldur	x0, [x29, #-8]
	str	x0, [sp, #8]                    ; 8-byte Folded Spill
	ldr	x1, [sp, #16]
	bl	__ZNSt3__114default_deleteIN3aes6Aes128EEC2B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEELi0EEERKNS0_IT_EE
	ldr	x0, [sp, #8]                    ; 8-byte Folded Reload
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZNSt3__114default_deleteIN3aes6Aes128EEC2B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEELi0EEERKNS0_IT_EE
__ZNSt3__114default_deleteIN3aes6Aes128EEC2B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEELi0EEERKNS0_IT_EE: ; @_ZNSt3__114default_deleteIN3aes6Aes128EEC2B9nqe210106INS1_12_GLOBAL__N_115PositiveControlIXadL_ZNS1_9twin_gateEhEEEELi0EEERKNS0_IT_EE
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, #8]
	str	x1, [sp]
	ldr	x0, [sp, #8]
	add	sp, sp, #16
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
	.globl	__ZTVN3aes6Aes128E              ; @_ZTVN3aes6Aes128E
	.weak_def_can_be_hidden	__ZTVN3aes6Aes128E
	.p2align	3, 0x0
__ZTVN3aes6Aes128E:
	.quad	0
	.quad	__ZTIN3aes6Aes128E
	.quad	__ZN3aes6Aes128D1Ev
	.quad	__ZN3aes6Aes128D0Ev
	.quad	___cxa_pure_virtual
	.quad	___cxa_pure_virtual
	.quad	__ZNK3aes6Aes12814encrypt_blocksEPKhPhm
	.quad	___cxa_pure_virtual

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
