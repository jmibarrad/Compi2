%{
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include "map"
#include "tr1/unordered_map"

using namespace std;

int yylex();
void yyerror(const char *str);
map <string, int> table_symbol;

%}

%union{
	int int_t;
	char* str_t;
}

%token<int_t> TK_NUM
%token TK_PRINT
%token<str_t> TK_ID
%left '+'
%left '*'
%type<int_t> E
%start SENTENCELIST
%%

SENTENCELIST: SENTENCE SENTENCELIST
			| SENTENCE
;

SENTENCE: DECLARATION
		| PRINT
		|
;

DECLARATION: TK_ID '=' E ';' {string my_string($1);	table_symbol[my_string] = $3;}
;

PRINT: TK_PRINT E ';' {cout << $2 << endl;}
;

E: E '+' E { $$ = $1 + $3; }
  | E '*' E { $$ = $1 * $3; }
  | '(' E ')' { $$ = $2; }
  | TK_NUM { $$ = $1; }
  | TK_ID {$$ = table_symbol[$1];}
;

%%

int main()
{
  yyparse();
  
  return 0;
}

void yyerror(const char *str)
{
    cout << str;
}