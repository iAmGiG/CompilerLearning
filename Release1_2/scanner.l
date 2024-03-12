%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

#define MAX_IDENTIFIER_LENGTH 31
#define MAX_STRING_LENGTH 1024
#define OUTPUT_FILENAME_SIZE 256
#define OUTPUT_PATH "./test_output/"
#define EXTENSION ".out"

int line_num = 1;
int char_pos = 1; // Initialize at 1 for the start of a new line
extern FILE *yyin;
FILE *output_file;
char output_filename[OUTPUT_FILENAME_SIZE];
%}

%x COMMENT

%%

\n  { ++line_num; char_pos = 1; }
[ \t]+ { char_pos += strlen(yytext); }

"#.*" {
    fprintf(output_file,"\n*** Error line %d.\n*** Invalid # directive\n", line_num);
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


"void"                                  { fprintf(output_file,"void\t\t line %d cols %d-%d is T_Void\n", line_num, char_pos + 1, char_pos + 4); }
"int"                                   { fprintf(output_file,"int\t\t line %d cols %d-%d is T_Int\n", line_num, char_pos + 1, char_pos + 3); }
"double"                                { fprintf(output_file,"double\t\t line %d cols %d-%d is T_Double\n", line_num, char_pos + 1, char_pos + 6); }
"string"                                { fprintf(output_file,"string\t\t line %d cols %d-%d is T_String\n", line_num, char_pos + 1, char_pos + 6); }
"while"                                 { fprintf(output_file,"while\t\t line %d cols %d-%d is T_While\n", line_num, char_pos + 1, char_pos + 5); }
"if"                                    { fprintf(output_file,"if\t\t line %d cols %d-%d is T_If\n", line_num, char_pos + 1, char_pos + 2); }
"else"                                  { fprintf(output_file,"else\t\t line %d cols %d-%d is T_Else\n", line_num, char_pos + 1, char_pos + 4); }
"return"                                { fprintf(output_file,"return\t\t line %d cols %d-%d is T_Return\n", line_num, char_pos + 1, char_pos + 6); }
"break"                                 { fprintf(output_file,"break\t\t line %d cols %d-%d is T_Break\n", line_num, char_pos + 1, char_pos + 5); }
"true"                                  { fprintf(output_file,"%-12s line %d cols %d-%d is T_BoolConstant (value = true)\n", "true", line_num, char_pos, (int)(char_pos + strlen(yytext) - 1)); char_pos += strlen(yytext); }
"false"                                 { fprintf(output_file,"%-12s line %d cols %d-%d is T_BoolConstant (value = false)\n", "false", line_num, char_pos, (int)(char_pos + strlen(yytext) - 1)); char_pos += strlen(yytext); }

"+"                                     { fprintf(output_file,"+\t\t line %d cols %d-%d is '+'\n", line_num, char_pos + 1, char_pos + 1); }
"-"                                     { fprintf(output_file,"-\t\t line %d cols %d-%d is '-'\n", line_num, char_pos + 1, char_pos + 1); }
"*"                                     { fprintf(output_file,"*\t\t line %d cols %d-%d is '*'\n", line_num, char_pos + 1, char_pos + 1); }
"/"                                     { fprintf(output_file,"/\t\t line %d cols %d-%d is '/'\n", line_num, char_pos + 1, char_pos + 1); }
"<"                                     { fprintf(output_file,"<\t\t line %d cols %d-%d is '<'\n", line_num, char_pos + 1, char_pos + 1); }
">"                                     { fprintf(output_file,">\t\t line %d cols %d-%d is '>'\n", line_num, char_pos + 1, char_pos + 1); }
";"                                     { fprintf(output_file,";\t\t line %d cols %d-%d is ';'\n", line_num, char_pos + 1, char_pos + 1); }
","                                     { fprintf(output_file,",\t\t line %d cols %d-%d is ','\n", line_num, char_pos + 1, char_pos + 1); }
"="                                     { fprintf(output_file,"=\t\t line %d cols %d-%d is '='\n", line_num, char_pos, char_pos); ++char_pos; }
"!"                                     { fprintf(output_file,"!\t\t line %d cols %d-%d is '!'\n", line_num, char_pos, char_pos); ++char_pos; }
"{"                                     { fprintf(output_file,"{\t\t line %d cols %d-%d is '{'\n", line_num, char_pos + 1, char_pos + 1); }
"}"                                     { fprintf(output_file,"}\t\t line %d cols %d-%d is '}'\n", line_num, char_pos + 1, char_pos + 1); }
"("                                     { fprintf(output_file,"(\t\t line %d cols %d-%d is '('\n", line_num, char_pos + 1, char_pos + 1); }
")"                                     { fprintf(output_file,")\t\t line %d cols %d-%d is ')'\n", line_num, char_pos + 1, char_pos + 1); }
"||"                                    { fprintf(output_file,"||\t\t line %d cols %d-%d is T_Or\n", line_num, char_pos + 1, char_pos + 2); }
"<="                                    { fprintf(output_file,"<=\t\t line %d cols %d-%d is T_LessEqual\n", line_num, char_pos + 1, char_pos + 2); }
">="                                    { fprintf(output_file,">=\t\t line %d cols %d-%d is T_GreaterEqual\n", line_num, char_pos + 1, char_pos + 2); }
"=="                                    { fprintf(output_file,"==\t\t line %d cols %d-%d is T_Equal\n", line_num, char_pos + 1, char_pos + 2); }
"&&"                                    { fprintf(output_file,"&&\t\t line %d cols %d-%d is T_Operator\n", line_num, char_pos, char_pos + 1);  char_pos += 2;}
"&"                                     { fprintf(output_file,"\n*** Error line %d.\n*** Unrecognized char: '%c'\n\n", line_num, '&'); char_pos++;}
"."                                     { fprintf(output_file,".\t\t line %d cols %d-%d is '.'\n", line_num, char_pos, char_pos); char_pos += 1; }

[a-zA-Z][a-zA-Z0-9_]* {
    if (strlen(yytext) > MAX_IDENTIFIER_LENGTH) {
        fprintf(output_file,"*** Error line %d.\n*** Identifier too long: %s\n", line_num, yytext);
        // Truncate the identifier for display purposes
        char temp[MAX_IDENTIFIER_LENGTH + 1];
        strncpy(temp, yytext, MAX_IDENTIFIER_LENGTH);
        temp[MAX_IDENTIFIER_LENGTH] = '\0';
        fprintf(output_file,"%s\t\t line %d cols %d-%d is T_Identifier (truncated to %s)\n", yytext, line_num, char_pos, char_pos + MAX_IDENTIFIER_LENGTH - 1, temp);
    } else {
        fprintf(output_file,"%s\t\t line %d cols %d-%d is T_Identifier\n", yytext, line_num, char_pos, (int)(char_pos + strlen(yytext) - 1));
    }
    char_pos += strlen(yytext);
}

[0-9]+ {
    int value = atoi(yytext);
    fprintf(output_file,"%s\t\t line %d cols %d-%d is T_IntConstant (value = %d)\n", yytext, line_num, char_pos, (int)(char_pos + strlen(yytext) - 1), value);
    char_pos += strlen(yytext);
}

[0-9]+(\.[0-9]*)?([Ee][+\-]?[0-9]+)? {
    double value = atof(yytext);
    fprintf(output_file,"%s\t\t line %d cols %d-%d is T_DoubleConstant (value = %g)\n", yytext, line_num, char_pos, (int)(char_pos + strlen(yytext) - 1), value);
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
    fprintf(output_file,"%s\t\t line %d cols %d-%d is T_StringConstant (value = \"%s\")\n", yytext, line_num, char_pos, (int)(char_pos + strlen(yytext) - 1), stringValue);
    char_pos += strlen(yytext);
}

[+\-*/%<>\|;,.(){}]+ {
    for(int i = 0; yytext[i] != '\0'; ++i) {
        fprintf(output_file,"%c\t\t line %d cols %d-%d is T_Operator\n", yytext[i], line_num, char_pos, char_pos);
        ++char_pos;
    }
}

[\$\@\^\~\`\?]+ {
    fprintf(output_file,"\n*** Error line %d.\n", line_num);
    for (int i = 0; yytext[i] != '\0'; i++) {
        if (i > 0) fprintf(output_file,"\n");
        fprintf(output_file,"*** Unrecognized char: '%c'\n", yytext[i]);
        char_pos++;
    }
    fprintf(output_file,"\n");
}

. { fprintf(output_file,"\n*** Error line %d.\n*** Unrecognized char: '%c'\n\n", line_num, yytext[0]); char_pos++; }

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *input_file;
        input_file = fopen(argv[1], "r");
        if (!input_file) {
            fprintf(stderr, "Could not open %s\n", argv[1]);
            return 1;
        }
        yyin = input_file;

        char *file_name = strrchr(argv[1], '/');
        if (file_name == NULL) {
            file_name = argv[1];
        } else {
            file_name++; // Move past the '/'
        }
        char *file_extension = strrchr(file_name, '.');
        if (file_extension != NULL) {
            *file_extension = '\0'; // Remove the extension
        }

        snprintf(output_filename, sizeof(output_filename), "./test_output/%s.out", file_name);
 
        // Open the output file for writing
        output_file = fopen(output_filename, "w");
        if (!output_file) {
            fprintf(stderr, "Could not create %s\n", output_filename);
            return 1;
        }
    } else {
        printf("Usage: %s input_file\n", argv[0]);
        return 1;
    }
 
    yylex();
 
    if (argc > 1) {
        fclose(yyin);
        fclose(output_file); // Close the output file after writing
 
        printf("Output saved to %s\n", output_filename);
    }
 
    return 0;
}