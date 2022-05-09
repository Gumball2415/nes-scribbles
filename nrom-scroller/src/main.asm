.include "defines.inc"
.include "global.inc"

.segment "BANK0"
.proc main					; Game logic goes here
  LDA #$00
  TAX
  TAY

  ; Satellite & Stardust Intro
  ; enable pulse 1 and 2
  LDA #%00000011
  STA $4015
  ; load nametable 
  LDA #0		; base nametable to draw on
  STA temp_8_0
  LDA #1
  STA nametable_state
  JSR load_nametable
  ; load palettes
  LDA #1
  STA palette_state
  JSR load_palettes
  ; play jingle
  JSR satt_n_star_jingle
  ; change palettes
  LDA #0
  STA palette_state
  JSR load_palettes


  ; load nametable 
  LDA #0		; base nametable to draw on
  STA temp_8_0
  LDA #2		; nametable index: stars!
  STA nametable_state
  JSR load_nametable
  ; load other part of nametable
  LDA #1		; base nametable to draw on
  STA temp_8_0
  LDA #3		; nametable index: stars part 2
  STA nametable_state
  JSR load_nametable


  JSR waitframe

@mainloop:
  LDA system_state
  CMP #0
  BNE :+
  JSR right_direction
:
  CMP #1
  BNE :+
  JSR left_direction
:
  CMP #2
  BNE :+
  JSR up_direction
:
  CMP #3
  BNE :+
  JSR down_direction
:

  ; load 2nd layer stars metasprite
  LDA #<Stars2
  STA temp_16_0
  LDA #>Stars2
  STA temp_16_0 + 1
  LDA star_layer_2_x
  STA temp_8_1
  LDA star_layer_2_y
  STA temp_8_2
  JSR load_sprite

  ; load 1st layer stars metasprite
  LDA #<Stars1
  STA temp_16_0
  LDA #>Stars1
  STA temp_16_0 + 1
  LDA star_layer_1_x
  STA temp_8_1
  LDA star_layer_1_y
  STA temp_8_2
  JSR load_sprite
  
  JSR update_scrolling
  JMP @mainloop
.endproc

.proc right_direction
  ; inc x
  CLC
  LDA ppu_scroll_x
  ADC #1
  STA ppu_scroll_x
  BCC :+
    ; if overflow, change nametable base
    LDA PPUCTRL_state
    EOR #%00000001
    STA PPUCTRL_state
  :
  JSR sprites_move_right
  JSR waitframe
  RTS
.endproc

.proc left_direction
  ; dec x
  SEC
  LDA ppu_scroll_x
  SBC #1
  STA ppu_scroll_x
  BCS :+
    ; if underflow, change nametable base
    LDA PPUCTRL_state
    EOR #%00000001
    STA PPUCTRL_state
  :
  JSR sprites_move_left
  JSR waitframe
  RTS
.endproc

.proc up_direction
  ; dec y
  SEC
  LDA ppu_scroll_y
  SBC #1
  STA ppu_scroll_y
  BCS :+
    ; if underflow, change nametable base
    LDA PPUCTRL_state
    EOR #%00000010
    STA PPUCTRL_state
	LDA #$EF
	STA ppu_scroll_y
  :
  JSR sprites_move_up
  JSR waitframe
  RTS
.endproc

.proc down_direction
  ; inc y
  CLC
  LDA ppu_scroll_y
  ADC #1
  STA ppu_scroll_y
  CMP #$EF
  BCC :+
    ; if overflow, change nametable base
    LDA PPUCTRL_state
    EOR #%00000010
    STA PPUCTRL_state
	LDA #$0
	STA ppu_scroll_y
  :
  JSR sprites_move_down
  JSR waitframe
  RTS
.endproc

.proc sprites_move_right
  SEC
  LDA star_layer_2_x
  SBC #2
  STA star_layer_2_x
  SEC
  LDA star_layer_1_x
  SBC #3
  STA star_layer_1_x
  RTS
.endproc

.proc sprites_move_left
  CLC
  LDA star_layer_2_x
  ADC #2
  STA star_layer_2_x
  CLC
  LDA star_layer_1_x
  ADC #3
  STA star_layer_1_x
  RTS
.endproc

.proc sprites_move_up
  CLC
  LDA star_layer_2_y
  ADC #2
  STA star_layer_2_y
  CLC
  LDA star_layer_1_y
  ADC #3
  STA star_layer_1_y
  RTS
.endproc

.proc sprites_move_down
  SEC
  LDA star_layer_2_y
  SBC #2
  STA star_layer_2_y
  SEC
  LDA star_layer_1_y
  SBC #3
  STA star_layer_1_y
  RTS
.endproc

.proc satt_n_star_jingle

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
