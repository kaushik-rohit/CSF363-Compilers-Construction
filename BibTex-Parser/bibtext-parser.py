import ply.lex as lex
import ply.yacc as yacc
import sqlite3 as lite
import logging

logging.basicConfig(
    level = logging.DEBUG,
    filename = "parselog.txt",
    filemode = "w",
    format = "%(filename)10s:%(lineno)4d:%(message)s"
)
log = logging.getLogger()

TABLE_NAME = "bibtex"

# connect to database
conn = lite.connect("tex.sqlite")
c = conn.cursor()
c.execute("DROP TABLE IF EXISTS bibtex")

create_table = """CREATE TABLE bibtex(
                  bibkey VARCHAR(50) PRIMARY KEY,
                  bibtype VARCHAR(50) NOT NULL,
                  address VARCHAR(255),
                  author VARCHAR(255) NOT NULL,
                  booktitle VARCHAR(255),
                  chapter VARCHAR(50),
                  edition VARCHAR(25),
                  journal VARCHAR(100),
                  number VARCHAR(25),
                  pages VARCHAR(25),
                  publisher VARCHAR(100),
                  school VARCHAR(100),
                  title VARCHAR(255),
                  volume VARCHAR(50),
                  year VARCHAR(25))"""
                  
c.execute(create_table)

# hold records to insert in db later

records = {}
records['bibkey'] = 'NULL'
records['bibtype'] = 'NULL'
records['address'] = 'NULL'
records['author'] = 'NULL'
records['booktitle'] = 'NULL'
records['chapter'] = 'NULL'
records['edition'] = 'NULL'
records['journal'] = 'NULL'
records['number'] = 'NULL'
records['pages'] = 'NULL'
records['publisher'] = 'NULL'
records['school'] = 'NULL'
records['title'] = 'NULL'
records['volume'] = 'NULL'
records['year'] = 'NULL'

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
t_ignore = " \t\r\n"

def t_NUMBER(t):
    r'\d+'
    t.value = int(t.value)
    return t
    
# Error handling rule
def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)

# Build the lexer
lexer = lex.lex(debug=True,debuglog=log)

data = """@article{key1,
        author = {Sarkar, Santonu},
        title = {John Smith}}
        
        @book{ourbook,
        author = {joe smith and john Kurt},
        title = {Our Little Book},
        year = {1997}}"""

# Give the lexer some input
lexer.input(data)


# Tokenize
while True:
    tok = lexer.token()
    if not tok:
        break      # last input, string traversed completely
    print tok

def p_bibfile(p):
    'bibfile : entries'
    p[0] = p[1]
    
def p_entries(p):
    '''entries : entry entries
               | entry'''
    if len(p) == 3:
        p[0] = p[1] + p[2]
    else:
        p[0] = p[1]
    
def p_entry(p):
    '''entry : AT NAME LBRACE key COMMA fields RBRACE'''
    p[0] = p[1] + p[2] + p[3] + p[4] + p[5] + p[6] + p[7]
    
    records['bibtype'] = p[2]
    records['bibkey'] = p[4]
    
    c.execute("""INSERT INTO bibtex(bibkey, bibtype, address, author,
                    booktitle, chapter, edition, journal, number, pages,
                    publisher, school, title, volume, year)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""",\
                    (records['bibkey'], records['bibtype'], records['address'], records['author'],\
                    records['booktitle'], records['chapter'], records['edition'],\
                    records['journal'], records['number'], records['pages'],\
                    records['publisher'],records['school'],records['title'],\
                    records['volume'], records['year']))
    conn.commit()
    
    # reset record after entry is complete 
    for i in records.keys():
        records[i] = 'NULL'
    
    
def p_key(p):
    '''key : NAME
           | NUMBER'''
    p[0] = p[1]
    
def p_fields(p):
    '''fields : field COMMA fields
              | field'''
    if(len(p) > 3):
        p[0] = p[1] + p[2] + p[3]
    else:
        p[0] = p[1]
        
def p_field(p):
    '''field : NAME EQUALS value'''
    p[0] = p[1] + p[2] + p[3]
    records[p[1]] = p[3]
    
def p_value(p):
    '''value : STRING
             | NUMBER
             | NAME'''
    p[0] = p[1]

def p_error(p):
    print "Syntax error in input!"
    
parser = yacc.yacc(debug=True,debuglog=log)
parser.parse(data)

def get_posts():
    print "Printing all the rows in table"
    with conn:
        c.execute("SELECT * FROM bibtex")
        rows = c.fetchall()
        for row in rows:
            print row
        
c.execute('PRAGMA TABLE_INFO({})'.format('bibtex'))

# collect names in a list
names = [tup[1] for tup in c.fetchall()]
print "BibTex record table specification"
print(names)

get_posts()
conn.close()
