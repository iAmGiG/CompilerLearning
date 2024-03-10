%option noyywrap

%{
#include <stdio.h>
#include <string.h>
int line_num = 1;
int char_pos = 1; // Start column position at 1
%}

/* Helper macros for tracking positions and printing tokens */
%macro update_pos 0
{
    int i;
    for (i = 0; yytext[i] != '\0'; i++) {
        if (yytext[i] == '\n') {
            ++line_num;
            char_pos = 0;
        }
        ++char_pos;
    }
}
%macro print_token 1
{
    printf("%s\tline %d cols %d-%d is %s\n", yytext, line_num, char_pos - strlen(yytext), char_pos - 1, #1);
}

%%
\n { ++line_num; char_pos = 1; }
[ \t] { ++char_pos; }

/* Keywords */
"void"|"int"|"double"|"bool"|
"string"|"null"|"for"|"while"|
"if"|"else"|"return"|"break"|
"Print"|"ReadInteger"|"ReadLine" { update_pos(); print_token(T_KEYWORD); }

/* Identifiers */
[a-zA-Z][a-zA-Z0-9_]{0,30} { update_pos(); print_token(T_Identifier); }

/* Boolean constants */
"true"|"false" { update_pos(); print_token(T_Boolean); }

/* Integer constants */
0[Xx][0-9A-Fa-f]+ { update_pos(); print_token(T_HexInteger); }
[0-9]+ { update_pos(); print_token(T_DecimalInteger); }

/* Double constants */
[0-9]*"."[0-9]+([Ee][+-]?[0-9]+)? { update_pos(); print_token(T_Double); }
[0-9]+"."[Ee][+-]?[0-9]+ { update_pos(); print_token(T_Double); }

/* String constants */
"\""[^"\n]*"\"" { update_pos(); print_token(T_String); }

/* Operators and punctuation */
"+"|"-"|"*"|"/"|"%"|"<"|"<="|">"|">="|"="|"=="|"!="|
"&&"|"||"|"!"|";"|","|"."|"("|")"|"{""}" { update_pos(); print_token(T_Operator); }

%%
