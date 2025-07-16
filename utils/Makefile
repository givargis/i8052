#
# Copyright (c) Tony Givargis, 1999-2025
#
# Makefile
#

CC     = gcc
CFLAGS = -std=c99 -pedantic -Wall -Wextra -Werror -Wfatal-errors -fPIC -O3
LDLIBS =
SRCS   = $(wildcard *.c)
OBJS   = $(SRCS:.c=.o)
DEST   = mkrom

all: $(OBJS)
	@echo "[LN]" $(DEST)
	@$(CC) -O3 -o $(DEST) $(OBJS) $(MODULES) $(LDLIBS)

%.o: %.c
	@echo "[CC]" $<
	@$(CC) $(CFLAGS) -c $<
	@$(CC) $(CFLAGS) -MM $< > $*.d

clean:
	@rm -f $(DEST) *.so *.a *.o *.d *~ *#

-include $(OBJS:.o=.d)
