%{
	#include "stdio.h"
	#include "tokens.h"
	int row = 1;
	int column;
%}

%option noyywrap
%option yylineno

Number [0-9]
ID [a-zA-Z_][0-9a-zA-Z]*
SUM_OPERAND [+]
SUB_OPERAND [-]
MULT_OPERAND [*]
DIV_OPERAND [/]
LEFT_PARENTHESIS [(]
RIGHT_PARENTHESIS [)]
EQUAL [=]
IGNORE [\t]

%%
\n row++;
[ ] /*none*/
"//".*  /*none*/
"print" return KW_PRINT;
[IGNORE] /*none*/
{Number}+ 	return NUMBER_LITERAL;
{ID} 	return TK_VAR;
{SUM_OPERAND}  	 return TK_SUM;
{SUB_OPERAND}  	 return TK_SUB;
{MULT_OPERAND}   return TK_MULT;
{DIV_OPERAND}   return TK_DIV;
{EQUAL}  	  return TK_EQUAL;
{LEFT_PARENTHESIS} return TK_LEFT_PARENTHESIS;
{RIGHT_PARENTHESIS}  return TK_RIGHT_PARENTHESIS;
"," return TK_COMMA;
"\"".*"\"" return STRING_LITERAL;
. printf("Unexpected token: %s at row: %d, column: %d .\n", yytext, row, column);	

%%

void main(){

	int current_token = yylex();
	while (current_token){
		printf("Lexeme: %s | Token Type: %d \n", yytext, current_token);
		current_token = yylex();
	}
}

