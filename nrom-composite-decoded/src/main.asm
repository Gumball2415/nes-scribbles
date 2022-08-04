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

@mainloop:
  LDA system_state
  CMP #0
  BNE :+
  LDA #0
  STA palette_state
:
  CMP #1
  BNE :+
  LDA #1
  STA palette_state
:
  CMP #2
  BNE :+
  LDA #2
  STA palette_state
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
