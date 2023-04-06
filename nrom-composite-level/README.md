# NROM Composite Level test

## About

This ROM is designed to measure [PPU composite voltage levels](https://www.nesdev.org/wiki/NTSC_video#Terminated_measurement) for use to supplement/add data to the NESDev wiki.

## Use

Toggle red emphasis with the start button.
Toggle green emphasis with the A button.
Toggle blue emphasis with the B button.
Toggle all emphasis channels with the select button.
Measure the resulting *terminated* composite voltage levels using an oscilloscope or logic analyzer.

Note: when using a PAL or Dendy console, set the `PAL_MODE` flag in `defines.inc`.

## Compiling

Dependencies (these must be available in path):
- CA65
- LD65
- Mesen

Run the makefile in a suitable bash environment. For more detailed instructions, refer to Pinobatch's [NROM template](https://github.com/pinobatch/nrom-template). If no bash environment is available, run the make.bat file.

## Credits

- Initial template: yoeynsf
- Programming help: lidnariq, zeta0134, rainwarrior, CutterCross
- General assistance: the NESDev Discord server

Thanks so much for your wonderful help!!
