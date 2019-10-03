## R in a Nutshell
## Started: September 24, 2014


# Chapter 3 A Short R Tutorial p. 19

# In R, any number that you enter in the console is interpreted as a vector,
# which is an ordered collection of numbers. The "[1]" means that the index
# of the first item displayed in the row is 1.

x <- 1

x # Presented in the console as [1] 1

# Constructing longer vectors is done with the c() function (combine). 
y <- c(1, 4, 8, 11, 3, 18, 33, 4)

y # Presented as [1] 1 4, 8, 11, 3, 18, 33, 4

# Now produce a vector of numbers from 1 to 50 with the sequence operator (:)
1:50 # Shows [1] 1...50

# You can perform an operation on two vectors and R will match the elements
# of the two vectors pairwise and return a vector
c(1, 2, 3, 4) + c(10, 20, 30, 40) # Returns [1] 11 22 33 44

c(1, 2, 3, 4) * c(10, 20, 30, 40) # Returns [1] 10 40 90 160

c(1, 2, 3, 4) ^ c(10, 20, 30, 40) # Returns [1] 1.000000e+00...1.208926e+24

# When two vectors aren't the same size R will repeat the smaller sequence
# multiple times
c(1, 2, 3, 4) + 1

1 / c(1, 2, 3, 4, 5)

c(1, 2, 3, 4, 5) + c(10, 100) # This pops up a warning re: length of each vector

"Hello world" # is a character vector in R of length 1
c("Hello world", "Hello R interpreter") # A string in C = character value in R

# What's the length of the combined character value above?
length(c("Hello world", "Hello R interpreter")) # Predict 2; bingo!

# How would I print the 2nd character value?
c("Hello world", "Hello R interpreter")[2] # This prints "Hello R interpreter" to the console!
# This works because the brackets indicates which index item to pull from the vector

# Functions
# Most functions are in the form f(argument1, argument2, ...) where f = function name
# and argmentX are the arguments.
exp(1)

cos(3.141593)

log2(1)

# What about functions that take more than one argument?
# Arguments can be specified by name, which means you can reference them
# out of order as they were defined in the function itself
log(x = 64, base = 4)

# Or if you refer to them in order you can omit the argument name...
log(64, 4)

# Not all functions come in standard form; operations are actually functions, too
17 + 2

2 ^ 10

3 == 4 # A test of equality is a function call and there is a BOOLEAN data type

# Variables
# R lets you assign values to variables (symbols) and refer to them by name;
# the operator is <- (gets). So, x <- 1 is "x gets 1", which is familiar to
# algorithm pseudocode. After you assign a value to a variable, R will substitute
# that value in place of the variable name when it evaluates the expression.
x <- 1
y <- 2
z <- c(x, y)
# Evaluate z
z # Prints [1] 1 2

# Substitution is done at the time the value is assigned, NOT when z
# is evaluated; now change the value of y; what happens to z?
y <- 4
z # Nothing happens to z

# There are multiple ways to refer to a member (or set of members) of a vector
b <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12) # create a vector named b

b # Print b's values; note referring to the vector prints all of its values

# Get the 7th value in the b vector
b[7]

# Fetch items 1:6 in the b vector
b[1:6]

# Fetch only multiples of 3 in the b vector
b[b %% 3 == 0]

# Only get a defined subset of members from vector b
b[c(1, 3, 6)]

# Fetch items out of order!
b[c(8, 4, 9)]

# Fetch a logical vector only from vector b; don't pull the actual values
# Print TRUE if the member of b is divisible by 3 with no remainder (modulo)
b %% 3 == 0 # b[b %% 3 == 0] returns the actual matching members because we're pulling the matching indices

# Assignment can be done with '=' or '<-'; use gets '<-' to assign values outside of function calls; function
# calls use the equals operator
one <- 1
two <- 2

# Assign the value of two to variable one
one = two # Prefer one <- two

one

# Start over
one <- 1
two <- 2

# Assign the value of two to variable one
one == two # Is one equal to two? No

# Assignment can go to the right, too, but AVOID THIS to reduce confusion
3 -> three # The variable three gets the value 3

three # Prints 3 in the console

# A function is just another object assigned to a symbol, which you can create yourself and call
f <- function(x, y) {c(x + 1, y + 2)} # Note no RETURN statement

f(1, 2) # Call my function f; prints [1] 2 4

# Introduction to Data Structures p.24
# Vectors and arrays are stored the same way internally, but displayed differently
# Arrays are multidimensional vectors and associated with a dimension attribute
# Let's define an array explicitly
a <- array(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12), dim = c(3, 4)) # Array a with values 1-12 and 3 rows and 4 columns

a # print array a; NOTE default array load is by-column!

# Referencing one "cell"
a[2, 2] # Prints 5

# A MATRIX is just a two-dimensional array
m <- matrix(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12), nrow = 3, ncol = 4)

m # Prints the matrix, which also defaults to loading by column

# Arrays can have more than two dimensions
w <- array(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18), dim = c(3, 3, 2)) # Array a with values 1-18 with two arrays of 3 rows and 4 columns

w

# Referencing a multi-dimensional array for one cell value
w[1, 1, 1] # Fetch the first row, first column value from the 1st matrix

# Specifying separate indices for each dimension to fetch array members
a[1, 2]

a[1:2, 1:2]

# To get all rows or columns...
a[1, ]

a[ , 1]

# Or get a range of rows
a[1:2, ] # Fetch rows 1 & 2

a[ , 1:2] # Fetch columns 1 & 2

# Or pull a non-contiguous set..
a[c(1, 3), ] # Fetch rows 1 and 3

# Lists allow a mix of data types and different number of row of data
# A list containing two strings
e <- list(thing = "hat", size = "8.25")
e

# Accessing an item multiple ways
e$thing # is the same as...

e[1] # This is a data slice

e[[1]] # Refers directly to the value

# A list can contain other lists
g <- list("this list references another list", e)

g

# A data frame is a list that contains multiple named vectors that are
# the same length, very much like a spreadsheet or a database table, and
# excellent for representing experimental data
# The win/loss results for the NL East in 2008
teams <- c("PHI", "NYM", "FLA", "ATL", "WSN")
w <- c(92, 89, 94, 72, 59)
l <- c(70, 73, 67, 90, 102)

nleast <- data.frame(teams, w, l)

nleast

# Referring to components of a dataframe
nleast$w # Fetch the win totals of the NL East teams

# Produce a logical T/F vector to select a member of an array
nleast$teams == "FLA"

nleast$l[nleast$teams == "FLA"]

# Objects and classes p.27
# R is object-oriented; every object has a type; every object is a
# member of a class
class(teams) # Returns 'character'
class(w) # Returns 'numeric'
class(nleast) # Returns 'data.frame'
class(class) # Returns 'function'

# Functions associated with a class are called methods; not all functions
# are tied closely to a particular class. Class system in R is much looser
# than in Java, for example.
# Methods for different classes can share the same name, called generic
# functions. This makes it easy to guess the right function name for an
# unfamiliar class and generic functions make it possible to use the same
# code for objects of different types. For example, '+' is a generic function
# call for adding objects
17 + 6

# Does the addition operator work with other types of objects?
as.Date("2009-09-08") + 7 # Returns 2009-09-15?

# Models and Formulas p.28
# Where a statistician's model might say y = c0 + c1x1 + c2x2 + ... + cnxn + E
# that relationship in R would say y ~ x1 + x2 + ... + xn, a formula object
# Let's look at the built-in cars data set and build a linear model of
# speed and stopping distance, assuming a linear relationship between them.
cars.lm <- lm(formula = dist ~ speed, data = cars) # formula and data is unnecessary unless out of order

cars.lm # print the results and the model

summary(cars.lm) # Better example of results

# Just calling the LM() function without assigned the results to a variable
# would show the same things as printing the CARS.LM variable result
lm(formula = dist ~ speed, data = cars)

# Charts and Graphics p.30
# Multiple packages for visualizing data: graphics, grid, and lattice. 
install.packages("nutshell")
library(nutshell)
data(field.goals)

names(field.goals)

hist(field.goals$yards)
hist(field.goals$yards, breaks = 35)

# Let's look at the distance of blocked field goals,
# which we can define through the PLAY.TYPE variable
table(field.goals$play.type) # 8 FG aborted, 24 blocked, 787 made, 163 no good

# Let's look at only the blocked field goals using a strip chart
# that plots one point on the x-axis for every point in a vector.
stripchart(field.goals[field.goals$play.type == "FG blocked", ]$yards, pch = 19, method = "jitter")

data(cars)
dim(cars) # What are the dimensions of the cars data? 50 rows and 2 columns
names(cars) # What are the variables within the cars data?

summary(cars)

# What's the relationship between speed and stopping distance?
plot(cars, xlab = "Speed (mph)", ylab = "Stopping distance (ft)", las = 1, xlim = c(0, 25))

# Looking at changes in Americans eating habits
library(lattice)
data(consumption)
dotplot(Amount ~ Year | Food, consumption)

# The dotplot is interesting but hard to read; let's customize it
dotplot(Amount ~ Year | Food, data = consumption, aspect = "xy", scales = list(relation = "sliced", cex = .4))

# Chapter 4 R Packages
# 
# A package is a related set of functions, help files, and data files that have been bundled together, similar
# to modules in Perl, libraries in C/C++, and classes in Java. Typically all the functions in the package
# are related.
# 
# To use a package you have to install it into a local library (libraries being very different than in C++).
# After installing, the package(s) are loaded into your current session. Loading after installing ensures
# R doesn't bog down its help system and keeps packages with similar objects and functions from overriding
# each other. ONLY LOAD PACKAGES YOU NEED TO MINIMIZE CONFLICTS.
# 
# Listing packages in local libraries
# To get the default list of loaded packages, use the GETOPTION() command on the defaultPackages value
getOption("defaultPackages") # Omits R's BASE package which is loaded by default

# To see currently loaded packages
(.packages()) # NOTE parens around outside

# To show all available packages, add all.available = TRUE to .packages
(.packages(all.available = TRUE))

# LIBRARY() will pop up a window with all available packages, too

# Custom Packages p.45
# Good idea to share code or data with other people or re-use code

# Chapter 5 An Overview of the R Language p. 51
# Learning a computer language is a lot like learning a spoken language, but simpler.
# It starts with syntax and grammar: verb conjugation, proper articles, sentence structure,
# and so on. The same goes with R, except for conjugation and some of that other stuff.
# 
# Expressions p.51
# R code is composed of a series of expressions, including assignment statements, conditional
# statements, and arithmetic expressions

x <- 1
if(1 > 2) then "yes" else "no"
127 %% 10

# Expressions are composed of objects and functions, which can be separated by line breaks
# or by semi-colons.
"This expression will be printed"; 7 + 13; exp(0 + 1i * pi) # Written on one line, prints on 3

# Objects p.52
# All R code manipulates objects; think of objects as "things" represented by the computer.
# Objects include numeric vectors, character vectors, lists, and functions
# Numerical vector with five elements
c(1, 2, 3, 4, 5)

# Character vector (with one element)
"This is an object too" # Object assigned an unnamed name space in memory

# List
list(c(1, 2, 3, 4, 5), "This is an object too", "This whole thing is a list")

# Function
function(x, y) {x + y}

# Symbols
# Formally variable names in R are called symbols; when you assign an object
# to a variable name, you are actually assigning the object to a symbol.

# Functions
# A function is an object in R that takes some input objects (arguments)
# and returns an output object. ALL WORK IN R IS DONE BY FUNCTIONS. Every
# statement in R--setting variables, doing arithmetic, repeating code
# in a loop--can be written as a function.
animals <- c("cow", "chicken", "pig", "tuna")

animals

# Change the fourth element
animals[4] <- "duck"

animals

# Or could be done this way
'[<-' (animals, 4, "dork")

# Objects are Copied in Assignment Statements
# In assignment statements, most objects are immutable, which is a good thing:
# for multi-threaded programs, immutable objects help prevent errors because
# R will COPY the object, not just reference (like a pointer) the object. This
# applies to vectors, lists, and most other primitive objects in R, including
#  functions.
u <-list(1)

v <- u
u[[1]] <- "hat"
u # prints hat

v # prints 1

f <- function(x, i) {x[i] = 4} # x is modified inside the context of the function

w <- c(10, 11, 12, 13)
f(w, 1) # w is copied so the original values don't change

w

# In many cases R will actually modify the object in place, such as this example
v <- 1:100 # Assign the numeric sequence 1 to 100 to v

v[50] <- 27 # New assignment for item 50 is 27

v # Item 50 is now equal to 27

# Special Values p.55
# There are a few...
# NA values are used to represent missing values ("Not Available"). This can represent
# missing values (from read-in spreadsheets, for example) or NULLs from databases. If you
# expand the size of a vector beyond the size where values were defined the new spaces
# will have NA values.
v <- c(1, 2, 3)

v

length(v) <- 4

v # Displays 1, 2, 3, NA

# Inf and -Inf
# If a computation results in a number that is too big, R returns Inf for a positive
# and -Inf for a negative
2 ^ 1024
-2 ^ 1024

# This also occurs when dividing by 0
1 / 0

# NaN
# Sometimes a computation produces a result that makes little sense, and R returns 
# NaN to notify of that.
Inf - Inf

0 / 0

# NULL
# Null is often used as an argument in functions to mean that no value was assigned to
# the arguments; some functions may return NULL. NULL is NOT the same as NA, Inf, -Inf,
# or NaN.

# Coercion p.56
# When you call a function with an argument of the WRONG type, R will try to force the argument
# into a different type to make the function work. Two types of coercion: with formal objects
# and with built-in types. With generic functions R will look for a suitable method; if no exact
# match is found then R will search for a coercion method that converts the object to a type for
# which a suitable method does exist. R will automatically convert between built-in object types
# when appropriate.

x <- c(1, 2, 3, 4, 5)
x
typeof(x) # double
class(x) # numeric

# Change the 2nd element to a character string and watch the fireworks!
x[2] <- "hat"
x
typeof(x) # now character
class(x) # now character

# Overview of coercion rules:
# * Logical values are converted to numbers: FALSE = 0 and TRUE = 1
# * Values are converted to the simplest type required to represent all information
# * Ordering is roughly logical < integer < numeric < complex < character < list
# * Objects of type RAW are not converted to other types
# * Object attributes are dropped when an object is coerced from one type to another

# Coercion can be inhibited when passing arguments to functions by using ASIS() or 
# the I() function

# The R Interpreter p.58
# 
# R is an interpreted language; entering expressions in the R console or in batch mode
# the interpreter executes the actual code. Compiling is unnecessary, similar to Lisp,
# Perl, and JavaScript. All R programs are composed of a series of expressions which often
# take the form of function calls

x <- 1

if(x > 1) "orange" else "apple"

To see how this expression is parsed, use the QUOTE() function, which returns a language
object but does not evaluate the expression
typeof(quote(if(x > 1) "orange" else "apple")) # returns 'language'

# Unfortunately the console print function is less helpful if we leave off typeof
quote(if(x > 1) "orange" else "apple")

# We can convert a language object into a list!
as(quote(if(x > 1) "orange" else "apple"), "list") # Returns parse tree of 4 elements 'if', 'x > 1', 'orange', 'apple'

# Chapter 6 R Syntax  p.63
# Every expression in R can be written as a function call. There is some special syntax to write common
# operations like assignments, lookups and numerical expressions more naturally, though. The focus
# in this chapter is how to write valid R expressions.
# 
# Constants
# Building blocks for data such as numbers, character values and symbols
# 
# Numeric vectors
# Interpreted literally
1.1
2
2 ^ 1023

# Can be in hexadecimal by prefixing with 0x
0x1 #1
0xFFFF #65535

# By default numbers in expressions are interpreted as double-precision floating points
typeof(1) # double

# If you want an integer use the sequence notation or the as function
typeof(1:1)
typeof(as(1, "integer"))

# The sequence operator a:b will return a vector of integers between a and b
# 
# Combining an arbitrary set of numbers using a vector with the C() function
v <- c(173, 12, 1.12312, -93)

# There's a limit to numeric precision, though
(2 ^ 1023 + 1) == 2 ^ 1023 # Should be FALSE, but returns TRUE

# Limits of size, too
2 ^ 1024 # returns Inf

# R supports complex numbers written as real_part + imaginary_part1, such as
0 + 1i ^ 2
sqrt(-1 + 0i)
exp(0 + 1i * pi)

# Character Vectors p.64
# A character object contains all the text between a pair of quotes, typically double quotes,
# but also by single quotes:
"hello" # is functionally equivalent to
'hello'

# This can be helpful when comparing two character vectors
identical("\"hello\"", '"hello"') # TRUE

identical('\'hello\'', "'hello'") # TRUE

# Symbols p.65
# 
# A symbol is an object in R that refers to another object; a symbol is the name 
# of a variable in R, so symbol = object = variable. In x <- 1 'x' is a symbol.
# A symbol that begins with a character and contains other characters, numbers,
# periods, and underscores may be used directly in R statements.
# 
# Not all words are valid; there are reserved words, just as in other languages:
#   if, else, repeat, while, function, for, in next, break, TRUE, FALSE, NULL,
# Inf, NaN, NA, NA_integer_, NA_real_, NA_complex_, NA_character_, ..., ..1, ..2,
# ..3 through ..9.
# 
# Primitives can be redefined that aren't in that list, such as 'c' refers to
# the combine function, but can be used as a variable/symbol, too.

c

c <- 1

c

v <- c(0, 1, 3)
v

# Operators p.66
# Many functions in R can be written as operators, which is a function that takes 
# one or two arguments and can be written without parentheses.

# addition
1 + 19

# multiplication
5 * 4

# Modulo operator
41 %% 20

# exponents
20 ^ 1

# Integer division; no remainder
21 %/% 2 # 10

# You can define your own binary operators that consist of a string characters between two
# % characters.
`%myop%` <- function(a, b) {2 * a + 2 * b}

1 %myop% 1

1 %myop% 2

Some language constructs are also binary operators, such as assignment, indexing,
and function calls.
# assignment is a binary operator
# the left side is a symbol, the right is a value
x <- c(1, 2, 3, 4, 5)

# indexing is a binary operator, too
# the left side is a symbol, the right is a value
x[3]

# a function call is also a binary operator
# the left side is a symbol pointing to the function argument
# the right side are the arguments
max(1, 2)

# Unary operators take only one variable, such as negation and ? for help
-7

?`?`

# Order of Operations p.67
# Just like math--PEMDAS--parentheses, exponents, multiplication, division, addition and subtraction.
# Precedence is:
#   1) Function calls and grouping expressions
#   2) Index and lookup operators
#   3) Arithmetic (PEMDAS)
#   4) Comparison
#   5) Formulas
#   6) Assignments
#   7) Help

# Assignments p.69
# Most assignments thus far have assigned an object to a symbol, such as...
x <- 1
y <- list(shoes = "loafers", hat = "Yankees cap", shirt = "white")
z <- function(a, b, c) { a ^ b / c}
v <- c(1, 2, 3, 4, 5, 6, 7, 8) # class numeric

# An alternative assignment with the function on the left-hand side of the operator;
# these statements replace an object with a new object that has slightly different properties.
# Each of these functions replaces the object associated with sym in the current environment.
# By convention, fun refers to a property of the object represented by sym in fun(sym) <- val.
dim(v) <- c(2, 4) # now a numeric matrix
v[2, 2] <- 10 # set the variable at row 2 col 2 to 10
formals(z) <- alist(a = 1, b = 2, c = 3)

# Expressions p.69
# 
# Use semicolons, parentheses or braces to group expressions. Separate expressions can be written
# on separate lines or separated by semicolons...
x <- 1
y <- 2
z <- 3 # or...
x <- 1; y <- 2; z <- 3

# Parentheses returns the result of evaluating the expression inside the parentheses.
# The operator has the same precedence as a function call. Grouping a set of expressions inside
# parentheses is equivalent to evaluating a function of one argument that just returns its
# argument.
2 * (5 + 1) # Returns 12?
# equivalent expression
f <- function(x) x
2 * f(5 + 1) # Stupid, but does the same thing

# Curly Braces are used to evaluate a series of expressions and return only the last expression
# In this function x and y are available ONLY in the function, not outside it
f <- function() {x <- 1; y <- 2; x + y}

f() # Returns 3?

# Curly braces can also be used as expressions in other contexts, in this case eliminating
# the need for a function call
{x <- 1; y <- 2; x + y}

# Control Structures p.71
# R provides special syntax for common program structures, such as conditional statements.
# Conditional statements take the form if(condition) true_expression else false_expression, or
# if(condition) expression
if(FALSE) "This will not be printed"
if(FALSE) "This will not be printed" else "This will be printed"
if(is(x, "numeric")) x / 2 else print("x is not numeric")

# IMPORTANT: Conditionals are NOT VECTOR operations. If a vector is passed only the first
# item in the vector will be used; for example,
x <- 10
y <- c(8, 10, 12, 3, 17)
if(x < y) x else y # Gives warning message that only the first element of y was compared

# For vector operations use IFELSE()
a <- c("a", "a", "a", "a", "a")
b <- c("b", "b", "b", "b", "b")

ifelse(c(TRUE, FALSE, TRUE, FALSE, TRUE), a, b) # Print the matching value from a or b based on the T/F vector value

# Use SWITCH() to return different values based on a single input value!
# This is invaluable in reducing if-then-else options
x <- "a"
switch(x,
       a = "alligator",
       b = "bear",
       c = "camel",
       "moose")

# Loops p.72
# Three different looping constructs in R, the simplest of which is REPEAT. To stop repeating
# the expression, use the keyword BREAK. Without BREAK R goes into an INFINITE LOOP, which might
# be okay in an interactive application. To skip to the next iteration in the loop use the
# command NEXT.

i <- 5
repeat {if (i > 25) break else {print(i); i <- i + 5;}}

# WHILE loops can be valuable, as they loop while a condition is true.
# You can also use BREAK and NEXT in WHILE loops
i <- 5
while(i <= 25) {print(i); i <- i + 5}

# Finally, the FOR loop iterates through each item in a vector(or list)
# BREAK and NEXT can be used in FOR loops, too.
for(i in seq(from = 5, to = 25, by = 5)) print(i)

# Looping Extensions
# Modern programming languages like Java have iterators and foreach loops. These are available 
# in R but through add-on libraries like iterators, which must be installed. Iterators can return
# elements of a vector, array, data frame, or other object. The can return values returned
# by a function like a function that returns random values
install.packages("iterators")
library(iterators)

onetofive <- iter(1:5)

nextElem(onetofive)

# Another valuable extension is FOREACH, available through the foreach package.
# FOREACH is an elegant way to loop through multiple elements of another
# object (such as a vector, matrix, data frame, or iterator), evaluate an
# expression for each element and return the results. Within the foreach
# function you assign elements to a temporary value, just like a for loop.
install.packages("foreach")
library(foreach)

sqrts.1to5 <- foreach(i = 1:5) %do% sqrt(i) # %do% evaluates in serial while %dopar% works in parallel

sqrts.1to5

# Accessing Data Structures p.75
# Three important differences between single ([]) and double-bracket ([[]]) notations:
#   1) Double brackets ALWAYS return a single element while singles can return multiple elements
#   2) When elements are referred to by name (instead of index) single brackets match only names objects exactly
#      while double brackets allow partial matches
#   3) When used with lists, single brackets returns a list but double-brackets return a vector

# Simple vector with 20 integers
v <- 100:119

v[5] # Looks up the fifth value
v[1:5] # Looks up the first through fifth value
v[c(1, 11, 6, 16)] # Looks up multiple, out of order elements

# Double bracket notation with a vector does the same thing as a single bracket
v[[3]] # Prints 102

# Negative integers can be used to return a vector consisting of all elements EXCEPT those specified
v[-15:-1] # Prints 115, 116, 117, 118, 119

v[-1:-15] # Prints the same values

# The same notation applies to lists
l <- list(a = 1, b = 2, c = 3, d = 4, e = 5, f = 6, g = 7, h = 8, i = 9, j = 10)

l[1:3] # Prints items a, b, and c

l[-1:-7] # Prints items h, i, and j; so would l[-7:-1]

# The same notation can be used to extract data from multidimensional data structures:
m <- matrix(data = c(101:122), nrow = 3, ncol = 4)

m

m[3] # Extracts 103, which is the 3rd item in the original vector

m[3, 4] # Extracts row 3, col 4 intersection, which is 112

m[1:2, 1:2] # Extracts rows 1 & 2 and cols 1 & 2 data, which is 101, 102, 104 and 105

# Omitting either row or column returns all in referenced
m[1:2, ] # All data in rows 1 and 2; 101, 104, 107, 110, 102, 105, 108, 111

m[3:4] # Items 3 and 4 in the original vector, which are 103 and 104

m[ , 3:4] # Items in columns 3 and 4

# Working with arrays and subsetting them
a <- array(data = c(101:124), dim = c(2, 3, 4))

a

class(a[1, 1, ]) # integer

class(a[1, , ]) # matrix

class(a[1:2, 1:2, 1:2]) # array

# Replacing elements in a vector, matrix or array using similar notation
m[1] <- 1000 # Replace first item in the vector with 1000

m

m[1:2, 1:2] <- matrix(c(1001:1004), nrow = 2, ncol = 2)

m

# Extend a vector by referencing a non-existent member
v <- 1:12

v[15] <- 15

v # Print the v vector, which substitutes NAs for items 13 and 14 prints 15


# Indexing by Logical Vector p.78
# An alternative to indexing by an integer vector...

rep(c(TRUE, FALSE), 10) # Repeat T/F pairs 10x

v[rep(c(TRUE, FALSE), 10)] # Pull every other value from the v vector, which are the evens

# Sometimes helpful to calculate a logical vector from the vector itself:
v[(v == 103)] # Parens in brackets are unnecessary

v[(v %% 3 == 0)]

# Index vector doesn't need to be the same length as the vector itself
v[c(TRUE, FALSE, FALSE)] # Should pull 1st, 4th, 7th, etc elements from vector v

# This applies to lists, too
l[l > 7] # Prints $h, $i, $j

# Indexing by Name
# With lists, each element may be assigned a name, which can be referenced with $
l <- list(a = 1, b = 2, c = 3, d = 4, e = 5, f = 6, g = 7, h = 8, i = 9, j = 10)

l$j

# Single bracket notation WITH QUOTES pulls named elements
l[c("a", "d", "f")]

# Double-bracket notation can be used to reference individual elements of a list
dairy <- list(milk = "1 gallon", butter = "1 pound", eggs = 12)

dairy$milk

dairy[["milk"]]

dairy[["mil"]] # Returns NULL

# Can reference incomplete names by turning off EXACT option
dairy[["mil", exact = FALSE]] # Returns "1 gallon"

# Lists can contain other lists, which can be referenced using double-bracket notation
fruit <- list(apples = 6, oranges = 3, bananas = 10)
shopping.list <- list(dairy = dairy, fruit = fruit)

shopping.list

shopping.list[[c("dairy", "milk")]] # Pull "1 gallon"

shopping.list[[c(1, 2)]] # Pull the 2nd item from the 1st list, which is "1 pound"

# Chapter 7: R Objects p.83
# All objects in R are built on top of a basic set of built-in objects. The TYPE of an object
# defines how it is stored in R. Objects in R are also members of a CLASS. Classes define
# what information objects contain, andhow those objects may be used.
# 
# Primitive Object Types
# BASIC VECTORS contain a single type of value: integers, floating-point numbers, complex numbers,
# text, logical values, or raw data.
# 
# COMPOUND OBJECTS are containers for basic vectors: lists, pairlists, S4 objects, and environments.
# Each of these objects has unique properties but each of them contains a number of named objects.
# 
# SPECIAL OBJECTS have specific meaning in a specific context, but you would never create one of 
# these objects: any, NULL, etc.
# 
# R LANGUAGE are objects that represent R code; they can be evaluated to return other objects.
# 
# FUNCTIONS are the R workhorse; they take arguments as inputs and return objects as outputs.
# Sometimes they modify objects in the environment or cause side effects outside the R environment
# like plotting graphics, saving files, or sending data over the network.
# 
# INTERNAL objects types are formally defined by R but which aren't normally accessible within the
# R language. You will probably never encounter these objects.
# 
# BYTECODE OBJECTS use the bytecode compiler (if used), R generates these objects that run on the R
# virtual machine.

Vectors
Six basic vector types, the simplest of which is put together with the c() (combine) function.
# Vector type #1
v <- c(.295, .300, .250, .287, .215)

v

# Vector type #2
# c() also COERCES all arguments into a single type
v <- c(.295, .300, .250, .287, "zilch")

v

# Vector type #3
# c() can also be combined with a RECURSIVE setting to combine with other objects, like a list
v <- c(.295, .300, .250, .287, list(.102, .200, .303), recursive = TRUE)

# Vector type #4
# Using the colon (:) operator for sequences
1:10

seq(from = 5, to = 25, by = 5)

w <- 1:10

w

length(w) <- 5

# When expanding the length of a vector, uninitialized values are given NA
length(w) <- 10

w

# Lists
# Lists are ordered collections of objects; like vectors you can refer to elements by position or by name.
# Lists are very important in R; they are the foundation of the data.frame.
l <- list(1, 2, 3, 4, 5)

l[1] # Refers to first item in list, which could be another list, in this case the value 1

l[[1]] # References actual value in the first member of the list object, again the value 1

parcel <- list(destination = "New York", dimensions = c(2, 6, 9), price = 12.95)

parcel$price

# Other Objects
# 
# Matrices
# A vector of two dimensions, used to represent two-dimensional data of a single type. NOTE: matrices 
# are, by default, filled in by COLUMN. use BYROW = TRUE to fill in otherwise.

# Transform another object into a matrix with AS.MATRIX(). Matrices are implemented as vectors, not as a
# vector of vectors or list of vectors, which allows for accessing individual matrix members within
# single brackets

m <- matrix(data = 1:12, nrow = 4, ncol = 3, dimnames = list(c("r1", "r2", "r3", "r4"), c("c1", "c2", "c3")))

m

# Proof that matrix is a vector
m[4] # Returns 4, which is the 1st value in the 4th row

m[7] # Returns 7, the 7th value in the by-column loaded vector

# Arrays
# Arrays are extensions of vectors to more than two dimensions and used to represent multidimensional
# data of a single type. The underlying storage structure, like matrices, is the VECTOR.
a <- array(data = 1:24, dim = c(3, 4, 2)) # Two 24-item arrays of 3 rows x 4 columns
a

a[11] # Pulls the 11th item in the array, which is 11

a[22] # Pulls the 22nd item in the array, which is 22 from r1, c4

# Factors
# Representations of categorical values, such as eye color or gender. Factors are ordered collections
# of items where different values the factor can take are called LEVELS.
# Eye colors as a vector
eye.colors <- c("brown", "blue", "blue", "green", "brown", "brown", "brown")

# Re-code as a factor
eye.colors <- factor(c("brown", "blue", "blue", "green", "brown", "brown", "brown"))

levels(eye.colors)

# Note the way R presents the values when printing eye.colors; stored as INTEGERS!
eye.colors

# In eye color, order didn't matter, but what about with items like survey responses?
# Could code responses 1 to 5 with factors, but this assumes a quantitative relationship
# between them, that they are effectively scaled (an Agree is worth as much as a Disagree
# and average out to Neutral?). Another way around this problem is with ordered factors.
survey.results <- factor(c("Disagree", "Neutral", "Strongly Disagree", "Neutral",
                           "Agree", "Strongly Agree", "Neutral", "Disagree", "Strongly Agree",
                           "Neutral", "Agree"), levels = c("Strongly Disagree", "Disagree", "Neutral",
                                                           "Agree", "Strongly Agree"),
                         ordered = TRUE)

survey.results

# Turning a factor into a integer array
class(eye.colors)

eye.colors.integer.vector <- unclass(eye.colors)

eye.colors.integer.vector

# Now return the integer array back to a factor
class(eye.colors.integer.vector) <- "factor"
eye.colors.integer.vector

class(eye.colors.integer.vector)

Data Frames
Useful for representing TABULAR DATA. Each column may be of different types but
each row in the data frame must be of the same length. Usually each column is named,
and sometimes rows are named as well

# Found in the NUTSHELL package
top.bacon.searching.cities <- data.frame(city = c("Seattle", "Washington", "Chicago",
                                                  "New York", "Portland", "St. Louis",
                                                  "Denver", "Boston", "Minneapolis", "Austin",
                                                  "Philadelphia", "San Francisco", "Atlanta",
                                                  "Los Angeles", "Richardson"),
                                         rank = c(100, 96, 94, rep(93, 2), 92, rep(90, 2), 89, 87, 85, 84, 82, rep(80, 2))
)
top.bacon.searching.cities

typeof(top.bacon.searching.cities) # Implemented as lists

class(top.bacon.searching.cities) # but class data.frame

# Formulas
# Often you need to express a relationship between variables and sometimes want to plot a chart
# showing the relationship between the two variables; other times you want to create a mathematical
# model. R provides the FORMULA class:
sample.formula <- as.formula(y ~ x1 + x2 + x3) # Y is a function of X1 + X2 + X3

class(sample.formula)

typeof(sample.formula)

# Meanings of Different Items in Formulas
# VARIABLE NAMES represent variable names
# 
# TILDE (~)  is used to show the relationship between the response variable (to the left) and the stimulus variables (to the right)
# 
# PLUS SIGN (+)  is used to express a linear relationship between variables
# 
# ZERO (0), when added to a formula, indicates that no intercept term should be included
# 
# VERTICAL BAR (|)  is used to specify conditioning variables (in lattice formulas)
# 
# IDENTITY FUNCTION (I()) is used to indicate that the enclosed expression should be interpreted by its arithmetic meaning;
# for example, a+b means a and b should be included in the formula, where I(a + b) means a plus b should be included
# 
# ASTERISK (*) is used to indicate interactions between variables; for example, y ~ (u + v) * w = y ~ u + v + w + I(u * v) +I(v * w)
# 
# CARAT (^)  is used to indicate crossing to a specific degree; y ~ (u + w) ^ 2 = y ~ (u + w) * (u + w)

Time Series
How do variables change over time? R includes the TIME SERIES class to represent this data. Some regression functions use these
objects and many plotting functions have special methods for time series objects.

ts(1:8, start = c(2008, 2), frequency = 4) # 8 time segments starting in 2008 in the 2nd of 4 quarters

# From the NUTSHELL library
data(turkey.price.ts)
turkey.price.ts

# Variety of utility functions for looking at time series objects
start(turkey.price.ts) # What's the 1st time item?

end(turkey.price.ts) # What's the last time item?

frequency(turkey.price.ts) # How many time segments are represented? 12

deltat(turkey.price.ts) 

# Stop at Shingles on p. 95

# Chapter 8: Symbols and Environments
# 
# Exceptions p.108
# Sometimes R gives you an error when entering an invalid expression

12 / "hat"

# Or R might just give you a warning
if(c(TRUE, FALSE)) TRUE else FALSE

# R throws exceptions in much the same way Java or other languages do. When 
# an exception occurs, the R interpreter may need to abandon the current function
# and signal the exception in the calling environment.

# Signaling Errors
# If something occurs in your code that requires stopping execution, use the STOP()
# function. 

doWork <- function(filename) {
  if(file.exists(filename)) {
    read.delim(filename)
  } else {
    stop("Could not open file: ", filename)
  }
}

doWork("File that doesn't exist")

# If something occurs in code that you want to tell the user about but not necessarily
# stop function, use the WARNING() function.
doNoWork <- function(filename) {
  if(file.exists(filename)) {
    "La la la"
  } else {
    warning("File does not exist: ", filename)
  }
}

doNoWork("Another file that doesn't exist")

# You can also communicate with the user through the MESSAGE() function
doNothing <- function(x) {
  message("This function does nothing. Literally.")
}

doNothing("Another input value")

# Catching Errors p.109
# Suppose you have one function that calls another and in the called function there's an error
# but you don't want to stop the calling function from running. TRY takes two arguments: EXPR and
# SILENT. EXPR is the expression to be tried, usually a function, and SILENT says whether to print
# a message to the console
res <- try({x <- 1}, silent = TRUE)
res

res <- try({open("file that doesn't exist")}, silent = TRUE)
res

# Better option is TRYCATCH: an expression to try, a set of handlers for diferent conditions,
# and a final expression to evaluate.

# Chapter 12: Preparing Data p.173
# Up to 80% of time is finding, cleaning and preparing data for analysis; less than 5% is
# spent on analysis; the rest is spent writing everything up. In practice, data is almost never
# stored in the right form for analysis, and even when it is there are often surprises in the
# data.
# 
# Combining Data Sets
# Working with data stored in two separate places is a recipe for work to be done to bring
# it all together.
# 
# Pasting Together Data Structures
# PASTE() concatenates multiple character vectors into a single vector; if you concat a different
# vectory type it will be coerced into a character vector first. Default is to separate values with a
# SPACE, which can be changed with the SEP = argument
x <- c("a", "b", "c", "d", "e")
y <- c("A", "B", "C", "D", "E")

paste(x, y)

paste(x, y, sep = "-")

paste(x, y, sep = "-", collapse = "#") # Return just a single value vector

# rbind and cbind pull together multiple data frames or matrices. cbind combines
# objects by adding columns, or bringing two tables together horizontally
name.last <- c("Manning", "Brady", "Peppers", "Palmer", "Manning")
name.first <- c("Peyton", "Tom", "Julius", "Carson", "Eli")
team <- c("Colts", "Patriots", "Panthers", "Bengals", "Giants")
position <- c("QB", "QB", "DE", "QB", "QB")
salary <- c(18700000, 14626720, 14137500, 13980000, 12916666)

top.5.salaries <- data.frame(name.last, name.first, team, position, salary)

# Create a new data frame with two more columns (year and rank)
year <- rep(2008, 5)
rank <- c(1, 2, 3, 4, 5)
more.cols <- data.frame(year, rank)
more.cols

# Let's bring the data frames together
cbind(top.5.salaries, more.cols)

# RBIND() brings together dataframes vertically, adding the 2nd df to the bottom of the first

# Merging Data by Common Fields
# Tack on some additional information to the previous two data.frames about football players
# and then merge them based on the common field between them. This is a completely goofy example
# and the numbers don't match correctly but we can see how MERGE() works.
top.5.salaries$player.ID <- c(1, 2, 3, 4, 5)
more.cols$player.ID <- c(5, 3, 2, 4, 1)

intersect(names(top.5.salaries), names(more.cols)) # Tells us which columns match!

top.5.salaries.w.ID <- merge(top.5.salaries, more.cols) # Didn't need to use BY = parameter because defaulted to INTERSECT

# Transformations p.179
# Sometimes variables just won't be quite right.
# 
# Reassigning Variables
# One of the most common and convenient ways to redefine a variable in a data frame is to use the
# assignment operator. Let's convert the POSITION variable from a FACTOR to a CHARACTER.

class(top.5.salaries$position) # Begins as a FACTOR
top.5.salaries$position <- as.character(top.5.salaries$position)
class(top.5.salaries$position) # Ends as a CHARACTER

# The Transform Function
# Allows for altering more than one variable in a dataframe. First, specify the dataframe
# and then a set of expressions that use variables in the dataframe. Convert POSITION back
# to a FACTOR and multiply SALARY * 3 to indicate three-year cap amount.
top.5.salaries.transformed <- transform(top.5.salaries, position = as.factor(position), three.yr.cap = salary * 3)

names(top.5.salaries.transformed)

class(top.5.salaries.transformed$position)

# Applying a Function to Each Element of an Object p.180
# 
# Applying a function to an array
# Use APPLY(), which takes three arguments: X = the array, MARGIN = the dimensions against which to apply the function,
# and FUN = the function
x <- 1:20
dim(x) <- c(5, 4)
x

# Apply the MAX function to each ROW where MARGINS = 1 as rows are the first dimension
apply(X = x, MARGIN = 1, FUN = max)

# Change MARGIN to 2 for columns
apply(X = x, MARGIN = 2, FUN = max)

# Slightly more complicated as we're going to have a three-dimensional array
x <- 1:27

dim(x) <- c(3, 3, 3)

x

# Let's look at which values are grouped for each value of MARGIN where 1 = rows, 2 = cols and 3 = each array
# COLLAPSE converts the results into VECTORs separated by the defined symbol
apply(X = x, MARGIN = 1, FUN = paste, collapse = ",")

apply(X = x, MARGIN = 2, FUN = paste, collapse = ",")

apply(X = x, MARGIN = 3, FUN = paste, collapse = ",")

# Applying a function to a list or vector
# To apply a function to a list or vector and return a list, use LAPPLY()
x <- as.list(1:5)
lapply(x, function(x) 2 ^ x)

# Apply a function to a dataframe and the function will be applied to each vector within it
d <- data.frame(x = 1:5, y = 6:10)
d

lapply(d, function(x) 2 ^ x)

lapply(d, max)

# If you want a VECTOR, MATRIX or ARRAY instead of a list, use SAPPLY()
sapply(d, function(x) 2 ^ x)

sapply(d, max)

# Finally, for multivariate function use, try MAPPLY()
# Here we're telling MAPPLY to use the PASTE function on the three vectors of data and
# to use the dash as the separator of the concatenated data
mapply(paste,
       c(1, 2, 3, 4, 5),
       c("a", "b", "c", "d", "e"),
       c("A", "B", "C", "D", "E"),
       MoreArgs = list(sep = "-"))

# The plyr library p.183
# A series of functions that makes remembering the differences in the other xapply functions
# useless. The plyr library accepts and returns ARRAYS, DATAFRAMES, and LISTS. The functions
# are logically named by the type of data input and then the output by first letter; for example,
# input = list and output = list call the llply() function. To discard the output, call the underscore
# version of the function; for example, if input is a DATAFRAME, call d_ply().
library(plyr)

d

lapply(d, function(x) 2 ^ x)

# Equivalent to lapply is llply (input = list, output = list)
llply(.data = d, .fun = function(x) 2 ^ x)

# Input = list, return a dataframe
ldply(d, function(x) 2 ^ x)

# Input = list, output = array
laply(d, function(x) 2 ^ x)

# Show only the 5th column of results
laply(d, function(x) 2 ^ x)[ , 5]

# Binning Data
# Another common transformation is to group a set of observations into bins based on the value of a specific
# variable; for example, you have time series data by day but want it by month.
# 
# Shingles
# Shingles represent intervals in R. They can be overlapping, like roof shingles, and are used extensively
# in the LATTICE graphics package.
library(lattice)
shingle(sat.act$ACT, intervals = sort(unique(sat.act$ACT))) # Produces all values and table of scores by count

# To split the data across relatively equally-sized bins, use EQUAL.COUNT()
equal.count(sat.act$ACT)

shingle(pdg$Nbr.of.Investments, intervals = sort(unique(pdg$Nbr.of.Investments)))
equal.count(pdg$Nbr.of.Investments)

# Cut p.186
# Cut is good for continuous variables and splitting them into distinct pieces; cut takes a numeric vector
# as input and returns a FACTOR. Suppose we want to count the number of players with batting averages in certain
# ranges.
library(nutshell)
data(batting.2008)

batting.2008.AB <- transform(batting.2008, AVG = H / AB) # Transform the original data by adding the AVG column

# Pull out all players with > 100 AB
batting.2008.over100AB <- subset(batting.2008.AB, AB > 100)

# Cut the BA for > 100 AB players into 10 groups
battingavg.2008.bins <- cut(batting.2008.over100AB$AVG, breaks = 10)

# Show those groups
table(battingavg.2008.bins)

# Use CUT to determine the number of investment bins by plan with PDG
# Pull all plans with more than 1 active participant
pdg.plans.gr1 <- subset(pdg, TOTAL_EMPL_CNT > 1)

pdg.plans.inv.bins <- cut(pdg.plans.gr1$Nbr.of.Investments, breaks = 4)

table(pdg.plans.inv.bins) # 0.965-9.73 = 6, 9.73-18.5 = 27, 18.5-27.3 = 197, 27.3-36 = 70

# Let's add the plan's Generosity Ratio
pdg.genratio <- transform(pdg, gen.ratio = Employer_Sum / Employee_Sum)

# Combining Objects with a Grouping Variable p.187
# Sometimes you would like to group like objects (either vectors or data frames) into a single data frame, 
# with a column labeling the source. Use MAKE.GROUPS() in the LATTICE package.
hat.sizes <- seq(from = 6.25, to = 7.75, by = .25) # Same as seq(6.25, 7.75, .25)

pants.sizes <- c(30, 31, 32, 33, 34, 35, 38, 40)

shoe.sizes <- seq(from = 7, to = 12) # default by = 1

make.groups(hat.sizes, pants.sizes, shoe.sizes)

# Not sure what the value of MAKE.GROUPS is unless the groupings are stored and used later, but can't think
# of an example to try right now to make it work.

# Subsets
# Sometimes you have too much data and other times you have too much relevant data; for example, if examining
# billions of website visits you might only need thousands to find a statistically significant result because
# R can't hold billions of records in local memory

# Bracket Notation
# We only want select players born in 1980.
library(nutshell)
data(batting.2008)
batting.born.1980 <- batting.2008[batting.2008$birthYear == 1980, ] # Returns all columns of matching rows

# We can also limit the columns that are returns by combining the ones we want either by number of names:
batting.born.1980.limited <- batting.2008[batting.2008$birthYear == 1980, c("nameLast", "nameFirst", "bats", "throws")]

# This would do the same thing, but not be as descriptive as to what's being pulled
batting.born.1980.colNums <- batting.2008[batting.2008$birthYear == 1980, c(1, 2, 5, 6)]

# Random Sampling
# Sometimes it's just better to take a random sample because you have too much data or for performance reasons.
# An easy way to pull a random sample is with the SAMPLE() function.
# sample(x = object from which sample taken, size = integer value of size, replace = logical value with or without replacement, prob = vector of probabilities for selecting each item)
# Pull 5 rows from the batting data
batting.2008[sample(1:nrow(batting.2008), 5), ]

# Slightly more complicated; want to randomly select statistics for three teams
batting.2008$teamID <- as.factor(batting.2008$teamID) # Convert teamID into a FACTOR
levels(batting.2008$teamID) # Display the FACTOR levels

sample(levels(batting.2008$teamID), 3) # Pull a sample of three of the FACTOR levels

# Pull 3 random team records
# IS.ELEMENT() is equivalent to x %in% y
batting.2008.3teams <- batting.2008[is.element(batting.2008$teamID, sample(levels(batting.2008$teamID), 3)), ]

summary(batting.2008.3teams$teamID) # One run pulled NY Yankees, Seattle Mariners, and Texas Rangers

# Summarizing Functions p.190
# Often data is too fine-grained for analysis, such as wanting to know the average number of pages delivered 
# to each user during a website session.
# TAPPLY() is flexible for summarizing a vector, such as summarizing 2008 homeruns by team
tapply(batting.2008$HR, list(batting.2008$teamID), sum)

# Get the FIVENUM of batting averages by team in each league
tapply(batting.2008$H / batting.2008$AB, list(batting.2008$lgID), fivenum)

# TAPPLY can also work across multiple dimensions; Homeruns per player by league and handedness
tapply(batting.2008$HR, list(batting.2008$lgID, batting.2008$bats), mean)

# Closely related to TAPPLY is BY() except that BY() works on DATAFRAMES, and INDEX argument is
# replaced by INDICES. BY pops WARNINGS about the mean function and suggests colMeans() instead.
# This statement says "Pull average hits, doubles, triples and homers from batting.2008 by league ID and handedness."
by(batting.2008[ , c("H", "2B", "3B", "HR")], list(batting.2008$lgID, batting.2008$bats), mean)

# AGGREGATE is another option working similar to BY()
# This says, "Sum each team's total at-bats, hits, walks, doubles, triples and homeruns"
aggregate(batting.2008[ , c("AB", "H", "BB", "2B", "3B", "HR")], list(batting.2008$teamID), sum)

# ROWSUM() takes AGGREGATE one step simpler for summary; don't need a LIST
rowsum(batting.2008[ , c("AB", "H", "BB", "2B", "3B", "HR")], group = batting.2008$teamID)

# Counting Values p.194
# Often useful to count the number of observations that take on each possible value of a variable.
# The simplest is TABULATE(), which counts the number of elements in a vector that take on each
# integer value and returns a vector with counts. How many players hit 0, 1, 2, etc. homers in 2008?
HR.cnts <- tabulate(batting.2008$HR)
HR.cnts # Results aren't labeled, just counts are produced

# Tabuluate doesn't label results, so let's create the labels
names(HR.cnts) <- 0:(length(HR.cnts) - 1)
HR.cnts # 92 players hit 0 homers, while 6 hit 32

# TABLE() can be used to tabulate factor values where TABULATE is for integer values only.
table(batting.2008$bats) # Table of only number of players by handedness

# Now by batting and throwing
table(batting.2008[ , c("bats", "throws")])

# Now add by league
table(batting.2008[ , c("bats", "throws", "lgID")])

# XTABS is like table except more flexible because it uses a formula-based method to define cross-tabs
xtabs(~bats + throws + lgID, batting.2008)

# Count by-segment of client Main or Other plans number of investments
x <- as.data.frame(xtabs(~Nbr.of.Investments + ClientMO + Segment, pdg))

# Chapter 13: Graphics p.213
# 
# Scatterplots
# 
# Looking at cases of cancer in 2008 and toxic waste releases by state in 2006, included in the NUTSHELL package.
library(nutshell)
data(toxins.and.cancer)

# To display a scatterplot, use the PLOT function, which is generic
attach(toxins.and.cancer)
plot(total_toxic_chemicals / Surface_Area, deaths_total / Population) # Plotting two percentages! Doesn't look heavily correlated

# What about airborne toxins and lung cancer?
plot(air_on_site / Surface_Area, deaths_lung / Population)

# Which states are associated with which points on the scatter?
# The LOCATOR function tells you the coordinates of a specific point (or set of points)
# Plot the data, then add LOCATOR(1) to the code. When it runs, click a plot point
locator(1) # Clicking a plot point presents the coordinates in the CONSOLE; ex: x = 0.002366628 and y = 0.0007292312

# IDENTIFY can also be used to interactively label points on a plot
identify(air_on_site / Surface_Area, deaths_lung / Population, State_Abbrev) # The plotted data is not shown until Finish is clicked

# What if we want to ID all of the points right off the bat?
plot(air_on_site / Surface_Area, deaths_lung / Population,
     xlab = "Air Release Rate of Toxic Chemicals",
     ylab = "Lung Cancer Death Rate", 
     text(air_on_site / Surface_Area, deaths_lung / Population, State_Abbrev, cex = 0.5, adj = c(0, -1)))

# PLOT is good for two columns of data on one chart. What if you have more columns to plot, perhaps split into
# different categories? Here comes MATPLOT! If plotting a lot of points consider SMOOTHSCATTER (smoothScatter).

# To generate a scatter plot of n different variables for each of the values in the data frame, use PAIRS. Let's plot
# the hits, runs, strikeouts, walks, and homeruns for each MLB player who have more than 100 ABs in 2008
library(nutshell)
data(batting.2008)
pairs(batting.2008[batting.2008$AB > 100, c("H", "R", "SO", "BB", "HR")])

# Plotting Time Series
# How do turkey prices change during a year?
library(nutshell)
data(turkey.price.ts)
plot(turkey.price.ts)

# Is there a correlation to price and time of the year? Try a CORRELOGRAM! This shows how correlated points
# are with each other, by difference in time. This is done with the ACF (auto-correlation function) by default.
acf(turkey.price.ts) # Points are correlated over 12-month cycles and inversely correlated over 6-month cycles.

# Bar Charts
# Use the BARPLOT function. Let's look at doctoral degrees awarded in the US between 2001-2006:
library(nutshell)
data(doctorates)

# Tranform the data.frame into a MATRIX for plotting; BARPLOT CANNOT work with data frames
doctorates.m <- as.matrix(doctorates[2:7])
rownames(doctorates.m) <- doctorates[ , 1]

doctorates.m

barplot(doctorates.m[1, ]) # Plot the 2001 data in the 1st row

# Want to show all different years as bars stacked next to one another, plotted horizontally,
# with a legend for the different years
barplot(doctorates.m, beside = TRUE, horiz = TRUE, legend = TRUE, cex.names = .75)

# Now how do we stack the bars and make them vertical?
barplot(t(doctorates.m), legend = TRUE, ylim = c(0, 66000)) # Transpose the data, keep the legend, and limit the y-axis in size

# Pie Charts
# There are lots of reasons not to use PIE CHARTS, but they can be good for highlighting different parts of quantities, mostly
# if there aren't too many categories to display. Let's look at 2006 fishery data in millions of pounds of live fish.
domestic.catch.2006 <- c(7752, 1166, 463, 108)
names(domestic.catch.2006) <- c("Fresh and frozen", "Reduced to meal, oil, etc.", "Canned", "Cured")
# NOTE: cex=.6 setting shrinks text by 40% so labels are visible
pie(domestic.catch.2006, init.angle = 100, cex = .6)

# Plotting Categorical Data
# What about plotting the conditional density of a set of categories dependent on a numeric variable? CDPLOT uses 
# the DENSITY function to compute kernel density estimates across the range of numeric values and then plots these estimates.
# Let's look at the distribution of batting hand (B/R/L) variation by batting average for 2008 MLB players.
batting.w.names.2008 <- transform(batting.2008,
                                  AVG = H / AB, bats = as.factor(bats), throws = as.factor(throws)) # Change the original data set with new variables and factors
cdplot(bats ~ AVG, data = batting.w.names.2008,
       subset = (batting.w.names.2008$AB > 100)) # Formula of Avg by Batting Hand subsetted by players with at least 100 AB

# Want to plot the proportion of observations for two different categorical variables with MOSAICPLOT, which shows a set
# of boxes corresponding to different factor values. The x-axis corresponds to one factor and the y-axis to another factor.
# For this example let's show 2008 MLB player Batting Hand versus Throwing Hand...
mosaicplot(formula = bats ~ throws, data = batting.w.names.2008, color = TRUE)
dev.off() # Wipes out the Plots console

# SPINEPLOTs shows different boxes corresponding to the number of observations associated with two factors.
spineplot(formula = bats ~ throws, data = batting.w.names.2008)

# ASSOCPLOTs plots a set of bar charts, showing the deviation of each combination of each factor from independence, also
# known as Cohen-Friendly association plots.
assocplot(table(batting.w.names.2008$bats,
                batting.w.names.2008$throws),
                xlab = "Throws",
                ylab = "Bats")

# Three-Dimensional Data
# All of these functions can be used against MATRICES of values where rows correspond to the x-axis, columns to the y-axis, and
# matrix values to the z-axis. These examples are from Yosemite and the US Geological Survey, specifically from http://seamless.usgs.gov/website/seamless/viewer.htm.
# The PERSP (perspective) function plots and graphs the data for visualization in 3D
library(nutshell)
data(yosemite)
# What are the dimensions of the data?
dim(yosemite) # 562 by 253
# Select all 253 columns in reverse order
yosemite.flipped <- yosemite[ , seq(from = 253, to = 1)]
# Select only a square subset of the elevation points by taking only the rightmost 253 columns
yosemite.rightmost <- yosemite[nrow(yosemite) - ncol(yosemite) + 1, ] # The +1 makes sure we get exactly 253 without a 'fencepost' error
# Now plot the data and build the halfdome
halfdome <- yosemite[(nrow(yosemite) - ncol(yosemite) + 1):562, seq(from = 253, to = 1)]
persp(halfdome, col = grey(.25), border = NA, expand = .15, theta = 225, phi = 20, ltheta = 45, lphi = 20, shade = .75)

# Another 3D function for plotting data is IMAGE
image(yosemite, asp = 253/562, ylim = c(1,0), col = sapply((0:32)/32, gray)) # ASP = aspect ratio

# Heat maps plot a single variable on two axes, each representing a different factor. The heat map
# plots a grid, where each box is encoded with a different color depending on the size of the dependent
# variable. Another function is CONTOUR, which plots contour lines, connecting equal values in the data.
# CONTOURS are often added to existing IMAGE plots.
contour(yosemite, asp = 253/562, ylim = c(1, 0))

# Plotting Distributions p.239
# Understanding the shape of a variable's distribution can be critical for determining outliers or whether
# a certain modeling technique will work or simply how many observations are within a certain range of values.
# Continue using the 2008 MLB batting data.
data(batting.2008)

batting.2008 <- transform(batting.2008,
                          PA = AB + BB + HBP + SF + SH)
hist(batting.2008$PA)

# This is great, but let's exclude players with < 25 plate appearances, increase the # of bars, and make breaks at 50
hist(batting.2008[batting.2008$PA > 25, "PA"], breaks = 50, cex.main = .8)

# Closely related to the HISTOGRAM is the DENSITY PLOT, which many statisticians like better better because they are 
# more robust and easier to read. There are two steps: 1) Use DENSITY to calculate kernel density estimates, then 2) use
# PLOT to plot the estimates.
plot(density(batting.2008[batting.2008$PA > 25, "PA"]))

# A common addition to a kernel density plot is a "RUG", essentially a STRIP PLOT shown along the axis, with each point
# represented by a short line segment. These are added with the following statement.
rug(batting.2008[batting.2008$PA > 25, "PA"])

# The QUANTILE-QUANTILE plot compare the distribution of the sample data to the distribution of a theoretical distribution
# (often normal). If the sample data is distributed the same way as the theoretical distribution, all points will be plotted
# on a 45 degree line froom the lower-left corner to the upper-right corner. Q-Q plots provide a VERY EFFICIENT WAY TO TELL
# HOW A DISTRIBUTION DEVIATES FROM AN EXPECTED DISTRIBUTION. These plots are generated with the QQNORM() function.
qqnorm(batting.2008$PA)

# Comparing two actual distributions or to another type of theoretical distribution? Use QQPLOT.
qqplot(batting.2008$PA, batting.2008$AB, xlab = "Plate Appearances", ylab = "At-Bats", col = c("Red", "Blue")) # How do Plate Appearances stack up versus At-Bats? Pretty well...

# Box Plots
# A box plot is a compact way to show the distribution of a variable. The box shows the interquartile range (IQR), which
# is the range between the 25th and 75th percentiles of the data. The line inside the box displays the MEDIAN and the 
# "whiskers" at either end of the line show adjacent values, which show extreme values but not always to the absolute minimum or
# maximum values. Extreme values are displayed outside the line plot and plotted separately. Boxplots are defaulted to X and Y
# plots, but can also plot formulas.
batting.2008 <- transform(batting.2008,
                          OBP = (H + BB +HBP) / (AB + BB + HBP + SF))
boxplot(OBP ~ teamID,
        data = batting.2008[batting.2008$PA > 100 & batting.2008$lgID == "AL", ], 
        cex.axis = .5) # Plot all team OBPs for teams in the AL and all players with > 100 Plate Appearances

boxplot(OBP ~ teamID,
        data = batting.2008,
        subset(batting.2008, PA > 100 & lgID == "AL"),
        cex.axis = .5) # This does not work exactly the same way, representing 1.0 OBPs for some teams

# Graphics Devices
# Graphics devices are the electronic "window" on which graphics are displayed. In default R that device is the one
# that plots graphics on the screen. In Windows the windows device is used. In Unix the X11 device and on the Mac
# the quartz device. Generating graphics is done in common formats such as bmp, jped, png, and tiff devices, and can
# include postscript, pdf, pictex, xfig and bitmaps.
# 
# Most devices allow you to specify the width, height, and point size of the output. After writing to a graphics file,
# call dev.off() to close and save the file.
# 
# Customizing Charts p.247
# Most intuitive way is with arguments to a charting function, but session parameters can also be set and your own functions
# can be written. The following are some common arguments for charting functions.
# 
#   add: Should this plot be added to the existing plots on the device, or should the device be cleaned first?
#   axes: Controls whether AXES will be plotted on the chart
#   log: Controls whether points are plotted on a LOGARITHMIC scale
#   type: Controls the type of graph being plotted
#   xlab, ylab: Labels for x- and y-axes
#   main: Main title for the plot
#   sub: Subtitle for the plot
# 
# Graphical Parameters
# All of this is found in the GRAPHICS package. These can be parameters to graphics functions, but the PAR()
# command can be used to set graphics parameters, too. PAR() sets graphics functions for a specific DEVICE
# and become the defaults any new plot until you close the device. PAR() can be helpful to set parameters for
# multiple graphics calls. PAR() can be used to CHECK the device's graphic parameters.

# Check the BACKGROUND color
par("bg") # returns "white"

par(bg = "transparent") # Setting the BG color

# Annotation
# TITLES and AXIS LABELS are called chart annotation. Chart annotation can be managed with the ANN parameter.
# If you set ann = FALSE then titles and axis labels are not printed.
# 
# Margins
# The whole graphics device is called the DEVICE REGION. The area where the data is plotted is the PLOT REGION.
# The MAI argument is used to specify the margin size in inches; MAR is to specify the margin in lines of text.
# If using MAR then can use MEX to control how big a line of text is in the margin compared with the rest of the
# plot. Controlling margins around titles and labels is done with MGP parameter. Overall dimensions of the device
# in inches can be found with the DIN parameter.
# 
# Multiple plots
# Multiple charts can be plotted in the same chart area by setting the MFCOL parameter; for example, to set six
# figures within the plot area in three rows of two cols,
par(mfcol = c(3, 2))
pie(c(5, 4, 3))
plot(x = c(1, 2, 3, 4, 5), y = c(1.1, 1.9, 3, 3.9, 6))
barplot(c(1, 2, 3, 4, 5))
barplot(c(1, 2, 3, 4, 5), horiz = TRUE)
pie(c(5, 4, 3, 2, 1))
plot(c(1, 2, 3, 4, 5, 6), c(4, 3, 6, 2, 1, 1))
dev.off() # Reset the device

# Stop at p.250

# Chapter 14: Lattice Graphics p.267
# An overview of the LATTICE package. Many improvements over the base GRAPHICS package, including splitting a chart
# into different panels in a grid, or groups shown with different colors of symbols using a conditioning or grouping
# variable. The LATTICE package is an implementation of the Trellis graphics package developed in the 1990s.
# 
# Chapter 15: ggplot2 p.325
# One of the most popular R packages for producing readable charts using the "grammar of graphics".
# GGPLOT2 does not work with our base installation of R 2.14.0!
# Start with a very simple data set...
d <- data.frame(a = c(0:9), b = c(1:10), c = c(rep(c("Odd", "Even"), times = 5)))

d

# We want to show how variable y varies with variable x using QPLOT (quick plot), which defaults to plotting points.
library(ggplot2)
qplot(x = a, y = b, data = d)

# The GGPLOT2 key idea: What do you want to present? Not how do you want to present it
first.ggplot2.example <- qplot(x = a, y = b, data = d)

qplot(x = education, y = health, data = doctorates)





























# Chapter 21 Classification Models p.467
# Not all problems can be solved by predicting a continuous numerical quantity like a drug dose,
# or a person's wage, or the value of a customer. Often an analyst tries to classify an item into
# a category or maybe to estimate the probability that an item belongs in a certain category.
# These models are called classification models.
# 
# Linear Classification Models p.467
# Suppose you were trying to estimate the probability of a certain outcome FOR A CATEGORICAL
# VARIABLE WITH TWO VALUES. A linear function using predictor variables has the problem that
# the value of y is unconstrained while the valid values are only between 0 and 1 (no and yes).
# A good approach to dealing with this problem is to pick a function for y that varies only
# between 0 and 1 for all possible predictor values. 
# 
# Looking at the field goal data again...
library(nutshell)
data(field.goals)

# Creates a new binary variable for field goals that are good or bad (anything other than good)
field.goals.forlr <- transform(field.goals, good = as.factor(ifelse(play.type == "FG good", "good", "bad")))

field.goals.table <- table(field.goals.forlr$good, field.goals.forlr$yards)

field.goals.table

# Plot the results as percentages
plot(colnames(field.goals.table), field.goals.table["good", ] / (field.goals.table["bad", ] + field.goals.table["good", ]), 
     xlab = "Distance in Yds", ylab = "Percent Good")

# Each FGA is a Bernouilli trial--only good or bad. Now call the GLM() function to model the probability
# of a successful field goal using a logistic regression:
field.goals.mdl <- glm(good ~ yards, data = field.goals.forlr, family = "binomial")

field.goals.mdl

# Better info with summary
summary(field.goals.mdl)

# Add a line to the plot showing the estimated probability of success at each point
# Do this as a function
fg.prob <- function(y) {
  eta <- 5.178856 - 0.097261 * y # The regression formula
  1 / (1 + exp(-eta)) # The logit expression
}

# This models the expected results pretty well
lines(15:65, fg.prob(15:65), new = TRUE)

fg.atts <- c(29, 42, 70, 44, 51)

fg.est <- fg.prob(fg.atts)

# IRR > 70?
irr.forlr <- transform(irr, above = as.factor(ifelse(irr$END_WRR > 70, "above", "below")))

irr.table <- table(irr.forlr$above, irr.forlr$END_WRR)

plot(colnames(irr.table), irr.table["above", ] / (irr.table["above", ] + irr.table["below", ]),
     xlab = "IRR", ylab = "Percent Above")

irr.above.mdl <- glm(above ~ END_WRR, d)

# Statistics II for Dummies
# Logistic regression Chapter 8
# Build the data: How many moviegoers of each age enjoyed the movie?
movie <- data.frame(age = c(rep(10, 3), rep(15, 4), rep(16, 3), rep(18, 3), rep(20, 3), rep(25, 4), rep(30, 4), rep(35, 5), rep(40, 6), rep(45, 3), rep(50,2)),
                    enjoyed = c(rep(1, 12), rep(0, 2), rep(1, 4), rep(0, 2), rep(1, 2), rep(0, 2), 1, rep(0, 4), 1, rep(0, 10)))

movie # Print the data

# Convert the ages to FACTORS
movie$age <- as.factor(movie$age)

# Summarize the results by age
movies.summary.table <- table(movie$enjoyed, movie$age)

# Plot the percent of each age group that enjoyed the movie
plot(colnames(movies.summary.table),
     movies.summary.table[2, ]/ (movies.summary.table[1, ] + movies.summary.table[2, ]),
     xlab = "Moviegoer Age", ylab = "Percent Enjoying Movie")

# Build the logistic regression model using a Y/N model
movie.log.mdl <- glm(formula = enjoyed ~ age, data = movie, family = "binomial")

# What are the model's results?
summary(movie.log.mdl)

# Create the function to predict the results of the model
enjoy.movie.prob <- function(y) {
  eta <- 4.86539 - 0.17574 * y
  1 / (1 + exp(-eta))
}

# Plot the prediction curve with AGES
lines(10:65, enjoy.movie.prob(10:65), new = TRUE)

# PDG data to predict Services Adoption
svcs2013 <- read.csv("c:\\R\\Data\\PDG2014.csv", header = TRUE, stringsAsFactors = FALSE)

# NQ
nq.table <- table(svcs2013$Segment, svcs2013$NQ) #106 Have, 196 Don't by Segment

nq.table

plot(colnames(nq.table),
     nq.table[2, ] / (nq.table[1, ] + nq.table[2, ]))

nq.log.mdl <- glm(formula = NQ ~ ., data = svcs2013[ , 20:97], family = "binomial")

summary(nq.log.mdl)

str(nq.log.mdl)

nq.log.mdl$coefficients # Base probability for NQ? -77.6%; MobileQE -51.0%, but Offers DB 52.6%

svc.prob <- function(y) {
  
  svcpct <- y * nq.log.mdl$coefficients[2:77]
  
  100 + sum(svcpct, na.rm = TRUE) + nq.log.mdl$coefficients[1]
}

nq.preds <- svc.prob(svcs2013[4, c(20:97)])

nq.preds



























