# Makefile

CC     = gcc
CFLAGS = -ansi -pedantic -Wall -Wextra -Werror -Wfatal-errors -O3
LDLIBS = -lm -lpthread
DEST   = mkrom

SRCS   = $(wildcard *.c)
OBJS   = $(SRCS:.c=.o)

all: $(OBJS)
	@echo "[LN] $(DEST)"
	@$(CC) $(CFLAGS) -o $(DEST) $(OBJS) $(LDLIBS)

%.o: %.c
	@echo "[CC] $<"
	@$(CC) $(CFLAGS) -c $<
	@$(CC) $(CFLAGS) -MM $< > $*.d

clean:
	@rm -f $(DEST) *.o *.d *~ *#

-include $(OBJS:.o=.d)
