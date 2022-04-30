.ifndef GLOBAL_INC
.define GLOBAL_INC
; init.asm
.global RESET_HANDLER

; nmi.asm
.global NMI_HANDLER

; irq.asm
.global IRQ_HANDLER

; control_read.asm
.global CONTROL_READ

; graphics.asm
.global load_palettes, load_nametable, clear_nametable

; strings.asm
.global textprint

; main.asm
.global main

.globalzp framecounter
.globalzp system_state
.globalzp controller_1
.globalzp controller_2
.globalzp temp_8_0
.globalzp temp_8_1
.globalzp temp_8_2
.globalzp temp_8_3
.globalzp temp_16_0
.globalzp temp_16_1
.globalzp temp_16_2
.globalzp temp_16_3

.globalzp palette_state
.globalzp nametable_state

.endif
