%{
#include <stdio.h>
int line_num = 1;
int column_num = 1;
%}

%option noyywrap

%%

\n                  { ++line_num; column_num = 1; }
[ \t]+              { column_num += yyleng; } /* Handle tabs and spaces for accurate column counting */

"true"|"false"      { printf("%s\t\t line %d cols %d-%d is T_Boolean\n", yytext, line_num, column_num, column_num + (int)yyleng - 1); column_num += yyleng; }
"TRUE"|"FALSE"|"True"|"False"      { printf("%s\t\t line %d cols %d-%d is T_Identifier\n", yytext, line_num, column_num, column_num + (int)yyleng - 1); column_num += yyleng; }
[a-zA-Z_][a-zA-Z0-9_]* { printf("IDENTIFIER: %s\t line %d cols %d-%d\n", yytext, line_num, column_num, column_num + (int)yyleng - 1); column_num += yyleng; } /* Valid identifier */

[0-9]+(\.[0-9]*)?([Ee][+-]?[0-9]+)? {
    printf("%s\t\t line %d cols %d-%d is T_Double\n", yytext, line_num, column_num, column_num + (int)yyleng - 1);
    column_num += yyleng;
}

.|\n               { printf("UNKNOWN: %s\t line %d cols %d-%d\n", yytext, line_num, column_num, column_num + (int)yyleng - 1); column_num += yyleng; } /* Catch-all for characters not matched by other rules */

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
