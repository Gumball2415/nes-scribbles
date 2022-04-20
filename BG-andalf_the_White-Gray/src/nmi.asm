.include "defines.inc"
.include "global.inc"

.segment "BANK0"

.proc NMI_HANDLER 
; push regs onto stack to preserve them and we can pop them off later
  PHA
  TYA
  PHA
  TXA
  PHA

  ; controller read controller state is in A
  JSR CONTROL_READ

  ; check for A press
  LDA #KEY_A
  BIT controller_1
  BEQ :+
  LDA #0
  STA system_state
  JSR PALETTE_TOGGLE
  ; check for B press
: LDA #KEY_B
  BIT controller_1
  BEQ :+
  LDA #1
  STA system_state
  JSR PALETTE_TOGGLE
:

  INC framecounter
  
  ; audio processing?
  
  ; redundant controller read?

  PLA
  TAX
  PLA
  TAY
  PLA
  RTI
.endproc
