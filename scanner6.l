%{
#include <stdio.h>
int line_num = 1;
int char_pos = 0; // Initialize char_pos to track start position of tokens
%}

%%

\n                                      { ++line_num; char_pos = 0; }
[ \t]                                    { /* Ignore tab for char position */ }
[ \t]+                                   { /* Ignore whitespace */ }

"void"                                  { printf("void\t\t line %d cols %d-%d is T_Void\n", line_num, char_pos + 1, char_pos + 4); }
"int"                                   { printf("int\t\t line %d cols %d-%d is T_Int\n", line_num, char_pos + 1, char_pos + 3); }
"double"                                { printf("double\t line %d cols %d-%d is T_Double\n", line_num, char_pos + 1, char_pos + 6); }
"string"                                { printf("string\t line %d cols %d-%d is T_String\n", line_num, char_pos + 1, char_pos + 6); }
"while"                                 { printf("while\t line %d cols %d-%d is T_While\n", line_num, char_pos + 1, char_pos + 5); }
"if"                                    { printf("if\t\t line %d cols %d-%d is T_If\n", line_num, char_pos + 1, char_pos + 2); }
"else"                                  { printf("else\t\t line %d cols %d-%d is T_Else\n", line_num, char_pos + 1, char_pos + 4); }
"return"                                { printf("return\t line %d cols %d-%d is T_Return\n", line_num, char_pos + 1, char_pos + 6); }
"break"                                 { printf("break\t line %d cols %d-%d is T_Break\n", line_num, char_pos + 1, char_pos + 5); }
"true"                                  { printf("true\t\t line %d cols %d-%d is T_BoolConstant (value = true)\n", line_num, char_pos + 1, char_pos + 4); }
"false"                                 { printf("false\t line %d cols %d-%d is T_BoolConstant (value = false)\n", line_num, char_pos + 1, char_pos + 5); }

"+"                                     { printf("+\t\t line %d cols %d-%d is '+'\n", line_num, char_pos + 1, char_pos + 1); }
"-"                                     { printf("-\t\t line %d cols %d-%d is '-'\n", line_num, char_pos + 1, char_pos + 1); }
"*"                                     { printf("*\t\t line %d cols %d-%d is '*'\n", line_num, char_pos + 1, char_pos + 1); }
"/"                                     { printf("/\t\t line %d cols %d-%d is '/'\n", line_num, char_pos + 1, char_pos + 1); }
"<"                                     { printf("<\t\t line %d cols %d-%d is '<'\n", line_num, char_pos + 1, char_pos + 1); }
">"                                     { printf(">\t\t line %d cols %d-%d is '>'\n", line_num, char_pos + 1, char_pos + 1); }
"="                                     { printf("=\t\t line %d cols %d-%d is '='\n", line_num, char_pos + 1, char_pos + 1); }
";"                                     { printf(";\t\t line %d cols %d-%d is ';'\n", line_num, char_pos + 1, char_pos + 1); }
","                                     { printf(",\t\t line %d cols %d-%d is ','\n", line_num, char_pos + 1, char_pos + 1); }
"!"                                     { printf("!\t\t line %d cols %d-%d is '!'\n", line_num, char_pos + 1, char_pos + 1); }
"{"                                     { printf("{\t\t line %d cols %d-%d is '{'\n", line_num, char_pos + 1, char_pos + 1); }
"}"                                     { printf("}\t\t line %d cols %d-%d is '}'\n", line_num, char_pos + 1, char_pos + 1); }
"("                                     { printf("(\t\t line %d cols %d-%d is '('\n", line_num, char_pos + 1, char_pos + 1); }
")"                                     { printf(")\t\t line %d cols %d-%d is ')'\n", line_num, char_pos + 1, char_pos + 1); }
"||"                                    { printf("||\t\t line %d cols %d-%d is T_Or\n", line_num, char_pos + 1, char_pos + 2); }
"<="                                    { printf("<=\t\t line %d cols %d-%d is T_LessEqual\n", line_num, char_pos + 1, char_pos + 2); }
">="                                    { printf(">=\t\t line %d cols %d-%d is T_GreaterEqual\n", line_num, char_pos + 1, char_pos + 2); }
"=="                                    { printf("==\t\t line %d cols %d-%d is T_Equal\n", line_num, char_pos + 1, char_pos + 2); }

(true|false)                             {
    printf("%s\tline %d cols %d-%d is T_Boolean\n", yytext, line_num, char_pos, char_pos + (int)strlen(yytext) - 1);
    char_pos += strlen(yytext);
}

([a-zA-Z][a-zA-Z0-9_]{0,30})             {
    printf("%s\tline %d cols %d-%d is T_Identifier\n", yytext, line_num, char_pos, char_pos + (int)strlen(yytext) - 1);
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

int main(int argc, char **argv)
{
    if (argc > 1)
    {
        FILE *file;
        file = fopen(argv[1], "r");
        if (!file)
        {
            perror(argv[1]);
            return 1;
        }
        yyin = file;
    }

    yylex();

    if (argc > 1)
    {
        fclose(yyin);
    }

    return 0;
}
