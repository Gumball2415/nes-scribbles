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
  ; todo: change nametable to slim version on dpad press
  ; LDA controller_1
  ; EOR #KEY_R
  ; AND #%0001
  ; BNE :+
  ; JSR right_direction
; :
  ; LDA controller_1
  ; EOR #KEY_L
  ; AND #%0010
  ; BNE :+
  ; JSR left_direction
; :
  ; LDA controller_1
  ; EOR #KEY_D
  ; AND #%0100
  ; BNE :+
  ; JSR down_direction
; :
  ; LDA controller_1
  ; EOR #KEY_U
  ; AND #%1000
  ; BNE :+
  ; JSR up_direction
; :

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
