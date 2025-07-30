//
// Copyright (c) Tony Givargis, 1999-2025
// givargis@uci.edu
// xram.c
//

__xdata unsigned char buffer[2048];

void
main(void)
{
	buffer[0] = 1;
	for (int i=1; i<2048; i++) {
		buffer[i] = buffer[i - 1] + 1;
	}

	for (;;);
}
