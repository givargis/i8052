//
// Copyright (c) Tony Givargis, 1999-2025
// givargis@uci.edu
// negcnt.c
//

#include <8052.h>

void
main(void)
{
	for (int i=-960; i<-950; i++) {
		P0 = (unsigned char)((unsigned)i >> 8); // 11111100
		P1 = (unsigned char)((unsigned)i >> 0); // 01000000 ...
	}

	for (;;);
}
