.include "defines.inc"
.include "global.inc"
.include "nes.inc"

.segment "ZEROPAGE"
	; $0010-$001F
	; $0020-$002F
	palette_table:			.res 32
	; PPU shadow registers
	s_PPUCTRL:				.res 1
	s_PPUMASK:				.res 1
	ppu_scroll_x:			.res 1
	ppu_scroll_y:			.res 1
	palette_state:			.res 1
	nametable_state:		.res 1
	nametable_loc:		    .res 1
	OAM_RAM_start:			.res 2
    

.segment "BANK0"
bg_00:
	.incbin "../gfx/bg_00.pal"

palette_tableLo:
	.byte <bg_00
palette_tableHi:
	.byte >bg_00

.include "../gfx/text_nametable.asm"

nametable_tableLo:
	.byte $00
	.byte <text_nametable
nametable_tableHi:
	.byte $00
	.byte >text_nametable

; these subroutines have to do with palettes and nametables
; temp_16_1:				address of nametable/palette data
; temp_8_0:					which nametable to draw/which palette set to write to
; palette_state:			index of all palettes
; nametable_state:			index of all nametables. 0 means to clear nametable

.proc load_palette
; loads a palette set to the shadow palette registers
; base palette set is chosen by temp_8_0; 0=BG, 1=FG
	LDY palette_state
	LDA palette_tableLo,y
	STA temp_16_1
	LDA palette_tableHi,y
	STA temp_16_1 + 1

	LDY #$00
	LDA temp_8_0
	ASL A
	ASL A
	ASL A
	ASL A
	TAX
	:
	LDA (temp_16_1), Y
	STA palette_table, X
	INY
	INX
	CPY #$10
	BNE :-

	RTS
.endproc

.proc write_palette
; copies the palette table to PPU
; rendering must be disabled

	LDA PPUSTATUS
	; address of palettes, $3F00
	LDA #$3F
	STA PPUADDR
	LDA #$00
	STA PPUADDR

	LDY #$00
	:
	LDA palette_table, Y
	STA PPUDATA
	INY
	CPY #$20					; #$20 entries per palette
	BNE :-

	RTS
.endproc

.proc load_nametable
; loads a single-screen nametable at where temp_16_1 points
; base nametable is chosen by nametable_loc
; rendering must be disabled

	LDA nametable_state
	CMP $00
	BNE :+
	JSR clear_nametable
	RTS
:
	LDY nametable_state
	LDA nametable_tableLo,y
	STA temp_16_1
	LDA nametable_tableHi,y
	STA temp_16_1 + 1

	LDA PPUSTATUS
	; address of base nametable (chosen by nametable_loc)
	LDA nametable_loc
	ASL A
	ASL A
	ADC #$20
	STA PPUADDR
	LDA #$00
	STA PPUADDR

	LDY #0
	LDX #4
:
	LDA (temp_16_1), Y 
	STA PPUDATA
	INY
	BNE :-
	INC temp_16_1 + 1
	DEX
	BNE :-

	RTS
.endproc

.proc clear_nametable
; clears a given nametable chosen by nametable_loc
; rendering must be disabled

	LDA PPUSTATUS
	LDA nametable_loc
	ASL A
	ASL A
	ADC #$20
	STA PPUADDR
	LDA #$00
	STA PPUADDR

	LDA #0
	TAY
	LDX #4
:
	STA PPUDATA
	INY
	BNE :-
	DEX
	BNE :-

	RTS
.endproc

; bugs the PPU to update the scroll position
.proc update_scrolling
	BIT PPUSTATUS
	LDA ppu_scroll_x
	STA PPUSCROLL
	LDA ppu_scroll_y
	STA PPUSCROLL
	RTS
.endproc

; writes to text. nametable chosen by nametable_loc
; rendering must be disabled
.proc update_registers
    jsr display_4016
    jsr display_ymf288_data
    jsr display_ymf288_addr
    rts
.endproc

.importzp cursor_x, cursor_y
.proc display_cursor
tile_cursor = $1F

    ldy #4
    ; y
    lda cursor_y
    cmp #2
    bcc skip_skip_gap
    clc
    adc #1
skip_skip_gap:
    asl
    asl
    asl
    adc #$27
    sta (OAM_RAM_start),y
    iny
    lda #tile_cursor
    sta (OAM_RAM_start),y
    iny
    lda #OAM_2_PAL_0|OAM_2_PRIORITY_BACK
    sta (OAM_RAM_start),y
    iny
    ; x
    lda cursor_x
    clc
    asl
    asl
    asl
    adc #$A0
    sta (OAM_RAM_start),y

	rts

.endproc
.export display_cursor


tile_number0 = $30
tile_number1 = $31

.proc display_ymf288_addr
    ; ymf288 addr: 2 bits
    bit PPUSTATUS
    lda nametable_loc
    asl a
    asl a
    ; offset 0174
    adc #$21
    sta PPUADDR
    lda #$34
	sta PPUADDR

    lda #%00000010
    sta temp_8_0

bit_loop:
    lda temp_8_0
    and s_epsm_addr
    beq write_0
write_1:
    lda #tile_number1
    sta PPUDATA
    lsr temp_8_0
    bne bit_loop
    jmp done

write_0:
    lda #tile_number0
    sta PPUDATA
    lsr temp_8_0
    bne bit_loop
    jmp done
done:
    rts
.endproc

.proc display_ymf288_data
    ; ymf288 data: 8 bits
    bit PPUSTATUS
    lda nametable_loc
    asl a
    asl a
    ; offset 0154
    adc #$21
    sta PPUADDR
    lda #$14
	sta PPUADDR

    lda #%10000000
    sta temp_8_0

bit_loop:
    lda temp_8_0
    and s_epsm_data
    beq write_0
write_1:
    lda #tile_number1
    sta PPUDATA
    lsr temp_8_0
    bne bit_loop
    jmp done

write_0:
    lda #tile_number0
    sta PPUDATA
    lsr temp_8_0
    bne bit_loop
    jmp done
done:

    rts
.endproc

.proc display_4016
    ; out1=1: 8 bits
    bit PPUSTATUS
    lda nametable_loc
    asl a
    asl a
    ; offset 00B4
    adc #$20
    sta PPUADDR
    pha ; save for later
    lda #$B4
	sta PPUADDR

    lda #%10000000
    sta temp_8_0

.scope
bit_loop:
    lda temp_8_0
    and s_epsm_4016_out1
    beq write_0
write_1:
    lda #tile_number1
    sta PPUDATA
    lsr temp_8_0
    bne bit_loop
    jmp done

write_0:
    lda #tile_number0
    sta PPUDATA
    lsr temp_8_0
    bne bit_loop
    jmp done
done:
.endscope

    ; out1=0: 8 bits
    bit PPUSTATUS
    pla
    sta PPUADDR
    lda #$D4
	sta PPUADDR

    lda #%10000000
    sta temp_8_0

.scope
bit_loop:
    lda temp_8_0
    and s_epsm_4016_out0
    beq write_0
write_1:
    lda #tile_number1
    sta PPUDATA
    lsr temp_8_0
    bne bit_loop
    jmp done

write_0:
    lda #tile_number0
    sta PPUDATA
    lsr temp_8_0
    bne bit_loop
    jmp done
done:
.endscope
    rts
.endproc