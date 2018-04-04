CC=gcc
CPP=g++
YACC=yacc
#YACC=bison -y
LEX=flex
#LEX=lex
LIBS=
COFLAGS=-g
CWFLAGS=-Wall
CIFLAGS=
CMFLAGS=
CFLAGS= $(CWFLAGS) $(COFLAGS) $(CIFLAGS) $(CMFLAGS)
all:		uc
uc:		uc.o bytecode.o error.o init.o javaclass.o lex.yy.o symbol.o
		$(CC) -o uc uc.o llvm_ir.o error.o init.o lex.yy.o symbol.o
uc.c:		uc.y
		$(YACC) -o uc.c -d -v uc.y
lex.yy.c:	uc.l uc.c
		$(LEX) uc.l
.c.o:
		$(CC) $(CFLAGS) -c $<
clean:
		rm -f uc core *.o uc.h uc.c lex.yy.c uc.output
