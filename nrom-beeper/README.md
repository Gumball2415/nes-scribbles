# NROM Beeper

## About

This program was designed to troubleshoot my NROM boards, since they were malfunctioning. In order to immediately test that at least the PRG ROM was working, I had to make a program that immediately outputs sound on boot. After a few hours of scope creep, I was satisfied with the product, and even learned how to take controller input!

## Use

This program first displays an intro screen with a jingle and text that reads "Satellite & Stardust". Press/hold B to Beep, press A to halt the beep.

## Compiling

Dependencies (these must be available in path):
- CA65
- LD65
- Mesen
Run the makefile in a suitable bash environment. For more detailed instructions, refer to Pinobatch's [NROM template](https://github.com/pinobatch/nrom-template). If no bash environment is available, run the make.bat file.

## Credits

- Initial template: yoeynsf
- Programming help: yoeynsf, Kasumi, Fiskbit, Pinobatch, jroweboy, zeta0134
- General assistance: the NESDev Discord server

Thanks so much for your wonderful help!!
