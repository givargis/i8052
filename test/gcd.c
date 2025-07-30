//
// Copyright (c) Tony Givargis, 1999-2025
// givargis@uci.edu
// gcd.c
//

#include <8052.h>

void
main(void)
{
	int x, y;

	x = 136;
	y = 36;

	while (x != y) {
		if (x > y) {
			x -= y;
			P0 = (unsigned char)x;
		}
		else {
			y -= x;
			P1 = (unsigned char)y;
		}
	}

	P2 = (unsigned char)x; // 00000100

	for (;;);
}
