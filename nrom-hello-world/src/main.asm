.include "defines.inc"
.include "global.inc"

.segment "BANK0"
.proc main					; Game logic goes here
  LDA #$00
  TAX
  TAY

  ; load palettes
  LDA #<palette_1
  STA temp_16_1
  LDA #>palette_1
  STA temp_16_1 + 1
  JSR load_palettes

  ; ; load nametable
  ; LDA #<text_nametable
  ; STA temp_16_1
  ; LDA #>text_nametable
  ; STA temp_16_1 + 1
  ; ; base nametable to draw on
  ; LDA #%00
  ; STA temp_8_0

  ; JSR load_nametable

  LDA #$44
  STA framecounter  
  LDA #$FF
  ;wait for 1 sec
:
  BIT framecounter
  BPL :-
  
  ; how to wait after vblank?
  
  ; location of string
  LDA #<eternal_gratitude
  STA temp_16_1
  LDA #>eternal_gratitude
  STA temp_16_1 + 1
  ; base nametable to draw on
  LDA #%00
  STA temp_8_0
  ; tile coordinate in nametable to write
  LDA #2
  STA temp_8_1
  LDA #3
  STA temp_8_2

  JSR textprint
  
mainloop:
  LDA framecounter
  waitVBlank:				; NMI will change framecounter and then it wont be equal anymore
  CMP framecounter    
  BEQ waitVBlank
  JMP mainloop
.endproc
