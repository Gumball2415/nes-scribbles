.include "defines.inc"
.include "global.inc"

.segment "BANK0"
; end of string is important!!!
; else, textprinter loops forever
; strings should be multiples of 28 characters (excluding line feed)!
;        ____________________________<-- up till here!!
string_test:
  .byte "    SATELLITE & STARDUST"
  .byte char_EOS
copyright_info:
  .byte "v.0.0.3", char_LF
  .byte "(C) SATELLITE & STARDUST ", char_SNS_LOGO, char_EOS
credits:
  .byte "Initial Template:", char_LF
  .byte "  yoeynsf", char_LF, char_LF
  .byte "Programming:", char_LF
  .byte "  Persune", char_LF, char_LF
  .byte "Programming help:", char_LF
  .byte "  yoeynsf, Kasumi, studsX,  "
  .byte "Fiskbit, Pino, zeta0134,    "
  .byte "jroweboy, & many, many more "
  .byte "others...:P", char_LF, char_LF
  .byte "Lots of thanks for you who  "
  .byte "helped me through each tiny "
  .byte "step in this, I am eternally"
  .byte "grateful!!"
  .byte char_EOS
eternal_gratitude:
  .byte "Jekuthiel, yoeynsf, Fiskbit,"
  .byte "lidnariq, Kasumi, Pinobatch,"
  .byte "studsX, Lockster, plgDavid, "
  .byte "Grievre, Iyatemu, BlueMario,"
  .byte "jroweboy, zeta0134, and also"
  .byte "the entire NESDev community."
  .byte char_LF, char_LF
  .byte "I am very grateful for all  "
  .byte "your help. I hope to return "
  .byte "the favor one day, when I am"
  .byte "much more able than I am now"
  .byte char_EOS
testline:
  .byte "Hello, NROM!"
  .byte char_EOS
beep:
  .byte "BEEP BEEP!"
  .byte char_EOS
unbeep:
  .byte "NO BEEP!!!"
  .byte char_EOS
error:
  .byte "ERR:NO TXT"
  .byte char_EOS
; string index table
string_tableLo:
  .byte <string_test
  .byte <copyright_info
  .byte <credits
  .byte <eternal_gratitude
  .byte <testline
  .byte <beep
  .byte <unbeep
  .byte <error
string_tableHi:
  .byte >string_test
  .byte >copyright_info
  .byte >credits
  .byte >eternal_gratitude
  .byte >testline
  .byte >beep
  .byte >unbeep
  .byte >error




; this is just a basic text printer
; it will print from a string and stop at the EOS char.
; it will also handle LF line breaks
; and also text wrapping
; TODO:
;   - implement less intensive method to print text
;   - implement multipage texts (pressing trigger button to continue)

; temp_16_0 : another temp variable (big endian)
; temp_16_1 : string location
; temp_16_2 : temp nametable offset (big endian)
; temp_8_0 : nametable a/b/c/d
; temp_8_1 : nametable X coordinate
; temp_8_2 : nametable Y coordinate
; temp_8_3 : string index

; safe zone boundaries:
; 2,3 - 29,26
; offset $0062 - $035D, at intervals of 28 tiles, and 4 tiles in between
; x = +-1 offset
; y = +-32 offset
NAM_X_MIN = 2
NAM_X_MAX = 29
NAM_Y_MIN = 3
NAM_Y_MAX = 26


.global string_test
.global copyright_info
.global credits
.global testline
.global lorem_ipsum


.proc textprint

  LDY temp_8_3
  LDA string_tableLo,y
  STA temp_16_1
  LDA string_tableHi,y
  STA temp_16_1 + 1

  LDA #0
  STA PPUMASK               ; disable rendering
  STA PPUCTRL               ; writes to PPUDATA will increment by 1 to the next PPU address
  JSR tilecoord_2_namoffset ; first execution; the tile coordinates have already been set

  LDY #0
@printloop:
  LDA (temp_16_1), Y
  INY
  ; handle Y overflow
  BNE :+
  INC temp_16_1 + 1
:
  CMP #char_LF
  BNE @line_feed_loop_end

@line_feed_loop:
  ; handle line feed stuff
  JSR line_feed
  BNE :+
:
  LDA (temp_16_1), Y ; line_feed clobbers A, load again
  INY ; skip over LF char
  BNE :+
  INC temp_16_1 + 1 ; handle Y overflow
:
  ; handle succesive line feeds
  CMP #char_LF
  BEQ @line_feed_loop

@line_feed_loop_end:
  LDX temp_8_1
  CPX #NAM_X_MAX + 1
  BNE :+
  DEY ; for some reason, it prints the succeeding char instead, DEY to compensate
  JMP @line_feed_loop
:

  LDX temp_8_2
  CPX #NAM_Y_MAX + 1
  BEQ @endprintloop ; if exceeds one full screen, end loop

  ; finally write char to nametable and increment X coordinate
  STA PPUDATA
  INC temp_8_1
  CMP #char_EOS ; handle end of string
  BEQ @endprintloop
  JMP @printloop

@endprintloop:
  LDA #$00                  ; restore scroll position
  STA PPUSCROLL
  STA PPUSCROLL
  LDA #%00011110
  STA PPUMASK               ; enable rendering
  LDA #%10000000            ; enable reaction to /NMI
  STA PPUCTRL

  RTS
.endproc

.proc line_feed
  ; reset X coordinate
  LDA #NAM_X_MIN
  STA temp_8_1
  ; increment Y coordinate
  INC temp_8_2
  JSR tilecoord_2_namoffset
  RTS
.endproc

.proc tilecoord_2_namoffset
  ; translate tile coordinates to nametable offset
  ; assumes the coordinates are already set in place before being executed
  CLC
  LDA temp_8_0
  ASL A
  ASL A
  ADC #$20
  STA temp_16_2
  LDA #$00
  STA temp_16_2 + 1
  
  ; add X offset
  CLC
  LDA temp_16_2 + 1
  ADC temp_8_1
  STA temp_16_2 + 1
  ; compensate for overflow
  LDA temp_16_2
  ADC #$00
  STA temp_16_2
  ; add Y offset
  CLC
  LDA #0
  STA temp_16_0
  STA temp_16_0 + 1
  
  ; first implicitly multiply by 256
  ; then divide by 8 (thanks pino!)
  LDA temp_8_2
  LSR A
  STA temp_16_0
  LDA #0
  ROR A
  LSR temp_16_0
  ROR A
  LSR temp_16_0
  ROR A
  STA temp_16_0 + 1 ; store resulting low byte from A
  
  ; add offset to base nametable address
  CLC
  LDA temp_16_0 + 1
  ADC temp_16_2 + 1
  STA temp_16_2 + 1
  LDA temp_16_0
  ADC temp_16_2
  STA temp_16_2
  ; load nametable offset to address
  LDA PPUSTATUS
  LDA temp_16_2
  STA PPUADDR
  LDA temp_16_2 + 1
  STA PPUADDR

  RTS
.endproc
