#include "global.h"
#include "uc.h"

struct Keyword
{	char *lexptr;
	int token;
};

static struct Keyword keywords[] =
{
	{ "break",	BREAK },
	{ "do",		DO },
	{ "else",	ELSE },
	{ "for",	FOR },
	{ "if",		IF },
	{ "return",	RETURN },
	{ "while",	WHILE },
	{ NULL }
};

/* init - populates global symbol table with keywords */
void init()
{
	struct Keyword *k;

	for (k = keywords; k->lexptr; k++)
		insert(k->lexptr, k->token);
}

