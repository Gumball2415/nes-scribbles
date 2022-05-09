.include "defines.inc"
.include "global.inc"

.segment "BANK0"

Stars2:
  .byte 16		; number of OAM tile entries
  ; y+offset, tile number, palette & object attribute, x+offset
  ; code from NEXXT
  ; first quadrant
  .byte -48+64,$83,3|16, 16+64
  .byte -24+64,$80,0|16,-32+64
  .byte -16+64,$81,2|16, 32+64
  .byte  16+64,$82,2|16,-16+64
  .byte  32+64,$80,0|16,  0+64
  ; second quadrant
  .byte -32+64,$82,2|16,  0+192
  .byte   8+64,$82,3|16,-64+192
  .byte  24+64,$83,3|16, 32+192
  .byte  56+64,$80,0|16,-53+192
  .byte  56+64,$82,2|16, 16+192
  ; third quadrant
  .byte -48+192,$82,2|16, 32+64
  .byte -32+192,$82,3|16,-32+64
  .byte  24+192,$80,0|16, 48+64
  .byte  32+192,$81,3|16,  0+64
  ; fourth quadrant
  .byte -16+192,$81,3|16,-48+192
  .byte   0+192,$82,2|16,  0+192

Stars1:
  .byte 8
  ; first quadrant
  .byte -64+64,$80,0|16, 48+64
  .byte -40+64,$80,0|16,-16+64
  .byte  24+64,$80,2|16,  8+64
  .byte  56+64,$80,0|16, 48+64
  ; second quadrant
  .byte -24+64,$80,2|16, 48+192
  .byte  24+64,$80,0|16,-24+192
  .byte  40+64,$80,2|16,-40+192
  ; third quadrant
  .byte -40+192,$80,0|16,-40+64
  ; fourth quadrant
  .byte   0+192,$80,0|16,  8+192




; initialize/update a metasprite
; temp_16_0: address of sprite data
; temp_8_0: num_hardware_sprites
; temp_8_1: x_offset
; temp_8_2: y_offset
; OAM_RAM_start: which OAM entry to start, saves as 
.proc load_sprite
  num_hardware_sprites := temp_8_0
  x_offset:= temp_8_1
  y_offset:= temp_8_2
  
  ; first byte of metasprite is number of entries
  LDY #0
  LDA (temp_16_0), y
  STA num_hardware_sprites
  
  INY
  LDX OAM_RAM_start
  : 
    CLC
    LDA (temp_16_0), y		; sprite offset y
    ADC y_offset
    STA $0200, x
    INY
    INX
  
    LDA (temp_16_0), y		; sprite tile
    STA $0200, x
    INY
    INX
  
    LDA (temp_16_0), y		; sprite attribute
    STA $0200, x
    INY
    INX
  
    CLC
    LDA (temp_16_0), y		; sprite offset x
    ADC x_offset
    STA $0200, x
    INY
    INX
    
  DEC num_hardware_sprites
  BNE :-
  RTS
.endproc