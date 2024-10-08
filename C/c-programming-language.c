#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <errno.h>
#include <math.h>

#define BUFSIZE 100


char buf[BUFSIZE];
int bufp = 0;

int getch(void)
{
	return (bufp > 0 ) ? buf[--bufp] : getchar();
}

void ungetch(int c)
{
	if (bufp >= BUFSIZE)
		printf("ungetch: too many characters\n");
	else
		buf[bufp++] = c;
}

/* page 87, exercise 5-1 */
/* getint: get next integer from input into *pn */
int getint(int *pn)
{
	int c, sign;
	
	while (isspace(c = getch()))
		;
	
	if (!isdigit(c) && c != EOF && c != '+' && c != '-') {
        ungetch(c); /* it is not a number */
		return 0;
	}
	
	sign = (c == '-') ? -1 : 1;
	if (c == '+' || c == '-')
		c = getch();

	if (!isdigit(c)) {
        ungetch(c); /* it is not a number */
		return 0;
	}
	
	for(*pn = 0; isdigit(c); c = getch())
		*pn = 10 * *pn + (c - '0');
	
	*pn *= sign;
	if (c != EOF)
		ungetch(c);
	
	return c;
}	

/* page 87, exercise 5-2 */
/* getfloat: get next float from input into *pn */
int getfloat(float *pn)
{
	int c, sign;
	
	while (isspace(c = getch()))
		;
	
	if (!isdigit(c) && c != EOF && c != '+' && c != '-') {
        ungetch(c); /* it is not a number */
		return 0;
	}
	
	sign = (c == '-') ? -1 : 1;
	if (c == '+' || c == '-')
		c = getch();

	if (!isdigit(c)) {
        ungetch(c); /* it is not a number */
		return 0;
	}
	
	for(*pn = 0; isdigit(c); c = getch())
		*pn = 10 * *pn + (c - '0');
	
	if (c == '.'){
		c = getch();
	    for(int i = 1; isdigit(c); c = getch(), ++i)
		    *pn += pow(0.1,i) * (c - '0');
	}
	
	*pn *= sign;
	if (c != EOF)
		ungetch(c);
	
	return c;
}	
int main(){
    fprintf(stdout, "start printing\n");
	float c;
	while ( getfloat(&c)) {
	    printf("number: %f\n",c);
	}
}