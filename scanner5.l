%{
#include <stdio.h>
#include <string.h>

int line_num = 1;
int char_pos = 1; // Initialize character position
%}

%%

\n                                      { ++line_num; char_pos = 1; }
[ \t]                                    { ++char_pos; } /* Track whitespaces for accurate column counting */
[ \t]+                                   { /* Ignore multiple whitespaces */ }

(void|int|double|bool|string|null|for|while|if|else|return|break|Print|ReadInteger|ReadLine) {
    printf("%s\tline %d cols %d-%d is T_KEYWORD\n", yytext, line_num, char_pos, char_pos + (int)strlen(yytext) - 1);
    char_pos += strlen(yytext);
}

([a-zA-Z][a-zA-Z0-9_]{0,30})             {
    printf("%s\tline %d cols %d-%d is T_Identifier\n", yytext, line_num, char_pos, char_pos + (int)strlen(yytext) - 1);
    char_pos += strlen(yytext);
}

(true|false)                             {
    printf("%s\tline %d cols %d-%d is T_Boolean\n", yytext, line_num, char_pos, char_pos + (int)strlen(yytext) - 1);
    char_pos += strlen(yytext);
}

(0[Xx][0-9A-Fa-f]+)                      {
    printf("%s\tline %d cols %d-%d is T_HexInteger\n", yytext, line_num, char_pos, char_pos + (int)strlen(yytext) - 1);
    char_pos += strlen(yytext);
}

[0-9]+                                   {
    printf("%s\tline %d cols %d-%d is T_DecimalInteger\n", yytext, line_num, char_pos, char_pos + (int)strlen(yytext) - 1);
    char_pos += strlen(yytext);
}

[0-9]+"."[0-9]*([Ee][+-]?[0-9]+)?        {
    printf("%s\tline %d cols %d-%d is T_Double\n", yytext, line_num, char_pos, char_pos + (int)strlen(yytext) - 1);
    char_pos += strlen(yytext);
}

\"([^"\n]|\\.)*\"                        {
    printf("%s\tline %d cols %d-%d is T_String\n", yytext, line_num, char_pos, char_pos + (int)strlen(yytext) - 1);
    char_pos += strlen(yytext);
}

[+\-*/%<>=!&|;,.(){}]+                   {
    printf("%s\tline %d cols %d-%d is T_Operator\n", yytext, line_num, char_pos, char_pos + (int)strlen(yytext) - 1);
    char_pos += strlen(yytext);
}

.                                        { /* Catch-all for any unrecognized character */
    printf("*** Error line %d.\n", line_num);
    printf("*** Unrecognized char: '%c'\n", yytext[0]);
}

%%

int yywrap(void) {
    return 1;
}

int main(void) {
    yylex();
    return 0;
}
