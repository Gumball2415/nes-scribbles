copy gfx\textchar.chr obj\textchar.chr
rem py tools/pilbmp2nes.py gfx/textchar.chr obj/textchar.chr
rem py tools/pilbmp2nes.py -H 16 gfx/textchar.chr obj/textchar.chr
ca65 -g src/header.asm -o obj/header.o
ca65 -g src/init.asm -o obj/init.o
ca65 -g src/imginit.asm -o obj/imginit.o
ca65 -g src/text_engine.asm -o obj/text_engine.o
ca65 -g src/main.asm -o obj/main.o
ca65 -g src/nmi.asm -o obj/nmi.o
ca65 -g src/irq.asm -o obj/irq.o
ca65 -g src/strings.asm -o obj/strings.o
ca65 -g src/palettes.asm -o obj/palettes.o
copy gfx\text_nametable.bin obj\text_nametable.bin
ca65 -g src/nametables.asm -o obj/nametables.o
ld65 -v --dbgfile output/hello_nes.dbg -o output/hello_nes.nes -m output/map.txt -C nrom_256.cfg obj/header.o obj/init.o obj/imginit.o obj/text_engine.o obj/main.o obj/nmi.o obj/irq.o obj/strings.o obj/palettes.o obj/nametables.o
mesen output/hello_nes.nes
