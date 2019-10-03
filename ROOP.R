##### R Object-Oriented Programming e-book
# by Kelly Black
# from Packt Publishing

# SIDE NOTES: Throughout this book the author refers to ARRAYs and COMMANDs, which are semantic equivalents to words I'm more
# familiar with, especially in R, such as VECTORs and FUNCTIONs. I believe the author uses these terms interchangeably. My notes
# certainly will.

# Chapter 1: Data Types
##### Much of this chapter revolves around the basic R environment, which they assume is 3.0.1+
# This chapter covers working with variables, discrete data types, continuous data types, vectors, and special data types
# R manages memory and variables names dynamically. A variable has scope and the meaning of a variable can vary depending on
# the context. For example, a variable referred to WITHIN a function is available within the function only, whereas the same-named
# variable through the rest of the program is not an issue.
# 
# Variable assignment can be done with the = or <- operators, though the arrowhead is preferred. Assignment can also be done with
# the <<- operator, which instructs R to search parent environments for the same variable. Variable assignment can also go the other
# way, -> and ->>, which simply reverse the direction of the assignment.
fX <- function(x) {
  a <- x
  a
}


a <- 6 # Assign the value 6 to 'a'
a
7 -> a # Assign the value 7 to 'a'
a

fX(9)

a <<- 11 # Check to see if 'a' exists in another environment within this script
a

# How do we find out which variables are currently defined?
ls()

# How do we remove variables or data?
rm(list = ls()) # Removes all of the variables and data by 1) getting all the variables and data in a list format and then removing them all
rm(a) # Removes only variable or data structure 'a'

# Directory options
getwd() # What's the working directory?
dir() # What are the contents of the current working directory?
setwd("c:\\r") # Set the working directory

# Saving and loading workspaces
save(a, file = "a.RData") # Save the variable a in the workspace in the current working directory called a.RData
save.image("wholeworkspace.Rdata") # Save the entire workspace

save(a, file = "a.RData", ascii = TRUE) # Save the variable a in the workspace in the current working directory called a.RData
save.image("wholeworkspace.Rdata", ascii = TRUE) # Save the entire workspace in almost human-readable format

load("a.RData") # Load the file back into R's memory
ls() # Get a list of the current workspace

# How are variables stored?
mode(a) # variable 'a' is a NUMERIC
storage.mode(a) # variable 'a' is stored internally as a DOUBLE

# Working with history
savehistory() # Save the current set of commands
history() # Display the latest history
loadhistory() # Replay commands in a file

# Discrete data types LOC 351 (10%)
# Discrete data types are INTEGER, LOGICAL, CHARACTER and FACTOR. 
# The default data type for a number is a double precision number. Strings can be interpreted as character strings or factors.
# Always understand how R is storing your data and double-check it.
# 
# Integers
# Values are 32-bit integers and must be explicitly cast as integers otherwise will be stored as double precision numbers
bubba <- integer(12) # INTEGER command sets aside space for an integer in memory, in this case 12 of them within the vector bubba
bubba # bubba is 12 zeros (0s)

bubba[1] # First index element of vector bubba is 0

bubba[4] <- 15

bubba

# Two ways to access an element: single brackets ([]) and double brackets ([[]]). For vectors, both do basically the same thing,
# which is reference the index element of the vector.
bubba[4]; bubba[[4]] # Both of these (separated by a semi-colon runs both on the same line) return 15

# The single versus double-bracket behavior is different with LISTS; the double braces returns objects of the same type as the
# elements WITHIN the vector, while single braces return values of the same type as the variable itself. Single braces on a list
# return the list, while double braces return a vector. A LIST is a data structure that allows for multiple types of vectors and lengths
# of those vectors (ragged vector lengths).

# Numbers can be cast as integers using the AS.INTEGER() command
a <- 13.55
typeof(a) # How R stores the object, and a is a double (defaulted because this is R's default)
a <- as.integer(a) # Cast a as an INTEGER
a # a becomes 13, dropping the fractional value, a quick way to FLOOR a double with precision!

# TYPEOF is different than CLASS. CLASS can be modified whereas TYPEOF is descriptive only
class(a)

# Sequences are created with the colon (:) operator or the SEQ() command
1:5
myNum <- as.integer(1:5)
myNum[4]

seq(4, 11, by = 2) # SEQ arguments are FROM, TO, BY

# Whereas as. CASTS values to other types, IS. determines whether a variable is a certain type
a <- 1.2
typeof(a)     # Defaults to DOUBLE
is.integer(a) # FALSE

a <- as.integer(1.2) # Cast the value as an integer, which changes the value to 1
a
typeof(a)     # INTEGER
is.integer(a) # TRUE

# Logical
# Logical data consists of variables that are either TRUE or FALSE. The LOGICAL() command can be
# used to allocate a vector of Boolean variables, where the default starting value is FALSE.
b <- logical(10)
b # 10 FALSEs are displayed
b[3] # Display the 3rd indexed value in the vector
!b # The NOT operator flips the all of the values in the vector, but...
b # DOES NOT change the stored values of the b vector, only the presentation
b <- !b # Changes all the values to TRUE
b

# Casting a value to a logical type uses AS.LOGICAL, where zero (0) is mapped to FALSE and all
# other values are cast to TRUE
a <- -1:1
a
as.logical(a)
a

# Determine if a value is logical with the IS.LOGICAL function
is.logical(a) # This returns FALSE because the actual stored values are NUMERIC!

b <- logical(4) # Set aside 4 index elements in a vector for LOGICAL values, all starting with FALSE
b
is.logical(b) # TRUE because these values are LOGICAL

# Standard operators are available for logical values, but note a difference between & and &&.
# & does an AND comparison on each pairwise element of two vectors, while && returns a single logical result
# USING ONLY THE FIRST ELEMENTS OF THE VECTORS.
(a <- logical(4)); (a[2] <- TRUE); (a[3] <- TRUE) # Parens around a set of command forces the result to be printed to the CONSOLE
b <- logical(4); b[2] <- TRUE; b[4] <- TRUE
a; b
a & b # Returns FALSE TRUE FALSE FALSE
a && b # Returns only FALSE

# Book example of logical operators
(l1 <- c(TRUE, FALSE))
(l2 <- c(TRUE, TRUE))
l1 & l2
l1 && l2
l1 | l2
l1 || l2

xor(a, b) # Exclusive OR where ONLY where one or the other is TRUE; results in FALSE, FALSE, TRUE, TRUE

# Character
# Character data is defined with single or double quotes. The CHARACTER command can be used to set space aside for a character
# string.
(many <- character(3)) # many displays as three empty strings "" "" ""

# Start adding characters to the many variable
many[2] <- "this is the second"
many[3] <- 'yo, third!'
many[1] <- 'and the first'
many

# Values can be cast as CHARACTERS using the AS.CHARACTER() function
(a <- 3.0)
(b <- as.character(a))

# The IS.CHARACTER determines if the variable is...
is.character(a) # FALSE

# Factors LOC 440 (13%)
# Discrete sets of levels are often recorded in ordinal data, such as the results of an individual trial denoted by 
# values like a, b, or c. Factors are great for this type of data. Factors are used to designate different levels and
# can be considered ordered or unordered. NOTE: typeof will return an INTEGER value because R stores the levels as integer
# values to reduce storage.
(lev <- factor(x = c("one", "two", "three", "one"))) # Displays Levels: one two three
# Determining the levels of a FACTORED variable
levels(lev)

sort(lev) # Sort a vector by FACTOR levels

# Identical to previous lines but explicitly DEFINING the levels within the factor function
(lev <- factor(x = c("one", "two", "three", "one"), levels = c("one", "two", "three"))) # Displays Levels: one two three
# Determining the levels of a FACTORED variable
levels(lev)

sort(lev) # Sort a vector by FACTOR levels

# Factors can be cast using AS.FACTOR and variables can be tested with IS.FACTOR.

# Continuous data types LOC 455 (14%)
# Continuous data is, basically, data with data between the whole values, such as numbers with fractional values or complex 
# values such as math functions. Each can use their equivalent AS. and IS. functions to cast other values or determine if the value
# is the type.
# 
# Double
# Default numeric data type in R. The double command can be used to set aside a vector of double precision numbers.
(d <- double(8)) # Displays 8 zeros
rm(d)
typeof(d <- double(8)) # Stupid, but R displays "double" instead of 8 zeros but does assign the DOUBLES to d
d # d with 8 zeros
typeof(d) # double, of course

# Complex
# Appending 'i' to the end of the number will make it the imaginary part of a complex number.
1i
1i * 1i
z <- 3 + 2i
z * z
Mod(z)
Re(z) # The real element of z = 3
Im(z) # The imaginary element of z = 2
Arg(z) # 0.5880026
Conj(z) # 3 - 2i

(z <- complex(3)) # allocate space for 3 complex variables
(z <- complex(real = c(1, 2), imag = c(3, 4))) # 1 + 3i, 2 + 4i
Re(z)

# Casting to and checking to see if a value is complex use AS. and IS. just like other data types.

# Special Data Types (NA, NULL)
# NA indicates a missing value, and is a constant in R. A variable can be tested for with IS.NA
(n <- c(NA, 2, 3, NA, 5))
is.na(n) # TRUE FALSE FALSE TRUE FALSE
n[!is.na(n)] # 2 3 5

# NULL
# NULL has the same meaning as the keyword null in C; it's not an actual type but used to determine
# whether or not an object exists.

a <- NULL
typeof(a) # "NULL"

# objects
# All of the preceding examples are considered objects in the R environment. When writing functions and
# classes it's important to realize that they're treated like variables. The names used to assign variables
# are just a shortcut for R to determine where an object is located. There is a difference between calling 
# the complex() function and referring to the set of instructions located at complex.
# 
# Notes on the as. and is. functions
# To determine whether a variable is of a given type generally starts with the IS. prefix, while
# casting to that type generally start with AS. prefix.

# Chapter 2: Organizing Data LOC 562 (17%)
# Basic Data Structures
# Vectors, lists, data frames, tables and matrices--with a focus on the data structures themselves
# 
# Vectors
# The default data structure in R. Defining a variable with one number tells R to save it as a vector of length  1.
(a <- 5) # Prints [1] 5
a[1] # Prints [1] 5 too

# The c() command is a common way of building vectors; it combines (concatenates) a set of arguments to form a single
# vector.
(v <- c(1, 3, 5, 7, -10))
v[4] # Print the fourth indexed element, 7

# Assign a new value within the vector by subtracting two others
(v[2] <- v[1] - v[5]) # Displays 11

# The : and seq notation
# The : notation creates a list of sequentially numbered values for given start and end values
1:5 # Prints [1] 1 2 3 4 5
10:14 # Prints [1] 10 11 12 13 14

# The SEQ() command does the same thing but with more flexibility; the start, stop and by values
# can be set within the command
(b <- seq(3,5)) # Prints 3 4 5
(b <- seq(3, 10, by = 3)) # Prints 3 6 9

# Lists
# Lists are flexible and an unstructured way to organize information. Lists can be thought of as 
# a collection of named objects, and are created using the LIST command; a variable can be tested
# or coerced (cast) with is. and as. A component within a list can be accessed using the $ character
# to denote which object within the list to use.
assumedMeans <- c(1.0, 1.5, 2.1) # Remember all of these are stored as DOUBLE because they're continuous and the default
alpha <- 0.5
eigenValue <- 3 + 2i

(l <- list(means = assumedMeans, alpha = alpha, maxRealEigen = eigenValue)) # Each vector is being named within the list

l$means

l$maxRealEigen

l[1] # Displays all the values in the $means vector
l[[1]] # Does the same thing as l[1]
l$means[2] # Displays 1.5, the 2nd item in the means vector

# The NAMES and ATTRIBUTES commands can be used to determine the components within a list. Attributes is more generic and 
# can be used to list the components of classes and a wider range of objects. Names can also be used to rename the components
# of a list.
names(l) # Display the list item names

names(l) <- c("assumedMeans", "confidenceLevels", "maximumRealValue") # Define the list items names
l # Display the list contents

# Data Frames
# similar to a list with many similar operations except that all components must have the same number of elements,
# making the "frame" more like a table you'd see in Excel, more of a square or rectangular shape. Data Frames can mix element types, they just
# can't have "ragged" vector lengths--col A must have the same number of rows as col C.
(d <- data.frame(Q1 = as.factor(c('y', 'n', 'y', 'y', 'n')), Q2 = c(2, 0, 1, 2, 0)))
# We assigned the answers to two questions to this data.frame, "Do you have a cat?" and "How many rooms in your house need new carpet?"
# We named the vectors Q1 and Q2 and cast the Q1 answers as factors, not just characters

# Display the answers to Q1
d$Q1 # Shows the contents and the factor levels; remember the data is stored as integers
typeof(d$Q1) # Displays INTEGER

summary(d) # Displays the most-common descriptive stats of the object

# NAMES and ATTRIBUTES have the same behaviors with data frames and lists; let's rename the Questions in the data frame
(names(d) <- c('HaveCat', 'NumberRooms')) # Redefine and display the new column names of the d dataframe
attributes(d) # Displays NAMES, ROW.NAMES, CLASS
row.names(d[1]) <- "Number One" # This CANNOT be done
row.names(d[1]) <- 14 # This doesn't work either
row.names(d) <- c(17, 8, 11, 22, 90) # This DOES work!

# Tables
# R automatically makes frequency tables from categorial data. The TABLE command has a number of options.
# Using the previous data.frame questions.
(q1Results <- table(d$HaveCat)) # Table with headers c(n, y) and totals c(2, 3)
summary(q1Results) # Displays Number of cases in table: 5, Number of factors: 1c
typeof(q1Results) # Displays table? Nope, INTEGER, the data type presented

# Two-way tables are easy: just add another variable for a cross-tabulation
(results <- table(d$HaveCat, as.factor(d$NumberRooms))) # Vertical = HaveCat, Horizontal = NumberRooms
# Cast the numeric value as a factor; necessary for the table?
(results <- table(d$HaveCat, d$NumberRooms)) # Results exactly the same; R must explicitly cast the variables
summary(results) # Displays number of cases as 5, and number of factors = 2! Q2 was NEVER defined as a factor!
# Summary also returns a chi-square test for independence automatically for the frequency data!
summary(table(d$HaveCat, d$NumberRooms)) # This DOES NOT display the table itself, just the summary

# Tables have rows and columns that can be named, too. Unfortunately the commands aren't the same as DATA.FRAMES
rownames(results) <- c("No cat", "Has cat")
colnames(results) <- c('No room', 'One room', 'Two rooms')
results

# TABLE command requires ORDINAL data; numeric (continuous) data can be converted to display an interval
# into which it falls with the CUT command, which takes the numeric data and a vector of break points.
a <- c(-0.8, -0.7, -0.9, -1.4, -0.3, 1.2)
(b <- cut(a, breaks = c(-1.5, -1, -0.5, 0, 0.5, 1.0, 1.5))) # Cut a's data by the listed break points, store in b
summary(b) # Display the frequencies of a's data in b by the defined breaks

(b <- cut(a, breaks = seq(-1.5, 1.5, 0.5))) # An excellent use for the SEQ command instead of combining the individual break points

table(b) # Displays the table by break points the same as SUMMARY

plot(table(b)) # This works; it ain't pretty but the point is made!
plot(a) # Plots the vector with index number as x-axis and index value on y-axis

# Matrices and arrays
# Tables are a special case of an array. An array or matrix can be constructed directly using the ARRAY or MATRIX
# commands, respectively. The ARRAY command takes a vector and dimensions, and defaults to column major order, which
# can be overridden by the TRANSPOSE command.
a <- c(1, 2, 3, 4, 5, 6)
a <- as.integer(c(1, 2, 3, 4, 5, 6)) # Would reduce storage
(A <- array(a, c(2, 3))) # Put vector a's data in an array of 2 rows, 3 columns
t(A) # Transpose and display (reverse rows and columns); does not change the internal structure of A
typeof(A) # Displays DOUBLE, which is the default data type because I didn't initially define 

# Arrays can have more than two dimensions, using the DIM command
(A <- array(1:24, c(2, 3, 4), dimnames = c('row', 'col', 'dep'))) # Displays 4 2x3 matrices with defined row and col names
# Accessing individual elements in A is like a vector A[4] displays 4, the 4th element of the vector that is dimensioned

A[2, 3, 4] # Displays the 24th element based on the dimensions, in this case 24
A[2, 3] # Fails because not the correct number of dimensions
A[11] # Displays 11 because this is the 11th element

# Matrices
# A matrix is a two-dimensional array and a special case built with the MATRIX command. Building a MATRIX
# requires specifying the number of rows and columns, and can define how the data is entered, by column (default)
# or row.
(B <- matrix(1:12, nrow = 3)) # Defaults to 4 columns and loads by COLUMN

B[1] # Displays 1
B[2, 3] # Displays row 2, col 3, which is 8 because the data was loaded by column!

# Both arrays and matrices can be altered with the DIM command.
(C <- matrix(1:12, ncol = 3)) # To load by row, set BYROW = TRUE

dim(C) # What are C's dimensions? 4 x 3

dim(C) <- c(3, 4) # Displays the dimensions, not the contents, still loaded by column
C

# Censoring Data
# Using a logical vector as an index is useful for limiting data to be examined. For example, to
# limit a vector to examine only the positive values in the data set, a logical comparison can be
# used for the index into the vector.
(u <- 1:6)
(v <- c(-1, 1, -2, 2, -3, 3))

u[v > 0]
u[v < 0] <- -2 * u[v < 0]
u

# Logical indexes can also be useful with the NA data type using IS.NA and the logical NOT (!) operator.
(v <- c(1, 2, 3, NA, 4, NA))

v[is.na(v)] # Display the NA elements in v
v[!is.na(v)] # Display the elements in v that are NOT NA values

# Many functions have optional arguments on handling NA, but they're not consistent in their usage. Always
# check HELP with respect to any command's NA handling.
v # What's in v?

mean(v) # Displays NA

mean(v, na.rm = TRUE) # Ignore NA values to determine the mean, returns 2.5

# Appending rows and columns (21%)
# Use CBIND and RBIND to append data to existing objects. Both commands can be used on vectors, matrices, arrays
# and data frames. Experiment if trying to append to matrices to be sure the behavior is expected.
(d <- data.frame(one = c(1, 2, 3), two = as.factor(c('one', 'two', 'three')))) # Build a two-column data frame

(e <- c('ein', 'zwei', 'drei')) # Generate a vector of German counting to 3

(de <- cbind(d, third = e)) # Combine the two by adding vector e as a new column with the name 'third'

de$third # Displays ein, zwei, drei and their levels

# If the arguments to CBIND are two data frames (or two arrays), then the command combines all the columns from
# all of the data frames or arrays.
e <- data.frame(three = c(4, 5, 6), four = as.factor(c("vier", "funf", "sechs")))

(newde <- cbind(d, e))

# The RBIND command concatenates the rows of the objects passed to it. The command uses the names of the columns
# to determine how to append the data. The NUMBER AND NAMES OF THE COLUMNS MUST BE IDENTICAL.
# Use the d data.frame from above
# Use the e data.frame from above, too
(rde <- rbind(d, e)) # This doesn't work because the column names don't match!

e <- data.frame(one = c(4, 5, 6), two = as.factor(c("vier", "funf", "sechs")))
(rde <- rbind(d, e)) # Now this works!

# Operations on data structures
# The APPLY commands are used to instruct R to use a given command on specific parts of a list, vector, or array.
# Each data type has different versions of the APPLY commands that are available. Before that, though, understanding
# the MARGINs of a table or array are important. Margins are defined along any dimension, and the dimension used must be
# specified. The MARGIN command can be used to determine the SUM of the ROW, COLUMNS, or the ENTIRE COLUMN of an array or
# table.
(A <- matrix(1:12, nrow = 3, byrow = TRUE)) # A matrix is loaded by-column by default unless overridden like this

margin.table(A) # Sum of all elements of matrix A
margin.table(A, 1) # Sum of all elements of matrix A rows, displays 10, 26, 42
margin.table(A, 2) # Sum of all elements of matrix A cols, displays 15, 18, 21, 24

# Would I get the frequency of rows doing this? YES; this would also work for columns
margin.table(A, 1) / margin.table(A) # Displays 0.128251 0.333333 0.5384615, so row 1 = 13% of total, row 2 = 33%, and row 3 = 54%

margin.table(A, 2) / margin.table(A) # Displays 0.19 0.23 0.27 0.31 (rounded), so this works, too

colSums(A) # Same as margin.table(A)
colSums(A) / sum(A) # Does the same as margin.table(A, 2) / margin.table(A)

# Understanding 'margins' is important for the APPLY commands; what are you applying and to what data are you applying it?
# 
# apply (23%)
# Used to apply a given function across a given margin of an ARRAY or TABLE. For example, to take the sum of a ROW or COLUMN
# from a two-way table, use the APPLY command with arguments for the table, the SUM command, and which dimension to use, 
# which is defined by using 1 (rows) or 2 (columns).
# Use matrix A from above
A

apply(A, 2, sum) # Same as rowSums and margin.table(A, 2); apply the sum command to matrix A's columns

# lapply and sapply
# lapply is used to apply a function to each element in a list, with a resulting list being returned where each component
# of the returned object is the function applied to the object in the original list with the same name.
theList <- list(one = c(1, 2, 3), two = c(TRUE, FALSE, TRUE, TRUE))

(sumResult <-lapply(theList, sum)) # Displays $one [1] 6 $two [1] 3 because the 3 elements of one = 6,
# and the four logical elements of two = 3 (3 TRUE, 1 FALSE)

# What does TYPEOF return on the results?
typeof(sumResult) # List, not INTEGER or DOUBLE

sumResult$one

# sapply is similar to lapply and performs the same operation, but the result is coerced (cast) to a vector, 
# if possible. Using theList, as defined above.

(meanResult <- sapply(theList, mean))

typeof(meanResult) # Returns a vector, not a list, so returns a DOUBLE in this case? Yes, it does!

# tapply
# tapply is used to apply a function to different parts of data within an ARRAY (VECTOR). There are at least three
# arguments, the first is the data on which to apply the operation, the second is the set of factors that defines
# how the data is organized with respect to the different levels, and the third is the operation to perform.
diameters <- c(28.8, 27.3, 45.8, 34.8, 25.3)
tree <- as.factor(c('pine', 'pine', 'oak', 'pine', 'oak'))
tapply(diameters, tree, sd) # Find the standard deviation of the diameters of the two types of trees: pine and oak

# mapply
# Takes a function to apply and a list of ARRAYS. MAPPLY takes the first elements of each array and applies the function
# to that list, then moves to the 2nd element and so on. If one array has fewer elements than the others, mapply will
# reset and start at the beginning of that array to fill in the missing values.

a <- c(1, 2, 3)
b <- c(1, 2, 3)
c <- sum(a, b) # Only sums the totals of a & b to 12, does not total vectors by element
(c <- c(sum(a[1],b[1]), sum(a[2],b[2]), sum(a[3],b[3]))) # This sums the individual elements to build vector/array c
c <- c(2, 4, 6) # This is far simpler than the previous line, but not dynamic

mapply(sum, a, b) # Note the argument order! Function THEN arguments displays [1] 2 4 6
mapply(sum, a, b, c) # MAPPLY takes the function call first and then as many arguments as you want

theList <- list(one = c(1, 2, 3), two = c(TRUE, FALSE, TRUE, TRUE)) # This is the original list
mapply(sum, theList$one, theList$two) # This doesn't work; R says the vectors are of ragged length and the function can't be applied
# This fails because the shorter vector is not a multiple of the longer (3 into 6, for example).

theList2 <- list(one = c(1, 2, 3), two = c(TRUE, FALSE, TRUE, TRUE, TRUE, FALSE))
mapply(sum, theList2$one, theList2$two) # This works because the two vectors are multiples in length of each other
# This MAPPLY displays vector results of [1] 2 2 4 2 3 3, which is (1 + 1) (2 + 0) (3 + 1) (1 + 1) (2 + 1) (3 + 0)

# The difference between LAPPLY and MAPPLY is that LAPPLY results against the total of the list arguments with a SUMMARY, whereas
# MAPPLY is applied to EACH ELEMENT of the VECTORs/ARRAYs. In some ways LAPPLY is columnar while MAPPLY is row-driven, which makes
# me better understand why margins are important. Know how each APPLY function is applied makes it easier to determine which to use.

# Chapter 3: Saving data and printing results (24%)
# 
# File and directory information
# Basic commands to list directories and file information are DIR, LIST.DIRS, and LIST.FILES. To see and change the working directory
# use GETWD and SETWD.
dir() # What files are in the current working directory?

# The files in the current working directory can be stored in a variable and then manipulated
(d <- dir()) # Stores the names of all files in the working directory in variable d
d[1] # displays the name of the first file in the working directory

d <- dir()[1] # Only puts the first file in d?
d # Yup

# list.dirs()
list.files('./csv') # Display the files with the extension .csv; none in my directory?

# Entering data LOC 827 (25%)
# 
# Entering data from the command line
# Combining data with the c() command/function is best known, but there are other ways to define data. The first is SCAN.
# Assigning a variable to the SCAN() command with no arguments offers a prompt to enter values from the command line. If ENTER
# is pressed with no values then the previous values are returned as a vector.
x <- scan()

# Providing the SCAN() command with a file path and name will read the values from the file as if typed from the command line
x <- scan("diameters.csv") # Read the file in the current working directory

# More complex files can be read with SCAN, but the process is a bit convoluted, having to tell SCAN the file structure and
# separator for a file called TREES.CSV, which has two columns of data: tree type and diameter separated by a comma
x <- scan("trees.csv", what = list("character", "double"), sep = ",") # This would store the data as a list

# Another data entry method is DATA.ENTRY() command, which opens a graphical interface (if available). Details depend upon your OS.
data.entry() # Errors out

# Reading tables from files
# One method that assumes the file is nicely arranged and formatted in rows and columns is READ.TABLE(), which has a lot of options.

(flttimes <- read.table('c:\\r\\data\\fltimes.txt', header = TRUE)) # Display the results of reading the TXT file after reading them into the flttimes variable
typeof(flttimes) # Reads in as a list
names(flttimes) # Column titles are generic V1 V2 and V3 because they're not named otherwise

# CSV files
# Similar to READ.TABLE, but where the file structure is unknown. READ.CSV returns a data.frame.
# Lines can be skipped with the SKIP = x option in the read.csv.
invent <- read.csv('inventories.csv', skip = 6, header = TRUE, sep = ',') # Skip the first six lines of the CSV file before reading the headers; the data is separated by commas

# READ.CSV2 has a different set of defaults than .CSV, defined to allow a simpler way of reading a file in which the delimiter
# between the decimal values is a comma and the values are separated by semi-colons, more popular in European countries.

Fixed-width files
Common used where every line has the same format and the information within a given line is strictly organized
by columns. These files can be read with READ.FWF(). The name of the file and width of each column must be explicitly
specified. R can skip columns by providing a negative value for the width of the column.

(trial <- read.fwf('c:\\r\\data\\trialFWF.txt', c(3, 5, 2, 4), skip = 1)) # Read the file in with lengths 3, 5, 2, 4 but skip the first line
typeof(trial) # Displays 'list'
trial$V1

# A column is ignored when preceded by a negative sign
(trial <- read.fwf('c:\\r\\data\\trialFWF.txt', c(3, -5, 2, 4), skip = 1))
# In this example, here's how R reads the file by line--
# Line 1, skip
# Line 2, read locations 1 to 3, skip positions 4 to 8, read positions 9 and 10, and then read positions 11 to 14
# Repeat 1 and 2 until the file is finished
names(trial) <- c('one', 'two', 'three')
trial

# Printing results and saving data
# 
# Saving a workspace
# Saving individual or groups of variables in the environment can be done with SAVE(), whereas the entire workspace's variables
# can be saved with SAVE.IMAGE(). SAVE() requires a list of variables to save, and the name of the file to save the variables.
dir()
ls()

save(diameters, tree, file = 'c:\\r\\workspaces\\treeDiams.RData') # Save the data sets DIAMETERS and TREE to the RData file in the Workspaces directory

# SAVE.IMAGE() has one argument, the file name where all of the variables and data should be stored
save.image('c:\\r\\workspaces\\wholeshebang.RData')

# When you start a new R session, saved RData files can be opened using the LOAD command

# The CAT command
# Take a list of variables, convert them to text form, and conCATenate the results. If no file or connector is specified
# the results are printed to the screen; otherwise the connector is used to determine how the result is handled.
one <- "A"; two <- "B"
cat(one, two, "\n")

# CAT allows options such as the SEPARATOR between variables, labels, or whether to append to a given file.
cat(one, two, "\n", sep = '-') # Displays A-B-
cat(one, two, "\n", sep = ' - ') # Note the difference in the display

# The PRINT, FORMAT, and PASTE commands
# For displaying printed output with numerous options to ensure that the information is readable.
# 
# Print
# Displays the contents of a single variable
one <- 'A'
print(one) # Same as 'one', which R assumes to be the PRINT command

# Paste
# Paste takes a list of variables, converts them to characters, and concatenates the result, useful for
# creating annotations for plots and figures.
one <- 'A'
two <- 'B'
(numbers <- paste(one, two)) # Displays [1] A B, defaulting to SPACE separator
(numbers <- paste(one, two, sep = '/')) # Displays [1] A/B

# Format
# Converts an R object to a string with a lot options to specify the appearance of the object. Could be valueable
# for writing to a fixed-length file that expects a certain record length, especially, or specific formatting.
three <- exp(1)
(nice <- format(three, digits = 2)) # DIGITS = total numbers, not right of the decimal point
(nice <- format(three, digits = 12))
(nice <- format(three, digits = 3, width = 5, justify = "right"))
(nice <- format(three, digits = 3, width = 8, justify = "right", decimal.mark = "#"))

# Primitive input/output
# Before digging into these fine-grained controls, we need to understand CONNECTORS. A connector is a generic
# way to treat a data source. This can be a file, an HTTP connection, a database connetion, or another network
# connection. This section concentrates on the file connector. The file connector is similar to the C fopen
# command.
fileConnector <- file('c:\\r\\data\\twoBinaryValues.dat', open = 'wb') # Open the file to WRITE in BINARY form
theNumber <- 2.72 # A double by default
writeBin(theNumber, fileConnector, size = 4) # Size = 4 b/c double = 4 bytes? Write binary to the file connector

note <- "Hello there!"
nchar(note) # how many characters in the note vector? 12
writeBin(note, fileConnector, size = nchar(note)) # Write binary the size of the new note variable
close(fileConnector) # Close the file connector pointer

# Open the binary file we just wrote
fileConnector <- file('c:\\r\\data\\twoBinaryValues.dat', open = 'rb')
(value <- readBin(fileConnector, double(), size = 4))
(note <- readBin(fileConnector, character(), 12, size = 1))
close(fileConnector)

# writeChar and readChar can write and read character data similar to writeBin and readBin.
# writeLines and readLines can write whole lines as characters at one time.

# Network options LOC 1005 (30%)
# Read information through a network connection using sockets using socketConnection(). This is a very
# advanced topic but covered briefly here for completeness.
# 
# Opening a socket
# Create a network connection to a given host using a port number. A connector is returned that can be
# treated the same way as a file connector.
usgs <- socketConnection(host = 'waterdata.usgs.gov', 80) # Cannot access behind work firewall
writeLines("GET /ny/nwis/dv?cb00060=on&format=rdb&site_no=04267500&referred_module=sw&period=begin_date=2013-05-08&end_date=2014-05-08 HTTP/1.1", con = usgs)
writeLines("Host:waterdata.usgs.gov", con = usgs)
writeLines("\n\n", con = usgs)
(lines = readLines(usgs)) # opened a socket connection to USGS and asked for New York water data, which we read into lines and displayed

# More in this section but skipping since can't open sockets through the firewall.

# Chapter 4: Calculating probabilities and random numbers
# Focusing on distribution functions, cumulative distribution function, inverse cumulative distribution function, random
# number generation, and sampling.
# 
# Overview
# Commands in this set of topics have common formatting; the suffix specifies the distribution by name; for example,
# the norm suffix refersto the normal distribution. Prefixes are one of the following.
# d -- Determines the value of the distribution function, for example, DNORM is the height of the normal's probability
# distribution function
# 
# p -- This determines the cumulative distribution, for example, PNORM is the cumulative distribution function for the normal
# distribution
# 
# q -- This determines the inverse cumulative distribution, for example, QNORM is the inverse cumulative distribution function
# for the normal distribution
# 
# r -- Generates random numbers according to the distribution, for example, RNORM calculates random numbers that follow
# a normal distribution
Another example would be determining the probability that a Poisson distribution will return a given value using DPOIS, and the
command to get the probaboility that a Poisson distribution is less than or equal to a particular value is PPOIS

# Plotting the probabilities for a Poisson distribution with a parameter 10
x <- 0:20
probabilities <- dpois(x, 10.0)
barplot(probabilities, names.arg = x, xlab = "x", ylab = "p", main = "Poisson Dist, l = 10.0")

# For the last 10 years during the week of Christmas the call center has received an average of 622 calls
# per week. What is the probability the call center will receive 650 call this year?
calls <- c(641, 667, 620, 508, 788)
barplot(dpois(calls, 700))

# More on the CHISQ distribution and testing that I'm skipping here.
# 
# Sampling
# Often used in bootstrapping and a wide variety of techniques. Sole focus is SAMPLE command. SAMPLE behavior
# depends upon whether or not you give it a vector or a number. If you pass a number, it will sample from the set
# of whole, positive numbers less than or equal to that number.
sample(3) # Displayed 2 3 1
sample(5) # Displayed 5 4 3 1 2
sample(5.6) # Dislayed 5 4 3 2 1

# Pass a vector whose length is greater than 1 and sample pulls from the elements of the vector.
x <- c(1, 3, 5, 7)
sample(x) # Displays 3 1 7 5

# The SIZE parameter allows for a different number of samples, but must be smaller size than vector or error
# unless you sample with replacement with REPLACE = TRUE (a value can be selected more than once).
sample(x, size = 2)
sample(x, size = 3)

You can change the probability of selection usually handled by the uniform probability mass functionc
(every element has the same likelihood of being chosen). 
x <- c(1, 3, 5, 7c)
sample(x, size = 8, replace = TRUE, p = c(0.05, .10, .15, .70))

















