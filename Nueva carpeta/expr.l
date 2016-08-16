%{

class Expression;
class Statement;

#include <cstdio>
#include <cstdlib>
#include "tokens.h"
#include <string.h>
#include <stack>

using namespace std;

  int lines;
  stack <int> tab_stack;
%}

%option noyywrap

ID [a-zA-Z_]*[a-zA-Z][0-9a-zA-Z]*

%%
[ \t]

^"    " {
			int tabCOunt = yyleng / 4;

			if(tab_stack.top() < tabCOunt) {
				tab_stack.push(tabCOunt);
				return INDENT;

			} else if(tab_stack.top() > tabCOunt) {
				tab_stack.pop();
				return DEDENT;
			}
		}

[\n] {return TK_NEWLINE;}
"if" {return TK_IF;}
"else" {return TK_ELSE;}
"print" {return TK_PRINT;}
"+" { return '+'; }
"*" { return '*'; }
"(" { return '('; }
")" { return ')'; }
{ID} {yylval.str_t = strdup(yytext);  return TK_ID;}
[0-9]+ { yylval.int_t = atoi(yytext); return TK_NUM; }
":" {return ':';}
"==" {return TK_EQUAL;}
"<" {return '<';}
">" { return '>';}
"<=" {return TK_LESSEQUAL;}
">=" {return TK_GREATEREQUAL;}
"!=" {return TK_NOTEQUAL;}
"=" {return '=';}
. { printf("Error: Caracter no valido\n"); }

%%