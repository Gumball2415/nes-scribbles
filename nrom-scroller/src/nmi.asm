.include "defines.inc"
.include "global.inc"

.segment "BANK0"
.proc NMI_HANDLER			; push regs onto stack to preserve them and we can pop them off later
  PHA
  TYA
  PHA
  TXA
  PHA

  ; transfer OAM data from $02xx
  LDA #0
  STA OAMADDR
  LDA #$02
  STA OAMDMA
  NOP

  ; controller state is in controller_1
  JSR CONTROL_READ
  ; check for R press
  LDA #KEY_R
  BIT controller_1
  BEQ :+
  LDA #00
  STA system_state
  ; check for L press
: LDA #KEY_L
  BIT controller_1
  BEQ :+
  LDA #01
  STA system_state
  ; check for U press
: LDA #KEY_U
  BIT controller_1
  BEQ :+
  LDA #02
  STA system_state
  ; check for D press
: LDA #KEY_D
  BIT controller_1
  BEQ :+
  LDA #03
  STA system_state
:

  INC framecounter

  ; update mask and ctrl state
  LDA PPUMASK_state
  STA PPUMASK
  LDA PPUCTRL_state
  STA PPUCTRL

  PLA
  TAX
  PLA
  TAY
  PLA
  RTI
.endproc