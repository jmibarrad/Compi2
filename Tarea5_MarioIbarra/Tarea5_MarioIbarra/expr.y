%{
#include "Expression.h"
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include "map"
#include "list"


using namespace std;

int yylex();
void yyerror(const char *str);
list<Statement*> statementList;

%}

%union{
	Expression* expr_t;
	Statement* stat_t;
	char* str_t;
	int int_t;
}

%token<int_t> TK_NUM
%token TK_PRINT
%token<str_t> TK_ID
%left '+'
%left '*'
%type<expr_t> E
%type<stat_t> DECLARATION
%type<stat_t> PRINT
%type<stat_t> SENTENCELIST
%type<stat_t> SENTENCE


%start input
%%

input: SENTENCELIST
		|
;

SENTENCELIST: SENTENCELIST SENTENCE
			| SENTENCE
;

SENTENCE: DECLARATION 	{statementList.push_back($1);}
		| PRINT 		{statementList.push_back($1);}
;

DECLARATION: TK_ID '=' E ';' { 
								$$ = new Assignment($1, $3);
							 }
;

PRINT: TK_PRINT E ';' 	{
							$$ = new Print($2);
						}
;

E: E '+' E {$$ = new AddExpr($1, $3);}
  | E '*' E {$$ = new MultExpr($1, $3);}
  | '(' E ')' { $$ = $2;}
  | TK_NUM { $$ =  new NumExpr($1);}
  | TK_ID {$$ = new IDExpr($1);}
;

%%

int main()
{
  yyparse();
  
  for (std::list<Statement*>::iterator it=statementList.begin(); it != statementList.end(); ++it)
    (*it)->evaluate();

  return 0;
}

void yyerror(const char *str)
{
    cout << str;
}