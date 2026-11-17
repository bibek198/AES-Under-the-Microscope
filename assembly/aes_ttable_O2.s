	.build_version macos, 26, 0	sdk_version 26, 4
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__ZN3aes11make_ttableEv         ; -- Begin function _ZN3aes11make_ttableEv
	.p2align	2
__ZN3aes11make_ttableEv:                ; @_ZN3aes11make_ttableEv
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
	adrp	x8, __ZTVN3aes12_GLOBAL__N_19AesTTableE@PAGE+16
Lloh1:
	add	x8, x8, __ZTVN3aes12_GLOBAL__N_19AesTTableE@PAGEOFF+16
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
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_19AesTTableD1Ev
__ZN3aes12_GLOBAL__N_19AesTTableD1Ev:   ; @_ZN3aes12_GLOBAL__N_19AesTTableD1Ev
	.cfi_startproc
; %bb.0:
	ret
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_19AesTTableD0Ev
__ZN3aes12_GLOBAL__N_19AesTTableD0Ev:   ; @_ZN3aes12_GLOBAL__N_19AesTTableD0Ev
	.cfi_startproc
; %bb.0:
	b	__ZdlPv
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function _ZN3aes12_GLOBAL__N_19AesTTable7set_keyEPKh
__ZN3aes12_GLOBAL__N_19AesTTable7set_keyEPKh: ; @_ZN3aes12_GLOBAL__N_19AesTTable7set_keyEPKh
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
	bl	__ZN3aes10expand_keyEPKhPh
	ldur	q0, [sp, #120]
	ldur	q1, [sp, #104]
	stur	q0, [x19, #120]
	ldur	q0, [sp, #136]
	ldur	q2, [sp, #152]
	stur	q0, [x19, #136]
	stur	q2, [x19, #152]
	ldur	q0, [sp, #168]
	stur	q0, [x19, #168]
	ldur	q0, [sp, #56]
	ldur	q2, [sp, #40]
	stur	q0, [x19, #56]
	ldur	q0, [sp, #72]
	ldur	q3, [sp, #88]
	stur	q0, [x19, #72]
	stur	q3, [x19, #88]
	stur	q1, [x19, #104]
	ldur	q0, [sp, #8]
	ldur	q1, [sp, #24]
	stur	q0, [x19, #8]
	stur	q1, [x19, #24]
	stur	q2, [x19, #40]
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
	.p2align	2                               ; -- Begin function _ZNK3aes12_GLOBAL__N_19AesTTable13encrypt_blockEPKhPh
__ZNK3aes12_GLOBAL__N_19AesTTable13encrypt_blockEPKhPh: ; @_ZNK3aes12_GLOBAL__N_19AesTTable13encrypt_blockEPKhPh
	.cfi_startproc
; %bb.0:
	ldp	w8, w9, [x1]
	ldp	w10, w11, [x0, #8]
	eor	w16, w10, w8
	eor	w15, w11, w9
	ldp	w8, w9, [x1, #8]
	ldp	w10, w11, [x0, #16]
	eor	w17, w10, w8
	eor	w8, w11, w9
	add	x12, x0, #36
	mov	w13, #9                         ; =0x9
Lloh8:
	adrp	x14, __ZN3aes12_GLOBAL__N_12kTE@PAGE
Lloh9:
	add	x14, x14, __ZN3aes12_GLOBAL__N_12kTE@PAGEOFF
LBB4_1:                                 ; =>This Inner Loop Header: Depth=1
	and	w9, w16, #0xff
	ldr	w9, [x14, w9, uxtw #2]
	ubfx	w10, w15, #8, #8
	add	x1, x14, #1024
	ldr	w10, [x1, w10, uxtw #2]
	eor	w9, w10, w9
	ubfx	w10, w17, #16, #8
	add	x3, x14, #2048
	ldr	w10, [x3, w10, uxtw #2]
	lsr	w11, w8, #24
	add	x4, x14, #3072
	ldr	w11, [x4, w11, uxtw #2]
	eor	w10, w10, w11
	and	w11, w15, #0xff
	ldr	w11, [x14, w11, uxtw #2]
	eor	w9, w9, w10
	ldp	w10, w5, [x12, #-12]
	eor	w9, w9, w10
	ubfx	w10, w17, #8, #8
	ldr	w10, [x1, w10, uxtw #2]
	eor	w10, w10, w11
	ubfx	w11, w8, #16, #8
	ldr	w11, [x3, w11, uxtw #2]
	lsr	w6, w16, #24
	ldr	w6, [x4, w6, uxtw #2]
	eor	w11, w11, w6
	eor	w10, w10, w11
	eor	w10, w10, w5
	and	w11, w17, #0xff
	ldr	w11, [x14, w11, uxtw #2]
	ubfx	w5, w8, #8, #8
	ldr	w5, [x1, w5, uxtw #2]
	ubfx	w6, w16, #16, #8
	ldr	w6, [x3, w6, uxtw #2]
	eor	w11, w5, w11
	lsr	w5, w15, #24
	ldr	w5, [x4, w5, uxtw #2]
	eor	w5, w6, w5
	eor	w11, w11, w5
	ldur	w5, [x12, #-4]
	eor	w11, w11, w5
	and	w8, w8, #0xff
	ldr	w8, [x14, w8, uxtw #2]
	ubfx	w16, w16, #8, #8
	ldr	w16, [x1, w16, uxtw #2]
	eor	w8, w16, w8
	ubfx	w15, w15, #16, #8
	ldr	w15, [x3, w15, uxtw #2]
	lsr	w16, w17, #24
	ldr	w16, [x4, w16, uxtw #2]
	eor	w15, w15, w16
	eor	w8, w8, w15
	ldr	w15, [x12], #16
	eor	w8, w8, w15
	mov	x16, x9
	mov	x15, x10
	mov	x17, x11
	subs	x13, x13, #1
	b.ne	LBB4_1
; %bb.2:
Lloh10:
	adrp	x12, __ZN3aes4SBOXE@GOTPAGE
Lloh11:
	ldr	x12, [x12, __ZN3aes4SBOXE@GOTPAGEOFF]
	and	x13, x9, #0xff
	ldrb	w13, [x12, x13]
	ubfx	x14, x10, #8, #8
	ldrb	w14, [x12, x14]
	ubfx	x15, x11, #16, #8
	ldrb	w15, [x12, x15]
	lsr	x16, x8, #24
	orr	w13, w13, w14, lsl #8
	orr	w13, w13, w15, lsl #16
	ldrb	w14, [x12, x16]
	orr	w13, w13, w14, lsl #24
	ldp	w14, w15, [x0, #168]
	eor	w13, w13, w14
	and	x14, x10, #0xff
	ldrb	w14, [x12, x14]
	ubfx	x16, x11, #8, #8
	ldrb	w16, [x12, x16]
	ubfx	x17, x8, #16, #8
	ldrb	w17, [x12, x17]
	lsr	x1, x9, #24
	orr	w14, w14, w16, lsl #8
	orr	w14, w14, w17, lsl #16
	ldrb	w16, [x12, x1]
	orr	w14, w14, w16, lsl #24
	and	x16, x11, #0xff
	ldrb	w16, [x12, x16]
	ubfx	x17, x8, #8, #8
	ldrb	w17, [x12, x17]
	ubfx	x1, x9, #16, #8
	ldrb	w1, [x12, x1]
	eor	w14, w14, w15
	lsr	x15, x10, #24
	orr	w16, w16, w17, lsl #8
	orr	w16, w16, w1, lsl #16
	ldrb	w15, [x12, x15]
	and	x8, x8, #0xff
	ldrb	w8, [x12, x8]
	ubfx	x9, x9, #8, #8
	ldrb	w9, [x12, x9]
	orr	w15, w16, w15, lsl #24
	ubfx	x10, x10, #16, #8
	ldrb	w10, [x12, x10]
	ldp	w16, w17, [x0, #176]
	eor	w15, w15, w16
	lsr	x11, x11, #24
	orr	w8, w8, w9, lsl #8
	ldrb	w9, [x12, x11]
	strb	w13, [x2]
	lsr	w11, w13, #8
	strb	w11, [x2, #1]
	lsr	w11, w13, #16
	strb	w11, [x2, #2]
	lsr	w11, w13, #24
	strb	w11, [x2, #3]
	strb	w14, [x2, #4]
	lsr	w11, w14, #8
	strb	w11, [x2, #5]
	lsr	w11, w14, #16
	strb	w11, [x2, #6]
	lsr	w11, w14, #24
	orr	w8, w8, w10, lsl #16
	strb	w11, [x2, #7]
	strb	w15, [x2, #8]
	lsr	w10, w15, #8
	strb	w10, [x2, #9]
	lsr	w10, w15, #16
	strb	w10, [x2, #10]
	lsr	w10, w15, #24
	strb	w10, [x2, #11]
	orr	w8, w8, w9, lsl #24
	eor	w8, w8, w17
	strb	w8, [x2, #12]
	lsr	w9, w8, #8
	strb	w9, [x2, #13]
	lsr	w9, w8, #16
	strb	w9, [x2, #14]
	lsr	w8, w8, #24
	strb	w8, [x2, #15]
	ret
	.loh AdrpAdd	Lloh8, Lloh9
	.loh AdrpLdrGot	Lloh10, Lloh11
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
	.p2align	2                               ; -- Begin function _ZNK3aes12_GLOBAL__N_19AesTTable4nameEv
__ZNK3aes12_GLOBAL__N_19AesTTable4nameEv: ; @_ZNK3aes12_GLOBAL__N_19AesTTable4nameEv
	.cfi_startproc
; %bb.0:
Lloh12:
	adrp	x0, l_.str@PAGE
Lloh13:
	add	x0, x0, l_.str@PAGEOFF
	ret
	.loh AdrpAdd	Lloh12, Lloh13
	.cfi_endproc
                                        ; -- End function
	.section	__DATA,__const
	.p2align	3, 0x0                          ; @_ZTVN3aes12_GLOBAL__N_19AesTTableE
__ZTVN3aes12_GLOBAL__N_19AesTTableE:
	.quad	0
	.quad	__ZTIN3aes12_GLOBAL__N_19AesTTableE
	.quad	__ZN3aes12_GLOBAL__N_19AesTTableD1Ev
	.quad	__ZN3aes12_GLOBAL__N_19AesTTableD0Ev
	.quad	__ZN3aes12_GLOBAL__N_19AesTTable7set_keyEPKh
	.quad	__ZNK3aes12_GLOBAL__N_19AesTTable13encrypt_blockEPKhPh
	.quad	__ZNK3aes6Aes12814encrypt_blocksEPKhPhm
	.quad	__ZNK3aes12_GLOBAL__N_19AesTTable4nameEv

	.p2align	3, 0x0                          ; @_ZTIN3aes12_GLOBAL__N_19AesTTableE
__ZTIN3aes12_GLOBAL__N_19AesTTableE:
	.quad	__ZTVN10__cxxabiv120__si_class_type_infoE+16
	.quad	__ZTSN3aes12_GLOBAL__N_19AesTTableE
	.quad	__ZTIN3aes6Aes128E

	.section	__TEXT,__const
__ZTSN3aes12_GLOBAL__N_19AesTTableE:    ; @_ZTSN3aes12_GLOBAL__N_19AesTTableE
	.asciz	"N3aes12_GLOBAL__N_19AesTTableE"

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

	.p2align	7, 0x0                          ; @_ZN3aes12_GLOBAL__N_12kTE
__ZN3aes12_GLOBAL__N_12kTE:
	.long	2774754246                      ; 0xa56363c6
	.long	2222750968                      ; 0x847c7cf8
	.long	2574743534                      ; 0x997777ee
	.long	2373680118                      ; 0x8d7b7bf6
	.long	234025727                       ; 0xdf2f2ff
	.long	3177933782                      ; 0xbd6b6bd6
	.long	2976870366                      ; 0xb16f6fde
	.long	1422247313                      ; 0x54c5c591
	.long	1345335392                      ; 0x50303060
	.long	50397442                        ; 0x3010102
	.long	2842126286                      ; 0xa96767ce
	.long	2099981142                      ; 0x7d2b2b56
	.long	436141799                       ; 0x19fefee7
	.long	1658312629                      ; 0x62d7d7b5
	.long	3870010189                      ; 0xe6abab4d
	.long	2591454956                      ; 0x9a7676ec
	.long	1170918031                      ; 0x45caca8f
	.long	2642575903                      ; 0x9d82821f
	.long	1086966153                      ; 0x40c9c989
	.long	2273148410                      ; 0x877d7dfa
	.long	368769775                       ; 0x15fafaef
	.long	3948501426                      ; 0xeb5959b2
	.long	3376891790                      ; 0xc947478e
	.long	200339707                       ; 0xbf0f0fb
	.long	3970805057                      ; 0xecadad41
	.long	1742001331                      ; 0x67d4d4b3
	.long	4255294047                      ; 0xfda2a25f
	.long	3937382213                      ; 0xeaafaf45
	.long	3214711843                      ; 0xbf9c9c23
	.long	4154762323                      ; 0xf7a4a453
	.long	2524082916                      ; 0x967272e4
	.long	1539358875                      ; 0x5bc0c09b
	.long	3266819957                      ; 0xc2b7b775
	.long	486407649                       ; 0x1cfdfde1
	.long	2928907069                      ; 0xae93933d
	.long	1780885068                      ; 0x6a26264c
	.long	1513502316                      ; 0x5a36366c
	.long	1094664062                      ; 0x413f3f7e
	.long	49805301                        ; 0x2f7f7f5
	.long	1338821763                      ; 0x4fcccc83
	.long	1546925160                      ; 0x5c343468
	.long	4104496465                      ; 0xf4a5a551
	.long	887481809                       ; 0x34e5e5d1
	.long	150073849                       ; 0x8f1f1f9
	.long	2473685474                      ; 0x937171e2
	.long	1943591083                      ; 0x73d8d8ab
	.long	1395732834                      ; 0x53313162
	.long	1058346282                      ; 0x3f15152a
	.long	201589768                       ; 0xc040408
	.long	1388824469                      ; 0x52c7c795
	.long	1696801606                      ; 0x65232346
	.long	1589887901                      ; 0x5ec3c39d
	.long	672667696                       ; 0x28181830
	.long	2711000631                      ; 0xa1969637
	.long	251987210                       ; 0xf05050a
	.long	3046808111                      ; 0xb59a9a2f
	.long	151455502                       ; 0x907070e
	.long	907153956                       ; 0x36121224
	.long	2608889883                      ; 0x9b80801b
	.long	1038279391                      ; 0x3de2e2df
	.long	652995533                       ; 0x26ebebcd
	.long	1764173646                      ; 0x6927274e
	.long	3451040383                      ; 0xcdb2b27f
	.long	2675275242                      ; 0x9f7575ea
	.long	453576978                       ; 0x1b090912
	.long	2659418909                      ; 0x9e83831d
	.long	1949051992                      ; 0x742c2c58
	.long	773462580                       ; 0x2e1a1a34
	.long	756751158                       ; 0x2d1b1b36
	.long	2993581788                      ; 0xb26e6edc
	.long	3998898868                      ; 0xee5a5ab4
	.long	4221608027                      ; 0xfba0a05b
	.long	4132590244                      ; 0xf65252a4
	.long	1295727478                      ; 0x4d3b3b76
	.long	1641469623                      ; 0x61d6d6b7
	.long	3467883389                      ; 0xceb3b37d
	.long	2066295122                      ; 0x7b292952
	.long	1055122397                      ; 0x3ee3e3dd
	.long	1898917726                      ; 0x712f2f5e
	.long	2542044179                      ; 0x97848413
	.long	4115878822                      ; 0xf55353a6
	.long	1758581177                      ; 0x68d1d1b9
	.long	0                               ; 0x0
	.long	753790401                       ; 0x2cededc1
	.long	1612718144                      ; 0x60202040
	.long	536673507                       ; 0x1ffcfce3
	.long	3367088505                      ; 0xc8b1b179
	.long	3982187446                      ; 0xed5b5bb6
	.long	3194645204                      ; 0xbe6a6ad4
	.long	1187761037                      ; 0x46cbcb8d
	.long	3653156455                      ; 0xd9bebe67
	.long	1262041458                      ; 0x4b393972
	.long	3729410708                      ; 0xde4a4a94
	.long	3561770136                      ; 0xd44c4c98
	.long	3898103984                      ; 0xe85858b0
	.long	1255133061                      ; 0x4acfcf85
	.long	1808847035                      ; 0x6bd0d0bb
	.long	720367557                       ; 0x2aefefc5
	.long	3853167183                      ; 0xe5aaaa4f
	.long	385612781                       ; 0x16fbfbed
	.long	3309519750                      ; 0xc5434386
	.long	3612167578                      ; 0xd74d4d9a
	.long	1429418854                      ; 0x55333366
	.long	2491778321                      ; 0x94858511
	.long	3477423498                      ; 0xcf45458a
	.long	284817897                       ; 0x10f9f9e9
	.long	100794884                       ; 0x6020204
	.long	2172616702                      ; 0x817f7ffe
	.long	4031795360                      ; 0xf05050a0
	.long	1144798328                      ; 0x443c3c78
	.long	3131023141                      ; 0xba9f9f25
	.long	3819481163                      ; 0xe3a8a84b
	.long	4082192802                      ; 0xf35151a2
	.long	4272137053                      ; 0xfea3a35d
	.long	3225436288                      ; 0xc0404080
	.long	2324664069                      ; 0x8a8f8f05
	.long	2912064063                      ; 0xad92923f
	.long	3164445985                      ; 0xbc9d9d21
	.long	1211644016                      ; 0x48383870
	.long	83228145                        ; 0x4f5f5f1
	.long	3753688163                      ; 0xdfbcbc63
	.long	3249976951                      ; 0xc1b6b677
	.long	1977277103                      ; 0x75dadaaf
	.long	1663115586                      ; 0x63212142
	.long	806359072                       ; 0x30101020
	.long	452984805                       ; 0x1affffe5
	.long	250868733                       ; 0xef3f3fd
	.long	1842533055                      ; 0x6dd2d2bf
	.long	1288555905                      ; 0x4ccdcd81
	.long	336333848                       ; 0x140c0c18
	.long	890442534                       ; 0x35131326
	.long	804056259                       ; 0x2fececc3
	.long	3781124030                      ; 0xe15f5fbe
	.long	2727843637                      ; 0xa2979735
	.long	3427026056                      ; 0xcc444488
	.long	957814574                       ; 0x3917172e
	.long	1472513171                      ; 0x57c4c493
	.long	4071073621                      ; 0xf2a7a755
	.long	2189328124                      ; 0x827e7efc
	.long	1195195770                      ; 0x473d3d7a
	.long	2892260552                      ; 0xac6464c8
	.long	3881655738                      ; 0xe75d5dba
	.long	723065138                       ; 0x2b191932
	.long	2507371494                      ; 0x957373e6
	.long	2690670784                      ; 0xa06060c0
	.long	2558624025                      ; 0x98818119
	.long	3511635870                      ; 0xd14f4f9e
	.long	2145180835                      ; 0x7fdcdca3
	.long	1713513028                      ; 0x66222244
	.long	2116692564                      ; 0x7e2a2a54
	.long	2878378043                      ; 0xab90903b
	.long	2206763019                      ; 0x8388880b
	.long	3393603212                      ; 0xca46468c
	.long	703524551                       ; 0x29eeeec7
	.long	3552098411                      ; 0xd3b8b86b
	.long	1007948840                      ; 0x3c141428
	.long	2044649127                      ; 0x79dedea7
	.long	3797835452                      ; 0xe25e5ebc
	.long	487262998                       ; 0x1d0b0b16
	.long	1994120109                      ; 0x76dbdbad
	.long	1004593371                      ; 0x3be0e0db
	.long	1446130276                      ; 0x56323264
	.long	1312438900                      ; 0x4e3a3a74
	.long	503974420                       ; 0x1e0a0a14
	.long	3679013266                      ; 0xdb494992
	.long	168166924                       ; 0xa06060c
	.long	1814307912                      ; 0x6c242448
	.long	3831258296                      ; 0xe45c5cb8
	.long	1573044895                      ; 0x5dc2c29f
	.long	1859376061                      ; 0x6ed3d3bd
	.long	4021070915                      ; 0xefacac43
	.long	2791465668                      ; 0xa66262c4
	.long	2828112185                      ; 0xa8919139
	.long	2761266481                      ; 0xa4959531
	.long	937747667                       ; 0x37e4e4d3
	.long	2339994098                      ; 0x8b7979f2
	.long	854058965                       ; 0x32e7e7d5
	.long	1137232011                      ; 0x43c8c88b
	.long	1496790894                      ; 0x5937376e
	.long	3077402074                      ; 0xb76d6dda
	.long	2358086913                      ; 0x8c8d8d01
	.long	1691735473                      ; 0x64d5d5b1
	.long	3528347292                      ; 0xd24e4e9c
	.long	3769215305                      ; 0xe0a9a949
	.long	3027004632                      ; 0xb46c6cd8
	.long	4199962284                      ; 0xfa5656ac
	.long	133494003                       ; 0x7f4f4f3
	.long	636152527                       ; 0x25eaeacf
	.long	2942657994                      ; 0xaf6565ca
	.long	2390391540                      ; 0x8e7a7af4
	.long	3920539207                      ; 0xe9aeae47
	.long	403179536                       ; 0x18080810
	.long	3585784431                      ; 0xd5baba6f
	.long	2289596656                      ; 0x887878f0
	.long	1864705354                      ; 0x6f25254a
	.long	1915629148                      ; 0x722e2e5c
	.long	605822008                       ; 0x241c1c38
	.long	4054230615                      ; 0xf1a6a657
	.long	3350508659                      ; 0xc7b4b473
	.long	1371981463                      ; 0x51c6c697
	.long	602466507                       ; 0x23e8e8cb
	.long	2094914977                      ; 0x7cdddda1
	.long	2624877800                      ; 0x9c7474e8
	.long	555687742                       ; 0x211f1f3e
	.long	3712699286                      ; 0xdd4b4b96
	.long	3703422305                      ; 0xdcbdbd61
	.long	2257292045                      ; 0x868b8b0d
	.long	2240449039                      ; 0x858a8a0f
	.long	2423288032                      ; 0x907070e0
	.long	1111375484                      ; 0x423e3e7c
	.long	3300242801                      ; 0xc4b5b571
	.long	2858837708                      ; 0xaa6666cc
	.long	3628615824                      ; 0xd8484890
	.long	84083462                        ; 0x5030306
	.long	32962295                        ; 0x1f6f6f7
	.long	302911004                       ; 0x120e0e1c
	.long	2741068226                      ; 0xa36161c2
	.long	1597322602                      ; 0x5f35356a
	.long	4183250862                      ; 0xf95757ae
	.long	3501832553                      ; 0xd0b9b969
	.long	2441512471                      ; 0x91868617
	.long	1489093017                      ; 0x58c1c199
	.long	656219450                       ; 0x271d1d3a
	.long	3114180135                      ; 0xb99e9e27
	.long	954327513                       ; 0x38e1e1d9
	.long	335083755                       ; 0x13f8f8eb
	.long	3013122091                      ; 0xb398982b
	.long	856756514                       ; 0x33111122
	.long	3144247762                      ; 0xbb6969d2
	.long	1893325225                      ; 0x70d9d9a9
	.long	2307821063                      ; 0x898e8e07
	.long	2811532339                      ; 0xa7949433
	.long	3063651117                      ; 0xb69b9b2d
	.long	572399164                       ; 0x221e1e3c
	.long	2458355477                      ; 0x92878715
	.long	552200649                       ; 0x20e9e9c9
	.long	1238290055                      ; 0x49cece87
	.long	4283782570                      ; 0xff5555aa
	.long	2015897680                      ; 0x78282850
	.long	2061492133                      ; 0x7adfdfa5
	.long	2408352771                      ; 0x8f8c8c03
	.long	4171342169                      ; 0xf8a1a159
	.long	2156497161                      ; 0x80898909
	.long	386731290                       ; 0x170d0d1a
	.long	3669999461                      ; 0xdabfbf65
	.long	837215959                       ; 0x31e6e6d7
	.long	3326231172                      ; 0xc6424284
	.long	3093850320                      ; 0xb86868d0
	.long	3275833730                      ; 0xc3414182
	.long	2962856233                      ; 0xb0999929
	.long	1999449434                      ; 0x772d2d5a
	.long	286199582                       ; 0x110f0f1e
	.long	3417354363                      ; 0xcbb0b07b
	.long	4233385128                      ; 0xfc5454a8
	.long	3602627437                      ; 0xd6bbbb6d
	.long	974525996                       ; 0x3a16162c
	.long	1667483301                      ; 0x6363c6a5
	.long	2088564868                      ; 0x7c7cf884
	.long	2004348569                      ; 0x7777ee99
	.long	2071721613                      ; 0x7b7bf68d
	.long	4076011277                      ; 0xf2f2ff0d
	.long	1802229437                      ; 0x6b6bd6bd
	.long	1869602481                      ; 0x6f6fdeb1
	.long	3318059348                      ; 0xc5c59154
	.long	808476752                       ; 0x30306050
	.long	16843267                        ; 0x1010203
	.long	1734856361                      ; 0x6767cea9
	.long	724260477                       ; 0x2b2b567d
	.long	4278118169                      ; 0xfefee719
	.long	3621238114                      ; 0xd7d7b562
	.long	2880130534                      ; 0xabab4de6
	.long	1987505306                      ; 0x7676ec9a
	.long	3402272581                      ; 0xcaca8f45
	.long	2189565853                      ; 0x82821f9d
	.long	3385428288                      ; 0xc9c98940
	.long	2105408135                      ; 0x7d7dfa87
	.long	4210749205                      ; 0xfafaef15
	.long	1499050731                      ; 0x5959b2eb
	.long	1195871945                      ; 0x47478ec9
	.long	4042324747                      ; 0xf0f0fb0b
	.long	2913812972                      ; 0xadad41ec
	.long	3570709351                      ; 0xd4d4b367
	.long	2728550397                      ; 0xa2a25ffd
	.long	2947499498                      ; 0xafaf45ea
	.long	2627478463                      ; 0x9c9c23bf
	.long	2762232823                      ; 0xa4a453f7
	.long	1920132246                      ; 0x7272e496
	.long	3233848155                      ; 0xc0c09b5b
	.long	3082253762                      ; 0xb7b775c2
	.long	4261273884                      ; 0xfdfde11c
	.long	2475900334                      ; 0x93933dae
	.long	640044138                       ; 0x26264c6a
	.long	909536346                       ; 0x36366c5a
	.long	1061125697                      ; 0x3f3f7e41
	.long	4160222466                      ; 0xf7f7f502
	.long	3435955023                      ; 0xcccc834f
	.long	875849820                       ; 0x3434685c
	.long	2779075060                      ; 0xa5a551f4
	.long	3857043764                      ; 0xe5e5d134
	.long	4059166984                      ; 0xf1f1f908
	.long	1903288979                      ; 0x7171e293
	.long	3638078323                      ; 0xd8d8ab73
	.long	825320019                       ; 0x31316253
	.long	353708607                       ; 0x15152a3f
	.long	67373068                        ; 0x404080c
	.long	3351745874                      ; 0xc7c79552
	.long	589514341                       ; 0x23234665
	.long	3284376926                      ; 0xc3c39d5e
	.long	404238376                       ; 0x18183028
	.long	2526427041                      ; 0x969637a1
	.long	84216335                        ; 0x5050a0f
	.long	2593796021                      ; 0x9a9a2fb5
	.long	117902857                       ; 0x7070e09
	.long	303178806                       ; 0x12122436
	.long	2155879323                      ; 0x80801b9b
	.long	3806519101                      ; 0xe2e2df3d
	.long	3958099238                      ; 0xebebcd26
	.long	656887401                       ; 0x27274e69
	.long	2998042573                      ; 0xb2b27fcd
	.long	1970662047                      ; 0x7575ea9f
	.long	151589403                       ; 0x909121b
	.long	2206408094                      ; 0x83831d9e
	.long	741103732                       ; 0x2c2c5874
	.long	437924910                       ; 0x1a1a342e
	.long	454768173                       ; 0x1b1b362d
	.long	1852759218                      ; 0x6e6edcb2
	.long	1515893998                      ; 0x5a5ab4ee
	.long	2694863867                      ; 0xa0a05bfb
	.long	1381147894                      ; 0x5252a4f6
	.long	993752653                       ; 0x3b3b764d
	.long	3604395873                      ; 0xd6d6b761
	.long	3014884814                      ; 0xb3b37dce
	.long	690573947                       ; 0x2929527b
	.long	3823361342                      ; 0xe3e3dd3e
	.long	791633521                       ; 0x2f2f5e71
	.long	2223248279                      ; 0x84841397
	.long	1397991157                      ; 0x5353a6f5
	.long	3520182632                      ; 0xd1d1b968
	.long	0                               ; 0x0
	.long	3991781676                      ; 0xededc12c
	.long	538984544                       ; 0x20204060
	.long	4244431647                      ; 0xfcfce31f
	.long	2981198280                      ; 0xb1b179c8
	.long	1532737261                      ; 0x5b5bb6ed
	.long	1785386174                      ; 0x6a6ad4be
	.long	3419114822                      ; 0xcbcb8d46
	.long	3200149465                      ; 0xbebe67d9
	.long	960066123                       ; 0x3939724b
	.long	1246401758                      ; 0x4a4a94de
	.long	1280088276                      ; 0x4c4c98d4
	.long	1482207464                      ; 0x5858b0e8
	.long	3486483786                      ; 0xcfcf854a
	.long	3503340395                      ; 0xd0d0bb6b
	.long	4025468202                      ; 0xefefc52a
	.long	2863288293                      ; 0xaaaa4fe5
	.long	4227591446                      ; 0xfbfbed16
	.long	1128498885                      ; 0x434386c5
	.long	1296931543                      ; 0x4d4d9ad7
	.long	859006549                       ; 0x33336655
	.long	2240090516                      ; 0x85851194
	.long	1162185423                      ; 0x45458acf
	.long	4193904912                      ; 0xf9f9e910
	.long	33686534                        ; 0x2020406
	.long	2139094657                      ; 0x7f7ffe81
	.long	1347461360                      ; 0x5050a0f0
	.long	1010595908                      ; 0x3c3c7844
	.long	2678007226                      ; 0x9f9f25ba
	.long	2829601763                      ; 0xa8a84be3
	.long	1364304627                      ; 0x5151a2f3
	.long	2745392638                      ; 0xa3a35dfe
	.long	1077969088                      ; 0x404080c0
	.long	2408514954                      ; 0x8f8f058a
	.long	2459058093                      ; 0x92923fad
	.long	2644320700                      ; 0x9d9d21bc
	.long	943222856                       ; 0x38387048
	.long	4126535940                      ; 0xf5f5f104
	.long	3166462943                      ; 0xbcbc63df
	.long	3065411521                      ; 0xb6b677c1
	.long	3671764853                      ; 0xdadaaf75
	.long	555827811                       ; 0x21214263
	.long	269492272                       ; 0x10102030
	.long	4294960410                      ; 0xffffe51a
	.long	4092853518                      ; 0xf3f3fd0e
	.long	3537026925                      ; 0xd2d2bf6d
	.long	3452797260                      ; 0xcdcd814c
	.long	202119188                       ; 0xc0c1814
	.long	320022069                       ; 0x13132635
	.long	3974939439                      ; 0xececc32f
	.long	1600110305                      ; 0x5f5fbee1
	.long	2543269282                      ; 0x979735a2
	.long	1145342156                      ; 0x444488cc
	.long	387395129                       ; 0x17172e39
	.long	3301217111                      ; 0xc4c49357
	.long	2812761586                      ; 0xa7a755f2
	.long	2122251394                      ; 0x7e7efc82
	.long	1027439175                      ; 0x3d3d7a47
	.long	1684326572                      ; 0x6464c8ac
	.long	1566423783                      ; 0x5d5dbae7
	.long	421081643                       ; 0x1919322b
	.long	1936975509                      ; 0x7373e695
	.long	1616953504                      ; 0x6060c0a0
	.long	2172721560                      ; 0x81811998
	.long	1330618065                      ; 0x4f4f9ed1
	.long	3705447295                      ; 0xdcdca37f
	.long	572671078                       ; 0x22224466
	.long	707417214                       ; 0x2a2a547e
	.long	2425371563                      ; 0x90903bab
	.long	2290617219                      ; 0x88880b83
	.long	1179028682                      ; 0x46468cca
	.long	4008625961                      ; 0xeeeec729
	.long	3099093971                      ; 0xb8b86bd3
	.long	336865340                       ; 0x1414283c
	.long	3739133817                      ; 0xdedea779
	.long	1583267042                      ; 0x5e5ebce2
	.long	185275933                       ; 0xb0b161d
	.long	3688607094                      ; 0xdbdbad76
	.long	3772832571                      ; 0xe0e0db3b
	.long	842163286                       ; 0x32326456
	.long	976909390                       ; 0x3a3a744e
	.long	168432670                       ; 0xa0a141e
	.long	1229558491                      ; 0x494992db
	.long	101059594                       ; 0x6060c0a
	.long	606357612                       ; 0x2424486c
	.long	1549580516                      ; 0x5c5cb8e4
	.long	3267534685                      ; 0xc2c29f5d
	.long	3553869166                      ; 0xd3d3bd6e
	.long	2896970735                      ; 0xacac43ef
	.long	1650640038                      ; 0x6262c4a6
	.long	2442213800                      ; 0x919139a8
	.long	2509582756                      ; 0x959531a4
	.long	3840201527                      ; 0xe4e4d337
	.long	2038035083                      ; 0x7979f28b
	.long	3890730290                      ; 0xe7e7d532
	.long	3368586051                      ; 0xc8c88b43
	.long	926379609                       ; 0x37376e59
	.long	1835915959                      ; 0x6d6ddab7
	.long	2374828428                      ; 0x8d8d018c
	.long	3587551588                      ; 0xd5d5b164
	.long	1313774802                      ; 0x4e4e9cd2
	.long	2846444000                      ; 0xa9a949e0
	.long	1819072692                      ; 0x6c6cd8b4
	.long	1448520954                      ; 0x5656acfa
	.long	4109693703                      ; 0xf4f4f307
	.long	3941256997                      ; 0xeaeacf25
	.long	1701169839                      ; 0x6565caaf
	.long	2054878350                      ; 0x7a7af48e
	.long	2930657257                      ; 0xaeae47e9
	.long	134746136                       ; 0x8081018
	.long	3132780501                      ; 0xbaba6fd5
	.long	2021191816                      ; 0x7878f088
	.long	623200879                       ; 0x25254a6f
	.long	774790258                       ; 0x2e2e5c72
	.long	471611428                       ; 0x1c1c3824
	.long	2795919345                      ; 0xa6a657f1
	.long	3031724999                      ; 0xb4b473c7
	.long	3334903633                      ; 0xc6c69751
	.long	3907570467                      ; 0xe8e8cb23
	.long	3722289532                      ; 0xdddda17c
	.long	1953818780                      ; 0x7474e89c
	.long	522141217                       ; 0x1f1f3e21
	.long	1263245021                      ; 0x4b4b96dd
	.long	3183305180                      ; 0xbdbd61dc
	.long	2341145990                      ; 0x8b8b0d86
	.long	2324303749                      ; 0x8a8a0f85
	.long	1886445712                      ; 0x7070e090
	.long	1044282434                      ; 0x3e3e7c42
	.long	3048567236                      ; 0xb5b571c4
	.long	1718013098                      ; 0x6666ccaa
	.long	1212715224                      ; 0x484890d8
	.long	50529797                        ; 0x3030605
	.long	4143380225                      ; 0xf6f6f701
	.long	235805714                       ; 0xe0e1c12
	.long	1633796771                      ; 0x6161c2a3
	.long	892693087                       ; 0x35356a5f
	.long	1465364217                      ; 0x5757aef9
	.long	3115936208                      ; 0xb9b969d0
	.long	2256934801                      ; 0x86861791
	.long	3250690392                      ; 0xc1c19958
	.long	488454695                       ; 0x1d1d3a27
	.long	2661164985                      ; 0x9e9e27b9
	.long	3789674808                      ; 0xe1e1d938
	.long	4177062675                      ; 0xf8f8eb13
	.long	2560109491                      ; 0x98982bb3
	.long	286335539                       ; 0x11112233
	.long	1768542907                      ; 0x6969d2bb
	.long	3654920560                      ; 0xd9d9a970
	.long	2391672713                      ; 0x8e8e0789
	.long	2492740519                      ; 0x949433a7
	.long	2610638262                      ; 0x9b9b2db6
	.long	505297954                       ; 0x1e1e3c22
	.long	2273777042                      ; 0x87871592
	.long	3924412704                      ; 0xe9e9c920
	.long	3469641545                      ; 0xcece8749
	.long	1431677695                      ; 0x5555aaff
	.long	673730680                       ; 0x28285078
	.long	3755976058                      ; 0xdfdfa57a
	.long	2357986191                      ; 0x8c8c038f
	.long	2711706104                      ; 0xa1a159f8
	.long	2307459456                      ; 0x89890980
	.long	218962455                       ; 0xd0d1a17
	.long	3216991706                      ; 0xbfbf65da
	.long	3873888049                      ; 0xe6e6d731
	.long	1111655622                      ; 0x424284c6
	.long	1751699640                      ; 0x6868d0b8
	.long	1094812355                      ; 0x414182c3
	.long	2576951728                      ; 0x999929b0
	.long	757946999                       ; 0x2d2d5a77
	.long	252648977                       ; 0xf0f1e11
	.long	2964356043                      ; 0xb0b07bcb
	.long	1414834428                      ; 0x5454a8fc
	.long	3149622742                      ; 0xbbbb6dd6
	.long	370551866                       ; 0x16162c3a
	.long	1673962851                      ; 0x63c6a563
	.long	2096661628                      ; 0x7cf8847c
	.long	2012125559                      ; 0x77ee9977
	.long	2079755643                      ; 0x7bf68d7b
	.long	4076801522                      ; 0xf2ff0df2
	.long	1809235307                      ; 0x6bd6bd6b
	.long	1876865391                      ; 0x6fdeb16f
	.long	3314635973                      ; 0xc59154c5
	.long	811618352                       ; 0x30605030
	.long	16909057                        ; 0x1020301
	.long	1741597031                      ; 0x67cea967
	.long	727088427                       ; 0x2b567d2b
	.long	4276558334                      ; 0xfee719fe
	.long	3618988759                      ; 0xd7b562d7
	.long	2874009259                      ; 0xab4de6ab
	.long	1995217526                      ; 0x76ec9a76
	.long	3398387146                      ; 0xca8f45ca
	.long	2183110018                      ; 0x821f9d82
	.long	3381215433                      ; 0xc98940c9
	.long	2113570685                      ; 0x7dfa877d
	.long	4209972730                      ; 0xfaef15fa
	.long	1504897881                      ; 0x59b2eb59
	.long	1200539975                      ; 0x478ec947
	.long	4042984432                      ; 0xf0fb0bf0
	.long	2906778797                      ; 0xad41ecad
	.long	3568527316                      ; 0xd4b367d4
	.long	2724199842                      ; 0xa25ffda2
	.long	2940594863                      ; 0xaf45eaaf
	.long	2619588508                      ; 0x9c23bf9c
	.long	2756966308                      ; 0xa453f7a4
	.long	1927583346                      ; 0x72e49672
	.long	3231407040                      ; 0xc09b5bc0
	.long	3077948087                      ; 0xb775c2b7
	.long	4259388669                      ; 0xfde11cfd
	.long	2470293139                      ; 0x933dae93
	.long	642542118                       ; 0x264c6a26
	.long	913070646                       ; 0x366c5a36
	.long	1065238847                      ; 0x3f7e413f
	.long	4160029431                      ; 0xf7f502f7
	.long	3431157708                      ; 0xcc834fcc
	.long	879254580                       ; 0x34685c34
	.long	2773611685                      ; 0xa551f4a5
	.long	3855693029                      ; 0xe5d134e5
	.long	4059629809                      ; 0xf1f908f1
	.long	1910674289                      ; 0x71e29371
	.long	3635114968                      ; 0xd8ab73d8
	.long	828527409                       ; 0x31625331
	.long	355090197                       ; 0x152a3f15
	.long	67636228                        ; 0x4080c04
	.long	3348452039                      ; 0xc79552c7
	.long	591815971                       ; 0x23466523
	.long	3281870531                      ; 0xc39d5ec3
	.long	405809176                       ; 0x18302818
	.long	2520228246                      ; 0x9637a196
	.long	84545285                        ; 0x50a0f05
	.long	2586817946                      ; 0x9a2fb59a
	.long	118360327                       ; 0x70e0907
	.long	304363026                       ; 0x12243612
	.long	2149292928                      ; 0x801b9b80
	.long	3806281186                      ; 0xe2df3de2
	.long	3956090603                      ; 0xebcd26eb
	.long	659450151                       ; 0x274e6927
	.long	2994720178                      ; 0xb27fcdb2
	.long	1978310517                      ; 0x75ea9f75
	.long	152181513                       ; 0x9121b09
	.long	2199756419                      ; 0x831d9e83
	.long	743994412                       ; 0x2c58742c
	.long	439627290                       ; 0x1a342e1a
	.long	456535323                       ; 0x1b362d1b
	.long	1859957358                      ; 0x6edcb26e
	.long	1521806938                      ; 0x5ab4ee5a
	.long	2690382752                      ; 0xa05bfba0
	.long	1386542674                      ; 0x52a4f652
	.long	997608763                       ; 0x3b764d3b
	.long	3602342358                      ; 0xd6b761d6
	.long	3011366579                      ; 0xb37dceb3
	.long	693271337                       ; 0x29527b29
	.long	3822927587                      ; 0xe3dd3ee3
	.long	794718511                       ; 0x2f5e712f
	.long	2215876484                      ; 0x84139784
	.long	1403450707                      ; 0x53a6f553
	.long	3518589137                      ; 0xd1b968d1
	.long	0                               ; 0x0
	.long	3988860141                      ; 0xedc12ced
	.long	541089824                       ; 0x20406020
	.long	4242743292                      ; 0xfce31ffc
	.long	2977548465                      ; 0xb179c8b1
	.long	1538714971                      ; 0x5bb6ed5b
	.long	1792327274                      ; 0x6ad4be6a
	.long	3415033547                      ; 0xcb8d46cb
	.long	3194476990                      ; 0xbe67d9be
	.long	963791673                       ; 0x39724b39
	.long	1251270218                      ; 0x4a94de4a
	.long	1285084236                      ; 0x4c98d44c
	.long	1487988824                      ; 0x58b0e858
	.long	3481619151                      ; 0xcf854acf
	.long	3501943760                      ; 0xd0bb6bd0
	.long	4022676207                      ; 0xefc52aef
	.long	2857362858                      ; 0xaa4fe5aa
	.long	4226619131                      ; 0xfbed16fb
	.long	1132905795                      ; 0x4386c543
	.long	1301993293                      ; 0x4d9ad74d
	.long	862344499                       ; 0x33665533
	.long	2232521861                      ; 0x85119485
	.long	1166724933                      ; 0x458acf45
	.long	4192801017                      ; 0xf9e910f9
	.long	33818114                        ; 0x2040602
	.long	2147385727                      ; 0x7ffe817f
	.long	1352724560                      ; 0x50a0f050
	.long	1014514748                      ; 0x3c78443c
	.long	2670049951                      ; 0x9f25ba9f
	.long	2823545768                      ; 0xa84be3a8
	.long	1369633617                      ; 0x51a2f351
	.long	2740846243                      ; 0xa35dfea3
	.long	1082179648                      ; 0x4080c040
	.long	2399505039                      ; 0x8f058a8f
	.long	2453646738                      ; 0x923fad92
	.long	2636233885                      ; 0x9d21bc9d
	.long	946882616                       ; 0x38704838
	.long	4126213365                      ; 0xf5f104f5
	.long	3160661948                      ; 0xbc63dfbc
	.long	3061301686                      ; 0xb677c1b6
	.long	3668932058                      ; 0xdaaf75da
	.long	557998881                       ; 0x21426321
	.long	270544912                       ; 0x10203010
	.long	4293204735                      ; 0xffe51aff
	.long	4093447923                      ; 0xf3fd0ef3
	.long	3535760850                      ; 0xd2bf6dd2
	.long	3447803085                      ; 0xcd814ccd
	.long	202904588                       ; 0xc18140c
	.long	321271059                       ; 0x13263513
	.long	3972214764                      ; 0xecc32fec
	.long	1606345055                      ; 0x5fbee15f
	.long	2536874647                      ; 0x9735a297
	.long	1149815876                      ; 0x4488cc44
	.long	388905239                       ; 0x172e3917
	.long	3297990596                      ; 0xc49357c4
	.long	2807427751                      ; 0xa755f2a7
	.long	2130477694                      ; 0x7efc827e
	.long	1031423805                      ; 0x3d7a473d
	.long	1690872932                      ; 0x64c8ac64
	.long	1572530013                      ; 0x5dbae75d
	.long	422718233                       ; 0x19322b19
	.long	1944491379                      ; 0x73e69573
	.long	1623236704                      ; 0x60c0a060
	.long	2165938305                      ; 0x81199881
	.long	1335808335                      ; 0x4f9ed14f
	.long	3701702620                      ; 0xdca37fdc
	.long	574907938                       ; 0x22446622
	.long	710180394                       ; 0x2a547e2a
	.long	2419829648                      ; 0x903bab90
	.long	2282455944                      ; 0x880b8388
	.long	1183631942                      ; 0x468cca46
	.long	4006029806                      ; 0xeec729ee
	.long	3094074296                      ; 0xb86bd3b8
	.long	338181140                       ; 0x14283c14
	.long	3735517662                      ; 0xdea779de
	.long	1589437022                      ; 0x5ebce25e
	.long	185998603                       ; 0xb161d0b
	.long	3685578459                      ; 0xdbad76db
	.long	3772464096                      ; 0xe0db3be0
	.long	845436466                       ; 0x32645632
	.long	980700730                       ; 0x3a744e3a
	.long	169090570                       ; 0xa141e0a
	.long	1234361161                      ; 0x4992db49
	.long	101452294                       ; 0x60c0a06
	.long	608726052                       ; 0x24486c24
	.long	1555620956                      ; 0x5cb8e45c
	.long	3265224130                      ; 0xc29f5dc2
	.long	3552407251                      ; 0xd3bd6ed3
	.long	2890133420                      ; 0xac43efac
	.long	1657054818                      ; 0x62c4a662
	.long	2436475025                      ; 0x9139a891
	.long	2503058581                      ; 0x9531a495
	.long	3839047652                      ; 0xe4d337e4
	.long	2045938553                      ; 0x79f28b79
	.long	3889509095                      ; 0xe7d532e7
	.long	3364570056                      ; 0xc88b43c8
	.long	929978679                       ; 0x376e5937
	.long	1843050349                      ; 0x6ddab76d
	.long	2365688973                      ; 0x8d018c8d
	.long	3585172693                      ; 0xd5b164d5
	.long	1318900302                      ; 0x4e9cd24e
	.long	2840191145                      ; 0xa949e0a9
	.long	1826141292                      ; 0x6cd8b46c
	.long	1454176854                      ; 0x56acfa56
	.long	4109567988                      ; 0xf4f307f4
	.long	3939444202                      ; 0xeacf25ea
	.long	1707781989                      ; 0x65caaf65
	.long	2062847610                      ; 0x7af48e7a
	.long	2923948462                      ; 0xae47e9ae
	.long	135272456                       ; 0x8101808
	.long	3127891386                      ; 0xba6fd5ba
	.long	2029029496                      ; 0x78f08878
	.long	625635109                       ; 0x254a6f25
	.long	777810478                       ; 0x2e5c722e
	.long	473441308                       ; 0x1c38241c
	.long	2790781350                      ; 0xa657f1a6
	.long	3027486644                      ; 0xb473c7b4
	.long	3331805638                      ; 0xc69751c6
	.long	3905627112                      ; 0xe8cb23e8
	.long	3718347997                      ; 0xdda17cdd
	.long	1961401460                      ; 0x74e89c74
	.long	524165407                       ; 0x1f3e211f
	.long	1268178251                      ; 0x4b96dd4b
	.long	3177307325                      ; 0xbd61dcbd
	.long	2332919435                      ; 0x8b0d868b
	.long	2316273034                      ; 0x8a0f858a
	.long	1893765232                      ; 0x70e09070
	.long	1048330814                      ; 0x3e7c423e
	.long	3044132021                      ; 0xb571c4b5
	.long	1724688998                      ; 0x66ccaa66
	.long	1217452104                      ; 0x4890d848
	.long	50726147                        ; 0x3060503
	.long	4143383030                      ; 0xf6f701f6
	.long	236720654                       ; 0xe1c120e
	.long	1640145761                      ; 0x61c2a361
	.long	896163637                       ; 0x356a5f35
	.long	1471084887                      ; 0x57aef957
	.long	3110719673                      ; 0xb969d0b9
	.long	2249691526                      ; 0x86179186
	.long	3248052417                      ; 0xc19958c1
	.long	490350365                       ; 0x1d3a271d
	.long	2653403550                      ; 0x9e27b99e
	.long	3789109473                      ; 0xe1d938e1
	.long	4176155640                      ; 0xf8eb13f8
	.long	2553000856                      ; 0x982bb398
	.long	287453969                       ; 0x11223311
	.long	1775418217                      ; 0x69d2bb69
	.long	3651760345                      ; 0xd9a970d9
	.long	2382858638                      ; 0x8e07898e
	.long	2486413204                      ; 0x9433a794
	.long	2603464347                      ; 0x9b2db69b
	.long	507257374                       ; 0x1e3c221e
	.long	2266337927                      ; 0x87159287
	.long	3922272489                      ; 0xe9c920e9
	.long	3464972750                      ; 0xce8749ce
	.long	1437269845                      ; 0x55aaff55
	.long	676362280                       ; 0x28507828
	.long	3752164063                      ; 0xdfa57adf
	.long	2349043596                      ; 0x8c038f8c
	.long	2707028129                      ; 0xa159f8a1
	.long	2299101321                      ; 0x89098089
	.long	219813645                       ; 0xd1a170d
	.long	3211123391                      ; 0xbf65dabf
	.long	3872862694                      ; 0xe6d731e6
	.long	1115997762                      ; 0x4284c642
	.long	1758509160                      ; 0x68d0b868
	.long	1099088705                      ; 0x4182c341
	.long	2569646233                      ; 0x9929b099
	.long	760903469                       ; 0x2d5a772d
	.long	253628687                       ; 0xf1e110f
	.long	2960903088                      ; 0xb07bcbb0
	.long	1420360788                      ; 0x54a8fc54
	.long	3144537787                      ; 0xbb6dd6bb
	.long	371997206                       ; 0x162c3a16
	.long	3332727651                      ; 0xc6a56363
	.long	4169432188                      ; 0xf8847c7c
	.long	4003034999                      ; 0xee997777
	.long	4136467323                      ; 0xf68d7b7b
	.long	4279104242                      ; 0xff0df2f2
	.long	3602738027                      ; 0xd6bd6b6b
	.long	3736170351                      ; 0xdeb16f6f
	.long	2438251973                      ; 0x9154c5c5
	.long	1615867952                      ; 0x60503030
	.long	33751297                        ; 0x2030101
	.long	3467208551                      ; 0xcea96767
	.long	1451043627                      ; 0x567d2b2b
	.long	3877240574                      ; 0xe719fefe
	.long	3043153879                      ; 0xb562d7d7
	.long	1306962859                      ; 0x4de6abab
	.long	3969545846                      ; 0xec9a7676
	.long	2403715786                      ; 0x8f45caca
	.long	530416258                       ; 0x1f9d8282
	.long	2302724553                      ; 0x8940c9c9
	.long	4203183485                      ; 0xfa877d7d
	.long	4011195130                      ; 0xef15fafa
	.long	3001768281                      ; 0xb2eb5959
	.long	2395555655                      ; 0x8ec94747
	.long	4211863792                      ; 0xfb0bf0f0
	.long	1106029997                      ; 0x41ecadad
	.long	3009926356                      ; 0xb367d4d4
	.long	1610457762                      ; 0x5ffda2a2
	.long	1173008303                      ; 0x45eaafaf
	.long	599760028                       ; 0x23bf9c9c
	.long	1408738468                      ; 0x53f7a4a4
	.long	3835064946                      ; 0xe4967272
	.long	2606481600                      ; 0x9b5bc0c0
	.long	1975695287                      ; 0x75c2b7b7
	.long	3776773629                      ; 0xe11cfdfd
	.long	1034851219                      ; 0x3dae9393
	.long	1282024998                      ; 0x4c6a2626
	.long	1817851446                      ; 0x6c5a3636
	.long	2118205247                      ; 0x7e413f3f
	.long	4110612471                      ; 0xf502f7f7
	.long	2203045068                      ; 0x834fcccc
	.long	1750873140                      ; 0x685c3434
	.long	1374987685                      ; 0x51f4a5a5
	.long	3509904869                      ; 0xd134e5e5
	.long	4178113009                      ; 0xf908f1f1
	.long	3801313649                      ; 0xe2937171
	.long	2876496088                      ; 0xab73d8d8
	.long	1649619249                      ; 0x62533131
	.long	708777237                       ; 0x2a3f1515
	.long	135005188                       ; 0x80c0404
	.long	2505230279                      ; 0x9552c7c7
	.long	1181033251                      ; 0x46652323
	.long	2640233411                      ; 0x9d5ec3c3
	.long	807933976                       ; 0x30281818
	.long	933336726                       ; 0x37a19696
	.long	168756485                       ; 0xa0f0505
	.long	800430746                       ; 0x2fb59a9a
	.long	235472647                       ; 0xe090707
	.long	607523346                       ; 0x24361212
	.long	463175808                       ; 0x1b9b8080
	.long	3745374946                      ; 0xdf3de2e2
	.long	3441880043                      ; 0xcd26ebeb
	.long	1315514151                      ; 0x4e692727
	.long	2144187058                      ; 0x7fcdb2b2
	.long	3936318837                      ; 0xea9f7575
	.long	303761673                       ; 0x121b0909
	.long	496927619                       ; 0x1d9e8383
	.long	1484008492                      ; 0x58742c2c
	.long	875436570                       ; 0x342e1a1a
	.long	908925723                       ; 0x362d1b1b
	.long	3702681198                      ; 0xdcb26e6e
	.long	3035519578                      ; 0xb4ee5a5a
	.long	1543217312                      ; 0x5bfba0a0
	.long	2767606354                      ; 0xa4f65252
	.long	1984772923                      ; 0x764d3b3b
	.long	3076642518                      ; 0xb761d6d6
	.long	2110698419                      ; 0x7dceb3b3
	.long	1383803177                      ; 0x527b2929
	.long	3711886307                      ; 0xdd3ee3e3
	.long	1584475951                      ; 0x5e712f2f
	.long	328696964                       ; 0x13978484
	.long	2801095507                      ; 0xa6f55353
	.long	3110654417                      ; 0xb968d1d1
	.long	0                               ; 0x0
	.long	3240947181                      ; 0xc12ceded
	.long	1080041504                      ; 0x40602020
	.long	3810524412                      ; 0xe31ffcfc
	.long	2043195825                      ; 0x79c8b1b1
	.long	3069008731                      ; 0xb6ed5b5b
	.long	3569248874                      ; 0xd4be6a6a
	.long	2370227147                      ; 0x8d46cbcb
	.long	1742323390                      ; 0x67d9bebe
	.long	1917532473                      ; 0x724b3939
	.long	2497595978                      ; 0x94de4a4a
	.long	2564049996                      ; 0x98d44c4c
	.long	2968016984                      ; 0xb0e85858
	.long	2236272591                      ; 0x854acfcf
	.long	3144405200                      ; 0xbb6bd0d0
	.long	3307925487                      ; 0xc52aefef
	.long	1340451498                      ; 0x4fe5aaaa
	.long	3977706491                      ; 0xed16fbfb
	.long	2261074755                      ; 0x86c54343
	.long	2597801293                      ; 0x9ad74d4d
	.long	1716859699                      ; 0x66553333
	.long	294946181                       ; 0x11948585
	.long	2328839493                      ; 0x8acf4545
	.long	3910203897                      ; 0xe910f9f9
	.long	67502594                        ; 0x4060202
	.long	4269899647                      ; 0xfe817f7f
	.long	2700103760                      ; 0xa0f05050
	.long	2017737788                      ; 0x78443c3c
	.long	632987551                       ; 0x25ba9f9f
	.long	1273211048                      ; 0x4be3a8a8
	.long	2733855057                      ; 0xa2f35151
	.long	1576969123                      ; 0x5dfea3a3
	.long	2160083008                      ; 0x80c04040
	.long	92966799                        ; 0x58a8f8f
	.long	1068339858                      ; 0x3fad9292
	.long	566009245                       ; 0x21bc9d9d
	.long	1883781176                      ; 0x70483838
	.long	4043634165                      ; 0xf104f5f5
	.long	1675607228                      ; 0x63dfbcbc
	.long	2009183926                      ; 0x77c1b6b6
	.long	2943736538                      ; 0xaf75dada
	.long	1113792801                      ; 0x42632121
	.long	540020752                       ; 0x20301010
	.long	3843751935                      ; 0xe51affff
	.long	4245615603                      ; 0xfd0ef3f3
	.long	3211645650                      ; 0xbf6dd2d2
	.long	2169294285                      ; 0x814ccdcd
	.long	403966988                       ; 0x18140c0c
	.long	641012499                       ; 0x26351313
	.long	3274697964                      ; 0xc32fecec
	.long	3202441055                      ; 0xbee15f5f
	.long	899848087                       ; 0x35a29797
	.long	2295088196                      ; 0x88cc4444
	.long	775493399                       ; 0x2e391717
	.long	2472002756                      ; 0x9357c4c4
	.long	1441965991                      ; 0x55f2a7a7
	.long	4236410494                      ; 0xfc827e7e
	.long	2051489085                      ; 0x7a473d3d
	.long	3366741092                      ; 0xc8ac6464
	.long	3135724893                      ; 0xbae75d5d
	.long	841685273                       ; 0x322b1919
	.long	3868554099                      ; 0xe6957373
	.long	3231735904                      ; 0xc0a06060
	.long	429425025                       ; 0x19988181
	.long	2664517455                      ; 0x9ed14f4f
	.long	2743065820                      ; 0xa37fdcdc
	.long	1147544098                      ; 0x44662222
	.long	1417554474                      ; 0x547e2a2a
	.long	1001099408                      ; 0x3bab9090
	.long	193169544                       ; 0xb838888
	.long	2362066502                      ; 0x8cca4646
	.long	3341414126                      ; 0xc729eeee
	.long	1809037496                      ; 0x6bd3b8b8
	.long	675025940                       ; 0x283c1414
	.long	2809781982                      ; 0xa779dede
	.long	3168951902                      ; 0xbce25e5e
	.long	371002123                       ; 0x161d0b0b
	.long	2910247899                      ; 0xad76dbdb
	.long	3678134496                      ; 0xdb3be0e0
	.long	1683370546                      ; 0x64563232
	.long	1951283770                      ; 0x744e3a3a
	.long	337512970                       ; 0x141e0a0a
	.long	2463844681                      ; 0x92db4949
	.long	201983494                       ; 0xc0a0606
	.long	1215046692                      ; 0x486c2424
	.long	3101973596                      ; 0xb8e45c5c
	.long	2673722050                      ; 0x9f5dc2c2
	.long	3178157011                      ; 0xbd6ed3d3
	.long	1139780780                      ; 0x43efacac
	.long	3299238498                      ; 0xc4a66262
	.long	967348625                       ; 0x39a89191
	.long	832869781                       ; 0x31a49595
	.long	3543655652                      ; 0xd337e4e4
	.long	4069226873                      ; 0xf28b7979
	.long	3576883175                      ; 0xd532e7e7
	.long	2336475336                      ; 0x8b43c8c8
	.long	1851340599                      ; 0x6e593737
	.long	3669454189                      ; 0xdab76d6d
	.long	25988493                        ; 0x18c8d8d
	.long	2976175573                      ; 0xb164d5d5
	.long	2631028302                      ; 0x9cd24e4e
	.long	1239460265                      ; 0x49e0a9a9
	.long	3635702892                      ; 0xd8b46c6c
	.long	2902087254                      ; 0xacfa5656
	.long	4077384948                      ; 0xf307f4f4
	.long	3475368682                      ; 0xcf25eaea
	.long	3400492389                      ; 0xcaaf6565
	.long	4102978170                      ; 0xf48e7a7a
	.long	1206496942                      ; 0x47e9aeae
	.long	270010376                       ; 0x10180808
	.long	1876277946                      ; 0x6fd5baba
	.long	4035475576                      ; 0xf0887878
	.long	1248797989                      ; 0x4a6f2525
	.long	1550986798                      ; 0x5c722e2e
	.long	941890588                       ; 0x38241c1c
	.long	1475454630                      ; 0x57f1a6a6
	.long	1942467764                      ; 0x73c7b4b4
	.long	2538718918                      ; 0x9751c6c6
	.long	3408128232                      ; 0xcb23e8e8
	.long	2709315037                      ; 0xa17cdddd
	.long	3902567540                      ; 0xe89c7474
	.long	1042358047                      ; 0x3e211f1f
	.long	2531085131                      ; 0x96dd4b4b
	.long	1641856445                      ; 0x61dcbdbd
	.long	226921355                       ; 0xd868b8b
	.long	260409994                       ; 0xf858a8a
	.long	3767562352                      ; 0xe0907070
	.long	2084716094                      ; 0x7c423e3e
	.long	1908716981                      ; 0x71c4b5b5
	.long	3433719398                      ; 0xccaa6666
	.long	2430093384                      ; 0x90d84848
	.long	100991747                       ; 0x6050303
	.long	4144101110                      ; 0xf701f6f6
	.long	470945294                       ; 0x1c120e0e
	.long	3265487201                      ; 0xc2a36161
	.long	1784624437                      ; 0x6a5f3535
	.long	2935576407                      ; 0xaef95757
	.long	1775286713                      ; 0x69d0b9b9
	.long	395413126                       ; 0x17918686
	.long	2572730817                      ; 0x9958c1c1
	.long	975641885                       ; 0x3a271d1d
	.long	666476190                       ; 0x27b99e9e
	.long	3644383713                      ; 0xd938e1e1
	.long	3943954680                      ; 0xeb13f8f8
	.long	733190296                       ; 0x2bb39898
	.long	573772049                       ; 0x22331111
	.long	3535497577                      ; 0xd2bb6969
	.long	2842745305                      ; 0xa970d9d9
	.long	126455438                       ; 0x7898e8e
	.long	866620564                       ; 0x33a79494
	.long	766942107                       ; 0x2db69b9b
	.long	1008868894                      ; 0x3c221e1e
	.long	361924487                       ; 0x15928787
	.long	3374377449                      ; 0xc920e9e9
	.long	2269761230                      ; 0x8749cece
	.long	2868860245                      ; 0xaaff5555
	.long	1350051880                      ; 0x50782828
	.long	2776293343                      ; 0xa57adfdf
	.long	59739276                        ; 0x38f8c8c
	.long	1509466529                      ; 0x59f8a1a1
	.long	159418761                       ; 0x9808989
	.long	437718285                       ; 0x1a170d0d
	.long	1708834751                      ; 0x65dabfbf
	.long	3610371814                      ; 0xd731e6e6
	.long	2227585602                      ; 0x84c64242
	.long	3501746280                      ; 0xd0b86868
	.long	2193834305                      ; 0x82c34141
	.long	699439513                       ; 0x29b09999
	.long	1517759789                      ; 0x5a772d2d
	.long	504434447                       ; 0x1e110f0f
	.long	2076946608                      ; 0x7bcbb0b0
	.long	2835108948                      ; 0xa8fc5454
	.long	1842789307                      ; 0x6dd6bbbb
	.long	742004246                       ; 0x2c3a1616

	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"ttable"

.subsections_via_symbols
