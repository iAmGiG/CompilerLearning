%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
int line_num = 1;
int char_pos = 1; // Initialize at 1 for the start of a new line
#define MAX_IDENTIFIER_LENGTH 31
#define MAX_STRING_LENGTH 1024
extern FILE *yyin;
FILE *output_file; // File pointer for the output file
char output_filename[256]; // Buffer for the output file name
%}

%x COMMENT

%%

\n  { ++line_num; char_pos = 1; }
[ \t]+ { char_pos += strlen(yytext); }

"#.*" {
    printf("\n*** Error line %d.\n*** Invalid # directive\n", line_num);
    char_pos = 1; 
}

"/*" {
    BEGIN(COMMENT);
}

<COMMENT>.|\n {
    // Ignored within comments
}

<COMMENT>"*/" {
    BEGIN(INITIAL);
}


"void"                                  { printf("void\t\t line %d cols %d-%d is T_Void\n", line_num, char_pos + 1, char_pos + 4); }
"int"                                   { printf("int\t\t line %d cols %d-%d is T_Int\n", line_num, char_pos + 1, char_pos + 3); }
"double"                                { printf("double\t\t line %d cols %d-%d is T_Double\n", line_num, char_pos + 1, char_pos + 6); }
"string"                                { printf("string\t\t line %d cols %d-%d is T_String\n", line_num, char_pos + 1, char_pos + 6); }
"while"                                 { printf("while\t\t line %d cols %d-%d is T_While\n", line_num, char_pos + 1, char_pos + 5); }
"if"                                    { printf("if\t\t line %d cols %d-%d is T_If\n", line_num, char_pos + 1, char_pos + 2); }
"else"                                  { printf("else\t\t line %d cols %d-%d is T_Else\n", line_num, char_pos + 1, char_pos + 4); }
"return"                                { printf("return\t\t line %d cols %d-%d is T_Return\n", line_num, char_pos + 1, char_pos + 6); }
"break"                                 { printf("break\t\t line %d cols %d-%d is T_Break\n", line_num, char_pos + 1, char_pos + 5); }
"true"                                  { printf("%-12s line %d cols %d-%d is T_BoolConstant (value = true)\n", "true", line_num, char_pos, (int)(char_pos + strlen(yytext) - 1)); char_pos += strlen(yytext); }
"false"                                 { printf("%-12s line %d cols %d-%d is T_BoolConstant (value = false)\n", "false", line_num, char_pos, (int)(char_pos + strlen(yytext) - 1)); char_pos += strlen(yytext); }

"+"                                     { printf("+\t\t line %d cols %d-%d is '+'\n", line_num, char_pos + 1, char_pos + 1); }
"-"                                     { printf("-\t\t line %d cols %d-%d is '-'\n", line_num, char_pos + 1, char_pos + 1); }
"*"                                     { printf("*\t\t line %d cols %d-%d is '*'\n", line_num, char_pos + 1, char_pos + 1); }
"/"                                     { printf("/\t\t line %d cols %d-%d is '/'\n", line_num, char_pos + 1, char_pos + 1); }
"<"                                     { printf("<\t\t line %d cols %d-%d is '<'\n", line_num, char_pos + 1, char_pos + 1); }
">"                                     { printf(">\t\t line %d cols %d-%d is '>'\n", line_num, char_pos + 1, char_pos + 1); }
";"                                     { printf(";\t\t line %d cols %d-%d is ';'\n", line_num, char_pos + 1, char_pos + 1); }
","                                     { printf(",\t\t line %d cols %d-%d is ','\n", line_num, char_pos + 1, char_pos + 1); }
"="                                     { printf("=\t\t line %d cols %d-%d is '='\n", line_num, char_pos, char_pos); ++char_pos; }
"!"                                     { printf("!\t\t line %d cols %d-%d is '!'\n", line_num, char_pos, char_pos); ++char_pos; }
"{"                                     { printf("{\t\t line %d cols %d-%d is '{'\n", line_num, char_pos + 1, char_pos + 1); }
"}"                                     { printf("}\t\t line %d cols %d-%d is '}'\n", line_num, char_pos + 1, char_pos + 1); }
"("                                     { printf("(\t\t line %d cols %d-%d is '('\n", line_num, char_pos + 1, char_pos + 1); }
")"                                     { printf(")\t\t line %d cols %d-%d is ')'\n", line_num, char_pos + 1, char_pos + 1); }
"||"                                    { printf("||\t\t line %d cols %d-%d is T_Or\n", line_num, char_pos + 1, char_pos + 2); }
"<="                                    { printf("<=\t\t line %d cols %d-%d is T_LessEqual\n", line_num, char_pos + 1, char_pos + 2); }
">="                                    { printf(">=\t\t line %d cols %d-%d is T_GreaterEqual\n", line_num, char_pos + 1, char_pos + 2); }
"=="                                    { printf("==\t\t line %d cols %d-%d is T_Equal\n", line_num, char_pos + 1, char_pos + 2); }
"&&"                                    { printf("&&\t\t line %d cols %d-%d is T_Operator\n", line_num, char_pos, char_pos + 1);  char_pos += 2;}
"&"                                     { printf("\n*** Error line %d.\n*** Unrecognized char: '%c'\n\n", line_num, '&'); char_pos++;}
"."                                     { printf(".\t\t line %d cols %d-%d is '.'\n", line_num, char_pos, char_pos); char_pos += 1; }

[a-zA-Z][a-zA-Z0-9_]* {
    if (strlen(yytext) > MAX_IDENTIFIER_LENGTH) {
        printf("*** Error line %d.\n*** Identifier too long: %s\n", line_num, yytext);
        // Truncate the identifier for display purposes
        char temp[MAX_IDENTIFIER_LENGTH + 1];
        strncpy(temp, yytext, MAX_IDENTIFIER_LENGTH);
        temp[MAX_IDENTIFIER_LENGTH] = '\0';
        printf("%s\t\t line %d cols %d-%d is T_Identifier (truncated to %s)\n", yytext, line_num, char_pos, char_pos + MAX_IDENTIFIER_LENGTH - 1, temp);
    } else {
        printf("%s\t\t line %d cols %d-%d is T_Identifier\n", yytext, line_num, char_pos, (int)(char_pos + strlen(yytext) - 1));
    }
    char_pos += strlen(yytext);
}

[0-9]+ {
    int value = atoi(yytext);
    printf("%s\t\t line %d cols %d-%d is T_IntConstant (value = %d)\n", yytext, line_num, char_pos, (int)(char_pos + strlen(yytext) - 1), value);
    char_pos += strlen(yytext);
}

[0-9]+(\.[0-9]*)?([Ee][+\-]?[0-9]+)? {
    double value = atof(yytext);
    printf("%s\t\t line %d cols %d-%d is T_DoubleConstant (value = %g)\n", yytext, line_num, char_pos, (int)(char_pos + strlen(yytext) - 1), value);
    char_pos += strlen(yytext);
}

\"(\\.|[^"\\])*\" {
    char stringValue[MAX_STRING_LENGTH];
    int i, j;
    for (i = 1, j = 0; yytext[i] != '"'; i++) {
        if (yytext[i] == '\\') {
            switch (yytext[++i]) {
                case 'n': stringValue[j++] = '\n'; break;
                case 't': stringValue[j++] = '\t'; break;
                // Handle other escape sequences as needed
                default: stringValue[j++] = yytext[i];
            }
        } else {
            stringValue[j++] = yytext[i];
        }
    }
    stringValue[j] = '\0';
    printf("%s\t\t line %d cols %d-%d is T_StringConstant (value = \"%s\")\n", yytext, line_num, char_pos, (int)(char_pos + strlen(yytext) - 1), stringValue);
    char_pos += strlen(yytext);
}

[+\-*/%<>\|;,.(){}]+ {
    for(int i = 0; yytext[i] != '\0'; ++i) {
        printf("%c\t\t line %d cols %d-%d is T_Operator\n", yytext[i], line_num, char_pos, char_pos);
        ++char_pos;
    }
}

[\$\@\^\~\`\?]+ {
    printf("\n*** Error line %d.\n", line_num);
    for (int i = 0; yytext[i] != '\0'; i++) {
        if (i > 0) printf("\n");
        printf("*** Unrecognized char: '%c'\n", yytext[i]);
        char_pos++;
    }
    printf("\n");
}

. { printf("\n*** Error line %d.\n*** Unrecognized char: '%c'\n\n", line_num, yytext[0]); char_pos++; }

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *input_file = fopen(argv[1], "r");
        if (!input_file) {
            fprintf(stderr, "Could not open %s\n", argv[1]);
            return 1;
        }
        yyin = input_file;

        char *file_name = strrchr(argv[1], '/');
        file_name = file_name ? file_name + 1 : argv[1];
        char file_base[256];
        strncpy(file_base, file_name, sizeof(file_base));
        file_base[sizeof(file_base) - 1] = '\0';
        char *file_extension = strrchr(file_base, '.');
        if (file_extension != NULL) {
            *file_extension = '\0'; // Remove the extension
        }

        snprintf(output_filename, sizeof(output_filename), "./test_output/%s.out", file_base);

        output_file = fopen(output_filename, "w");
        if (!output_file) {
            fprintf(stderr, "Could not create %s\n", output_filename);
            fclose(input_file); // Make sure to close the input file before returning
            return 1;
        }

        // If using printf in lexer actions, you must redirect stdout here
        // freopen(output_filename, "w", stdout);

        yylex();

        fclose(input_file);
        fclose(output_file); // Close the output file after writing
        // If you redirected stdout, consider how to restore it here

        printf("Output saved to %s\n", output_filename);
    } else {
        printf("Usage: %s input_file\n", argv[0]);
        return 1;
    }

    return 0;
}