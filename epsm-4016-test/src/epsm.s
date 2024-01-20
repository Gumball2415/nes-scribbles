; EPSM $4016 write library
; Copyright (C) Fiskbit 2022
; License? Your choice of CC0, CC0 with 4a modified to strike the words "or patent", or MIT-0.

.export WriteToEpsm4016, InitEpsmSafeWriteRam

; EPSM RAM: $00-08
.segment "ZEROPAGE"
EPSM_4016W_RAM_BUFFER: .res 9

.segment "BANK0"

dEpsmSafeWriteOp1:
  .byte $01,$05,$0A,$0D,$10,$15,$18,$1D,$21,$25,$2A,$2D,$30,$35,$38,$3D
  .byte $41,$45,$4A,$4D,$50,$55,$59,$5D,$61,$65,$6A,$6D,$70,$75,$79,$7D
  .byte $80,$86,$8A,$8E,$90,$95,$98,$9D,$A2,$A5,$A9,$AD,$B0,$B5,$18,$BD
  .byte $C0,$C5,$C9,$CD,$D0,$D5,$D9,$DD,$E0,$E4,$EA,$EC,$F0,$F5,$F9,$FD
dEpsmSafeWriteOp2:
  .byte $00,$01,$60,$01,$00,$01,$60,$01,$00,$01,$60,$01,$00,$01,$60,$01
  .byte $00,$01,$60,$01,$00,$01,$00,$01,$00,$01,$60,$01,$00,$01,$00,$01
  .byte $00,$01,$60,$01,$00,$00,$60,$00,$00,$01,$00,$01,$00,$01,$60,$01
  .byte $00,$01,$00,$01,$00,$01,$00,$01,$00,$01,$60,$01,$00,$01,$00,$01
dEpsmSafeWriteOp3:
  .byte $60,$60,$60,$00,$60,$60,$60,$00,$60,$60,$60,$00,$60,$60,$60,$00
  .byte $60,$60,$60,$00,$60,$60,$00,$00,$60,$60,$60,$00,$60,$60,$00,$00
  .byte $60,$60,$60,$00,$60,$60,$60,$00,$60,$60,$60,$00,$60,$60,$60,$00
  .byte $60,$60,$60,$00,$60,$60,$00,$00,$60,$60,$60,$00,$60,$60,$00,$00

InitEpsmSafeWriteRam:
  LDY #$03
 :
  LDA dEpsmSafeWriteData,Y
  STA EPSM_4016W_RAM_BUFFER+$01,Y
  DEY
  BNE :-

  LDA #$60
  STA z:EPSM_4016W_RAM_BUFFER+$08
  RTS

dEpsmSafeWriteData:
  .byte $00,$8D,$16,$40


WriteToEpsm4016:
  PHA

  LSR
  LSR
  TAX

  LDA dEpsmSafeWriteOp1,X
  STA z:EPSM_4016W_RAM_BUFFER+$05
  LDA dEpsmSafeWriteOp2,X
  STA z:EPSM_4016W_RAM_BUFFER+$06
  LDA dEpsmSafeWriteOp3,X
  STA z:EPSM_4016W_RAM_BUFFER+$07

  PLA
  LDX #$00
  JMP EPSM_4016W_RAM_BUFFER+$02
