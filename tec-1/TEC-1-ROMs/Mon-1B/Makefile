all: mon1B-tom.bin

%.bin : %.asm
	z80asm --verbose --list --label	--input $< --output $@ >$<.lst
