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

### Expanded Output File Handling

The scanner project is designed with a focus on user convenience and automated file management. When running the scanner, the output is neatly organized into a designated output directory, ensuring that all generated files are easy to find and manage. Here's what you need to know about the output directory and its contents:

#### Output Directory Structure

- **Default Location**: By default, the output files are saved in `./test_output/` relative to where the scanner is executed. This directory is automatically created if it does not exist when the scanner is run.
  
- **Customization**: Users have the option to customize the output directory by modifying the `output_file` path in the scanner's source code or by adjusting the relevant script. This allows for flexibility in organizing the output files according to the user's project structure or preferences.

#### Contents of the Output Directory

- **Output Files**: Each run of the scanner generates an output file named after the input file, but with an `.out` extension, indicating that it contains the output from processing the corresponding input. For instance, if the input file is named `example.frag`, the output will be `example.out`.

- **Naming Convention**: The naming convention ensures that output files are easily associated with their input files, simplifying the review process and helping users track which input files have been processed.

- **File Contents**: The output files contain the results of the lexical analysis performed by the scanner. This includes tokens identified in the input file, along with any errors or messages generated by the lexer. The format and specific contents depend on the lexing rules defined in `scanner.l`.

#### Managing Output Files

- **Review and Analysis**: Users are encouraged to review the output files for insights into the lexical structure of their input files and to aid in debugging or further development of their lexing rules.
  
- **Version Control**: It's generally advisable to exclude the `./test_output/` directory from version control by adding it to your `.gitignore` (or equivalent) file. This prevents cluttering your repository with generated files and ensures that only source files and essential resources are versioned.

#### Example

After running the scanner on an input file named `sample.frag`, you'll find `sample.out` in the `./test_output/` directory. Open this file to review the tokens extracted from `sample.frag`, along with any lexical analysis messages the scanner was programmed to generate.

### Final Note

The automated handling of output files, including directory creation and systematic file naming, is part of our commitment to making the scanner tool as user-friendly and efficient as possible. By automatically managing output files, we aim to streamline the analysis process, allowing users to focus on the content and results of their lexical analysis.
