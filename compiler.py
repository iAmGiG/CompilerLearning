import ply.lex as lex

# List of token names. This is always required - these will include our reserve works such as: 'if', 'break', 'Print' 
tokens = (
   'IDENTIFIER', 'INTCONSTANT', 'DOUBLECONSTANT', 'BOOLCONSTANT', 'STRINGCONSTANT', 'NULL',
   'TYPE', 'IF', 'ELSE', 'FOR', 'WHILE', 'RETURN', 'BREAK', 'PRINT', 'READINTEGER', 'READLINE',
   # Operators
   'PLUS', 'MINUS', 'MULTIPLY', 'DIVIDE', 'MOD', 'LESSTHAN', 'LESSEQUAL', 'GREATERTHAN', 
   'GREATEREQUAL', 'EQUAL', 'NOTEQUAL', 'AND', 'OR', 'NOT',
   # Delimiters
   'LPAREN', 'RPAREN', 'LBRACE', 'RBRACE', 'SEMICOLON', 'COMMA'
)

# Regular expression rules for simple tokens
t_PLUS          = r'\+'
t_MINUS         = r'-'
t_MULTIPLY      = r'\*'
t_DIVIDE        = r'/'
t_MOD           = r'%'
t_LESSTHAN      = r'<'
t_LESSEQUAL     = r'<='
t_GREATERTHAN   = r'>'
t_GREATEREQUAL  = r'>='
t_EQUAL         = r'=='
t_NOTEQUAL      = r'!='
t_AND           = r'&&'
t_OR            = r'\|\|'
t_NOT           = r'!'
t_LPAREN        = r'\('
t_RPAREN        = r'\)'
t_LBRACE        = r'{'
t_RBRACE        = r'}'
t_SEMICOLON     = r';'
t_COMMA         = r','

# A string containing ignored characters (spaces and tabs)
t_ignore  = ' \t'

# A rule for identifiers (example)
def t_IDENTIFIER(t):
    r'[a-zA-Z_][a-zA-Z_0-9]*'
    t.type = reserved.get(t.value,'IDENTIFIER')    # Check for reserved words
    return t

# A rule for integer literals (example)
def t_INTEGER(t):
    r'\d+'
    t.value = int(t.value)    # Convert string to integer
    return t

# Define a rule so we can track line numbers
def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

# Error handling rule
def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)

# Build the lexer
lexer = lex.lex()

# Dictionary of reserved words
reserved = {
    'if' : 'IF',
    'else' : 'ELSE',
    'while' : 'WHILE',
    'for' : 'FOR',
    'return' : 'RETURN',
    'break' : 'BREAK',
    'Print' : 'PRINT',
    'ReadInteger' : 'READINTEGER',
    'ReadLine' : 'READLINE',
    'int' : 'TYPE',
    'double' : 'TYPE',
    'bool' : 'TYPE',
    'string' : 'TYPE',
    'void' : 'TYPE',
    'null' : 'NULL'
}

# Test it out
data = '''
int myVar = 10;
if (myVar < 20) {
    Print("Variable is less than 20.");
}
'''

# Give the lexer some input
lexer.input(data)

# Tokenize
while True:
    tok = lexer.next()
    if not tok: 
        break      # No more input
    print(tok)
