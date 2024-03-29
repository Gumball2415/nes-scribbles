; some flags here for build configuration i guess

; use limited charset
COMPACT_CHARSET = 0

;;; actual code to do with the file starts here ;;;
.include "defines.inc"
.include "global.inc"

.import NMI_HANDLER, RESET_HANDLER, IRQ_HANDLER

.segment "HEADER"
    ; comments regarding header format taken from
    ; https://wiki.nesdev.org/w/index.php?title=INES#iNES_file_format
    ; Flag 0-3
    .byte "NES", $1A
    ; Flag 4
    .byte $01                       ; n * 16KB PRG ROM
    ; Flag 5
    .byte $01                       ; n * 8KB CHR ROM

    ; Flag 6
    .byte %00000001
    ;      ||||||||
    ;      |||||||+- Mirroring: 0: horizontal (vertical arrangement) (CIRAM A10 = PPU A11)
    ;      |||||||              1: vertical (horizontal arrangement) (CIRAM A10 = PPU A10)
    ;      ||||||+-- 1: Cartridge contains battery-backed PRG RAM ($6000-7FFF) or other persistent memory
    ;      |||||+--- 1: 512-byte trainer at $7000-$71FF (stored before PRG data)
    ;      ||||+---- 1: Ignore mirroring control or above mirroring bit; instead provide four-screen VRAM
    ;      ++++----- Lower nybble of mapper number

    ; Flag 7
    .byte %00000000
    ;      ||||||||
    ;      |||||||+- VS Unisystem
    ;      ||||||+-- PlayChoice-10 (8KB of Hint Screen data stored after CHR data)
    ;      ||||++--- If equal to 2, flags 8-15 are in NES 2.0 format
    ;      ++++----- Upper nybble of mapper number

    ; Flag 8-10
    .byte $00, $00, $00

    ; Flag 11
    .byte $00
    ;      cC
    ;      |+----- CHR-RAM size (volatile) shift count
    ;      +------ CHR-NVRAM size (non-volatile) shift count
    ;     If the shift count is zero, there is no CHR-(NV)RAM.
    ;     If the shift count is non-zero, the actual size is
    ;     "64 << shift count" bytes, i.e. 8192 bytes for a shift count of 7.

    ; Flag 12-15; unused
    .byte $00, $00, $00, $00

.segment "ZEROPAGE"
	; 8 temp variables, 4 8-bit and 4 16-bit
	temp_8_0:				.res 1
	temp_8_1:				.res 1
	temp_8_2:				.res 1
	temp_8_3:				.res 1
	temp_16_0:				.res 2
	temp_16_1:				.res 2
	temp_16_2:				.res 2
	temp_16_3:				.res 2

.segment "CHR"
  .incbin "obj/tiles.chr"

; thank you yoey