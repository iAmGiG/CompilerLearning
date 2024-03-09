import subprocess
import glob
import os
import datetime
import multiprocessing


def run_command(command):
    '''
    Runs a command in the shell and captures its standard output, standard error, and return code.

    Args:
        command (str): The command to be executed in the shell.

    Returns:
        tuple: A tuple containing the following values:
            - stdout (str): The standard output of the command.
            - stderr (str): The standard error of the command.
            - returncode (int): The return code of the command.
    '''
    process = subprocess.Popen(
        command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    stdout, stderr = process.communicate()
    return stdout.decode('utf-8'), stderr.decode('utf-8'), process.returncode


def compile_scanner(scanner_file='scanner.l'):
    '''
    Compiles the scanner (lexer) by running the `flex` and `gcc` commands.

    Args:
        scanner_file (str, optional): The name of the Flex file containing the scanner definition.
            Default is 'scanner.l'.

    Returns:
        bool: True if the compilation was successful, False otherwise.
    '''
    print("Generating C source from Flex file...")
    _, flex_err, exit_code = run_command(f"flex {scanner_file}")
    if exit_code != 0:
        print(f"Error running flex: {flex_err}")
        return False

    print("Compiling generated C source...")
    _, gcc_err, exit_code = run_command("gcc lex.yy.c -lfl -o scanner")
    if exit_code != 0:
        print(f"Error compiling lex.yy.c: {gcc_err}")
        return False

    return True

# Future goal is to have test directory a variable, for now, we know it is fixed, and we'll leave it till further notice.


def test_scanner(test_dir='samples', log_file='scanner_test_log.txt'):
    '''
    Tests the compiled scanner against a set of sample input files (`.frag` files) and compares
    the output with the expected output (`.out` files) in the specified test directory.
    Writes detailed logs to the specified log file.

    Args:
        test_dir (str, optional): The directory containing the test files. Default is 'samples'.
        log_file (str, optional): The name of the log file. Default is 'scanner_test_log.txt'.
    '''
    with open(log_file, 'w') as log:
        log.write(f"Scanner Test Log - {datetime.datetime.now()}\n\n")

        frag_files = glob.glob(f"{test_dir}/*.frag")
        for frag_file in frag_files:
            expected_output_file = frag_file.replace('.frag', '.out')

            if not os.path.exists(expected_output_file):
                log.write(f"No .out file for {frag_file}. Skipping...\n")
                continue

            log.write(f"Testing {frag_file}...\n")
            output, _, _ = run_command(f"./scanner {frag_file}")

            with open(expected_output_file, 'r') as f:
                expected_output = f.read()

            if output != expected_output:
                log.write(f"Mismatch found in {frag_file}.\n")
                log.write("Expected Output:\n")
                log.write(expected_output)
                log.write("\nActual Output:\n")
                log.write(output)
                log.write("\n")
            else:
                log.write(f"{frag_file} passed.\n")


def test_case_worker(frag_file, test_dir, log_file):
    expected_output_file = os.path.join(
        test_dir, frag_file.replace('.frag', '.out'))

    if not os.path.exists(expected_output_file):
        with open(log_file, 'a') as log:
            log.write(f"No .out file for {frag_file}. Skipping...\n")
        return

    with open(log_file, 'a') as log:
        log.write(f"Testing {frag_file}...\n")
        output, _, _ = run_command(
            f"./scanner {os.path.join(test_dir, frag_file)}")

        with open(expected_output_file, 'r') as f:
            expected_output = f.read()

        if output != expected_output:
            log.write(f"Mismatch found in {frag_file}.\n")
            log.write("Expected Output:\n")
            log.write(expected_output)
            log.write("\nActual Output:\n")
            log.write(output)
            log.write("\n")
        else:
            log.write(f"{frag_file} passed.\n")


def test_scanner_parallel(test_dir='samples', log_file='scanner_test_log.txt', num_processes=4):
    '''
    Tests the compiled scanner against a set of sample input files (`.frag` files) in parallel
    and compares the output with the expected output (`.out` files) in the specified test directory.
    Writes detailed logs to the specified log file.

    Args:
        test_dir (str, optional): The directory containing the test files. Default is 'samples'.
        log_file (str, optional): The name of the log file. Default is 'scanner_test_log.txt'.
        num_processes (int, optional): The number of parallel processes to use. Default is 4.
    '''
    with open(log_file, 'w') as log:
        log.write(f"Scanner Test Log - {datetime.datetime.now()}\n\n")

    frag_files = glob.glob(os.path.join(test_dir, "*.frag"))
    pool = multiprocessing.Pool(processes=num_processes)
    pool.starmap(test_case_worker, [
                 (frag_file, test_dir, log_file) for frag_file in frag_files])
    pool.close()
    pool.join()


if __name__ == "__main__":
    if compile_scanner():
        use_parallel_testing = input("Do you want to run tests in parallel? (y/n): ").lower() == 'y'
        if use_parallel_testing:
            num_processes = int(input("Enter the number of parallel processes to use (default: 4): ") or '4')
            test_scanner_parallel(num_processes=num_processes)
        else:
            test_scanner()
