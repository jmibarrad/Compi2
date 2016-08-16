%{
	#include <iostream>
	#include <cstdio>
	#include <map>
	#include <string.h>
	#include "Nodes.h"
	#include <stack>

	#define YYERROR_VERBOSE 1;

	using namespace std;

	int yylex();

	void yyerror(const char * str);


	extern stack <int> mystack;
	extern int line;
%}

%union {
	char* STR_T;
	int NUM_T;

	Expression * EXPR;
	Statement * STATE;
}



%token <NUM_T> TK_NUM
%token <STR_T> TK_ID
%token <STR_T> TK_PRINT

%token <STR_T> TK_IF
%token <STR_T> TK_ELSE

%token TK_INDENT
%token TK_DEDENT
%token TK_NEWLINE

%type <EXPR> e
%type <EXPR> expr
%type <EXPR> term
%type <EXPR> factor

%type<STATE> INSTRUCTION
%type<STATE> INSTRUCTION_LIST
%type<STATE> PRINT
%type<STATE> BLOCK

%type<STATE> IF
%type<STATE> ELSE

%nonassoc '>'
%nonassoc '<'
%nonassoc TK_MAYORIGUAL
%nonassoc TK_MENORIGUAL
%nonassoc TK_IGUALDAD
%nonassoc TK_DESIGUALDAD

%left '+'
%left '*'

%%


input: INSTRUCTION_LIST {$1->Evaluate();}
	;

INSTRUCTION_LIST: INSTRUCTION INSTRUCTION_LIST {$1->nextStatement = $2; $$ = $1;}
	 |INSTRUCTION {$$ = $1;}
	 ;

INSTRUCTION: PRINT
		   | TK_ID '=' e {$$ = new AssignStatement($1, $3);}
		   | IF
			;

BLOCK: TK_INDENT INSTRUCTION_LIST TK_DEDENT{$$ = $2;}

IF: TK_IF e ':' BLOCK ELSE { $$ = new IfStatement($2, $4, $5);}
	;

ELSE: TK_ELSE ':' BLOCK {$$ = $3;}
	|{return NULL;}
	;

PRINT: TK_PRINT e{ $$ = new PrintStatement($2);}
     ;


e:	 e '<' expr 			{ $$ = new LesserExpression($1,$3);}
	|e '>' expr 			{ $$ = new GreaterExpression($1,$3);}
	|e TK_MAYORIGUAL expr 	{ $$ = new GreaterOrEqualExpression($1,$3);}
	|e TK_MENORIGUAL expr 	{ $$ = new LesserOrEqualExpression($1,$3);}
	|e TK_IGUALDAD expr 	{ $$ = new EqualityExpression($1,$3);}
	|e TK_DESIGUALDAD expr 	{ $$ = new InequalityExpression($1,$3);}
	|expr 					{ $$ = $1;}
;


expr: expr '+' term 	{ $$ = new AddExpression($1,$3);}
    | term          	{ $$ = $1; }
;
 
term: term '*' factor   { $$ = new MultExpression($1,$3);}
    | factor            { $$ = $1; }
;
 
factor: '(' expr ')'    { $$ = $2; }
        | TK_NUM        { $$ = new NumExpression($1);}
        | TK_ID 		{ string str($1) ; $$ = new IdExpression(str);}
;

%%

int main(){
	mystack.push(0);
	yyparse();
	return 0;
}

void yyerror(const char *str){
	printf("Line %d: %s\n", line, str);
}