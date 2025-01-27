# ThreeAddrCompiler
This project is a compiler designed to process arithmetic expressions with operators (+, -, *, /), parentheses, and integers. It performs lexical analysis using Flex, syntax analysis with Bison, and generates intermediate three-address code for error-free compilation of expressions.
# ThreeAddrCompiler

A compiler designed to process and evaluate arithmetic expressions using **Flex** and **Bison**, with support for generating intermediate three-address code. This project simplifies expression evaluation while ensuring error-free compilation.

## Features

- **Arithmetic Operations**: Supports addition, subtraction, multiplication, and division.
- **Parentheses Handling**: Proper handling of operator precedence and parentheses for accurate computations.
- **Three-Address Code Generation**: Converts expressions into an intermediate code representation.
- **Error-Free Compilation**: Ensures proper parsing and processing of valid inputs.
- **Special Conditions**: 
  - Handles integers, including reversals for multiples of 10.
  - Removes decimal fractions from results.
  - Supports operator precedence rules.

## Tools Used

- **Flex**: For lexical analysis, breaking down the input expressions into tokens.
- **Bison**: For syntax analysis and generating an Abstract Syntax Tree (AST) to evaluate expressions.

## Example Usage

### Input Expression
a = 30 + 21 / 6 * 14;
t1 = 21 / 6;
t2 = t1 * 14;
t3 = 30 + t2;
a = t3;
###
c = 23 * 24 / (5 + 45) - 16;
t1 = 5 + 45;
t2 = 24 / t1;
t3 = 23 * t2;
t4 = t3 - 16;
c = t4;
git clone https://github.com/ParsaHaghighatgoo/ThreeAddrCompiler.git
cd ThreeAddrCompiler
sudo apt-get install flex bison
flex lexer.l
bison -d parser.y
gcc lex.yy.c parser.tab.c -o compiler
./compiler
