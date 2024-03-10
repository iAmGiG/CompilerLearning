#!/bin/bash

# Name of the lexer file without extension
LEXER_NAME="scanner5"

# Use Flex to generate the scanner C code
flex -o "${LEXER_NAME}.c" "${LEXER_NAME}.l"

# Compile the generated C code to an executable
gcc -o "${LEXER_NAME}" "${LEXER_NAME}.c" -lfl

echo "${LEXER_NAME} has been compiled successfully."
