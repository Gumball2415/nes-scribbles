.include "defines.inc"
.include "global.inc"

.segment "BANK0"
.proc RESET_HANDLER
  SEI             ; disables interrupts
  CLD             ; disable decimal mode

  LDX #$40        ; disable DMC IRQ
  STX $4017

  LDX #$FF        ; init stack
  TXS
  INX
  STX PPUCTRL     ; disable NMI
  STX PPUMASK     ; disable rendering
  STX $4010       ; disable DPCM IRQ

  ; insert misc init routine here

  ;wait vblank 1
:
  BIT PPUSTATUS
  BPL :-

  ; init RAM with $00
  TXA
CLEARMEM:
  STA $0000, X 
  STA $0100, X
  STA $0300, X
  STA $0400, X 
  STA $0500, X
  STA $0600, X
  STA $0700, X
  ; init OAM RAM with $FF
  LDA #$FF
  STA $0200, X
  LDA #$00
  INX
  BNE CLEARMEM

  ; insert misc init routine here

  ;wait vblank 2
:
  BIT PPUSTATUS
  BPL :-

  LDA #0
  STA OAMADDR
  LDA #02
  STA OAMDMA
  NOP

  ; clear nametables
  LDA #0
  STA temp_8_0		; nametable 1
  JSR clear_nametable
  INC temp_8_0		; nametable 2
  JSR clear_nametable
  INC temp_8_0		; nametable 3
  JSR clear_nametable
  INC temp_8_0		; nametable 4
  JSR clear_nametable

  LDA #%00011110		; enable rendering
  STA PPUMASK
  STA PPUMASK_state
  LDA #%10000000
  STA PPUCTRL
  STA PPUCTRL_state

  CLI                     ; enable interrupts

  JMP main
.endproc
