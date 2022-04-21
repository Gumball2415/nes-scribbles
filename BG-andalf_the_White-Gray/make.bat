ca65 -g src/control_read.asm -o obj/nes/control_read.o
ca65 -g src/header.asm -o obj/nes/header.o
ca65 -g src/init.asm -o obj/nes/init.o
ca65 -g src/irq.asm -o obj/nes/irq.o
ca65 -g src/main.asm -o obj/nes/main.o
ca65 -g src/nmi.asm -o obj/nes/nmi.o
ca65 -g src/palettes.asm -o obj/nes/palettes.o
ld65 -v --dbgfile output/BG-andalf_the_White-Gray.dbg -o output/BG-andalf_the_White-Gray.nes -m output/map.txt -C nrom_128.cfg obj/nes/control_read.o obj/nes/header.o obj/nes/init.o obj/nes/irq.o obj/nes/main.o obj/nes/nmi.o obj/nes/palettes.o
mesen output/BG-andalf_the_White-Gray.nes
