#!/bin/bash

# Name of the generated executable
EXECUTABLE_NAME="./scanner"

if [ ! -f "$EXECUTABLE_NAME" ]; then
    echo "Executable ${EXECUTABLE_NAME} not found. Please run build.sh first."
    exit 1
fi

# Execute the scanner
$EXECUTABLE_NAME

echo "${EXECUTABLE_NAME} execution completed."
