#
# Copyright (c) Tony Givargis, 1999-2025
# givargis@uci.edu
# Makefile
#

CC     = gcc
CFLAGS = -std=c99 -pedantic -Wall -Wextra -Werror -Wfatal-errors -O3
LDLIBS = -lm -lpthread
SRCS   = $(wildcard *.c)
OBJS   = $(SRCS:.c=.o)
DEST   = mkrom

all: $(OBJS)
	$(CC) $(CFLAGS) -o $(DEST) $(OBJS) $(LDLIBS)

%.o: %.c
	$(CC) $(CFLAGS) -c $<
	@$(CC) $(CFLAGS) -MM $< > $*.d

clean:
	@rm -f $(DEST) *.o *.d *~ *#

-include $(OBJS:.o=.d)
