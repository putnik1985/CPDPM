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

#define ALLOCSIZE 10000 /* size of available space */
static char allocbuf[ALLOCSIZE]; /* storage for alloc */
static char *allocp = allocbuf; /* next free position */

char *alloc(int n)
{
	  if (allocbuf + ALLOCSIZE - allocp >= n) { /* it fits */
	      allocp += n;
		  return allocp - n; /* old p */
	  } else /* not enough room */
	      return 0;
}

void afree(char *p)
{
	 if (p >= allocbuf && p < allocbuf + ALLOCSIZE)
		 allocp = p;
}

///////////////#include <string.h>
#define MAXLINE 1000

int _strlen(char* s)
{
	char* p = s;
	while (*++p != '\0')
		;
	return p - s;
}



int _strcat(char* s, char* t)
{
	char* p = s;
	while (*++p != '\0') /* go to the end of the string */
		;

	while ( (*p++ = *t++) != '\0' )
		;

	return 0;
}

int _strend(char* s, char* t)
{
	   char* sp = s;
	   char* tp = t;
	   int n  = _strlen(sp);
	   int n1 = _strlen(tp);

	   if (n < n1) return 0;
	   char* p = sp + n - n1; /* point to the latest n1 leters */

           /* if (*p != *tp) return 0; */

	   while ( *p++ == *tp++ && *p != '\0')
                    ;

	   if (*p != '\0') return 0;
	   return 1;
}

int _strncpy(char *s, char* t, int n)
{
	char* sp = s;
	char* tp = t;
	int i;

	for( i = 0; i < n && *tp != '\0'; *sp++ = *tp++, ++i)
		;
	return i;
}

int _strncat(char *s, char* t, int n)
{
	char* sp = s;
	char* tp = t;
	int i;

        while (*sp++ != '\0')
		;

	for( i = 0; i < n && *tp != '\0'; *sp++ = *tp++, ++i)
		;
	return i;
}

#include <string.h>
int _strncmp(char* s, char* t, int n)
{
	int d = _strlen(s);
	if (d < n) return strcmp(s,t);

	char* p = s + n - 1;
        for(int i = 0 ; *s == *t && i < n; s++, t++, ++i)
	       if ( *s == *p )
		    return 0;

	return *s - *t;
}

/* getline: get ine into s and return length */
int getline(char* s, int lim)
{
	int c, i;
	i = 0;
	while (--lim > 0 && (c = getchar()) != EOF && c!= '\n')
           s[i++] = c;

    if (c == '\n')
           s[i++] = c;
    s[i] = '\0';
    return i;	
}

/* strindex: return index of t in s, -1 if none */
int _strindex(char* s, char* t)
{
	char* begin = s;
	for( ; *s != '\0'; s++) {
		char* sp = s;
		char* tp = t;
		for( ;  *tp != '\0' && *tp == *sp; tp++, sp++)
			;    
		printf("%c -- %c\n", *s, *tp);
		if ((tp > t) && ( *tp == '\0'))
			return s - begin;
	}
	return -1;
}
/* swap: swap the chars pointed defined by the address */
int swap(char* p, char* t)
{ 
     char temp = *p;
     *p = *t;
     *t = temp;
     return 0;
}

/* reverse: reverse string s in place */
int reverse(char* s)
{ 
	char* end = s + strlen(s) - 1;
	char* begin = s;
	int c, i, j;
	for(; begin < end; begin++, end--){
	      swap(begin, end);
	}
	return 0;
}

/* atoi: convert s into integer */
int _atoi(char* s)
{
	int sign, number;
	char* begin = s;
	for(; isspace(*begin); ++begin)
		;

	sign = (*begin == '-') ? -1 : 1;
	if (*begin == '-' || *begin == '+' )++begin; /* skip sign */

	for(number = 0; isdigit(*begin);++begin)
            number = 10 * number + (*begin - '0');
	return sign * number;
}

int main(){
    char s1[MAXLINE];
    char s2[MAXLINE];     
    printf("input string\n");
    scanf("%s",s1);
    printf("\ninput:\n");
    printf("%s\n",s1);
    printf("number:\n");
    int n = _atoi(s1); 
    printf("%d\n",n);
    return 0;
}
