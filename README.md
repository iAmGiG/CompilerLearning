# Compiler Project for Decaf 19

## Lexical Analyzer for DeCaf 19 Fragments (.frag)

This project implements a lexical analyzer for DeCaf 19 fragments using the Flex tool in Ubuntu. The tool reads a .frag file as input and generates a list of tokens as output. The correctness of the generated tokens can be verified by comparing them with an equivalent .out file located in the same directory.

## Features

- **Lexical Analysis:** Identifies and classifies tokens in a DeCaf 19 fragment file.
- **Tokenization:** Breaks down the source code into meaningful units (tokens) like keywords, identifiers, operators, and literals.
- **Output Generation:** Creates a list of tokens based on the lexical analysis.
- **Verification with Equivalents:** Allows comparison of the generated tokens with a pre-defined expected output file (.out).
- **Parallel Testing:** Runs tests in parallel for faster execution.
- **Selective Scanner Testing:** Allows testing different scanner files.
- **Timestamped Logs:** Generates timestamped log files for each test run.

## Phases

### Phase 1: Lexical Analysis

- **Objective**: Develop a scanner with Flex.
- **Result**: List of tokens.
- **How to Run**:
  - Manually: `flex scanner.l; gcc lex.yy.c -lfl -o scanner; ./scanner <input_file>`
  - Python script: `python run_scanner.py`

### How it Works

1. **Source Code Input:** The tool takes a .frag file containing a DeCaf 19 fragment as input.
2. **Lexical Analysis:** Flex processes the input file and identifies meaningful units (tokens) based on predefined patterns and rules.
3. **Token Generation:** The identified tokens are then compiled into a list.
4. **Output:** The list of tokens is generated as output.
5. **Verification (Optional):** The output can be compared with a corresponding .out file in the samples/ folder to verify the correctness of tokenization.

## Getting Started

### Prerequisites

- Python 3.9+, Flex, GCC

### Usage

Running the Lexical Analyzer

### Option 1: Manual Compilation and Execution

1. **Compile Flex Scanner:** Compile the Flex scanner definition file (scanner.l) using the command:

```bash
flex scanner.l
```

This generates the C code (lex.yy.c) for the scanner.

2. **Compile Scanner Code:** Compile the generated C code (lex.yy.c) with GCC and the Flex library (-lfl) to create the executable (scanner):

```bash
gcc lex.yy.c -lfl -o scanner
```

3. **Run the Scanner:** Execute the scanner with your .frag file as input:

```bash
./scanner <your_fragment_file.frag>
```

## Option 2: Using Python Script (run_scanner.py)

- 1. Ensure Python 3.9+ is installed.
- 2. **Run the Scanner with Python Script:** Execute the Python script (run_scanner.py) with your .frag file as input:

```bash
python run_scanner.py
```

The script will prompt you for the following inputs:

- Scanner file name (default: scanner.l)
- Whether to run tests in parallel (y/n)
- Number of parallel processes to use (if parallel testing is chosen, default: 4)
- Test directory (default: samples)
- Note: Both methods achieve the same outcome: generating a list of tokens from the .frag file.

## Testing

The `/tests` directory contains sample `.frag` files and their corresponding expected output files `(.out)` for testing the scanner's functionality. You can use these samples to verify if the tool is correctly tokenizing DeCaf 19 fragments.

- Python 3.9+ (if using the Python script)
- Flex
- GCC

### Setup

- Clone the repository using Git.
- Install the required tools (Flex and GCC) using your Ubuntu package manager.
