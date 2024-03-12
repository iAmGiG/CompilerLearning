#!/bin/bash

# Navigate to the parent directory to access the lexer file
cd "$(dirname "$0")/.."

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Name of the lexer file without extension
LEXER_NAME="scanner"
# Uncomment the next line if you're using Bison
# PARSER_NAME="parser"

# Output directory relative to the script location
OUTPUT_DIR="workdir"

# Check for Flex
if ! command_exists flex; then
    echo "Flex is not installed."
    echo "Please install Flex using your package manager. For example, on Ubuntu:"
    echo "sudo apt-get install flex"
    exit 1
fi

# Check for Bison (uncomment if Bison is needed)
# if ! command_exists bison ; then
#     echo "Bison is not installed."
#     echo "Please install Bison using your package manager. For example, on Ubuntu:"
#     echo "sudo apt-get install bison"
#     exit 1
# fi

# Use Flex to generate the scanner C code
flex -o "${OUTPUT_DIR}/${LEXER_NAME}.c" "${LEXER_NAME}.l"

# If using Bison, generate the parser C code (uncomment if Bison is needed)
# bison -d "${PARSER_NAME}.y"

# Compile the generated C code to an executable
gcc -o "${OUTPUT_DIR}/${LEXER_NAME}" "${OUTPUT_DIR}/${LEXER_NAME}.c" -lfl

# Uncomment the next line if Bison is used and you have parser code to compile along with the lexer
# gcc -o "${OUTPUT_DIR}/${LEXER_NAME}" "${OUTPUT_DIR}/${LEXER_NAME}.c" "${PARSER_NAME}.tab.c" -lfl

echo "${LEXER_NAME} has been compiled successfully."
