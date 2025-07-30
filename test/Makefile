#
# Copyright (c) Tony Givargis, 1999-2025
# givargis@uci.edu
# Makefile
#

SRC = $(wildcard *.c)
OBJ = $(SRC:.c=.ihex)
HEX = $(SRC:.c=.hex)

all: $(HEX)
	rm -f *.asm *.ihx *.lk *.lst *.map *.mem *.rel *.rst *.sym

%.hex: %.ihx
	packihx $< > $@

%.ihx: %.c
	sdcc --std=c99 $<

clean:
	rm -f *.hex *~ *#
