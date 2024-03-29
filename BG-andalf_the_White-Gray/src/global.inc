.ifndef GLOBAL_INC
.define GLOBAL_INC
; init.asm
.global RESET_HANDLER

; control_read.asm
.global CONTROL_READ

; palettes.asm
.global PALETTE_LOAD, PALETTE_TOGGLE, CLEAR_NAMETABLE

; main.asm
.global main

; nmi.asm
.global NMI_HANDLER

; irq.asm
.global IRQ_HANDLER

; palettes.asm
.global palette_choice1, palette_choice2

; nametables.asm
.global WRITE_NAMETABLE, CLEAR_NAMETABLES

.globalzp framecounter
.globalzp system_state
.globalzp controller_1
.globalzp controller_2
.globalzp temp_8_0
.globalzp temp_8_1
.globalzp temp_8_2
.globalzp temp_8_3
.globalzp controller_press_1
.globalzp controller_press_2
.globalzp temp_16_0
.globalzp temp_16_1
.endif
