//
// Copyright (c) Tony Givargis, 1999-2025
// givargis@uci.edu
// sqrt.c
//

#include <math.h>
#include <8052.h>

void
main(void)
{
	const float X = 3.0;
	const float Y = 4.0;
	float xx, yy, xx_yy, sqrt_xx_yy;

	xx = X * X;
	P0 = (unsigned char)xx; // 00001001

	yy = Y * Y;
	P1 = (unsigned char)yy; // 00010000

	xx_yy = xx + yy;
	P2 = (unsigned char)xx_yy; // 00011001

	sqrt_xx_yy = sqrtf(xx_yy);
	P3 = (unsigned char)sqrt_xx_yy; // 00000101

	for (;;);
}
