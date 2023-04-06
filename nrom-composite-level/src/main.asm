.include "defines.inc"
.include "global.inc"

.segment "BANK0"
.proc main					; Game logic goes here
  LDA #$00
  TAX
  TAY

  ; load nametable 
  LDA #0		; base nametable to draw on
  STA temp_8_0
  LDA #1
  STA nametable_state
  JSR load_nametable
  ; load palette
  LDA #0
  STA palette_state
  JSR load_palettes

  JSR waitframe

@mainloop:
  ; clear emphasis bits
  LDA PPUMASK_state
  AND #%00011111
  STA PPUMASK_state

  ; red
  LDA controller_1
  AND #KEY_STA
  BEQ :+
  LDA PPUMASK_state
  ORA #EMP_R
  STA PPUMASK_state
:

  ; green
  LDA controller_1
  AND #KEY_B
  BEQ :+
  LDA PPUMASK_state
  ORA #EMP_G
  STA PPUMASK_state
:

  ; blue
  LDA controller_1
  AND #KEY_A
  BEQ :+
  LDA PPUMASK_state
  ORA #EMP_B
  STA PPUMASK_state
:

  ; set everything
  LDA controller_1
  AND #KEY_SEL
  BEQ :+
  LDA PPUMASK_state
  ORA #EMP_R | EMP_G | EMP_B
  STA PPUMASK_state
:

  JSR waitframe
  JMP @mainloop
.endproc

.proc waitframe
  LDA framecounter
:
  CMP framecounter    ; NMI will change framecounter and then it wont be equal anymore
  BEQ :-
  RTS
.endproc
