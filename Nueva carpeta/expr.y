%{
#include <iostream>
#include "stdio.h"
#include <cstdlib>
#include <map>
#include <list>
#include "stack"

using namespace std;
#include "Expression.h"


int yylex();
void yyerror(const char *str);
list<Statement*> statementList;
list<Statement*> temp;

extern stack<int> tab_stack;

%}

%union{
	Expression* expr_t;
	Statement* stat_t;
	char* str_t;
	int int_t;
}

%token DEDENT
%token INDENT
%token<int_t> TK_NUM
%token TK_ELSE
%token TK_IF
%token TK_EQUAL
%token TK_GREATEREQUAL
%token TK_NOTEQUAL
%token TK_LESSEQUAL
%token TK_PRINT
%token TK_NEWLINE
%token TK_INDENT
%token<str_t> TK_ID
%nonassoc '>' '<' TK_EQUAL TK_LESSEQUAL TK_GREATEREQUAL TK_NOTEQUAL
%left '+'
%left '*'
%type<expr_t> E
%type<stat_t> DECLARATION
%type<stat_t> PRINT
%type<stat_t> IF
%type<stat_t> ELSE
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
		| IF            {statementList.push_back($1);}
;

DECLARATION: TK_ID '=' E TK_NEWLINE { 
								$$ = new Assignment($1, $3);
							 }
;

IF: TK_IF E ':' TK_NEWLINE INDENT SENTENCELIST DEDENT ELSE{ $$ = new If($2, temp, $8);}
	| TK_IF E ':' TK_NEWLINE INDENT SENTENCELIST DEDENT { $$ = new If($2, temp, NULL);}
;

ELSE: TK_ELSE ':'  TK_NEWLINE INDENT SENTENCELIST DEDENT {$$ = new Else(temp); temp.clear();}
;

PRINT: TK_PRINT E TK_NEWLINE {
							$$ = new Print($2);
						}
;

E: E '+' E {$$ = new AddExpr($1, $3);}
  | E '*' E {$$ = new MultExpr($1, $3);}
  | '(' E ')' { $$ = $2;}
  |E '>' E {$$ = new GreaterThan($1, $3);}
  | E '<' E {$$ = new LessThan($1, $3);}
  | E TK_NOTEQUAL E {$$ = new NotEqual($1, $3);}
  | E TK_EQUAL E {$$ = new Equal($1, $3);}
  | E TK_LESSEQUAL E {$$ = new LessEqual($1, $3);}
  | E TK_GREATEREQUAL E {$$ = new GreaterEqual($1, $3);}
  | TK_NUM { $$ =  new NumExpr($1);}
  | TK_ID {$$ = new IDExpr($1);}
;

%%

int main()
{
	tab_stack.push(0);
  yyparse();
  
  for (std::list<Statement*>::iterator it=statementList.begin(); it != statementList.end(); ++it)
    (*it)->evaluate();

  return 0;
}

void yyerror(const char *str)
{
    cout << str;
}