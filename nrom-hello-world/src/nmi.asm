.include "defines.inc"
.include "global.inc"

.segment "BANK0"
.proc NMI_HANDLER			; push regs onto stack to preserve them and we can pop them off later
  PHA
  TYA
  PHA
  TXA
  PHA

  ; controller read
  ; audio processing
  INC framecounter
  ; redundant controller read?

  PLA
  TAX
  PLA
  TAY
  PLA
  RTI
.endproc