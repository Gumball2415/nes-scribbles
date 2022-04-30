copy gfx\textchar.chr obj\textchar.chr
rem py tools/pilbmp2nes.py gfx/textchar.chr obj/textchar.chr
rem py tools/pilbmp2nes.py -H 16 gfx/textchar.chr obj/textchar.chr
ca65 -g src/header.asm -o obj/header.o
ca65 -g src/init.asm -o obj/init.o
ca65 -g src/main.asm -o obj/main.o
ca65 -g src/strings.asm -o obj/strings.o
ca65 -g src/control_read.asm -o obj/control_read.o
ca65 -g src/nmi.asm -o obj/nmi.o
ca65 -g src/irq.asm -o obj/irq.o
ca65 -g src/graphics.asm -o obj/graphics.o
ld65 -v --dbgfile output/nrom-beeper.dbg -o output/nrom-beeper.nes -m output/map.txt -C nrom_128.cfg obj/header.o obj/init.o obj/main.o obj/strings.o obj/control_read.o obj/nmi.o obj/irq.o obj/graphics.o
mesen output/nrom-beeper.nes
