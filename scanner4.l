%option noyywrap

%{
#include <stdio.h>
#include <string.h>

int line_num = 1;
int start_pos = 1;
int char_pos = 0;

void update_position(const char *text) {
    for (int i = 0; text[i] != '\0'; i++, char_pos++) {
        if (text[i] == '\n') {
            line_num++;
            char_pos = 0;
            start_pos = 1;
        }
    }
}

#define TOKEN_INFO(token) printf("%s         line %d cols %d-%d is " #token "\n", yytext, line_num, start_pos, start_pos + (int)strlen(yytext) - 1); start_pos += (int)strlen(yytext);
%}

%%
\n { line_num++; char_pos = 0; start_pos = 1; }
. { char_pos++; }

/* Adjust token patterns here */
/* Example pattern for an identifier, including special handling for certain boolean values */
TRUE|FALSE|True|False|[a-zA-Z][a-zA-Z0-9_]{0,30} {
    update_position(yytext);
    TOKEN_INFO(T_Identifier);
}

/* Add other token patterns as needed, each followed by the TOKEN_INFO macro call */

%%
