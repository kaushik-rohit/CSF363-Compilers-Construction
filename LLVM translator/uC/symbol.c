#include "global.h"
#define MAX_SYMBOLS 200000

Symbol symbol_table[MAX_SYMBOLS];

Symbol *lookup(char *s)
{   
    for (int i = 0; i < n_tokens; i++)
    {
    if(strcmp(lexme, (symbol_table[i])->lexptr) == 0)
      return symbol_table[i];
    }

    return NULL;
}

Symbol *insert(char *s, int token)
{
    Symbol key;

    if(token >= MAX_SYMBOLS)
    {
    printf("Symbol Table Full!!!");
    return NULL;
    }

    key.lexptr = s;
    key.token = token;

    symbol_table[token] = key;
  

    return key;
}
