.include "defines.inc"
.include "global.inc"

.segment "BANK0"

.proc CONTROL_READ
  LDA #$01
  STA JOYPAD1
  STA controller_1
  LSR A
  STA JOYPAD1
:
  LDA JOYPAD1
  LSR
  ROL controller_1
  BCC :-

  RTS
.endproc