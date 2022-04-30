.include "defines.inc"
.include "global.inc"

.segment "BANK0"
palette_1:
  ; BG
  .byte $0f,$00,$10,$30
  .byte $00,$19,$29,$39
  .byte $00,$01,$12,$21
  .byte $00,$06,$16,$26
  ; FG
  .byte $0f,$11,$21,$31
  .byte $00,$12,$22,$32
  .byte $00,$13,$23,$33
  .byte $00,$14,$24,$34
palette_2:
  .byte $2d,$00,$10,$30
  .byte $2d,$19,$29,$39
  .byte $2d,$06,$16,$27
  .byte $2d,$06,$16,$26
  
  .byte $2d,$00,$10,$30
  .byte $2d,$19,$29,$39
  .byte $2d,$06,$16,$27
  .byte $2d,$06,$16,$26


palette_tableLo:
  .byte <palette_1
  .byte <palette_2
palette_tableHi:
  .byte >palette_1
  .byte >palette_2


text_nametable:
  .incbin "../gfx/text_nametable.bin"

nametable_tableLo:
  .byte $00
  .byte <text_nametable
nametable_tableHi:
  .byte $00
  .byte >text_nametable


; these subroutines have to do with palettes and nametables
; temp_16_1: address of nametable/palette data
; temp_8_0:	which nametable address to use
; palette_state: index of all palettes
; nametable_state: index of all nametables. 0 means to clear nametable

.proc load_palettes
; loads a palette at the palette index points
  LDY palette_state
  LDA palette_tableLo,y
  STA temp_16_1
  LDA palette_tableHi,y
  STA temp_16_1 + 1

  LDA #0
  STA PPUMASK               ; disable rendering
  STA PPUCTRL               ; writes to PPUDATA will increment by 1 to the next PPU address

  LDA PPUSTATUS
  ; address of palettes, $3F00
  LDA #$3F
  STA PPUADDR
  LDA #$00
  STA PPUADDR

  LDY #$00
:
  LDA (temp_16_1), Y
  STA PPUDATA
  INY
  CPY #$20                  ; #$20 entries per palette
  BNE :-

  LDA #$00                  ; restore scroll position
  STA PPUSCROLL
  STA PPUSCROLL
  LDA #%00011110
  STA PPUMASK               ; enable rendering
  LDA #%10000000            ; enable reaction to /NMI
  STA PPUCTRL

  RTS
.endproc

.proc load_nametable
; loads a complete nametable at where temp_16_1 points
; base nametable is chosen by temp_8_0

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

  LDA #0
  STA PPUMASK               ; disable rendering
  STA PPUCTRL               ; writes to PPUDATA will increment by 1 to the next PPU address

  LDA PPUSTATUS
  ; address of nametable (chosen by temp_8_0)
  LDA temp_8_0
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

  LDA #$00                  ; restore scroll position
  STA PPUSCROLL
  STA PPUSCROLL
  LDA #%00011110
  STA PPUMASK               ; enable rendering
  LDA #%10000000            ; enable reaction to /NMI
  STA PPUCTRL

  RTS
.endproc

.proc clear_nametable
; clears a given nametable chosen by temp_8_0
  LDA #0
  STA PPUMASK               ; disable rendering
  STA PPUCTRL               ; writes to PPUDATA will increment by 1 to the next PPU address

  LDA PPUSTATUS
  LDA temp_8_0
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

  LDA #$00                  ; restore scroll position
  STA PPUSCROLL
  STA PPUSCROLL
  LDA #%00011110
  STA PPUMASK               ; enable rendering
  LDA #%10000000            ; enable reaction to /NMI
  STA PPUCTRL

  RTS
.endproc
