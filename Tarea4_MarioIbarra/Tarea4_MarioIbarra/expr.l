%{

#include <cstdio>
#include <cstdlib>
#include "tokens.h"
#include <string.h>

  int lines;

%}

%option noyywrap
ID [a-zA-Z_]*[a-zA-Z][0-9a-zA-Z]*

%%
[ ] 
[\n\t\r]
"print" {return TK_PRINT;}
"+" { return '+'; }
"*" { return '*'; }
"(" { return '('; }
")" { return ')'; }
{ID} {yylval.str_t = strdup(yytext);  return TK_ID;}
[0-9]+ { yylval.int_t = atoi(yytext); return TK_NUM; }
";" {return ';';}
"=" {return '=';}
. { printf("Error: Caracter no valido\n"); }

%%