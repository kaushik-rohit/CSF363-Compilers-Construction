#include <stdio.h>
#include <stdlib.h>
#include "symbol_table.h"
#include <string.h>
#define MAX_SYMBOLS 200

typedef struct _entry entry;

entry* symbol_table[MAX_SYMBOLS];
int n_tokens = 0;

char *keywords[] = {"auto", "double", "int", "struct", "break", "else", "long", "switch", "case", "enum", "register",
                    "typedef", "char", "extern", "return", "union", "const", "float", "short", "unsigned", "continue",
                    "for", "signed", "void", "default", "goto", "sizeof", "volatile", "do", "if", "static", "while"}; 

int lookup(char *lexme)
{
  for (int i = 0; i < n_tokens; i++)
  {
    if(strcmp(lexme, (symbol_table[i])->lexptr) == 0)
      return i;
  }
  return -1;
}


int insert(char *ch, int token)
{
  entry *key;
  if(n_tokens == MAX_SYMBOLS)
  {
    printf("Symbol Table Full!!!");
    return -1;
  }
  
  key = (entry*) malloc(sizeof(entry));
  key->lexptr = ch;
  symbol_table[n_tokens] = key;
  n_tokens++;
  
  return 0;
}

void init()
{

  int len_keys = sizeof(keywords)/sizeof(keywords[0]);
  
  for (int i = 0; i < len_keys; i++)
  {
    entry *data;
    data = (entry*) malloc(sizeof(entry));
    data->lexptr = keywords[i];
    symbol_table[n_tokens] = data;
    n_tokens++;
  }

}
