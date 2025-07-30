//
// Copyright (c) Tony Givargis, 1999-2025
// givargis@uci.edu
// cast.c
//

#include <8052.h>

unsigned char
cast(unsigned long l)
{
	return (unsigned char)l;
}

void
main(void)
{
	const unsigned long L = 0x01234567;

	P0 = cast(L >> 24); // 00000001
	P1 = cast(L >> 16); // 00100011
	P2 = cast(L >>  8); // 01000101
	P3 = cast(L >>  0); // 01100111

	for (;;);
}
