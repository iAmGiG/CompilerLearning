%{
#include <stdio.h>
#include "tokens.h"
#define MAX_IDENTIFIER_LENGTH 31
int line_num = 1;
int column_num = 1;
%}

%option noyywrap

DIGIT    [0-9]
LETTER   [a-zA-Z]
IDENTIFIER ({LETTER}|_)({LETTER}|{DIGIT}|_){0,30}

%%

"void"      { return T_VOID; }
"int"       { return T_INT; }
"double"    { return T_DOUBLE; }
"string"    { return T_STRING; }
"while"     { return T_WHILE; }
"if"        { return T_IF; }
"else"      { return T_ELSE; }
"return"    { return T_RETURN; }
"break"     { return T_BREAK; }
"true"      { printf("%s\t\t line %d cols %d-%d is T_BoolConstant (value = true)\n", yytext, line_num, column_num, column_num + (int)yyleng - 1); column_num += yyleng; return T_BOOL_CONSTANT; }
"false"     { printf("%s\t\t line %d cols %d-%d is T_BoolConstant (value = false)\n", yytext, line_num, column_num, column_num + (int)yyleng - 1); column_num += yyleng; return T_BOOL_CONSTANT; }
"||"        { return T_OR; }
"<="        { return T_LESS_EQUAL; }
">="        { return T_GREATER_EQUAL; }
"=="        { return T_EQUAL; }

\n                  { ++line_num; column_num = 1; }
[ \t]+              { column_num += yyleng; } /* Handle tabs and spaces for accurate column counting */

"true"|"false"|"TRUE"|"FALSE"|"True"|"False" {
    printf("BOOLEAN: %s\t line %d cols %d-%d\n", yytext, line_num, column_num, column_num + (int)yyleng - 1);
    column_num += yyleng;
}

[a-zA-Z_][a-zA-Z0-9_]{0,30} {
    if (yyleng > MAX_IDENTIFIER_LENGTH) {
        printf("BAD_IDENTIFIER (too long): %s\t line %d cols %d-%d\n", yytext, line_num, column_num, column_num + (int)yyleng - 1);
    } else {
        printf("IDENTIFIER: %s\t line %d cols %d-%d\n", yytext, line_num, column_num, column_num + (int)yyleng - 1);
    }
    column_num += yyleng;
}

[0-9]+(\.[0-9]*)?([Ee][+-]?[0-9]+)? {
    printf("%s\t line %d cols %d-%d is T_Double\n", yytext, line_num, column_num, column_num + (int)yyleng - 1);
    column_num += yyleng;
}

.|\n {
    printf("UNKNOWN or INVALID TOKEN: %s\t line %d cols %d-%d\n", yytext, line_num, column_num, column_num + (int)yyleng - 1);
    column_num += yyleng;
}

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file;
        file = fopen(argv[1], "r");
        if (!file) {
            perror(argv[1]);
            return 1;
        }
        yyin = file;
    }
    yylex();
    if (argc > 1) {
        fclose(yyin);
    }
    return 0;
}

/*
int yywrap() {
    return 1;
}
*/