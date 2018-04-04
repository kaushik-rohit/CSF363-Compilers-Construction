/* TODO: TO BE COMPLETED */

%{

#include "global.h"
#include "llvm.h" // This header will have a class llvm_ir with appropriate methods. Look at the main() program to define the methods
llvm_ir ir;
%}

/* declares YYSTYPE type of attribute for all tokens and nonterminals */
%union
{ Symbol *sym;  /* token value yylval.sym is the symbol table entry of an ID */
  unsigned num; /* token value yylval.num is the value of an int constant */
  float flt;    /* token value yylval.flt is the value of a float constant */
  char *str;    /* token value yylval.str is the value of a string constant */
  unsigned loc; /* location of instruction to backpatch */
}

/* Declare ID token and its attribute type 'sym' */
%token <sym> ID

/* Declare INT tokens (8 bit, 16 bit, 32 bit) and their attribute type 'num' */
%token <num> INT8 INT16 INT32

/* Declare FLT token (not used in this assignment) */
%token <flt> FLT

/* Declare STR token (not used in this assignment) */
%token <str> STR

/* Declare tokens for keywords */
/* Note: install_id() returns Symbol* for both keywords and identifiers */
%token <sym> BREAK DO ELSE FOR IF RETURN WHILE

/* Declare operator tokens */
/* TODO: TO BE COMPLETED WITH ASSOCIATIVITY AND PRECEDENCE DECLARATIONS */
%token PA NA TA DA MA AA XA OA LA RA OR AN EQ NE LE GE LS RS AR PP NN

/* Declare attribute types for marker nonterminals, such as L M and N */
/* TODO: TO BE COMPLETED WITH ADDITIONAL NONMARKERS AS NECESSARY */
%type <loc> L M N

%%

stmts   : stmts stmt
        | /* empty */
        ;

stmt    : ';'
        | expr ';'      { /* TODO: COmplete with semantic action */; }
        | IF '(' expr ')' stmt
                        { /* TODO: TO BE COMPLETED */ error("if-then not implemented"); }
        | IF '(' expr ')' stmt ELSE stmt
                        { /* TODO: TO BE COMPLETED */ error("if-then-else not implemented"); }
        | WHILE '(' expr ')' stmt
                        { /* TODO: TO BE COMPLETED */ error("while-loop not implemented"); }
        | DO stmt WHILE '(' expr ')' ';'
                        { /* TODO: TO BE COMPLETED */ error("do-while-loop not implemented"); }
        | FOR '(' expr ';' expr ';' expr ')' stmt
                        { /* TODO: TO BE COMPLETED */ error("for-loop not implemented"); }
        | RETURN expr ';'
                        { /* TODO: COmplete with semantic action */ }
        | BREAK ';'
                        { /* TODO: COmplete with semantic action */ error("break not implemented"); }
        | '{' stmts '}'
        | error ';'     { yyerrok; }
        ;

expr    : ID   '=' expr { /* TODO: TO BE COMPLETED with code-generation routines*/ ; }
        | ID   PA  expr { /* TODO: TO BE COMPLETED */ error("+= operator not implemented"); }
        | ID   NA  expr { /* TODO: TO BE COMPLETED */ error("-= operator not implemented"); }
        | ID   TA  expr { /* TODO: TO BE COMPLETED */ error("*= operator not implemented"); }
        | ID   DA  expr { /* TODO: TO BE COMPLETED */ error("/= operator not implemented"); }
        | ID   MA  expr { /* TODO: TO BE COMPLETED */ error("%= operator not implemented"); }
        | ID   AA  expr { /* TODO: TO BE COMPLETED */ error("&= operator not implemented"); }
        | ID   XA  expr { /* TODO: TO BE COMPLETED */ error("^= operator not implemented"); }
        | ID   OA  expr { /* TODO: TO BE COMPLETED */ error("|= operator not implemented"); }
        | ID   LA  expr { /* TODO: TO BE COMPLETED */ error("<<= operator not implemented"); }
        | ID   RA  expr { /* TODO: TO BE COMPLETED */ error(">>= operator not implemented"); }
        | expr OR  expr { /* TODO: TO BE COMPLETED */ error("|| operator not implemented"); }
        | expr AN  expr { /* TODO: TO BE COMPLETED */ error("&& operator not implemented"); }
        | expr '|' expr { /* TODO: TO BE COMPLETED */ error("| operator not implemented"); }
        | expr '^' expr { /* TODO: TO BE COMPLETED */ error("^ operator not implemented"); }
        | expr '&' expr { /* TODO: TO BE COMPLETED */ error("& operator not implemented"); }
        | expr EQ  expr { /* TODO: TO BE COMPLETED */ error("== operator not implemented"); }
        | expr NE  expr { /* TODO: TO BE COMPLETED */ error("!= operator not implemented"); }
        | expr '<' expr { /* TODO: TO BE COMPLETED */ error("< operator not implemented"); }
        | expr '>' expr { /* TODO: TO BE COMPLETED */ error("> operator not implemented"); }
        | expr LE  expr { /* TODO: TO BE COMPLETED */ error("<= operator not implemented"); }
        | expr GE  expr { /* TODO: TO BE COMPLETED */ error(">= operator not implemented"); }
        | expr LS  expr { /* TODO: TO BE COMPLETED */ error("<< operator not implemented"); }
        | expr RS  expr { /* TODO: TO BE COMPLETED */ error(">> operator not implemented"); }
        | expr '+' expr { /* TODO: TO BE COMPLETED */ error("+ operator not implemented"); }
        | expr '-' expr { /* TODO: TO BE COMPLETED */ error("- operator not implemented"); }
        | expr '*' expr { /* TODO: TO BE COMPLETED */ error("* operator not implemented"); }
        | expr '/' expr { /* TODO: TO BE COMPLETED */ error("/ operator not implemented"); }
        | expr '%' expr { /* TODO: TO BE COMPLETED */ error("% operator not implemented"); }
        | '!' expr      { /* TODO: TO BE COMPLETED */ error("! operator not implemented"); }
        | '~' expr      { /* TODO: TO BE COMPLETED */ error("~ operator not implemented"); }
        | '+' expr %prec '!' /* '+' at same precedence level as '!' */
                        { /* TODO: TO BE COMPLETED */ error("unary + operator not implemented"); }
        | '-' expr %prec '!' /* '-' at same precedence level as '!' */
                        { /* TODO: TO BE COMPLETED */ error("unary - operator not implemented"); }
        | '(' expr ')'
        | '$' INT8      { emit(aload_1); emit2(bipush, $2); emit(iaload); }
        | PP ID         { /* TODO: TO BE COMPLETED */ error("pre ++ operator not implemented"); }
        | NN ID         { /* TODO: TO BE COMPLETED */ error("pre -- operator not implemented"); }
        | ID PP         { /* TODO: TO BE COMPLETED */ error("post ++ operator not implemented"); }
        | ID NN         { /* TODO: TO BE COMPLETED */ error("post -- operator not implemented"); }
        | ID            { /* TODO: TO BE COMPLETED with code-generation routines*/ ; }
        | INT8          { /* TODO: TO BE COMPLETED with code-generation routines*/ ; }
        | INT16         { /* TODO: TO BE COMPLETED with code-generation routines*/ ; }
        | INT32         { /* TODO: TO BE COMPLETED with code-generation routines*/ ; }
        | FLT		{ error("float constant not supported now"); }
        | STR		{ error("string constant not supported now"); }
        ;

L       : /* empty */   { /* TODO: TO BE COMPLETED with code-generation routines*/ ; }
        ;

M       : /* empty */   { /* TODO: TO BE COMPLETED with code-generation routines*/ ;
			}
        ;

N       : /* empty */   { /* TODO: TO BE COMPLETED with code-generation routines*/ ;
			}
        ;

/* TODO: TO BE COMPLETED WITH ADDITIONAL NONMARKERS AS NEEDED */

%%

int main(int argc, char **argv)
{
	int index1, index2, index3;
	int label1, label2;
    if (argc > 2) {
		if (!(yyin = fopen(argv[1], "r")))
			error("Cannot open file for reading");
        
        char *ir_filename;
        // read the IR filename from command line
        // set up new file structure
        ir.create(ir_filename);
        ir.generate_prologue_code();
        init(); // Initialize the symbol table
        if (yyparse() || errnum > 0)
        error("Compilation errors: class file not saved");
        fprintf(stderr, "Compilation successful: saving %s.class\n", ir.getname());
        ir.generate_epilog_code();
        ir.save();
        return 0;
    } else {
        // Write error message
        return -1;
    }
}

