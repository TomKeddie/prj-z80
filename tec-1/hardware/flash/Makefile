all: tec-1.hex tec-1.bin

tec-1.hex :
	srec_cat -Output $@ -Intel @tec-1.srec_cat

tec-1.bin :
	srec_cat -Output $@ -Binary @tec-1.srec_cat

clean :
	rm -f tec-1.hex
