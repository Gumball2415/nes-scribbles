# NROM 🏳️‍⚧️

## About

🏳️‍⚧️ in 136 total used bytes. Inspired by [uaflag](https://github.com/pinobatch/little-things-nes/tree/master/uaflag).

A version which uses no CHR can be enabled by the `OPTIMIZEDFORCHR` flag; this has a tradeoff of 15 extra PRG bytes (or 21 if `PAL_NES_RASTER` is set).

## Compiling

Dependencies (these must be available in path):
- CA65
- LD65
- Mesen

Run the makefile in a suitable bash environment. For more detailed instructions, refer to Pinobatch's [NROM template](https://github.com/pinobatch/nrom-template). If no bash environment is available, run the make.bat file.

## Credits

- Initial template: yoeynsf
- BIT PPUDATA optimization: Famicuber
- JSR tree delay code: Rainwarrior
- General assistance: the NESDev Discord server

Thanks so much for your wonderful help!!
