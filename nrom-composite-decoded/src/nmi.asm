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
  ; check for B press
  LDA #KEY_B
  BIT controller_1
  BEQ :+
  LDA #00
  STA system_state
  ; check for A press
: LDA #KEY_A
  BIT controller_1
  BEQ :+
  LDA #01
  STA system_state
: LDA #KEY_STA
  BIT controller_1
  BEQ :+
  LDA #02
  STA system_state
:
  INC framecounter
  
  ; update palette
  JSR load_palettes

  ; update scroll registers
  JSR update_scrolling
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