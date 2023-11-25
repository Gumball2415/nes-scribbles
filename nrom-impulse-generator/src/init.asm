.include "defines.inc"
.include "global.inc"

.segment "BANK0"
.proc RESET_HANDLER
	SEI             ; disables interrupts
	CLD             ; disable decimal mode

	LDX #$40        ; disable DMC IRQ
	STX $4017

	LDX #$FF        ; init stack
	TXS
	INX
	STX PPUCTRL     ; disable NMI
	STX PPUMASK     ; disable rendering
	STX $4010       ; disable DPCM IRQ

	; insert misc init routine here

	;wait vblank 1
:
	BIT PPUSTATUS
	BPL :-

	; init RAM with $00
	TXA
CLEARMEM:
	STA $0000, X 
	STA $0100, X
	STA $0300, X
	STA $0400, X 
	STA $0500, X
	STA $0600, X
	STA $0700, X
	; init OAM RAM with $FF
	LDA #$FF
	STA $0200, X
	LDA #$00
	INX
	BNE CLEARMEM

	; insert misc init routine here

	; init palette table with #$0F
	LDX #0
CLEARPALETTETABLE:
	LDA #$0F
	STA palette_table, X
	INX
	CPX #$20
	BNE CLEARPALETTETABLE

	;wait vblank 2
:
	BIT PPUSTATUS
	BPL :-

	LDA #0
	STA OAMADDR
	LDA #02
	STA OAMDMA
	JSR clear_nametable

	; load palette
	LDA #0
	STA palette_state
	LDA #0
	STA temp_8_0
	JSR load_palette

	;wait vblank 3
:
	BIT PPUSTATUS
	BPL :-

	; write palettes
	JSR write_palette

	; load nametable
	LDA #0
	STA temp_8_0
	LDA #1		; index 1: screen of text and art
	STA nametable_state
	JSR load_nametable

	; enable channel outputs
	LDA #$1F
	STA $4015

	; transfer OAM data from $02xx
	LDA #0
	STA OAMADDR
	LDA #$02
	STA OAMDMA

	; update scrolling
	JSR update_scrolling

	LDA #%00011110				; enable rendering
	STA s_PPUMASK
	STA PPUMASK
	LDA #%10000000
	STA PPUCTRL
	STA s_PPUCTRL				; enable NMI

	LDX #1
	JSR wait_x_frames

	JMP main
.endproc
