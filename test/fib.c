//
// Copyright (c) Tony Givargis, 1999-2025
// givargis@uci.edu
// fib.c
//

#include <8052.h>

void
fib(int *buf, int n)
{
	buf[0] = 1;
	buf[1] = 1;
	for (int i=2; i<n; i++) {
		buf[i] = buf[i-1] + buf[i-2];
	}
}

void
print(int *buf, int n)
{
	for (int i=0; i<n; i++) {
		P0 = (unsigned char)buf[i];
	}
}

void
main(void)
{
	int buf[10];

	fib(buf, 10);
	print(buf, 10);

	for (;;);
}
