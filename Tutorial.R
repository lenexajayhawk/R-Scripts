x <- 2
x
x ^ x
x ^ 2
mode(x)
x <= c(1:10)
x
x ^ x
mode(x)
dim(x) <- c(2,5)
x
mode(x)
x <- c("Hello", "world", "!")
x
mode(x)
x <- c(TRUE, TRUE, FALSE, FALSE, TRUE, FALSE, TRUE)
x
mode(x)
x <- list("R", "12345", FALSE)
x
mode(x)

acctdata <-	c(1, 132,	86.7,
		2,	50,	50.7,
		3,	32,	36.0,
		4,	20,	27.9,
		5,	19,	22.8,
		6,	11,	19.3,
		7,	10,	16.7,
		8,	9,	14.7,
		9,	5,	13.2)

##### Load the Tutorial package #####
load("c:\\R\\Tutorial")

##### Load some variable with the <- assignment operator, which could also be = #####
s <- c("aa", "bb", "cc", "dd", "ee")

##### Working with vector indexes
s[-2] #Pull all members EXCEPT #2

s[10] #Out of range gives NA

s[c(2, 3)] #Pull members 2 and 3 from the vector

s #Pulling two members from the vector does not alter the vector, though

s[c(2, 3, 3)] #Pull three members but repeat the 3rd

s[c(2, 1, 3)] #Pull three members but not in order is just fine

s[c(2:4)] #Pull vector members in a range

s[c(1,3:5)] #This is the same as s[-2]

L <- c(FALSE, TRUE, FALSE, TRUE, FALSE) #Logical index vector

s[L] #Slice the s vector with the L logical vector, which should return members 2, 4

v = c("Mary", "Sue") #Vector members can be named

v	#Print the vector member names

names(v) = c("First", "Last")

v	#Print the v vector names

v["First"]	#Pull the vector member named "First"

#Also pull the vector member by the index number
v[1]

#Reverse the vector member names but not the stored order
v[c("Last", "First")]

v[1]

#c = Combine, just concats the values, but does not structurally re-order them

##### Matrixes: Collection of data elements arranged in two-dimensional rectangular layout #####

#Build matrix A with two rows, three columns and fill it by row, not by column (DEFAULT)
A =	matrix(
	c(2, 4, 3, 1, 5, 7),
	nrow = 2,
	ncol = 3,
	byrow = TRUE)

A

#Accessing matrix members requires extra reference in [x, y] format: pull row 2, col 3 member
A[2, 3]

#NOTE: R is case-sensitive; I typed 'a' instead of 'A' and got something very different than I expected
a

A

#Retrieve the entire 2nd row of matrix A[2, ]
A[2, ]

#Retrieve the 3rd column of matrix A[ , 3]
A[ , 3]

#Don't forget to COMBINE to pull more than one column or row
A[ , (1, 3)]

A[ , c(1, 3)]

#Assign names to columns and rows with DIMNAMES
dimnames(A) = list(
			c("row1", "row2"),
			c("col1", "col2", "col3"))

A

#Reference named columns by name or index
A["row1", 2]

A[1, "col3"]

A[1, 1]

A["row2", "col2"]

#Building a matrix using by-column default
B = matrix(
		c(2, 4, 3, 1, 5, 7),
		nrow = 3,
		ncol = 2)

B

#B has 3 rows and 2 columns; how would we reverse this?
t(B)

#t = Transpose

#How do we combine two matrices?
C = matrix(c(7, 4, 2))

C

#Combine matrices with cbind (by col) and rbind (by row)
cbind(B, C)

#Note that C was concatenated to the end of B

#CBIND works when the matrices have the SAME NUMBER OF COLUMNS
#RBIND works with the matrices have the SAME NUMBER OF ROWS

D <- matrix(c(6, 2))

D

#Built D the wrong way; would TRANSPOSE fix the issue?

t(D)

#Now try to bind the two matrices, B & D
rbind(B, D)

#Nope, TRANSPOSE didn't change the structure, only the representation

##### ASIDE: What may be the difference between the CLASS and MODE functions?
class(D)
class(B)

mode(D)
mode(B)

##### CLASS tells us what the matrix structure is while MODE tells us what's in the matrix

D = matrix(c(6, 2), nrow = 1, ncol = 2)

#Now that we've rebuilt D correctly, let's bind it to B

rbind(B, D)

#Note that B and D are still separate objects because the bind was not assigned to a new object
B

#Binding is temporary, unless...
F <- rbind(B, D)
F

##### ASIDE: Assignment operators (<-, =) are functionally identical, though R people like <- because visually definitive

#Deconstructing a matrix into a single data vector using c function
c(B)

#Print the vector
B

#Save the B matrix data in a variable object
decon = c(B)

decon

##### LISTS: Generic vectors containing other objects, including values, matrices and vectors

 #### Lists are generic vectors containing other objects, including values and vectors
n = c(2, 3, 5)

s

b

b = c(TRUE, FALSE, TRUE, FALSE, FALSE)

b

s

n

listx = list(n, s, b, 3) #listx has three vectors and a numeric

listx

#There are 4 elements in listx
length(listx)

B

#Can a matrix be stored in a list?
listy = list(3, B)
listy


#You bet it can


#How do we refer to the list members?
listx[[1]]

#Double brackets to offset vectors, matrixes references
listx[2]

listx[[2]]

listx

#Single bracket references are list slices!
listx[1]

listx[2, 4] #List slicing members 2 and 4

#Argh! Forgot to c = combine them!
listx[c(2, 4)] #List slicing members 2 and 4


listx[[2]][1]

# Got it! Need to reference the right object first!
listx[[1]][3]

listx[[3]]

listx[[1]]

#How can we reassign members within the list?

listx[[2]][1] = "ta"

x[[2]]

listx[[2]]

#Changed the first element of the vector from 'aa' to 'ta'


#List members can be named, just as vectors and matrices
v = list(bob = c(2, 3, 5), john = c("aa", "bb"))

v

#Note the non-quoted names in the naming process, though!

#Let's get a list slice with the names

v["bob"]

$bob

#Pull a slice with multiple members with an index vector
v[c("john", "bob")]

$john

$bob

v

#Note the pull does not restructure the list itself

v[["bob"]] #Reference only the bob list member directly

> v[[john]]

#Error b/c did not quote John

v[["john"]]

class(v[["john"]])

mode(v[["john"]])

class(v)

#List members can also be referenced with the '$' concatenator
v$bob

v$john

#Lists can be attached to the R search path, but should be detached for cleanup later

attach(v)

v

bob

#Valuable to cut down on coding reference typing
john

detach(v) #detach the list from the search path when finished

bob

#See? Single list item reference no longer available
v$bob #is, though

v[[bob]]
Error: object 'bob' not found
#Oops, forgot the quotes

v[["bob"]]
[1] 2 3 5

#####DATA FRAMES are for storing data tables, which are lists of vectors of equal length

n

s

s = c("aa", "bb", "cc")
b = c(TRUE, FALSE, TRUE)

#Build a DATA FRAME df
df = data.frame(n, s, b)

#What's in the data frame df?
df

#Use the built-in R data about sports cars for this next example
#HEAD function gives a few of the first rows of the data to get the column names
head(mtcars)

#Retrieving data requires single brackets []
mtcars[1,1]

#Data referencing in a data frame is by [row, col]
mtcars[6,8]

#Can also reference directly by name
mtcars["Mazda RX4", "disp"]

#How many ROWS and COLS are in the data frame?
nrow(mtcars)
ncol(mtcars)

#Total members in the DATA FRAME
nrow(mtcars) * ncol(mtcars)

#Referencing Data Frames with the double square bracket [[]]
#Pulling the ninth (9th) column vector of mtcars
mtcars[[9]]

#Note column data viewed like a row; don't be shocked by the representation

#Can I pull individual data this way, too?
mtcars[[9,1]]

#Sure can. Merc 230 MPG from ROW 9, COL 1

#Pull columns by their name, too
mtcars[["drat"]]

#Or pull by $ operator
mtcars$drat
#Much easier and less typing with room for error

#Can also use single square bracket like we did matrix
mtcars[ ,"wt"]

#Data Frame column slices
#Reference by number or by name or multiple columns
mtcars[1]

mtcars["mpg"]

mtcars[c("mpg","hp")]

#Retrieving Data Frame row slices
#By number, by name, or more than one

mtcars[24, ]

#Comma after row number is not a typo; leaves column blank
mtcars["Camaro Z28", ]

#Getting more than one row requires the combine 'c'
mtcars[c("Volvo 142E","Maserati Bora"),]
#DON'T FORGET THE TRAILING COMMA to signify the missing column reference

#More Logical Indexing with TRUE/FALSE values
#This builds vector L with TRUE or FALSE based on whether the car has automatic transmission
#This combines a lot of code in the background: while there are records to read, if each record's am 
#is equal to 0 (false), add a TRUE to the L vector
L = mtcars$am == 0
L

#Pull the cars from MTCARS Data Frame with Manual Transmission
mtcars[L, ]

#The gas mileage for all cars with manual transmission
mtcars[L, ]$mpg

#The AVERAGE mpg of manual transmission cars in the mtcars DATA FRAME
mean(mtcars[L, ]$mpg)

#Got the MPG for all cars with manual transmission!
mean(mtcars[!L, ]$mpg)

#####ASIDE: The WORKING DIRECTORY
setwd("H:\\Stuff\\R\\r-tutorial-src")

getwd()

mydata = read.table("mydata.txt")
mydata

#Look at me go; just found the WORKING DIR, and re-set it
#Then I read the TXT file into R for use

mydata$V1

mydata[1,]

#Look at me remembering how to read a Data Frame (table, for God's sake)

##### July 9, 2014 practice: Convert a Data Frame from Y/N to 1/2

# Need some simple vectors to build the Data Frame
tdf = c("Y", "Y", "Y")

ma = c("N", "N", "N")

brok = c("N", "Y", "Y")

defer = c(7, 4.5, 6)

# Build the Data Frame PRACDF with the simple vectors
pracdf = data.frame(tdf, ma, brok)
pracdf = data.frame(defer, tdf, ma, brok)

# Make sure the Data Frame is loaded correctly; print the contents; note the headers are the names of the vectors
pracdf

# This works only when the value is "Y"; any other value fills in a 1
ifelse(pracdf == "Y", 2, 1)

# Recoding factors from rwiki.sciviews.org
pracdf <- replace(pracdf, pracdf == "Y", 1)
if(is.factor(pracdf)) factor(pracdf) else pracdf

pracdf

# Store the linear model results of the variable versus actual IRR change in the IRRDS Data Frame
mod1 <- lm(defer ~ as.numeric(ma), pracdf)

# Print the MOD1 results
summary(mod1)


# Working with TAPPLY and LISTS for vectorized results
# TRICK: Name the list members for easier access
# NOTE: Forcing R to store FACTORS as factors
biglist <- list(nbrs = c(rnorm(12, 50, 7.7)), 
		    letters = c("C", "D", "F", "R", "S", "A", "B", "L", "M", "N", "O", "P"), 
		    morenbrs = c(rnorm(12, 50, 5)),
		    factors = as.factor(c("A", "A", "A", "A", "B", "B", "B", "C", "C", "C", "C", "C")))

# TRICK: R stores factors as NUMERICS!

# Print one element list
biglist$letters

# What are the CLASS and MODE of each list member?
# The following only explains the class and mode of the LIST itself,
# NOT its members
class(biglist)
mode(biglist)

# Doing math on LISTS
# MEAN against the list does not work alone
mean(biglist)

# Does SAPPLY work? 
# Yes, except that it returns NA on the LETTERS vector b/c it is CHARACTER
# R throws a WARNING regarding the CHARACTER and FACTOR vectors
sapply(biglist, mean)

# Build a LOGICAL vector of T/F if BIGLIST members are CHARACTERS
# This returns TRUE only for the LETTERS member!
# FACTORS is stored NUMERIC
char <- sapply(biglist, is.character)

# Crude but effective way to avoid NA
# R throws WARNING anyway and returns MEANS in quoted strings
ifelse(sapply(biglist, is.numeric), sapply(biglist, mean), "Not numeric")

# Summing FACTORS
# R returns as summary table:
# A B C
# 4 3 5
table(biglist$factors)

# Returns the # of list members
length(biglist) # = 4

# Returns the # of individual list members
sapply(biglist, length) # = 12, 12, 12, 12

# DOES NOT WORK
mean(biglist)

# TAPPLY cycles through numeric factors
tapply(biglist$nbrs, biglist$factors, mean)

# Working with lists within lists
smalllist <- list(nbrs = c(rnorm(12, 50, 7.7)),  
		    morenbrs = c(rnorm(12, 50, 5)),
		    factors = as.factor(c("A", "A", "A", "A", "B", "B", "B", "C", "C", "C", "C", "C")))

combolist <- list(first = biglist, second = smalllist)

# Working with data frames stored in lists
# Use lists when the data frames are of differing lengths

pror <- c(rnorm(10, 11, 9.75))
agecohort <- c("20-29", "20-29", "20-29", "40-49", "40-49", "40-49", "30-39", "30-39", "30-39", "30-39")
factors <- c("BROK", "BROK", "BROK", "DIY", "DIY", "DIY", "DIY", "MA", "MA", "MA")

df1 <- data.frame(pror, agecohort, factors)

pror <- c(rnorm(12, 13, 12))
agecohort <- c("20-29", "20-29", "20-29", "50-59", "50-59", "50-59", "30-39", "30-39", "30-39", "40-49", "40-49", "40-49")
factors <- c("TDF", "TDF", "TDF", "TDF", "TDF", "DIY", "DIY", "DIY", "DIY", "MA", "MA", "MA")

df2 <- data.frame(pror, agecohort, factors)

pror <- c(rnorm(8, 9, 14.25))
agecohort <- c("20-29", "20-29", "20-29", "40-49", "40-49", "40-49", "30-39", "30-39")
factors <- c("TDF", "TDF", "TDF", "DIY", "DIY", "BROK", "BROK", "BROK")

df3 <- data.frame(pror, agecohort, factors)

# Put the ragged (different) length data frames in a list
dflist <- list(frame1 = df1, frame2 = df2, frame3 = df3)

# Basics of the list
length(dflist) # Returns 3 = how many members in the list

sapply(dflist, length) # Returns 3 3 3 = how many members in each data frame

sapply(dflist, nrow) # Returns 10 12 8 = how many rows in each member

nrow(dflist) # Returns NULL; must specify which member to run function

mean(dflist$frame1$pror) # frame1 overall average

# Want vectorized means by factor, but...
mean(dflist$frame1$pror[dflist$frame1$factor]) # Works but returns different mean

# Returns FRAME1 mean IRRs by STRATEGY
tapply(dflist$frame1$pror, dflist$frame1$factors, mean)

# Can we create a loop to run all of the list elements?
# listct <- 1:length(dflist) works too
listct <- seq(1:length(dflist))

# TRICK: FOR loop needs a sequence to go through, not just a value
# If set listct <- length(dflist) then for loop sets n to 3 immediately
# Need sequence for R to run n through; see above listct code
# Replace PRINT function with WRITE.TABLE (see PROR.R) and write data to file
# This prints the 1, 3, and 5-Year PROR averages by strategy
for(n in listct) print(tapply(dflist[[n]]$pror, dflist[[n]]$factors, mean))


# Create PROR averages based on age cohorts by strategy
table(df1$agecohort, df1$factors)

# CrossTable is found in the gmodels package
# CrossTable extends the table function, looks more like SAS PROC FREQ
CrossTable(x = df1$agecohort, df1$factors)

library(RODBC)
# Use RODBC package for ODBC access
# Open a connection called MYDB to the database with the DSN my_dsn
# RODBC not available for 32-bit SAS? Added to 64-bit but R offers
# odd error message that the DSN can't be found because don't have 
# the 64-bit Oracle drivers loaded
mydb <- odbcConnect("my_dsn")

# How to incorporate a username and password into the connection
mydb <- odbcConnect("ORARDMBAUP", uid = "n344244", pwd = "Jul142014")

# Now that the connection is open we use sqlQuery() to create a data frame
patient_query <- "select * from patient_data where alive = 1"
patient_data <- sqlQuery(channel = mydb, query = patient_query, stringsAsFactors = FALSE)


























