C-Lexical-and-Syntactical-analyzer
Lexical and Syntactical analyzer for Uni-C language(C language)

This repository contains code for lexic and syntactic analyze of Uni-C language (practically same as C language) that identify tokens from input file and write the kind of token that it is in output file.In addition from C-Lexical-Analyzer repo ,this is an updated version of this project,which include bison code that identify declarations,variable assignments and operators between tokens.

---
Also it identifies errors in input,such as assign an integer on a character,and print it in the output.Furthermore it has global variables and functions to count correct/incorrect words and correct/incorrect phrases and print the number of them at the end.

Flex code is pretty much the same as in the C-Lexical-Analyzer repo with variables to increase correct words counter ,if it identifies the input token, and increase incorrect words counter if the token is unexpected. Bison code contains an array of character for symbols(operators) and declaration of all expected tokens and operators.After that there is the code,which identifies decl(declarations),assign(assignments),operation and errors.

---
If we have an expected input ,correct phrases counter increase by one and when we have unexpected input,incorrect phrases counter increase by one.

In the main function on bison file we check arguments and if there are 3 of them the second is input file and the third is output file.If there are none of them the program takes input from keyboard and prints output on screen. Furthermore in main we call all functions and variable counters to print the number of correct/incorrect words and correct/incorrect phrases.

---
All codes compiled and executed in Linux environment,specifically Ubuntu 20.10.
