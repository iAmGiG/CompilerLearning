# Scanner Project

## Overview

This project contains a Flex lexer (`scanner.l`), which is compiled into an executable scanner tool named `scanner`. The tool is designed to process input according to the lexing rules defined in `scanner.l`.

## Prerequisites

- Flex
- GCC (GNU Compiler Collection)

Make sure you have Flex and GCC installed on your system.

## Dependencies

This scanner project relies on Flex for generating the lexical analyzer. If you're using Bison for parsing, that will be a dependency as well. Here are the instructions for installing these dependencies on Ubuntu/Linux:

## Installing Flex

Flex can be easily installed on Ubuntu and other Debian-based systems using the following command:

```bash
sudo apt-get update
sudo apt-get install flex
```

## Installing Bison

If your project uses Bison, install it with:

```bash
sudo apt-get install bison
```

## Verifying Installation

After installation, you can verify that Flex and Bison are correctly installed by checking their versions:

```bash
flex --version
bison --version
```

If both commands output version information, you're ready to proceed with building and running the scanner.

### Note on Cross-Platform Compatibility

If users of your scanner might be on different operating systems, consider providing installation instructions for those systems as well. For example, on macOS, Flex and Bison can be installed using Homebrew:

### Installing on macOS

You can use Homebrew to install Flex and Bison on macOS:

```bash
brew install flex bison
```

**Note** that macOS comes with an older version of Bison, so you might need to link the newly installed version if required by your project.

### Building the Project

To build the scanner executable, run the `build.sh` script from the terminal:

```bash
./build.sh
```

1. A function command_exists to check if a given command is available in the system's PATH.
2. Checks for the existence of flex (and bison if you uncomment the relevant sections), providing instructions for installation if these are not found.
3. Proceeds with the compilation process only if all necessary tools are present.

**Note** This script generates an executable named scanner (or another name if you've customized the script).

### Running the Scanner

After building the scanner, you can run it using the exec.sh script. This script allows you to specify an input file for the scanner to analyze.

To analyze a specific file:

```bash
./exec.sh samples/{test}.frag
```

If no file is specified, the scanner will wait for input from standard input (stdin).

### Customizing the Build

The build.sh script uses default names for the source and output files. You can modify the script to change these names according to your project's needs.

#### Troubleshooting

If you encounter any issues with building or running the scanner, ensure Flex and GCC are correctly installed and accessible from your command line. Additionally, check the permissions of the .sh scripts and make them executable if necessary:

```bash
chmod +x build.sh exec.sh
```

```makefile

### build.sh

Here's a reminder of the content for `build.sh`, simplified for clarity:

```bash
#!/bin/bash

LEXER_NAME="scanner"
flex -o "${LEXER_NAME}.c" "${LEXER_NAME}.l"
gcc -o "${LEXER_NAME}" "${LEXER_NAME}.c" -lfl

echo "${LEXER_NAME} has been compiled successfully."
```

And for exec.sh, enabling execution with or without an input file:

```bash
#!/bin/bash

if [ ! -f "scanner" ]; then
    echo "Executable 'scanner' not found. Please run build.sh first."
    exit 1
fi

if [ "$#" -eq 0 ]; then
    echo "No input file specified. Waiting for input from stdin..."
    ./scanner
else
    ./scanner < "$1"
fi
```

Make sure to replace "scanner" with the actual name of your executable if you've chosen a different name.

#### Final Steps

- Place these texts in their respective files within your project directory.
- Make sure to adjust any paths, filenames, or specific instructions based on the actual setup and requirements of your scanner project.
- Don't forget to mark your .sh scripts as executable using chmod +x build.sh exec.sh.
