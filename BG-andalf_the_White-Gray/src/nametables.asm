.include "defines.inc"
.include "global.inc"

.segment "BANK0"
nametable_text:
	.byte $01,$02,$03,$04,$04,$00,$00,$05,$00,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e

  

; loads nametable_text
.proc WRITE_NAMETABLE
  LDA #<nametable_text
  STA temp_16_0
  LDA #>nametable_text
  STA temp_16_0 + 1

  LDA #0
  STA PPUMASK               ; disable rendering
  STA PPUCTRL               ; writes to PPUDATA will increment by 1 to the next PPU address

  LDA PPUSTATUS
  LDA #$21
  STA PPUADDR
  LDA #$E7
  STA PPUADDR

  LDY #0
:
  LDA (temp_16_0), Y
  STA PPUDATA
  INY
  CPY #19    
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
; parameters: temp_8_0 = 0
.proc CLEAR_NAMETABLES
  LDA #0
  STA PPUMASK               ; disable rendering
  STA PPUCTRL               ; writes to PPUDATA will increment by 1 to the next PPU address
  STA temp_8_0

  LDA PPUSTATUS
@loop:
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
  
  INC temp_8_0
  
  LDA temp_8_0
  CMP #$03
  BNE @loop

  LDA #$00                  ; restore scroll position
  STA PPUSCROLL
  STA PPUSCROLL
  LDA #%00011110
  STA PPUMASK               ; enable rendering
  LDA #%10000000            ; enable reaction to /NMI
  STA PPUCTRL

  RTS
.endproc
