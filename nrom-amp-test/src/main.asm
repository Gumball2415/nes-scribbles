.include "defines.inc"
.include "global.inc"

.segment "BANK0"
.proc main
	LDA #$00
	TAX
	TAY

	; load palette
	LDA #0
	STA palette_state
	LDA #0
	STA temp_8_0
	JSR load_palette

	; load nametable
	LDA #0
	STA temp_8_0
	LDA #1		; index 1: screen of text and art
	STA nametable_state
	JSR load_nametable

	; enable channel outputs
	LDA #$1F
	STA $4015

	; only render screen once
	JSR delay_frame
	; disable NMI, prepare A and X
	LDA #$00
	STA PPUCTRL
	LDX #$7F

; play a square wave with maximum amplitude at ~440Hz
; each half-wavelength will take 2034 cycles
@mainloop:
	STA $4011
	JSR delay_1536
	JSR delay_384
	JSR delay_96
	JSR delay_12
	STA $00					; dummy, +3 cycles
	JMP @mainloop2			; dummy, +3 cycles
@mainloop2:
	STX $4011
	JSR delay_1536
	JSR delay_384
	JSR delay_96
	JSR delay_12
	STA $00					; dummy, +3 cycles
	JMP @mainloop			; +3 cycles
.endproc

; taken from bbbradsmith/nes-audio-tests
delay_frame:
	jsr delay_24576
	jsr delay_3072
	jsr delay_1536
	jsr delay_384
	jsr delay_192
	;nop
	;nop
	;nop
	nop
	rts
; 20 + 192 + 384 + 1536 + 3072 + 24576 = 29780 (approximately NTSC frame)
; -6 cycles to make it closer in the swap_delay loop

delay_24576: jsr delay_12288
delay_12288: jsr delay_6144
delay_6144:  jsr delay_3072
delay_3072:  jsr delay_1536
delay_1536:  jsr delay_768
delay_768:   jsr delay_384
delay_384:   jsr delay_192
delay_192:   jsr delay_96
delay_96:    jsr delay_48
delay_48:    jsr delay_24
delay_24:    jsr delay_12
delay_12:    rts
