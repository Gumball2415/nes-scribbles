.include "defines.inc"
.include "global.inc"

.segment "BANK0"
; these subroutines have to do with palettes and nametables
; temp_16_1: address of nametable/palette data
; temp_8_0: which nametable address to use

; loads a palette at where temp_16_1 points
.proc load_palettes
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

; loads a complete nametable at where temp_16_1 points
.proc load_nametable
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

; fills nametable with 0
.proc clear_nametable
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
