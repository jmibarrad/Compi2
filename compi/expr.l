%{
	class Expression;
	class Statement;
	
	#include <cstdio>
	#include <cstdlib>
	#include <iostream>
	#include "tokens.h"
	#include <stack>

	using namespace std;

	stack <int> mystack;
	int line = 0;
	int detabDebt = 0;
%}

%option noyywrap
%x NEWLINE

ID [a-zA-Z_][a-zA-Z0-9_]*

%%

%{

%}


<NEWLINE>^" "+ {
	BEGIN(INITIAL);
	if (yyleng > mystack.top()) {
        cout << "start_of_line 1: TK_INDENT " << mystack.top() << " " << yyleng << endl;
        mystack.push(yyleng);
        return TK_INDENT;
    } else if (yyleng < mystack.top()) {

        cout << "start_of_line 1: TK_DEDENT " << mystack.top() << endl;
        mystack.pop();
        return TK_DEDENT;
    } else if (yyleng == mystack.top()) {
    }
}


<NEWLINE>. {
	cout << "start_of_line 2: " << yytext << endl;	
	cout << "--curr stack: " << mystack.top() << endl;	
	unput(yytext[0]); 
	BEGIN(INITIAL);
	if (mystack.top() != 0) {
        mystack.pop();
        cout << "start_of_line 2: TK_DEDENT" << endl;
        return TK_DEDENT;
    }
}


[ \t]

":" {return ':';}

"=" {return '=';}
"+" {return '+';}
"*" {return '*';}
"(" {return '(';}
")" {return ')';}
";" {return ';';}

">" {return '>';}
"<" {return '<';}

">=" {return TK_MAYORIGUAL;}
"<=" {return TK_MENORIGUAL;}
"==" {return TK_IGUALDAD;}
"!=" {return TK_DESIGUALDAD;}

\n {
	line++;
	BEGIN(NEWLINE);
	}

"print" {return TK_PRINT;}
"if" {return TK_IF;}
"else" {return TK_ELSE;}

{ID} { yylval.STR_T = strdup(yytext); return TK_ID;}
[0-9]+ { yylval.NUM_T = atoi(yytext); return TK_NUM; }

. { printf("Error: Caracter no valido\n"); }

%%