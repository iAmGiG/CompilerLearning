%{
/* C Declarations and Includes */
#include <stdio.h>
#include <stdlib.h>

/* Function Prototypes */
int yyerror(const char *s);
extern int yylex();
%}

/* Union for Values */
%union {
    int ival;
    double dval;
    char *sval;
}

/* Token Definitions */
%token <ival> INTEGER_LITERAL
%token <dval> DOUBLE_LITERAL
%token <sval> IDENTIFIER STRING_LITERAL
/* ... other token definitions ... */

/* Non-Terminal Types */
%type <ival> expression
/* ... other non-terminal types ... */

/* Start Symbol */
%start program

%%

/* Grammar Rules */

program : /* ... */
        ;

expression : INTEGER_LITERAL
           | expression '+' expression
           | expression '-' expression
           | expression '*' expression
           | expression '/' expression
           | '(' expression ')'
           /* ... other expression rules ... */
           ;

/* ... other grammar rules ... */

%%

/* C Code */

int yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
    return 0;
}

int main() {
    yyparse();
    return 0;
}