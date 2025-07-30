//
// Copyright (c) Tony Givargis, 1999-2025
// givargis@uci.edu
// sort.c
//

#include <8052.h>

void
sort(int *buf, int n)
{
	int t;

	for (int i=0; i<n; i++) {
		for (int j=i; j<n; j++) {
			if (buf[i] > buf[j]) {
				t = buf[i];
				buf[i] = buf[j];
				buf[j] = t;
			}
		}
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
	int buf[] = { 19, 18, 17, 16, 15, 14, 13, 12, 11, 10 };

	sort(buf, 10);
	print(buf, 10);

	for (;;);
}
