#include <stdio.h>
#include <ctype.h>
#include <string.h>

#define MAXWORD 100
#define BUFSIZE 100

char buf[BUFSIZE]; /* buffer for ungetch */
int bufp = 0; /* next free position in buf */



#define NKEYS 13
struct key {
	char *word;
	int count;
} keytab[] = {
	"auto", 0,
	"break", 0,
	"case", 0,
	"char" ,0,
	"const", 0,
	"continue", 0,
	"default", 0,
	"unsigned", 0,
	"void", 0,
	"volatile", 0,
	"while", 0,
	"#", 0,
	"_", 0
};

#define NSYMBS 2
struct key special_symbol [] = {
	       "_", 0,
	       "#", 0,
};

int getword(char *, int);
int binsearch(char *, struct key *, int);
int search(char *, struct key *, int);

int getch(void);
void ungetch(int);

/* count C words */
int main()
{
	int n;
	char word[MAXWORD];

	while (getword(word, MAXWORD) != EOF){
	//	if ( isalpha(word[0]) )
			if ((n = search(word, keytab, NKEYS)) >= 0)
				keytab[n].count++;
	}
	for (n = 0; n < NKEYS; n++)
			printf("%4d %s\n",
					keytab[n].count, keytab[n].word);

	return 0;
}

/* search_symbol: search special symbol in the special symbol array */
int search(char* word, struct key tab[], int n)
{
	for(int i = 0; i < n; ++i){
		if (strcmp(word, tab[i].word) == 0) 
			return i;
	}
	return -1;
}

/* binsearch: find word in tab[0]...tab[n-1] */
int binsearch(char *word, struct key tab[], int n)
{
	int cond;
	int low, high, mid;

	low = 0;
	high = n - 1;
	while (low <= high) {
		mid = (low + high)/2;
		if ((cond = strcmp(word, tab[mid].word)) < 0)
			high = mid - 1;
		else if (cond > 0)
			low = mid + 1;
		else 
			return mid;
	}
	return -1;
}

/* getword: get next word or character from input */
int getword(char *word, int lim)
{
	int c, getch(void);
	void ungetch(int);
	char *w = word;

	while (isspace(c = getch()))
		;

	if (c != EOF )
		*w++ = c;

	if (!isalpha(c)) {
		*w = '\0';
		return c;
	}

	for (; --lim > 0; w++)
		if (!isalnum(*w = getch())) {
			ungetch(*w);
			break;
		}
	*w = '\0';

	return word[0];
}

int getch(void) /* get a (possibly pushed-back) character */
{
	return (bufp > 0) ? buf[--bufp] : getchar();
}

void ungetch(int c)
{
	if (bufp >= BUFSIZE)
		printf("ungetch: too many characters\n");
	else
		buf[bufp++]=c;
}
