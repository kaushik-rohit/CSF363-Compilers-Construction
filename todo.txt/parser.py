import ply.lex as lex
import ply.yacc as yacc

# List of tokens
tokens = (
    'COMPLETE',
    'PRIORITY',
    'DATE',
    'LIST',
    'PARENT',
    'COLOR',
    'DUE',
    'DESC'
)

t_DESC = r'[a-zA-Z_]+'
t_COMPLETE = r'x'
t_PRIORITY = r'\([a-zA-Z]\)'
t_DATE     = '(\d+[-/]\d+[-/]\d+)'
t_LIST     = r'\@[a-zA-Z_]+'
t_PARENT   = r'\+[a-zA-Z]+'
t_COLOR    = r'color:[^{}]'
t_DUE      = r'due:\d+[-/]\d+[-/]\d+'


# Error handling rule
def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)

# Build the lexer
lexer = lex.lex()

data = '(C) this is a test task @test'

# Give the lexer some input
lexer.input(data)


# Tokenize
while True:
    tok = lexer.token()
    if not tok:
        break      # No more input
    print tok    
