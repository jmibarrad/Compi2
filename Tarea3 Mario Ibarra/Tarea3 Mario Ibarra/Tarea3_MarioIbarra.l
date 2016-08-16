%{
	#include "stdio.h"
	#include "sstream"
	#include "string"
	#define STRING_LITERAL 1
	#define TK_SEMICOLON 2
	using namespace std;
	stringstream ss;
%}

%option noyywrap
%x STRING_STATE

%%

";" return TK_SEMICOLON;
\" {ss.str(""); BEGIN(STRING_STATE);}
. {printf("Unexpected token: %s", yytext);}
<STRING_STATE>\\n {ss << endl;}
<STRING_STATE>\\t {ss << "\t";}
<STRING_STATE>\\\" {ss << "\"";}
<STRING_STATE>\\\\ {ss << "\\";}
<STRING_STATE>\\d[0-9]+ {string num = yytext;
						num = num.substr(2);
	ss << (char)atoi(num.c_str());}
<STRING_STATE>\" {BEGIN(INITIAL); return STRING_LITERAL;}
<STRING_STATE>. {ss << yytext;}

%%

int main (){

	int current_token = yylex();
	while(current_token){

		if(current_token == STRING_LITERAL){

			printf("%s", ss.str().c_str());
		}

		current_token = yylex();
	}
	return 0;
}


