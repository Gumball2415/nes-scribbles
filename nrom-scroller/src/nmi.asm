.include "defines.inc"
.include "nes.inc"

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