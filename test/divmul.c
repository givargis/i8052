//
// Copyright (c) Tony Givargis, 1999-2025
// givargis@uci.edu
// divmul.c
//

#include <8052.h>

void
main(void)
{
	unsigned x, y, q, r, p;

	x = 134;
	y = 1;

	for (int i=0; i<12; i++) {
		y++;
	}

	q = x / y;
	r = x % y;
	p = q * y + r;

	P0 = (unsigned char)q; // 00001010
	P1 = (unsigned char)r; // 00000100
	P2 = (unsigned char)p; // 10000110

	for (;;);
}
