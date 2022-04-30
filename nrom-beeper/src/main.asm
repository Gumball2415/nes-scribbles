.include "defines.inc"
.include "global.inc"

.segment "BANK0"
.proc main					; Game logic goes here
  LDA #$00
  TAX
  TAY
  
  ; enable pulse 1
  LDA #%00000011
  STA $4015
  
  ; clear nametable 
  LDA #0		; base nametable to draw on
  STA temp_8_0
  JSR clear_nametable

  ; load palettes
  LDA #0
  STA palette_state
  JSR load_palettes

  JSR satt_n_star_jingle


  ; clear nametable again
  LDA #0		; base nametable to draw on
  STA temp_8_0
  JSR clear_nametable

  LDA #1		; text index
  STA temp_8_3
  LDA #0		; nametable
  STA temp_8_0
  LDA #2		; tile x
  STA temp_8_1
  LDA #25		; tile y
  STA temp_8_2

  JSR textprint

  LDA #6		; text index
  STA temp_8_3
  LDA #0		; nametable
  STA temp_8_0
  LDA #2		; tile x
  STA temp_8_1
  LDA #6		; tile y
  STA temp_8_2

  JSR textprint

mainloop:
  LDA #1
  BIT system_state
  BEQ :+
  JSR change_1
:
  LDA #2
  BIT system_state
  BEQ :+
  JSR change_2
:

  LDA framecounter


  JSR waitframe

  ; controller state is in controller_1
  JSR CONTROL_READ

  ; check for A press
  LDA #KEY_B
  BIT controller_1
  BEQ :+
  LDA #01
  STA system_state
  ; check for B press
: LDA #KEY_A
  BIT controller_1
  BEQ :+
  LDA #02
  STA system_state
:
  JMP mainloop
.endproc

.proc change_1
  LDA #01
  STA palette_state

  LDA #%01000100
  STA $4000
  LDA #%00001000
  STA $4001
  LDA #%10101011
  STA $4002
  LDA #%00001001
  STA $4003
  
  LDA #5		; text index
  STA temp_8_3
  LDA #0		; nametable
  STA temp_8_0
  LDA #2		; tile x
  STA temp_8_1
  LDA #6		; tile y
  STA temp_8_2
  
: ; wait vblank
  BIT PPUSTATUS
  BPL :-

  JSR textprint
  
  LDA #00
  STA system_state
  RTS
.endproc

.proc change_2
  LDA #00
  STA palette_state

  LDA #%00110000
  STA $4000
  LDA #%11111000
  STA $4001
  LDA #0
  STA $4002
  LDA #%0
  STA $4003
  
  LDA #6		; text index
  STA temp_8_3
  LDA #0		; nametable
  STA temp_8_0
  LDA #2		; tile x
  STA temp_8_1
  LDA #6		; tile y
  STA temp_8_2
  
: ; wait vblank
  BIT PPUSTATUS
  BPL :-

  JSR textprint
  
  LDA #00
  STA system_state
  
  RTS
.endproc

.proc satt_n_star_jingle

  LDA #0		; text index
  STA temp_8_3
  LDA #0		; nametable
  STA temp_8_0
  LDA #2		; tile x
  STA temp_8_1
  LDA #12		; tile y
  STA temp_8_2

  JSR textprint

; very crude jingle, all made manually
; notes from FT register view

; A-2 8 V02 
  LDA #%10111000
  STA $4000
  LDA #%00001000
  STA $4001
  LDA #$ED
  STA $4002
  LDA #$09
  STA $4003

  JSR waitframe		; F03
  JSR waitframe
  JSR waitframe
  
; D-3
  LDA #$71
  STA $4002
  LDA #$09
  STA $4003

  JSR waitframe		; F03
  JSR waitframe
  JSR waitframe
  
; A-3
  LDA #$F6
  STA $4002
  LDA #$08
  STA $4003

  JSR waitframe		; F03
  JSR waitframe
  JSR waitframe

; E-3
  LDA #$49
  STA $4002
  LDA #$09
  STA $4003
; A-2 2 V02
  LDA #%10110010
  STA $4004
  LDA #%00001000
  STA $4005
  LDA #$ED
  STA $4006
  LDA #$09
  STA $4007

  JSR waitframe		; F03
  JSR waitframe
  JSR waitframe
  
; D-4
  LDA #$B8
  STA $4002
  LDA #$08
  STA $4003
; D-3
  LDA #$71
  STA $4006
  LDA #$09
  STA $4007

  JSR waitframe		; F03
  JSR waitframe
  JSR waitframe
  
; E-4
  LDA #$A4
  STA $4002
  LDA #$08
  STA $4003
; A-3
  LDA #$F6
  STA $4006
  LDA #$08
  STA $4007

  JSR waitframe		; F03
  JSR waitframe
  JSR waitframe
  
; D-4
  LDA #$B8
  STA $4002
  LDA #$08
  STA $4003
; E-3
  LDA #$49
  STA $4006
  LDA #$09
  STA $4007

  JSR waitframe		; F03
  JSR waitframe
  JSR waitframe
  
; A-4
  LDA #$7A
  STA $4002
  LDA #$08
  STA $4003
; D-4
  LDA #$B8
  STA $4006
  LDA #$08
  STA $4007

  JSR waitframe		; F03
  JSR waitframe
  JSR waitframe
  
; A-3 1
  LDA #%10110001
  STA $4000
  LDA #$F6
  STA $4002
  LDA #$08
  STA $4003
; E-4
  LDA #$A4
  STA $4006
  LDA #$08
  STA $4007

  JSR waitframe		; F03
  JSR waitframe
  JSR waitframe

; E-3
  LDA #$49
  STA $4002
  LDA #$09
  STA $4003
; D-4
  LDA #$B8
  STA $4006
  LDA #$08
  STA $4007

  JSR waitframe		; F03
  JSR waitframe
  JSR waitframe
  
; D-4
  LDA #$B8
  STA $4002
  LDA #$08
  STA $4003
; A-4
  LDA #$7A
  STA $4006
  LDA #$08
  STA $4007

  JSR waitframe		; F03
  JSR waitframe
  JSR waitframe
  
; E-4
  LDA #$A4
  STA $4002
  LDA #$08
  STA $4003
; ---
  LDA #%10110000
  STA $4004
  LDA #0
  STA $4006
  STA $4007

  JSR waitframe		; F03
  JSR waitframe
  JSR waitframe
  
; D-4
  LDA #$B8
  STA $4002
  LDA #$08
  STA $4003

  JSR waitframe		; F03
  JSR waitframe
  JSR waitframe
  
; A-4
  LDA #$7A
  STA $4002
  LDA #$08
  STA $4003

  JSR waitframe		; F03
  JSR waitframe
  JSR waitframe

; ---
  LDA #%10110000
  STA $4000
  LDA #0
  STA $4002
  STA $4003

:
  BIT PPUSTATUS
  BPL :-

  RTS
.endproc

.proc waitframe
  LDA framecounter
:
  CMP framecounter    ; NMI will change framecounter and then it wont be equal anymore
  BEQ :-
  RTS
.endproc
