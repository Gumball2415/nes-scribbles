.include "defines.inc"
.include "global.inc"
.include "nes.inc"

.segment "VECTORS"
	.addr nmi, reset, irq

.segment "BANK0"

.import main, InitEpsmSafeWriteRam
.proc reset
	sei             ; disables interrupts
	cld             ; disable decimal mode

	ldx #$40        ; disable DMC IRQ
	stx $4017

	ldx #$FF        ; init stack
	txs
	inx
	stx PPUCTRL     ; disable NMI
	stx PPUMASK     ; disable rendering
	stx $4010       ; disable DPCM IRQ

	; insert misc init routine here

	;wait vblank 1
:
	bit PPUSTATUS
	bpl :-

	; init RAM with $00
	txa
clearmem:
	sta $0000, X 
	sta $0100, X
	sta $0300, X
	sta $0400, X 
	sta $0500, X
	sta $0600, X
	sta $0700, X
	; init OAM RAM with $FF
	lda #$FF
	sta $0200, X
	lda #$00
	inx
	bne clearmem

	; insert misc init routine here

	; init palette table with #$0F
	LDX #0
clearpalettetable:
	lda #$0F
	sta palette_table, X
	inx
	cpx #$20
	bne clearpalettetable
    jsr InitEpsmSafeWriteRam

	;wait vblank 2
:
	bit PPUSTATUS
	bpl :-

	lda #0
	sta OAMADDR
	lda #02
	sta OAM_RAM_start+1
	sta OAM_DMA

	; load palette
	lda #0
	sta palette_state
	lda #0
	sta temp_8_0
	jsr load_palette
    inc temp_8_0
	jsr load_palette

	;wait vblank 3
:
	bit PPUSTATUS
	bpl :-

	; write palettes
	jsr write_palette

	; load nametable
	lda #0
	sta nametable_loc
	lda #1		; index 1: screen of text and art
	sta nametable_state
	jsr load_nametable

	; update scrolling
	jsr update_scrolling

	lda system_state
	ora #STATUS_RENDER
	sta system_state

	lda #%00011110				; enable rendering
	sta s_PPUMASK
	lda #%10000000
	sta PPUCTRL
	sta s_PPUCTRL				; enable NMI

	cli

	lda #$00
	tax
	tay
	jmp main
.endproc

.import write_epsm_registers, display_cursor
.proc nmi			; push regs onto stack to preserve them and we can pop them off later
	pha
	tya
	pha
	txa
	pha

    ; write to EPSM
    ; we do this asap in NMI so that we get consistent timing
    jsr write_epsm_registers

    ; update cursor before OAM DMA
    jsr display_cursor

    ; check system state
    lda system_state
    and #STATUS_RENDER
    beq skip_render

	STA PPUMASK					; disable rendering
	STA PPUCTRL					; writes to PPUDATA will increment by 1 to the next PPU address

    lda render_state
    and #RENDER_OAM
    beq skip_oam

	; read input, syncing on OAM DMA
	; transfer OAM must happen with controller reads
	lda #0
	sta OAMADDR
    lda OAM_RAM_start+1
    sta OAM_DMA
    lda render_state
    and #($FF - RENDER_OAM)
    sta render_state

skip_oam:
    jsr update_registers

	; update scrolling
	jsr update_scrolling

	; restore mask and ctrl state
	lda s_PPUMASK
	sta PPUMASK
	lda s_PPUCTRL
	sta PPUCTRL

skip_render:
	inc nmis

	pla
	tax
	pla
	tay
	pla
	rti
.endproc

.proc irq
	; handle irq
    rti
.endproc