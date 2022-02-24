.ifndef GLOBAL_INC
.define GLOBAL_INC
; init.asm
.global RESET_HANDLER

; nmi.asm
.global NMI_HANDLER

; irq.asm
.global IRQ_HANDLER

; imginit.asm
.global load_palettes, load_nametable, clear_nametable

; text_engine.asm
.global textprint

; main.asm
.global main

.globalzp framecounter
.globalzp gamestate
.globalzp dummy1
.globalzp dummy2
.globalzp temp_8_0
.globalzp temp_8_1
.globalzp temp_8_2
.globalzp temp_8_3
.globalzp temp_16_0
.globalzp temp_16_1
.globalzp temp_16_2
.globalzp temp_16_3

; strings.asm
.global string_test, copyright_info, credits, testline, lorem_ipsum

; palettes.asm
.global palette_1

; nametables.asm
.global text_nametable
.endif
