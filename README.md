# Compi2
Repo Temporal

input: LS { statements = *($1); }
| 
;
LS: LS S { $$ = $1; $$->push_back($2); }
| S { $$ = new list<Statement*>; $$->push_back($1); }
;
S: TK_PRINT '(' E ')'{ $$ = new PrintStatement($3);}
| TK_ID '=' E {
$$ = new AssignStatement($3, 
static_cast<IdExpression*>($1),
&symbolTable);
}
| IF_STATEMENT 
;
IF_STATEMENT: TK_IF E ':' TK_INDENT LS TK_DEDENT ELSE_OPTIONAL {
$$ = new IfStatement($2,*$5,*$7);
}
;
ELSE_OPTIONAL: TK_ELSE ':' TK_INDENT LS TK_DEDENT { $$ = $4; }
| { $$ = new list<Statement *>; }
;
E: E '+' E { $$ = new AddExpression($1, $3); }
| E '*' E { $$ = new MultiplyExpression($1, $3); }
| E '<' E { $$ = new LessThanExpression($1, $3); }
| E '>' E { $$ = new GreaterThanExpression($1, $3); }
| E TK_LTE E { $$ = new LessOrEqualToExpression($1, $3); }
| E TK_GTE E { $$ = new GreaterOrEqualToExpression($1, $3); }
| E TK_ET E { $$ = new EqualToExpression($1, $3); }
| '(' E ')' { $$ = $2; }
| TK_NUM { $$ = $1; }
input: LS { statements = *($1); }
| 
;
LS: LS S { $$ = $1; $$->push_back($2); }
| S { $$ = new list<Statement*>; $$->push_back($1); }
;
S: TK_PRINT '(' E ')'{ $$ = new PrintStatement($3);}
| TK_ID '=' E {
$$ = new AssignStatement($3, 
static_cast<IdExpression*>($1),
&symbolTable);
}
| IF_STATEMENT 
;
IF_STATEMENT: TK_IF E ':' TK_INDENT LS TK_DEDENT ELSE_OPTIONAL {
$$ = new IfStatement($2,*$5,*$7);
}
;
ELSE_OPTIONAL: TK_ELSE ':' TK_INDENT LS TK_DEDENT { $$ = $4; }
| { $$ = new list<Statement *>; }
;
E: E '+' E { $$ = new AddExpression($1, $3); }
| E '*' E { $$ = new MultiplyExpression($1, $3); }
| E '<' E { $$ = new LessThanExpression($1, $3); }
| E '>' E { $$ = new GreaterThanExpression($1, $3); }
| E TK_LTE E { $$ = new LessOrEqualToExpression($1, $3); }
| E TK_GTE E { $$ = new GreaterOrEqualToExpression($1, $3); }
| E TK_ET E { $$ = new EqualToExpression($1, $3); }
| '(' E ')' { $$ = $2; }
| TK_NUM { $$ = $1; }
| TK_ID { $$ = $1 ;}
;

