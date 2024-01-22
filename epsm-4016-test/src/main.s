.include "defines.inc"
.include "global.inc"
.include "nes.inc"

.segment "ZEROPAGE"
	nmis:               .res 1
	system_state:       .res 1
	render_state:       .res 1
    cur_keys:           .res 2
    new_keys:           .res 2
    das_keys:           .res 2
    das_timer:          .res 2
    cursor_x:           .res 1
    cursor_y:           .res 1

    s_epsm_4016_out0:   .res 1
    s_epsm_4016_out1:   .res 1
    s_epsm_data:        .res 1
    s_epsm_addr:        .res 1
.exportzp cur_keys, new_keys, das_keys, das_timer, cursor_x, cursor_y

.segment "BANK0"

.import read_pads, autorepeat
.proc main
    ; start on YMF288 addr
    lda #2
    sta cursor_y

    ; enable OAM DMA for the first time, so we can see the cursor
    jsr render_oam_enable
mainloop:
    ; not ready to render
    lda system_state
    and #($FF - STATUS_RENDER)
    sta system_state

	jsr read_pads
    ; calculate autorepeat
    ldx #0
    jsr autorepeat
    jsr run_program
    jsr prep_epsm_registers

    ; ready to render
    lda system_state
    ora #STATUS_RENDER
    sta system_state

	jsr waitframe
	jmp mainloop
.endproc

.proc waitframe
	lda nmis
:
	cmp nmis    ; NMI will change framecounter and then it wont be equal anymore
	beq :-
	rts
.endproc

.proc render_oam_enable
    lda render_state
    ora #RENDER_OAM
    sta render_state
    rts
.endproc

.proc run_program
CURSOR_X_SIZE = 8
CURSOR_Y_SIZE = 4
CURSOR_X_MAX = CURSOR_X_SIZE - 1
CURSOR_Y_MAX = CURSOR_Y_SIZE - 1

    ; up/down/left/right: navigate bits

    ; if we move our cursor, enable oam dma
    lda new_keys
    and #KEY_UP|KEY_DOWN|KEY_LEFT|KEY_RIGHT
    beq done_dpad
    jsr render_oam_enable
done_dpad:

    ; up/down: cursor Y
    lda new_keys
    and #KEY_UP
    beq done_up
    lda cursor_y
    bne skip_wrap_underflow_y
    ; if underflow, set Y to max
    lda #CURSOR_Y_MAX
    sta cursor_y

    ; check if we're in YMF288 addr line
    ; we might end up in the blank space after the 2 bits
    lda cursor_x
    cmp #2
    bcc done_up
    lda #1
    sta cursor_x
    jmp done_up
skip_wrap_underflow_y:
    dec cursor_y
done_up:

    lda new_keys
    and #KEY_DOWN
    beq done_down
    lda cursor_y
    cmp #CURSOR_Y_MAX
    ; if overflow, set Y to 0
    beq wrap_overflow_y
    inc cursor_y

    ; check if we're in YMF288 addr line
    ; we might end up in the blank space after the 2 bits
    lda cursor_y
    cmp #CURSOR_Y_MAX
    bne done_down
    lda cursor_x
    cmp #2
    bcc done_down
    lda #1
    sta cursor_x
    jmp done_down
wrap_overflow_y:
    lda #0
    sta cursor_y
done_down:

    ; left/right: cursor X
    lda new_keys
    and #KEY_LEFT
    beq done_left
    lda cursor_x
    ; if underflow, set X to max
    bne skip_wrap_underflow_x
    lda #CURSOR_X_MAX
    sta cursor_x

    ; check if we're in YMF288 addr line
    ; we might end up in the blank space after the 2 bits
    lda cursor_y
    cmp #CURSOR_Y_MAX
    bne done_left
    lda #1
    sta cursor_x
    jmp done_left
skip_wrap_underflow_x:
    dec cursor_x
done_left:

    lda new_keys
    and #KEY_RIGHT
    beq done_right
    lda cursor_x
    cmp #CURSOR_X_MAX
    ; if overflow, set X to 0
    beq wrap_overflow_x
    inc cursor_x

    ; check if we're in YMF288 addr line
    ; we might end up in the blank space after the 2 bits
    lda cursor_y
    cmp #CURSOR_Y_MAX
    bne done_right
    lda cursor_x
    cmp #2
    bcc done_right
    ; fall through
wrap_overflow_x:
    lda #0
    sta cursor_x
done_right:

    ; a/b: toggle bits

    ; b: set bit to 1
    lda new_keys
    and #KEY_B
    beq done_b
    lda #0
    jsr set_bit_on_cursor
done_b:

    ; a: set bit to 0
    lda new_keys
    and #KEY_A
    beq done_a
    lda #1
    jsr set_bit_on_cursor
done_a:

    rts
.endproc

; sets a bit to memory specified by the cursor.
; A = bit value
.proc set_bit_on_cursor
    pha
    ldy cursor_y
    ldx cursor_x
    lda cursor_y_lut,y
    sta temp_8_0
    cpy #2
    bcs skip_skip_4016_conv
    lda system_state
    ora #STATUS_SKIP_4016_CONV
    sta system_state
    jmp continue
skip_skip_4016_conv:
    lda system_state
    and #($FF - STATUS_SKIP_4016_CONV)
    sta system_state
continue:
    cpy #3
    bne skip_addr_downshift
    txa
    clc
    adc #6
    tax
skip_addr_downshift:
    ldy #0
    pla
    beq invert_bit
    lda (temp_8_0),y
    ora cursor_x_shift_lut,x
    jmp store_bit
invert_bit:
    lda cursor_x_shift_lut,x
    eor #$FF
    and (temp_8_0),y
store_bit:
    sta (temp_8_0),y
    rts

cursor_y_lut:
    .byte s_epsm_4016_out1
    .byte s_epsm_4016_out0
    .byte s_epsm_data
    .byte s_epsm_addr
cursor_x_shift_lut:
    .byte %10000000
    .byte %01000000
    .byte %00100000
    .byte %00010000
    .byte %00001000
    .byte %00000100
    .byte %00000010
    .byte %00000001

.endproc

.proc prep_epsm_registers
    lda system_state
    and #STATUS_SKIP_4016_CONV
    beq continue
    rts
continue:
    ; 7  bit  0
    ; DDDD AA1.
    ; |||| |||
    ; |||| ||+-- DDDD and AA latched when this bit goes from 0 to 1
    ; |||| ++--- D3=YMF288 A0, D2=YMF288 A1
    ; ++++------ YMF288 D7-D4
    lda s_epsm_data
    pha
    ; D7-D4
    and #$F0
    ora #$02
    sta s_epsm_4016_out1
    ; A0, A1
    lda s_epsm_addr
    and #$01
    asl
    asl
    asl
    ora s_epsm_4016_out1
    sta s_epsm_4016_out1
    lda s_epsm_addr
    and #$02
    asl
    ora s_epsm_4016_out1
    sta s_epsm_4016_out1

    ; 7  bit  0
    ; DDDD ..0.
    ; ||||   |
    ; ||||   +-- DDDD latched and write triggered when this bit goes from 1 to 0
    ; ++++------ YMF288 D3-D0
    pla
    ; D3-D0
    asl
    asl
    asl
    asl
    sta s_epsm_4016_out0

    lda system_state
    and #($FF - STATUS_SKIP_4016_CONV)
    sta system_state
    rts
.endproc

.import WriteToEpsm4016
.proc write_epsm_registers
    lda s_epsm_4016_out1
    jsr WriteToEpsm4016
    lda s_epsm_4016_out0
    jsr WriteToEpsm4016
    rts
.endproc