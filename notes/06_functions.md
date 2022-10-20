# Functions

## 6.2 
Functions are objects.

Functions have three components:

- Arguments
- Body
- Environment

### 6.2.1 Function components
The `formals()` of a function are the arguments.

The `body()` of a function is the code inside the function, not including comments

### 6.2.2 Primitive functions
Some functions are written in C code.

E.g., `sum`, or `[`

### 6.2.3 First-class functions
There is no special syntax for defining functions in R. You bind them to variables as
with other objects.

### 6.2.4 Invoking functions

## 6.3 Function composition
Introduction to the binary operator `%>%`, which allows for easy compounding of functions.

## 6.4 Lexical scoping
R lexical scoping follows four primary rules:

**Name masking**

Names defined in a function mask names defined outside of a function.

However, names defined outside of a function can be used inside of a function, even
if they're not passed.

**Functions versus variables**

Stupid, not covering. Don't reuse object names...

**A fresh start**

Variables inside of functions do not exist within the function between calls. See example

**Dynamic lookup**

Functions use the most recently defined variable if a global variable is used inside
of the function without being passed

## 6.5 Lazy evaluation
R functions are only evaluated when accessed.

## 6.6 ...
`...` is equivalent to `*args`.

