//
// Copyright (c) Tony Givargis, 1999-2025
// givargis@uci.edu
// int2bin.c
//

#include <8052.h>

void
main(void)
{
	const unsigned char X = 0xaa;

	for (int i=0; i<8; i++) {
		P0 = (X & (1 << i)) ? 1 : 0; // 00000000, 00000001, 00000000...
	}

	for (;;);
}
