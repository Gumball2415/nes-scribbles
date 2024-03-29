.include "defines.inc"
.include "global.inc"

.segment "BANK0"
.proc NMI_HANDLER			; push regs onto stack to preserve them and we can pop them off later
	PHA
	TYA
	PHA
	TXA
	PHA
	
	LDA #0
	STA PPUMASK				; disable rendering

	; transfer OAM data from $02xx
	LDA #0
	STA OAMADDR
	LDA #$02
	STA OAMDMA

	; write palettes
	JSR write_palette

	; display test register values
	LDA #0
	STA temp_8_0
	JSR display_registers

	; update scrolling
	JSR update_scrolling

	; update mask and ctrl state
	LDA s_PPUMASK
	STA PPUMASK
	LDA s_PPUCTRL
	STA PPUCTRL

	PLA
	TAX
	PLA
	TAY
	PLA
	RTI
.endproc