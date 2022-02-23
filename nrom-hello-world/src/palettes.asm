.include "defines.inc"
.include "global.inc"

.segment "BANK1"
palette_1:
	; BG
	.byte $0f,$00,$10,$30
	.byte $00,$19,$29,$39
	.byte $00,$01,$12,$21
	.byte $00,$06,$16,$26
	; FG
	.byte $0f,$11,$21,$31
	.byte $00,$12,$22,$32
	.byte $00,$13,$23,$33
	.byte $00,$14,$24,$34
