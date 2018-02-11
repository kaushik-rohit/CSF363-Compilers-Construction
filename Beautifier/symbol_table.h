struct _entry
{
  char *lexptr;
  int token;
};

int lookup(char *lexme);
int insert(char *ch, int token);
void init();

