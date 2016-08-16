bison --defines=tokens.h -o expr_parser.cpp expr.y
flex -o expr_lexer.cpp expr.l

g++ -c -o expr_lexer.o expr_lexer.cpp
g++ -c -o expr_parser.o expr_parser.cpp

g++ -o expr expr_lexer.o expr_parser.o
