/* beautifier.l
 * Copyright (C) 2018 Rohit Kaushik <kaushikrohit325@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "symbol_table.h"

#define INDENT (4)

int line = 1;
int column = 4;
int paren = 0;
void write_string();
void write_char();
void write_oct();
void write_hex();
void write_int();
void write_fp();
void write_id();
void write_begin();
void write_end();
void write_open();
void write_close();
void write_bopen();
void write_bclose();
void write_sep();
void write_op();
void write_inline();
void write_comment();
void write_directive();
void error();
%}

quote   '
ditto   \"
back    \\
digit   0|1|2|3|4|5|6|7|8|9
exp    (e|E)([+-]?)({digit}+)
hex     {digit}|a|b|c|d|e|f|A|B|C|D|E|F
alpha  [a-zA-Z_]
ch     [^{back}{quote}{ditto}\n]


%%
{ditto}({back}{ch}|{back}{back}|{back}{quote}|{back}{ditto}|{ch}|{quote}){ditto}   write_string();
{quote}({back}{ch}|{back}{back}|{back}{quote}|{back}{ditto}|{ch}|{ditto}){quote}   write_char();
0[0-7]+                                                                            write_oct();
0(x|X){hex}+                                                                       write_hex();
{digit}+                                                                           write_int();
{digit}+\.{digit}*{exp}{0,1}                                                       write_fp();
{alpha}({alpha}|{digit})*(" "|"\n")?                                               write_id();
"{"                                                                                write_begin();
"}"                                                                                write_end();
"("                                                                                write_open();
")"                                                                                write_close();
"["                                                                                write_bopen();
"]"                                                                                write_bclose();
";"                                                                                write_sep();
"="|"+"|"-"|"*"|"/"|"++"|"--"|"+="|"-="|"*="|"/="|"%="|"&="|"|="|"^="|"?"|":"|","|"%"|"!"|"~"|"sizeof"|"&&"|"&"|"||"|">>"|"<<"|"<"|">"|"=="|">="|"<="|"!="|"->"     write_op();
"//"[^\n]*                                                                         write_inline();
"/*"                                                                               write_comment();
#[^\n]*                                                                            write_directive();
[\t\n\v\r\f]+                                                                      {;}
{ch}                                                                               error();
%%

void indent() { printf("\n%-*d", column, line++); }


void write_html_char(int c)
{ 
  switch (c)
  { 
    case '<': printf("&lt;"); break;
    case '>': printf("&gt;"); break;
    case '"': printf("&quot;"); break;
    case '&': printf("&amp;"); break;
    default: putchar(c);
  }
}

void write_html() 
{ 
  char *s = yytext;
  while (*s)
    write_html_char(*s++);
}

void write_string()
{
  printf("<font color='#FF0000'>");
  write_html();
  printf("</font>");
}

void write_char()
{
  printf("<font color='#00ffff'>");
  printf("<u>");
  write_html();
  printf("</u>");
  printf("</font>");
}

void write_oct()
{
  printf("<font color='#00ffff'>");
  printf("<i>");
  write_html();
  printf("</i>");
  printf("</font>");
}

void write_hex()
{
  printf("<font color='#00ffff'>");
  printf("<i>");
  write_html();
  printf("</i>");
  printf("</font>");
}

void write_int()
{
  printf("<font color='#00ffff'>");
  printf("<i>");
  write_html();
  printf("</i>");
  printf("</font>");
}

void write_fp()
{
  printf("<font color='#00ffff'>");
  write_html();
  printf("</font>");
}

void write_id()
{
  char *s = yytext;
  //printf("%s\n", s);
  int ends_with_space = 0;
  
  if(s[strlen(s) - 1] == ' ' || s[strlen(s) - 1] == '\n')
  {
    s[strlen(s)-1] = 0;
    ends_with_space = 1;
  }
    
    
  int id = lookup(s);
  //printf("\n%s %d\n", s,id);
  if(id == -1)
  {
    /* the id is not already present in the symbol table
     * here we need to create an anchor tag
     */
 	  insert(s,1);
	  printf("<a name='%s'>",s);
	  printf("<font color='#0000FF'>");
	  write_html();
	  if(ends_with_space)
	    putchar(' ');
	  printf("</font></a>");
  }
  else
  {
    /* first 32 elements in symbol table are keywords rest
     * are identifiers. The keywords need to be Blue and
     * boldface.
     */
     
    if(id < 32)
    {
      // Here goes the code for keywords
        printf("<font color='#0000FF'><b>");
        write_html();
    	  if(ends_with_space)
	        putchar(' ');
        printf("</b></font>");
    }
   else
   {
     // Here goes the code for already encoutered identifier
  	 printf("<a href='#%s'>",s);
     printf("<font color='#0000FF'>");
     write_html();
 	   if(ends_with_space)
	     putchar(' ');
     printf("</font></a>");
   }

  }
}

// begin {}-block
void write_begin()
{ 
  indent();
  write_html();
  column += INDENT;
  indent();
}

// end {}-block
void write_end()
{ 
  column -= INDENT;
  indent();
  write_html();
  indent();
}

// start opening paren
void write_open()
{ 
  write_html();
  paren++;
}

// close paren
void write_close()
{ 
  write_html();
  paren--;
}

void write_bopen()
{
  write_html();
  putchar(' ');
}

void write_bclose()
{
  write_html();
  putchar(' ');
}

// output ’;’, i.e. statement terminator or for()-expression separator
void write_sep()
{ 
  write_html();
  if (!paren)
    indent();
  else
    putchar(' ');
}

void write_op()
{
  char *s = yytext;
  printf("<font color='#000000'><b>");
  write_html();
  if(strcmp(s, ",") == 0)
  {
    /* use case in case of enum where ',' mean next line
     * enum{
     *   PROP_0,
     *   PROP_PREFERENCES_PANEL,
     *   LAST_PROP 
     * }
     */
    if(!paren)
    {
      indent();
    }
      
    else
      putchar(' ');
  }
  else if(strcmp(s, "=") == 0)
    putchar(' ');
    
  
  printf("</b></font>");
}

void write_inline()
{
	printf("<font color='#00FF00'>");
	write_html();
	printf("</font>");
  indent();
}

void write_comment()
{ 
  char c, c1;
  printf("<font color='#00FF00'>/*");
  loop:
    while ((c = input()) != '*' && c != 0)
      write_html_char(c);
    write_html_char('*');
    if ((c1 = input()) != '/' && c != 0)
      { 
        unput(c1);
        goto loop; 
      }
    if (c != 0)
      write_html_char(c1);
    printf("</font>");
    indent();
}

void write_directive()
{
  printf("<font color='#FF00FF'><b>");
  write_html();
  printf("</b></font>");
  indent();
}

void error()
{

}

int main(int argc, char *argv[])
{
  if(argc == 3)
  {
    FILE *fp;
    yyin = fopen(argv[1], "r");  
    fp = freopen(argv[2], "w",stdout);
    init(); // intitalise symbol-table
   
    printf("<html><pre>\n");
    indent();
    yylex();
    printf("\n</pre></html>\n");
    
    fclose(fp);
  }
  else
  {
    printf("Incorrect arguments, Usage as: a.out input.c output.html");
    return 0;
  }
  return 0;
}
