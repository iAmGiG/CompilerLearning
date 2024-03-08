%{
#include <stdio.h>
#include <string.h>

#define MAX_IDENTIFIER_LENGTH 31
#define MAX_INT_CONSTANT_VALUE 2147483647  /* 2^31 - 1 */

int line_num = 1;
int column_num = 1;
%}

%option noyywrap

DIGIT    [0-9]
LETTER   [a-zA-Z]
IDENTIFIER  ({LETTER}|_)({LETTER}|{DIGIT}|_){0,30}

%%

{IDENTIFIER} {
    if (yyleng > MAX_IDENTIFIER_LENGTH) {
        printf("*** Identifier too long: \"%s\"\n", yytext);
        printf("%.*s line %d cols %d-%d is T_Identifier (truncated to %.*s)\n", MAX_IDENTIFIER_LENGTH, yytext, line_num, column_num, column_num + MAX_IDENTIFIER_LENGTH - 1, MAX_IDENTIFIER_LENGTH, yytext);
    } else {
        printf("%s line %d cols %d-%d is T_Identifier\n", yytext, line_num, column_num, column_num + (int)yyleng - 1);
    }
    column_num += yyleng;
}

{DIGIT}+ {
    int value = atoi(yytext);
    if (value > MAX_INT_CONSTANT_VALUE) {
        printf("*** Integer constant too large: %s\n", yytext);
    }
    printf("%s line %d cols %d-%d is T_IntConstant (value = %d)\n", yytext, line_num, column_num, column_num + (int)yyleng - 1, value);
    column_num += yyleng;
}

\n {
    ++line_num;
    column_num = 1;
}

[ \t]+ {
    column_num += yyleng;
}

. {
    printf("%s line %d cols %d-%d is '%s'\n", yytext, line_num, column_num, column_num, yytext);
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