%{
#include <stdio.h>
#define IDENTIFIER 1
#define INTEGER_LITERAL 2
#define DOUBLE_LITERAL 3
#define STRING_LITERAL 4
#define BOOLEAN_LITERAL 5
// Add definitions for other tokens
%}

%%

"void"|"int"|"double"|"bool"|"string"|"null"|"for"|"while"|"if"|"else"|"return"|"break"|"Print"|"ReadInteger"|"ReadLine" { printf("KEYWORD: %s\n", yytext); }
[truefalse]+                                                                         { printf("BOOLEAN: %s\n", yytext); return BOOLEAN_LITERAL; }
0x[0-9a-fA-F]+                                                                       { printf("HEX_INTEGER: %s\n", yytext); return INTEGER_LITERAL; }
[0-9]+                                                                               { printf("INTEGER: %s\n", yytext); return INTEGER_LITERAL; }
[0-9]+\.[0-9]*([eE][-+]?[0-9]+)?                                                     { printf("DOUBLE: %s\n", yytext); return DOUBLE_LITERAL; }
\"[^"\n]*\"                                                                          { printf("STRING: %s\n", yytext); return STRING_LITERAL; }
[a-zA-Z][a-zA-Z0-9_]*                                                                { printf("IDENTIFIER: %s\n", yytext); return IDENTIFIER; }
[ \t\n]+                                                                             { /* Ignore whitespace */ }
.                                                                                    { printf("UNKNOWN: %s\n", yytext); }

%%

int main(int argc, char **argv) {
    yyin = fopen(argv[1], "r");
    yylex();
    fclose(yyin);
    return 0;
}

int yywrap() {
    return 1;
}
