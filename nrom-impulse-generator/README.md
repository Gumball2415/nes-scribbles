# NROM Impulse Generator

## About

This program plays an impulse with maximum amplitude in the DPCM channel for each second. This is used to characterize one aspect of a NES/Famicom's filter path, which can be used with an emulator via an FIR filter.

## Use

Measure and record the impulse response at the at the output of the console/system.

## Compiling

Dependencies (these must be available in path):
- CA65
- LD65
- Mesen

Run the makefile in a suitable bash environment. For more detailed instructions, refer to Pinobatch's [NROM template](https://github.com/pinobatch/nrom-template). If no bash environment is available, run the make.bat file.

## Credits

- Initial template: yoeynsf
- Inspiration: plgDavid, lidnariq, Finny
- Programming help: lidnariq, Kasumi, Fiskbit
- NROM template: Pinobatch
- JSR tree delay code: Rainwarrior
- I-CHR: Kasumi
- NEXXT: FrankenGraphics
- Art: yoeynsf
- General assistance: the NESDev Discord server

Thanks so much for your wonderful help!!
