all: issue11_page29_1.bin

%.bin : %.asm
	z80asm --verbose --list --label	--input $< --output $@ >$<.lst 2>&1

clean:
	rm *.bin *.lst

