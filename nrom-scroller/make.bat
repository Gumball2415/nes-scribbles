copy gfx\textchar.chr obj\textchar.chr
ca65 -g src/header.asm -o obj/header.o
ca65 -g src/init.asm -o obj/init.o
ca65 -g src/main.asm -o obj/main.o
ca65 -g src/control_read.asm -o obj/control_read.o
ca65 -g src/nmi.asm -o obj/nmi.o
ca65 -g src/irq.asm -o obj/irq.o
ca65 -g src/graphics.asm -o obj/graphics.o
ca65 -g src/sprites.asm -o obj/sprites.o
ld65 -v --dbgfile output/nrom-scroller.dbg -o output/nrom-scroller.nes -m output/map.txt -C nrom_128.cfg obj/header.o obj/init.o obj/main.o obj/control_read.o obj/nmi.o obj/irq.o obj/graphics.o obj/sprites.o
mesen output/nrom-scroller.nes
