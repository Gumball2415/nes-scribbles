# EPSM $4016 Register Test

## About

This program [writes to EPSM via $4016](https://www.nesdev.org/wiki/Expansion_Port_Sound_Module#Universal_access).

This requires an EPSM connected to the console, along with OUT1.

## Use

- D-Pad: Navigate bits
- B: Set bit to 0
- A: Set bit to 1

## Compiling

Dependencies (these must be available in path):
- CA65
- LD65
- Mesen

Run the makefile in a suitable bash environment. For more detailed instructions, refer to Pinobatch's [NROM template](https://github.com/pinobatch/nrom-template). If no bash environment is available, run the make.bat file.

## Credits

- Initial template: yoeynsf
- Inspiration: plgDavid, Fiskbit, Perkka
- EPSM: Perkka
- EPSM $4016 write library: Fiskbit
- Additional defines and libraries: Pinobatch, Kagamiin~, zeta0134
- Programming help: Perkka, zeta0134, Fiskbit
- NROM template: Pinobatch
- NEXXT: FrankenGraphics
- Art: yoeynsf
- General assistance: the NESDev Discord server

Thanks so much for your wonderful help!!
