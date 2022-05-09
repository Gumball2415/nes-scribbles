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
.global load_palettes, load_nametable, clear_nametable, update_scrolling

; sprites.asm
.global load_sprite, Stars2, Stars1

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

.globalzp PPUCTRL_state
.globalzp PPUMASK_state

.globalzp ppu_scroll_x
.globalzp ppu_scroll_y

.globalzp palette_state
.globalzp nametable_state

.globalzp star_layer_1_x
.globalzp star_layer_1_y
.globalzp star_layer_2_x
.globalzp star_layer_2_y
.globalzp OAM_RAM_start

.endif
