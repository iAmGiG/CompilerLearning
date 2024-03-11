[0-9]+(\.[0-9]*)?([Ee][+\-]?[0-9]+)? {
    char* ptr = yytext;
    char* end = yytext + strlen(yytext);

    // Initially assume the entire token might be a double
    int isDouble = 0;
    char* e_ptr = strchr(ptr, 'E') ? strchr(ptr, 'E') : strchr(ptr, 'e');
    if (e_ptr != NULL) {
        // Check if the pattern after E/e is a valid exponent
        char* next_char = e_ptr + 1;
        if (*next_char == '+' || *next_char == '-') next_char++;
        if (isdigit(*next_char)) {
            isDouble = 1; // Valid exponent pattern found
        }
    }

    if (!isDouble && e_ptr != NULL) {
        // Handle the part before 'E' or 'e' as integer
        char temp[256] = {0};
        strncpy(temp, ptr, e_ptr - ptr);
        printf("%s\t\t line %d cols %d-%d is T_IntConstant (value = %s)\n", temp, line_num, char_pos, (int)(char_pos + (e_ptr - ptr) - 1), temp);
        char_pos += (e_ptr - ptr);

        // Handle 'E' or 'e' as an identifier
        printf("%c\t\t line %d cols %d-%d is T_Identifier\n", *e_ptr, line_num, char_pos, char_pos);
        char_pos++;

        // Process the rest if it's '+' or '-'
        ptr = e_ptr + 1;
        if (*ptr == '+' || *ptr == '-') {
            printf("%c\t\t line %d cols %d-%d is T_Operator\n", *ptr, line_num, char_pos, char_pos);
            ptr++; // Move past the operator
            char_pos++;
        }

        // The rest should be an integer
        printf("%s\t\t line %d cols %d-%d is T_IntConstant (value = %s)\n", ptr, line_num, char_pos, (int)(char_pos + strlen(ptr) - 1), ptr);
        char_pos += strlen(ptr);
    } else {
        // Handle as a double constant or a simple integer
        if (strchr(yytext, '.') != NULL || e_ptr != NULL) {
            // It's a double
            double value = atof(yytext);
            printf("%s\t\t line %d cols %d-%d is T_DoubleConstant (value = %g)\n", yytext, line_num, char_pos, (int)(char_pos + strlen(yytext) - 1), value);
            char_pos += strlen(yytext);
        } else {
            // It's a simple integer
            printf("%s\t\t line %d cols %d-%d is T_IntConstant (value = %s)\n", yytext, line_num, char_pos, (int)(char_pos + strlen(yytext) - 1), yytext);
            char_pos += strlen(yytext);
        }
    }
}