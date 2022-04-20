.include "defines.inc"
.include "global.inc"

.segment "BANK0"

palette_choice1:
  ; gandalf the gray
  .res 32, $2D
palette_choice2:
  ; gandalf the white
  .res 32, $30

; palette pointer selection
; thanks Kasumi!
palette_tableLo:
  .byte <palette_choice1
  .byte <palette_choice2
palette_tableHi:
  .byte >palette_choice1
  .byte >palette_choice2

.proc PALETTE_TOGGLE
  ; wait for vblank
:
  BIT PPUSTATUS
  BPL :-
  
  LDY system_state
  LDA palette_tableLo,y
  STA temp_16_0
  LDA palette_tableHi,y
  STA temp_16_0 + 1

  JSR PALETTE_LOAD
  
  RTS
.endproc

.proc PALETTE_LOAD
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
  LDA (temp_16_0), Y
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

; fills nametable with 0
.proc CLEAR_NAMETABLE
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