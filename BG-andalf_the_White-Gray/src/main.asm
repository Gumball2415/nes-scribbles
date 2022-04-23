.include "defines.inc"
.include "global.inc"

.segment "BANK0"
.proc main					; Game logic goes here
  LDA #$00
  TAX
  TAY

  ; write the text
  JSR WRITE_NAMETABLE
  
mainloop:
  LDA framecounter
waitVBlank:				; NMI will change framecounter and then it wont be equal anymore
  CMP framecounter
  BEQ waitVBlank
  JMP mainloop
.endproc
