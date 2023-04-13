PPUCTRL				= $2000
PPUMASK				= $2001
PPUSTATUS			= $2002
PPUSCROLL			= $2005
PPUADDR				= $2006
PPUDATA				= $2007

; use a technique that uses no CHR
OPTIMIZEDFORCHR		= 0
PAL_NES_RASTER		= 0

.segment "HEADER"
  .byte "NES", $1A
  .byte $01			; n * 16KB PRG ROM
  ; the rest are handled by the config, all 0s

.segment "VECTORS"
	.addr nmi, reset, irq

.segment "BANK0"

.if ::OPTIMIZEDFORCHR
nmi:
	sta PPUADDR		; 4
	stx PPUADDR		; 4
.if ::PAL_NES_RASTER
	; optimized for PAL timings
	; wait 118 scanlines
	jsr delay_6144
	jsr delay_6144
	jsr delay_192
	jsr delay_96
	jsr delay_48
	jsr delay_24
	bit PPUDATA		; 4 !!
	; wait 48 scanlines
:	jsr delay_3072
	jsr delay_1536
	jsr delay_384
	jsr delay_96
	jsr delay_12
	inc $00, x		; 6; dummy
	bit PPUDATA		; 4 !!
	dey				; 2
	bne :-			; 2 1/3
.else
	; optimized for NTSC/Dendy timings
	; wait 69 scanlines
	jsr delay_6144
	jsr delay_1536
	jsr delay_96
	jsr delay_24
	inc $00
	bit PPUDATA		; 4 !!
	; wait 48 scanlines
:	jsr delay_3072
	jsr delay_1536
	jsr delay_768
	jsr delay_48
	jsr delay_24
	bit PPUDATA		; 4 !!
	dey				; 2
	bne :-			; 2 1/3
.endif
	ldy #3

irq:
	rti

; taken from bbbradsmith/nes-audio-tests
delay_6144:  jsr delay_3072
delay_3072:  jsr delay_1536
delay_1536:  jsr delay_768
delay_768:   jsr delay_384
delay_384:   jsr delay_192
delay_192:   jsr delay_96
delay_96:    jsr delay_48
delay_48:    jsr delay_24
delay_24:    jsr delay_12
delay_12:    rts

reset:
	sei
	cld

	ldx #$FF		; init stack
	txs
	inx				; now $00
	stx PPUCTRL		; disable NMI
	stx PPUMASK		; disable rendering


	; wait for the PPU to warm up
	bit PPUSTATUS
:	bit PPUSTATUS
	bpl :-
:	bit PPUSTATUS
	bpl :-

	; setup palette
	lda #$3F
	sta PPUADDR
	stx PPUADDR
	lda #$31		; light blue
	sta PPUDATA
	lda #$35		; light pink
	sta PPUDATA
	lda #$30		; white
	sta PPUDATA
	lda #$35		; light pink
	sta PPUDATA
	lda #$31		; light blue
	sta PPUDATA

	lda #$80
	sta PPUCTRL			; enable NMI

	lda #$3F
	ldy #3

	; fall through
main:
	jmp main

.else

nmi:
irq:
	rti

reset:
	sei
	cld

	ldx #$FF		; init stack
	txs
	inx				; now $00
	stx PPUCTRL		; disable NMI
	stx PPUMASK		; disable rendering

	; wait for the PPU to warm up
	bit PPUSTATUS
:	bit PPUSTATUS
	bpl :-
:	bit PPUSTATUS
	bpl :-

	; write 3 tiles to CHR RAM
	; each a solid color of color indexes 0, 2, and 3
	; based on pinobatch's algorithm in uaflag
	stx PPUADDR
	stx PPUADDR
	txa
tilegenerator:
	ldx #24			; 24 bytes of either $00, or $FF
:	sta PPUDATA
	dex
	bne :-
	eor #$FF		; quits when EOR'd twice
	bmi tilegenerator

	; write nametables
	lda #$20
	sta PPUADDR
	stx PPUADDR

	; write 12x16 tiles of $02
	ldy #$02
	jsr tilewrites

	; write 12x16 tiles of $01
	dey
	jsr tilewrites

	; write 12x16 tiles of $00
	dey
	jsr tilewrites

	; write 12x16 tiles of $01
	iny
	jsr tilewrites

	; write 12x16 tiles of $02
	iny
	jsr tilewrites

	; write 4x16 attribute tiles of $00
	ldy #$00
	ldx #$40
	jsr attrwrites

	; write colors to palette ram
	dey				; masks off to $3F
	sty PPUADDR
	stx PPUADDR
	sta PPUDATA		; white ($20)
	sta PPUDATA		; garbage
	lda #$35		; light pink
	sta PPUDATA
	lda #$31		; light blue
	sta PPUDATA

	; restore scrolling
	stx PPUSCROLL
	stx PPUSCROLL

	lda #%00001110		; render only BG
	sta PPUMASK
	stx PPUCTRL			; set base nametable to $2000

	; fall through
main:
	ldx #$03
	jmp main

tilewrites:
	ldx #$C0
attrwrites:
:	sty PPUDATA
	dex
	bne :-
	rts
.endif
