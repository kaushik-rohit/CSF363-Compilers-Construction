import lex
import yacc

#List of tokens

tokens = (
    'AT',
    'NEWLINE',
    'COMMENT',
    'WHITESPACE',
    'JUNK',
    'NUMBER',
    'NAME',
    'LBRACE',
    'RBRACE',
    'LPAREN',
    'RPAREN',
    'EQUALS',
    'HASH',
    'COMMA',
    'QUOTE',
    'STRING'
)


# Regular expression rules for simple tokens
t_AT         = r'\@'
t_NEWLINE    = r'\n'
t_COMMENT    = r'\%~[\n]*\n'
t_WHITESPACE = r'[\ \r\t]+'
t_JUNK       = r'~[\@\n\ \r\t]+'
t_NAME       = r"[a-zA-Z0-9\!\$\&\*\+\-\.\/\:\;\<\>\?\[\]\^\_\'\|]+"
t_LBRACE     = r'\{'
t_RBRACE     = r'\}'
t_LPAREN     = r'\('
t_RPAREN     = r'\)'
t_EQUALS     = r'='
t_HASH       = r'\#'
t_COMMA      = r'\,'
t_QUOTE      = r'\"'
t_STRING     = r'{[^{}]*}'

 
def t_NUMBER(t):
    r'\d+'
    t.value = int(t.value)
    return t
    
# Error handling rule
def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)

# Build the lexer
lexer = lex.lex()

data = '''@article{key1,
author = {Sarkar, Santonu},
title = "John Smith"}'''

# Give the lexer some input
lexer.input(data)


# Tokenize
while True:
    tok = lexer.token()
    if not tok:
        break      # No more input
    print tok

def p_bibfile(p):
    'bibfile : entries'
    p[0] = p[1]
    
def p_entries(p):
    '''entries : entry entries
               | entry'''
    if len(p) > 2:
        p[0] = p[1]+p[2]
    else:
        p[0] = p[1]
    
def p_entry(p):
    pass
    
def p_field(p):
    pass
    

