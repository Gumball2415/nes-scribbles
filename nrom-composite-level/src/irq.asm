.include "defines.inc"
.include "global.inc"

.segment "BANK0"
.proc IRQ_HANDLER
  RTI
  PHA
  TYA
  PHA
  TXA
  PHA

  ; handle irq

  PLA
  TAX
  PLA
  TAY
  PLA
.endproc