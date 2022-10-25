# NROM Amp Test

## About

This program plays a ~440Hz square wave with maximum amplitude in the DPCM channel. This is used to measure the db difference between before and after the amplifier output of the Famicom/NES.

## Use

Measure and record the square tone at the input of the amplifier. Measure and record the square tone at the output of the amplifier.

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
- JSR delay code: Rainwarrior
- I-CHR: Kasumi
- NEXXT: FrankenGraphics
- Art: yoeynsf
- General assistance: the NESDev Discord server

Thanks so much for your wonderful help!!
