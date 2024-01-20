.ifndef GLOBAL_INC
.define GLOBAL_INC
; graphics.asm
.global load_palette, write_palette, load_nametable, clear_nametable, update_registers, update_scrolling

; main.asm
.global main, write_epsm_registers

.globalzp nmis
.globalzp system_state
.globalzp render_state

.globalzp s_epsm_4016_out0
.globalzp s_epsm_4016_out1
.globalzp s_epsm_data
.globalzp s_epsm_addr

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

.globalzp s_PPUCTRL
.globalzp s_PPUMASK
.globalzp OAM_RAM_start

.globalzp palette_state
.globalzp palette_table
.globalzp nametable_state
.globalzp nametable_loc

.endif
