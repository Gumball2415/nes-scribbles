.include "defines.inc"
.include "global.inc"

.segment "BANK0"
.proc main
@mainloop:
	; prepare A and Y regs
	LDA #$7F
	LDY #$00
	STA $4011
	STY $4011

	; wait approx. 1 second
	LDX #60
	JSR wait_x_frames
	JMP @mainloop
.endproc

;;
; wait X amount of frames
; note: NMI must be enabled
.proc wait_x_frames
@wait_for_frame:
	lda framecounter
@wait_for_nmi:
	cmp framecounter
	beq @wait_for_nmi
	dex
	bne @wait_for_frame
	rts
.endproc