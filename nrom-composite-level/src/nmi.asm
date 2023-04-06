.include "defines.inc"
.include "global.inc"

.segment "BANK0"
.proc NMI_HANDLER			; push regs onto stack to preserve them and we can pop them off later
  PHA
  TYA
  PHA
  TXA
  PHA

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