	.build_version macos, 26, 0	sdk_version 27, 2
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; -- Begin function reverse_bytes
lCPI0_0:
	.byte	12                              ; 0xc
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	13                              ; 0xd
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	14                              ; 0xe
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	15                              ; 0xf
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
lCPI0_1:
	.byte	8                               ; 0x8
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	9                               ; 0x9
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	10                              ; 0xa
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	11                              ; 0xb
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
lCPI0_2:
	.byte	4                               ; 0x4
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	5                               ; 0x5
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	6                               ; 0x6
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	7                               ; 0x7
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
lCPI0_3:
	.byte	0                               ; 0x0
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	1                               ; 0x1
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	2                               ; 0x2
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	3                               ; 0x3
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
	.byte	255                             ; 0xff
lCPI0_4:
	.byte	0                               ; 0x0
	.byte	4                               ; 0x4
	.byte	8                               ; 0x8
	.byte	12                              ; 0xc
	.byte	16                              ; 0x10
	.byte	20                              ; 0x14
	.byte	24                              ; 0x18
	.byte	28                              ; 0x1c
	.byte	32                              ; 0x20
	.byte	36                              ; 0x24
	.byte	40                              ; 0x28
	.byte	44                              ; 0x2c
	.byte	48                              ; 0x30
	.byte	52                              ; 0x34
	.byte	56                              ; 0x38
	.byte	60                              ; 0x3c
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_reverse_bytes
	.p2align	2
_reverse_bytes:                         ; @reverse_bytes
	.cfi_startproc
; %bb.0:
	cbz	x2, LBB0_25
; %bb.1:
	mov	w8, #0                          ; =0x0
	cbz	x0, LBB0_26
; %bb.2:
	cbz	x1, LBB0_26
; %bb.3:
	sub	x10, x1, x0
	subs	x8, x0, x1
	csel	x8, x8, x10, hi
	cmp	x8, x2
	b.hs	LBB0_5
; %bb.4:
	mov	w0, #0                          ; =0x0
	ret
LBB0_5:
	cmp	x2, #16
	b.lo	LBB0_9
; %bb.6:
	mov	x9, #0                          ; =0x0
	mov	x8, x2
LBB0_7:                                 ; =>This Inner Loop Header: Depth=1
	ldr	q0, [x0, x9]
	rbit.16b	v0, v0
	str	q0, [x1, x9]
	add	x9, x9, #16
	sub	x8, x8, #16
	cmp	x8, #15
	b.hi	LBB0_7
; %bb.8:
	subs	x8, x2, x9
	b.hi	LBB0_10
	b	LBB0_25
LBB0_9:
	mov	x9, #0                          ; =0x0
	subs	x8, x2, x9
	b.ls	LBB0_25
LBB0_10:
	cmp	x8, #4
	b.lo	LBB0_14
; %bb.11:
	cmp	x10, #15
	b.ls	LBB0_14
; %bb.12:
	cmp	x8, #16
	b.hs	LBB0_15
; %bb.13:
	mov	x10, #0                         ; =0x0
	b	LBB0_19
LBB0_14:
	mov	x11, x9
	b	LBB0_23
LBB0_15:
	and	x10, x8, #0xfffffffffffffff0
	add	x11, x1, x9
Lloh0:
	adrp	x12, lCPI0_0@PAGE
Lloh1:
	ldr	q0, [x12, lCPI0_0@PAGEOFF]
Lloh2:
	adrp	x12, lCPI0_1@PAGE
Lloh3:
	ldr	q1, [x12, lCPI0_1@PAGEOFF]
	add	x12, x0, x9
Lloh4:
	adrp	x13, lCPI0_2@PAGE
Lloh5:
	ldr	q2, [x13, lCPI0_2@PAGEOFF]
Lloh6:
	adrp	x13, lCPI0_3@PAGE
Lloh7:
	ldr	q3, [x13, lCPI0_3@PAGEOFF]
	movi.4s	v4, #170
	movi.4s	v5, #204
Lloh8:
	adrp	x13, lCPI0_4@PAGE
Lloh9:
	ldr	q6, [x13, lCPI0_4@PAGEOFF]
	mov	x13, x10
LBB0_16:                                ; =>This Inner Loop Header: Depth=1
	ldr	q7, [x12], #16
	tbl.16b	v16, { v7 }, v0
	tbl.16b	v17, { v7 }, v1
	tbl.16b	v18, { v7 }, v2
	tbl.16b	v7, { v7 }, v3
	ushr.4s	v19, v7, #1
	ushr.4s	v20, v18, #1
	ushr.4s	v21, v17, #1
	ushr.4s	v22, v16, #1
	bic.4s	v22, #42
	bic.4s	v21, #42
	bic.4s	v20, #42
	add.4s	v7, v7, v7
	add.4s	v18, v18, v18
	bic.4s	v19, #42
	add.4s	v17, v17, v17
	add.4s	v16, v16, v16
	and.16b	v16, v16, v4
	and.16b	v17, v17, v4
	and.16b	v18, v18, v4
	and.16b	v7, v7, v4
	orr.16b	v7, v19, v7
	orr.16b	v18, v20, v18
	orr.16b	v17, v21, v17
	orr.16b	v16, v22, v16
	ushr.4s	v19, v16, #2
	ushr.4s	v20, v17, #2
	ushr.4s	v21, v18, #2
	ushr.4s	v22, v7, #2
	bic.4s	v22, #12
	bic.4s	v21, #12
	bic.4s	v20, #12
	bic.4s	v19, #12
	shl.4s	v16, v16, #2
	shl.4s	v17, v17, #2
	shl.4s	v18, v18, #2
	shl.4s	v7, v7, #2
	and.16b	v7, v7, v5
	and.16b	v18, v18, v5
	and.16b	v17, v17, v5
	and.16b	v16, v16, v5
	orr.16b	v16, v19, v16
	orr.16b	v17, v20, v17
	orr.16b	v18, v21, v18
	orr.16b	v7, v22, v7
	shl.4s	v19, v7, #4
	shl.4s	v20, v18, #4
	shl.4s	v21, v17, #4
	shl.4s	v22, v16, #4
	usra.4s	v22, v16, #4
	usra.4s	v21, v17, #4
	usra.4s	v20, v18, #4
	usra.4s	v19, v7, #4
	tbl.16b	v7, { v19, v20, v21, v22 }, v6
	str	q7, [x11], #16
	subs	x13, x13, #16
	b.ne	LBB0_16
; %bb.17:
	cmp	x8, x10
	b.eq	LBB0_25
; %bb.18:
	tst	x8, #0xc
	b.eq	LBB0_22
LBB0_19:
	and	x12, x8, #0xfffffffffffffffc
	add	x11, x9, x12
	sub	x13, x10, x12
	add	x10, x10, x9
	add	x9, x1, x10
	add	x10, x0, x10
	movi.4s	v0, #170
	movi.4s	v1, #204
LBB0_20:                                ; =>This Inner Loop Header: Depth=1
	ldr	s2, [x10], #4
	ushll.8h	v2, v2, #0
	ushll.4s	v3, v2, #0
	ushr.4s	v3, v3, #1
	bic.4s	v3, #42
	ushll.4s	v2, v2, #1
	and.16b	v2, v2, v0
	orr.16b	v2, v3, v2
	ushr.4s	v3, v2, #2
	bic.4s	v3, #12
	shl.4s	v2, v2, #2
	and.16b	v2, v2, v1
	orr.16b	v2, v3, v2
	shl.4s	v3, v2, #4
	usra.4s	v3, v2, #4
	xtn.4h	v2, v3
	uzp1.8b	v2, v2, v0
	st1.s	{ v2 }[0], [x9], #4
	adds	x13, x13, #4
	b.ne	LBB0_20
; %bb.21:
	cmp	x8, x12
	b.ne	LBB0_23
	b	LBB0_25
LBB0_22:
	add	x11, x9, x10
LBB0_23:
	sub	x8, x2, x11
	add	x9, x1, x11
	add	x10, x0, x11
LBB0_24:                                ; =>This Inner Loop Header: Depth=1
	ldrb	w11, [x10], #1
	lsr	w12, w11, #1
	and	w12, w12, #0x55555555
	lsl	w11, w11, #1
	and	w11, w11, #0xaaaaaaaa
	orr	w11, w12, w11
	lsr	w12, w11, #2
	and	w12, w12, #0xfffffff3
	lsl	w11, w11, #2
	and	w11, w11, #0xcccccccc
	orr	w11, w12, w11
	lsr	w12, w11, #4
	orr	w11, w12, w11, lsl #4
	strb	w11, [x9], #1
	subs	x8, x8, #1
	b.ne	LBB0_24
LBB0_25:
	mov	w8, #1                          ; =0x1
LBB0_26:
	mov	x0, x8
	ret
	.loh AdrpLdr	Lloh8, Lloh9
	.loh AdrpAdrp	Lloh6, Lloh8
	.loh AdrpLdr	Lloh6, Lloh7
	.loh AdrpAdrp	Lloh4, Lloh6
	.loh AdrpLdr	Lloh4, Lloh5
	.loh AdrpLdr	Lloh2, Lloh3
	.loh AdrpAdrp	Lloh0, Lloh2
	.loh AdrpLdr	Lloh0, Lloh1
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
