##### Book name: Beginning R
##### Author: Larry Pace
##### Published: 2012

##### Chapter 1: Getting R and Getting Started

##### Working with Data in R
# Vectors are most common data type in R, must be homogenous (all same data types--
# character, numeric or logical--but if mixed may be coerced (forced) into single
# type

# Everything is an object; no required declarations so just type and begin using
x <- c(1, 2, 3, 4, "Pi")

x

# MODE is the storage class of the object, not the modal value in a series
mode(x)

# Building vectors uses the c function--combine, not concatenate (cat())
x <- c(1:10)

#The colon (:) creates a sequence, which can also be created with seq(1:10)

#How many elements are in the x vector?
length(x)

# Assign the numeric value 10 to y and see how many elements are in it
y <- 10

length(y)

# Add the two vectors together; what happens?
x + y

# R recycles the y element to add it to each element in the x vector

# Note how R handles recycling when vector length is odd
y <- c(0,1)

y

x + y

y <- c(1, 3, 5)

y

x + y

##### Order of operations and complex numbers

2 + 3 * x

# Note the differences

(2 + 3) * x

sqrt(x)

# Modulo (remainder) divide operation
x %% 4

# R does complex numbers
y <- 3 + 2i

Re(y) # Real part of the complex number

Im(y) #Imaginary part of the complex number

x * y

##### Four ways to create a sequence vector
x <- c(1:10)

x

y <- 1:10

y

z <- seq(10)

z

# Note: This creates a vector with 1 value REPEATED 10x, not 1-10, as above
a <- rep(1, 10)

a

##### R sequences all indexes starting with 1, not 0 like C/C++ or other languages

##### Adding elements (members) to a vector
x

# Concat (really, combine) the sequence 11-15 to the end of vector x
x <- c(x, 11:15)

x

##### Benford's Distribution: predicting the first digit in a string of numbers

# Build the vectors
P = c(0.301, 0.176, 0.125, 0.097, 0.079, 0.067, 0.058, 0.051, 0.046)
V = c(1, 2, 3, 4, 5, 6, 7, 8, 9)

P

V

# Discrete probability (additive) where each member of V is multiplied by corresponding member of P
# and summed for each pairing until totaled--implicit looping benefit within R
sum(V * P)

# Find the variance of the discrete probability distribution, again with implicit looping through the vectors
# Loop through vector V for each value substract the vector's mean and then square the difference
Dev <- (V - mean(V)) ^ 2

Dev

#Multiply the stddev by the probability in another implicit loop through both vectors
sum(Dev * P)

#Calculate the standard deviation of the same data
stdev <- sqrt(sum(Dev * P))

stdev

##### In R, a matrix is a vector but a vector is not a one-column or one-row matrix

x <- 1:10

# Create a matrix of the x vector sequence 1-10 in two rows and five columns in a DEFAULT by-column format
x <- matrix(x, 2, 5)

x

# This would also do the same matrix without using another variable
y <- matrix(1:10, 2, 5)

y

##### Referring to matrix rows and columns
colnames(x) <- c("A", "B", "C", "D", "E")

x

x[1, "C"]

x[1, 2]

x[ , 1]

x[1, ]

x[2, "E"]

##### More with Benford's Distribution, this time with a Matrix
# Create the ACCTDATA vector first
acctdata <-	c(1, 132, 86.7,
		  2,  50, 50.7,
		  3,  32, 36.0,
		  4,  20, 27.9,
		  5,  19, 22.8,
		  6,	11, 19.3,
		  7,	10, 16.7,
		  8,	 9, 14.7,
		  9,	 5, 13.2)
acctdata

# Convert the vector into a MATRIX
acctdata <- matrix(acctdata, 9, 3, byrow = TRUE)
# Name the columns of the MATRIX
colnames(acctdata) <- c("digit", "actual", "expected")
# Show me the matrix
acctdata

# We are going to write the chi-square analysis to see if the Observed fits the Expected
# Another advantage of implicit looping, this one line...
# 1) Substracts each value in COL 3 from each value in COL 2
# 2) Squares the difference between those values
# 3) Divides that squared difference by the matching value in COL 3
# 4) Sums all of the divided values

chisquare <- sum((acctdata[, 2] - acctdata[ , 3]) ^ 2 / acctdata[ , 3])

chisquare

# Matrix transposition, multiplication and inversion
# Create two small matrices to work with

A <- matrix(c(6,	1,
		  0,	-3,
		  -1,	-2), 3, 2, byrow = TRUE)
B <- matrix(c(4,	2,
		  0,	1,
		  -5,	-1), 3, 2, byrow = TRUE)

A
B

# Matrix addition
A + B

# Matrix subtraction
A - B

# Matrix component-by-component multiplication, not matrix multiplication
A * B

# Transpose matrix A
t(A)

# Matrix inversion: only done with square matrixes (same # rows and cols)
# Inversion handled with solve() function

A <- matrix(c(4, 0, 5,
		  0, 1, -6,
		  3, 0, 4), 3, 3, byrow = TRUE)
#Next command finds the inverse of matrix A
B <- solve(A)

A %*% B #Actual matrix multiplication

B %*% A

# Possible to have one-row or column matrix by adding drop = FALSE to index
# Print the entire matrix
A

# Print column one as a vector
A[ , 1]

# Print row one as a vector
A[1, ]

# Print row one as a one-row matrix
A[1, , drop = FALSE]

# Print col one as a one-col matrix
A[ , 1, drop = FALSE]

# Lists (which won't be used much as the Data Frame is the data structure of choice for
# most statistical analyses)

address <- list("Sam Johnson", "16902 W. 83rd Terr.", "Shawnee", "KS", 66219)

address

# Quick refresher on retrieving list elements; pull my name
address[[1]]

# Also pulls my name, but this time as a data slice
address[1]

# Data Frames
# Data Frames must have the same kind of data in each column
# Data Frames have rows and columns
# Data Frames can have a combination of numeric, character or logical data
# Think of Data Frame like an Excel spreadsheet
# Most of the time we'll be importing data into Data Frames, not building in R
# Get ready for the lapply() function to use when certain functions don't work with Data Frames

# Building a simple Data Frame from vectors
people <- c("Kim", "Bob", "Ted", "Sue", "Liz", "Amanda", "Tricia", "Jonathan", "Luis", "Isabel")
scores <- c(17, 19, 24, 25, 16, 15, 23, 24, 29, 17)

people

scores

# Create the Data Frame from the People and Scores vectors
quiz_scores <- data.frame(people, scores)

quiz_scores

# We don't need the individual People and Scores vectors anymore, so let's remove
rm(people, scores)

# Shouldn't be there as individual vector; error
people

# Should find in the quiz_scores Data Frame, though
quiz_scores

# Like a matrix, can get individual columns and rows by indexing
# But this pulls a data slice as a vector, not the column
quiz_scores[ , 2]

# This pulls the column only
quiz_scores[2]

quiz_scores$people

# If we attach() the Data Frame to the search path, we have immediate vector access to each column
attach(quiz_scores)

people

scores

# More sophisticated manipulation with cbind() (column bind) and rbind() (row bind)
# to bring Data Frames together

# Creating a Data Frame in the R Data Editor

# Invoke the Data Frame and initialize the columns with their types
Min_Wage <- data.frame(Year = numeric(), Value = numeric())

# Open the R Data Editor on the Min_Wage Data Frame
Min_Wage <- edit(Min_Wage)

# Show the Data Frame
Min_Wage

# Reading a CSV file into a Data Frame
# Taken from http://www.infoplease.com/ipa/A0104652.html

# R does not like numbers as column headers; placed Yr at beginning of each year
# NOTE: I pulled the US averages 
percapita <- read.csv("c:\\r\\data\\uspercapita.csv", header = TRUE)

head(percapita)

class(percapita)

# R defaults the read-in data as a Data Frame

# To get the column averages, use the colMeans() function; means() has been deprecated
# In this case, get the column averages for columns 2 through 9
colMeans(percapita[2:9]) # Returning NA b/c some missing data?

# summary() function returns frequency counts
summary(percapita[2:9])

# If I'd have stored summary in an object, I would have had access to the summary information
summaryPerCapita = summary(percapita[2:9])

summaryPerCapita

class(summaryPerCapita)

# Handling missing data in R
# To remove NAs (really ignore), such as in stats, use na.rm = TRUE

# Fill a vector
x <- c(1, 2, 3, 4, 5, 6, NA, 8, 9, 10)

# Show the vector
x

# Vector average, which should error out
mean(x)

# This version works because it ignores the NA
mean(x, na.rm = TRUE)

# NA is still in the vector, though
x


##### Flow control: Looping, conditionals, and branching

# Looping
# R offers 3 types of explicit loops
# Conditional statements (if-then-else, for example) let us execute a branch of code when certain conditions are satisfied

# R offers the standard arithmetic operators, which follow the PEMDAS order of operation
# +, -, *, /, ^ or ** for exponentiation, %% modulus (remainder), and %/% for integer (truncated) division

# Comparison operators are the usual, but unlike SAS, do not have letter equivalents
# >, <, >=, <=, == equal to, != not equal to
# Operators evaluate to TRUE and FALSE (note case is important!)

# Logical operators also evaluate to TRUE and FALSE
# R provides vectorized and unvectorized versions of the "and" and "or" operators
# & and (vectorized), && logical and (unvectorized), | logical or (vectorized), || logical or (unvectorized), ! logical not

# Looking at vectorized AND
x <- 0:2
y <- 2:0

# Checks each pair (0,2), (1,1), (2,0)
(x < 1) & (y > 1)

# Unvectorized checks only the first value in each vector, L to R,
# returning only the first logical result
(x < 1) && (y > 1)

!y == x

identical(x, y) # identical tests for exact equality

##### Input and Output
# R defaults to 7 digits for numerical data, which can be changed with the options() function
getOption("digits")

# Note digits = 4 includes numbers larger than 0, in the 1s, 10s columns, etc.
# pi will be 3.142; digits is not just after the decimal

options(digits = 4)
pi

# Prompting for feedback from the keyboard with readline()
size <- readline("How many digits do you want to display?")

pi

options(digits = size)

pi

# Reading data using the scan() function; similar to read.table()
# Scan opens a channel to enter data at the command line until nothing more to enter and stores in the object
x <- scan()

# Scan() is the slightly harder way to do x <- c(1, 2, 3, 4, 5) or x <- seq(1:5) or x <- 1:5


##### Understanding the R environment
# Everything to R is an object; functions have names too

# CV is a function of my design that is calculating coefficient of variance
CV <- function(x) sd(x) / mean(x)
# Print x
x
# Print the coefficient of variance of x with my CV function
CV(x)

##### Implementing Program Flow
# Three basic loops: for, while, and repeat
# Remember, though, that vectorized implicit looping is far better and more effective

# The for loop
i <- c(1:5)
for(n in i) print(n * 10)

# The above loop was unnecessary, as looping through i can be done implicitly
print(i * 10)

# For loops can be used with lists and vectors
carbrands <- c("Honda", "Toyota", "Ford", "GM", "BMW", "Fiat")
for(brand in carbrands) {
	print(brand)
}

# Next two are functionally equivalent
carbrands

print(carbrands)

##### While and Repeat loops
# Most R programmers try to avoid these and use explicit for loops if required

# While loops
even <- 0
while(even < 10) {
	even <- even + 2
	print(even)
}

# Repeat loop, where a condition is met to break out of the loop
i <- 1
repeat 
{
	print(i)
	i <- i + 1
	if(i > 5) 
	{
		break
	}
}

##### Avoiding explicit looping; using the apply() function family
# Note that median is not applicable to the data frame
median(percapita[2:9])

# The lapply() function allows us to find the median for each column in the data frame
# lapply() returns a list
lapply(percapita[2:9], median)

# While lapply() has ugly output, wrapping a DATAFRAME around the output can help
as.data.frame(lapply(percapita[2:9], median))

# lapply() is pretty ugly output; try apply() with three arguments (data, 1 = rows or 2 = columns, called function)
# apply(the percapita data frame, columns, median of each column)
apply(percapita[2:9], 2, median)

# tapply() applies a function to arrays of variable length (ragged arrays), defined by a vector

# Three stats classes of differing size and their scores, in three vectors
class1 <- c(17, 18, 12, 13, 15, 14, 20, 11, 16, 17)
class2 <- c(18, 15, 16, 19, 20, 20, 19, 17, 14)
class3 <- c(17, 16, 15, 18, 11, 10)
# Combine the vectors into a Class list
classes <- list(class1, class2, class3)

# lapply() returns a list
lapply(classes, length)

# sapply() (simplify apply) tries to return a bit more table-like structure
sapply(classes, length)

# We can also use sapply() to apply the mean to the list
sapply(classes, mean)

sapply(classes, summary)

##### A simple expense report
# Invoke the Data Frame and initialize the columns with their types
# See page 40

##### Generating Pythagorean triples with a, b, and c where a2 + b2 = c2

pythag <- function(x) 
{
	s <- x[1]
	t <- x[2]

	a <- t^2 - s^2
	b <- 2 * s * t
	c <- s^2 + t^2

	cat("The Pythagorean triple is: ", a, b, c, "\n")
}

input <- scan()

##### Writing reusable functions
# Calculating the confidence interval of a single mean

confint <- function(x, alpha = .05)
{
	conflevel <- (1 - alpha) * 100
	stderr <- sd(x) / sqrt(length(x))
	tcrit <- qt(1 - alpha / 2, length(x) - 1)
	margin <- stderr * tcrit
	lower <- mean(x) - margin
	upper <- mean(x) + margin

	cat("Mean: ", mean(x), "Std. Error: ", stderr, "\n")
	cat("Lower Limit: ", lower, "\n")
	cat("Upper Limit: ", upper, "\n")
}

##### Avoiding loops with vectorized operations
# Understanding where vectorized implicit looping is available can save a ton of time and code
# This example is Euler's formula to find prime numbers, first in a function call
# Formula is x^2 - x + 41
TryIt <- function(x)
flush.console()
	for (n in x)
	{
		result <- n^2 - n + 41
		cat("For x =", n, "Result is", result, "\n")
	}

# Implicit looping makes this much, much easier
# Re-set x as a vector again for code purposes only
x <- 0:50

y <- x^2 - x + 41

y

##### Vectorizing if-else statements with ifelse()

x <- -5:5

x

# Square roots of negative numbers will have Not a Number (NaN) outputs
sqrt(x)

# Do ifelse() inside the sqrt function to leave NAs alone
sqrt(ifelse(x >= 0, x, NA))

# Moving ifelse to the outside creates NaNs again
ifelse(x >= 0, sqrt(x), NA)

##### Chapter 4: Summary statistics
# Mean, median and mode
# Remember that the mode() function returns the storage class of the object, not the most common value in a vector
# Summary() is the six-number summary of a vector
# colMeans() gives all of the column averages of the supplied object, typically a data frame

# Put percapita in the search stream
attach(percapita)

head(percapita)

summary(percapita[2:9])

colMeans(percapita[2:9])

mean(percapita[2:9])

# Median is NOT vectorized, so have to apply() wrapper
# apply(percapita cols 2-9, 2 = columns, using the median() function
apply(percapita[2:9], 2, median)

# Can also use apply with the quantile function to find the median and other quantiles (percentiles)
apply(percapita[2:9], 2, quantile)


# Add a specific quantile to one column of data to find its value
quantile(percapita$Yr2005, 0.75)

# R has no built-in method for finding mode
# Use the table and sort functions to identify the modal value
# Manually check frequency count of values; 36421 is the only repeat, thus the modal value
sort(table(Yr2010))

apply(percapita[2:9], 2, mean, trim = .5)

x <- c(0:10, 50)
xm <- mean(x)
c(xm, mean(x, trim = 0.1))


##### Measuring location via standard scores
# scale() is the z-score function call
# Accepting the defaults uses mean as center of measure and sddev as scaling value
zYr2010 <- scale(Yr2010)

zYr2010

# Let's make sure the defaults of stddev = 1 and mean are true
mean(zYr2010)

# Obviously sd is not vectorized
apply(zYr2010, 2, sd)

# This works, too, just prints to the console; doesn't save the results to another object
scale(percapita[2:9])

##### Measuring variability
# Many ways to measure spread, or dispersion: Variance, std dev,
# range, mean absolute deviation, median absolute deviation, IQR,
# coefficient of variation

# Variance and Standard Deviation
# Get the variance and stddev for Yr2010
var(Yr2010)

# Are var and sd vectorized? YES, but get a variance-covariance matrix
var(percapita[2:9])

sd(Yr2010)

# R recommends using sapply wrapper because sd is deprecated
sd(percapita[2:9])

sapply(percapita[2:9], sd)

##### Range
# Most commonly defined as the difference between the highest and lowest
# values in a data vector. R gives you the high and low value; you do the rest
# This uses the WEIGHTS data we created in Chapter 3
range(weights)

range.diff <- function(x) max(x) - min(x)
range.diff(weights)

##### Mean and Median Absolute Deviations
# mad() function where we can specify measure of central tendency
# by supplying an argument

mad(weights)

mad(weights, center = mean(weights))

sd(weights)

# Because these values are relatively close to each other, the
# data may be symmetrical. Let's find out with a histogram
hist(weights)

##### IQR
# Difference between 3rd and 1st quartiles, a view of the middle 50% of the data
IQR(weights)

# My first real function: IQRVALS finds the LOW and HIGH values of an IQR'd data set
# Compare the LOW and HIGH VALS to the MIN and MAX of the data set to determine whether
# using the IQR values is even required
# Remember to use apply() if more than one column passed in
iqrvals <- function(x) {
	# Get the min and max values
	minx <- min(x)
	maxx <- max(x)
	
	# Get the IQR value
	iqrx <- IQR(x)
	# Calculate the IQR multiplier, which will be used to calculate LOW and HIGH values
	iqrmult <- 1.5 * iqrx
	# Calculate the LOW IQR value for the data
	lowiqrval <- quantile(x, 0.25) - iqrmult
	# Calculate the HIGH IQR value for the data
	highiqrval <- quantile(x, 0.75) + iqrmult

	# Don't use IFELSE because returns NULL for argument that isn't used
	# Don't use IQR values if one or both is above the MAX or below the MIN of the data
	if(lowiqrval < minx || highiqrval > maxx)
		 cat("Use data min:", minx, "and max: ", maxx, "\n")
	else
		 cat("Low IQR value: ", lowiqrval, "and High IQR value: ", highiqrval, "\n")
}

##### Coefficient of variation
# Measuring the standard deviation relative to the size of either the sample or population
# mean. Often used as measure of relative risk, showing variability relative to size of
# average; good for rates of return. Not built in to R but can easily be turned into a
# function.

# CV is simply the standard deviation divided by the mean of the data (sample or population)
CV <- function(x) sd(x) / mean(x)

CV(weights) #0.15258

##### Covariance and Correlation
# Covariance is the positive, zero, or negative numerator value in calculating correlation.
# Correlation is the value between -1 and 1 that indicates the directional relationship
# of change between two variables
# Hypothetical advertising and sales figures

region <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
ads <- c(5.5, 5.8, 6.9, 7.2, 6.3, 6.5, 6.4, 5.7, 6.1, 6.8)
sales <- c(101, 110, 120, 125, 117, 118, 120, 108, 115, 116)

adsales <- data.frame(region, ads, sales)

adsales

cov(ads, sales)

cor(ads, sales)

##### Measuring symmetry (or lack thereof) p. 74
# Examples use the PSYCH package, which we cannot pull down right now
# Button ticket submitted 7/11/14 re: how to mirror CRAN download site
# Skewness (data balance to one side or another, positive (left) and negative (right)-skewed) 
# and kurtosis (peaks, such platykurtic (flat) and leptokurtic (tall) or meso- (just right)
# Functions not available in Base R packages, but skew() and kurtosi()
# available in PSYCH

##### Chapter 5: Creating tables and graphs p. 77
# Frequency distributions and tables
# Already seen that table() produces a simple frequency distribution
# Using base R faithful data set

# Print the first few rows with headers
head(faithful)

# Pull waiting out of data frame into its own vector
waiting <- faithful[ , 2]

# Range of waiting = time between eruptions
range(waiting)

# Create a basic frequency distribution with table()--too many values to be very helpful
table(waiting)

# Create intervals (bins) to better view the data
# Not exact science though my rule of thumb is 2^x bins
# based on number of data points; for example, 272 eruptions
# would be 2^8 or 2^9, so we need 8 or 9 bins, probably 8

# Bins are 8 * 7.5 = 60, the width of our data representation
# Use sequence function to build bins vector
bins <- seq(40, 100, by = 7.5)
bins

# CUT uses the bins to divide the WAITING data into intervals;
# right = FALSE defines whether the intervals should be closed on the right side
wait_time <- cut(waiting, bins, right = FALSE)

# TABLE produces a tabular view of the data in a row-like format
table(wait_time)

wait_time

# CBIND converts the TABLE function into a more vertical columnar view
cbind(table(wait_time))

# table() with two variables gives a cross-tabulation, whether
# quantitative or qualitative variables

##### Pie charts and bar charts (bar plots in R parlance) p. 79
# While both can be used for representing the same kind of data
# humans are more inclined to bar charts; use them over pie charts
# wherever possible for nominal (Repulican or Democrat) or ordinal data
# (1st place, 2nd place, etc.)
# Using DuPont's data on car colors in 2012 through table editor
car_colors <- data.frame(color = factor(), percentage = numeric())
car_colors <- edit(car_colors)

car_colors

# Attach the object to the search chain
attach(car_colors)

# Create the base pie with ugly pastels by default
pie(percentage)

# Add a new set of colors with a colors vector

piecolors = c("#C0C0C0", "black", "white", "#696969", "red", "blue", "brown", "green", "#F0E68C")

piecolors

# Rebuild the pie chart with the actual colors represented
pie(percentage, col = piecolors)

# Let's present the actual names of the pieces of pie
names(percentage) = c("Silver", "Black", "White", "Gray", "Red", "Blue", "Brown", "Green", "Other")

names(percentage)

# Rebuild the pie with the new names
# This would work, too, without creating a new object: 
#	pie(percentage, 
	    col = c("Silver", "Black", "White", "Gray", "Red", "Blue", "Brown", "Green", "Other"), 
	    main = "Pie Graph of Car Color Preferences")

pie(percentage, col = piecolors, main = "Pie Graph of Car Color Preferences")

# Bar charts p. 83
# Mostly a change in the function call; not going to reproduce all of the previous code
barplot(percentage, col = piecolors, main = "Bar Chart of Car Color Preferences")

# Boxplots
# Also called box plots or box-and-whisker plots; popularized by statistician John Tukey
# Represents five-number summary of summary()
# Relative lengths of whiskers indicates skew; IQR = length of box; median = line in box
# If distribution relatively unskewed median be close to center of box and whiskers roughly
# same length; outliers represented by small circles

test1 <- c(72.41, 72.73, 71.63, 70.26, 77.98, 83.48, 87.25, 84.25)
test2 <- c(92.71, 86.35, 87.80, 107.92, 58.54, 91.93, 103.85, 101.56)
test3 <- c(73.63, 90.97, 44.59, 67.04, 78.57, 82.36, 72.96, 78.55)

quizzes <- data.frame(test1, test2, test3)

boxplot(quizzes)

detach(percapita)

##### Chapter 6: Discrete probability distributions

# Discrete probabilities must satisfy these conditions:
# 1) Probabilities sum to 1
# 2) Probability of any one outcome is between 0 and 1
# 3) List of outcomes is exhaustive (can be no others) and mutually exclusive (no outcome in more than 1 category)

# Jonathan sells cars and has tracked his sales on Saturday
saturday_sales <- data.frame(numsold = c(0, 1, 2, 3, 4, 5), prob = c(0.6, 0.15, 0.1, 0.08, 0.05, 0.02))

attach(saturday_sales)

# Calculate the mean and variance given the probability distribution
mu <- sum(numsold * prob)

variance <- sum((numsold - mu)^ 2 * prob)

standarddev <- sqrt(variance)

# Bernoulli processes have only two outcomes per trial, each of which is
# independent, such as the toss of a coin, a free throw attempt, or the
# selection of the correct answer on a multiple choice question
# One outcome is a SUCCESS and the other FAILURE.
x <- c(0, 1, 2, 3, 4, 5)

# DBINOM() is the density or mass function with probabilities for each outcome
# Other options include PBINOM (cumulative density or mass function for the distribution),
# QBINOM (Quantile function or reverse lookup to find the value of the random variable
# associated with any probability, RBINOM (Random function to generate random samples from
# the probability distribution))
# Show the results in a column (CBIND) of the density binomial distribution of vector x
cbind(dbinom(x, size = 5, prob = .5))

# MicroSort technique to increase chances of having a specific gendered child, where
# probability is .91 for femail and .76 for male
# Probability that of 10 families exactly 8 will have a male?
dbinom(8, size = 10, prob = .76)

# Of 10 families, probability that all 10 will have a male child
dbinom(10, size = 10, prob = .76)

# Probability that <=6 families will have a male child
xvec <- 0:6
sum(dbinom(xvec, 10, .76))

# Or use PBINOM for cumulative probability of <=6 families having male child
# If use XVEC here function returns cumulative probability of each vector member!
pbinom(6, 10, .76)

# Want to generate 100 samples of size N = 10 with p = .76; RBINOM generates this
# set of a random binomial distribution
randombinom <- rbinom(100, 10, .76)

# Can find confidence intervals through quantiles of the distribution at 95% empirical
# confidence. This example notes that of 10 families sample, between 5 and 10 will have
# a male child with 95% confidence
quantile(randombinom, .025) # 5 is lower confidence limit
quantile(randombinom, .975) # 10 is high confidence limit

# Chapter 7 Computing Normal Probabilities
# Learn early that the distribution of sample means, regardless of the shape of the
# parent distribution, approaches a normal distribution as sample size increases.

# The SCALE() function produces z-scores for any set of data, which gives us
# SCALE is a combination stat; gives the location of the raw score relative to
# the mean and the number of standard deviations the raw score is away from
# the mean, which makes z-scores both descriptive and inferential

# Most often we are interested in finding the areas under the normal curve
# (or assuming the curve is normal, as Karl Pearson told us, even though he
# eventually regretted the term 'normal'). 

# DNORM can be used to draw a graph of a normal distribution
# We'll put two curves on the same plot, too
# Build a sequence starting at 0 to 40 going up by .5
xaxis <- seq(0, 40, .5)

# Show me xaxis
xaxis

# Build two normal distributions with the same mean but different stdev
y1 <- dnorm(xaxis, 20, 3)
y2 <- dnorm(xaxis, 20, 6)

# Plot the curves
plot(xaxis, y2, type = "l", main = "Comparing Two Normal Distributions")
# POINTS adds the second line to the graph and TYPE = "l" tells R to plot lines
points(xaxis, y1, type = "l", col = "red")

# Different normal distributions have different amounts of spread based on the
# standard deviation. It's often helpful to convert a normal distribution to
# the standard normal distribution and work with z-scores, which have a mean 
# of 0 and stdev of 1

# Finding probabilities using the PNORM function
# PNORM() function finds a left-tailed probability, where the critical value
# of z for a 95% confidence interval is +/-1.96, and the area between those
# values is 95% of the standard normal distribution. PNORM defaults to mean
# of 0 and stdev 1; these defaults can be changed as arguments in the call.

# Finding a left-tailed probability
# This is the CUMULATIVE probability under the standard normal distribution
# up to a z-score of 1.96.
pnorm(1.96) # This says 97.5% of the area lies to the left while 2.5% is to the right

# Finding the area between two z-scores
# Is simply a matter of subtraction
pnorm(1.96) - pnorm(-1.96)

# Finding a right-tailed probability
# Is just as easy; just take the reciprocal value of the left-tailed probability
1 - prob(1.96)

# You took a standardized test with a mean of 500 and stdev of 100 and scored a 720.
# How'd you do? How much better than what % of test takers?
# First standardize your score against the test
scale(720, 500, 100)

pnorm(2.2) # Your score is better than 98.6% of other test takers

# With PNORM, given a z-score, it returns the left-tailed probability in the sample
# that the value is higher than

# Finding critical values using the QNORM function
# With QNORM, given a probability, it returns the equivalent z-score
# of the value

qnorm(.975)

# To find a one-tailed critical value...
# Subtract the alpha level (.05 = standard) from 1
qnorm(1 - .05)

# Using RNORM to generate random samples
# RNORM(sample size, mean, stdev) generates a random sample from a normal
# distribution. Omitting MEAN and STDEV results in a mean of 0 and stdev 1.
samples <- rnorm(50, 100, 15)

samples

hist(samples) # Not exactly "normal"

# What if we bump the sample size to 1000?
sample2 <- rnorm(1000, 50, 15)

hist(sample2) # Much more "normal"-looking

# R does not include a one-sample z-test
ztest <- function(xbar, mu, stdev, n) {
  z = (mean(xbar) - mu) / (stdev / sqrt(n))
  return(z)
}

# Generate 100 weights for adult males who exercise
exmen <- rnorm(100, 187, 17)

# Let's compare that group with weights of all adult males, averaging 191 pounds
ztest(exmen, 191, sd(exmen), length(exmen)) # -4.852295 for one run; -2.403974 for another

# This returns a z-score, so convert it to a probability
pnorm(-2.403974) # .00024; much lower than .05 so we could reject the NULL hypothesis
# that there is no difference in the weights of exercising adult males and average
# adult male

# The above could be wrapped into a single line of code
pnorm(ztest(exmen, 191, sd(exmen), length(exmen)))

# Chapter 8 Creating confidence intervals
# A confidence interval (or interval estimate) is a range of possible values used
# to estimate the true value of a population parameter, which is associated with
# a level of confidence, such as 90%, 95% or 99%. The confidence level is the complement
# to our alpha level, so these three confidence levels correspond to alpha levels of
# .1, .05, and .01
# 
# The general idea behind a confidence interval is that we have an estimate of a parameter
# and we calculate a margin of error, adding the margin to the estimate to get an upper
# limit and subtracting the margin for a lower limit

# If our confidence interval for a population mean has a lower limit of 164.13 and an
# upper limit of 180.97, we can say we are 95% confident that the true population mean
# (for men who exercise, for example) is contained within that range.
# 
# INCORRECT:
#   1) There is a 95% chance (.95 probability) that the true value of the mean is between those values
#   2) 95% of the sample means fall between those numbers

# Let's build a sample size function!
# E = Desired margin of error
# sigma = stdev
# alpha = complement of confidence level
sampsize.est <- function(E, sigma, alpha = .05) {
  # Remember QNORM converts alpha to a z-score value
  n <- ((qnorm(alpha / 2) * sigma)/ E) ^ 2
  estsize <- ceiling(n) # Rounds to the next highest integer
  cat("For a desired margin of error of:", E, "the required sample size is:", estsize, "\n")
}

# Does it work with our random sample of adult male exercisers?
sampsize.est(5, sd(exmen)) # 49 required to be 95% confident that the true pop mean is +/-5 pounds
sampsize.est(2.5, sd(exmen)) # 195
# Is there a general rule of thumb for sample size here?
# Yes, about 4x the sample size for each 1/2 of margin of error
sampsize.est(1.25, sd(exmen)) # 780
sampsize.est(10, sd(exmen)) # Predict 12, actually 13
sampsize.est(7.5, sd(exmen)) # 1 1/2 original MOE = 1/2x sample, predict 24; actual 22

sampsize.est(5, sd(exmen), alpha = .01) # NOTE alpha change; sample needed = 85
sampsize.est(5, sd(exmen), alpha = .1) # NOTE alpha change; sample needed = 35

# Confirdence intervals for the mean using the t distribution
# When we don't know the population standard deviation we use the sample
# standard deviation as a reasonable estimate. We also use the t distribution
# instead of the normal distribution to calculate the confidence interval.
confint.mean <- function(x, alpha = .05, two.tailed = TRUE)
{
  cat("\t", "Confidence Interval for the Mean", "\n")
  cat("Mean: ", mean(x), "\n")
  
  df <- length(x) - 1
  conflevel <- ifelse(two.tailed == TRUE, 1 - alpha / 2, 1 - alpha)
	stderr <- sd(x) / sqrt(length(x))
	tcrit <- qt(conflevel, df)
	margin <- stderr * tcrit
	lower <- mean(x) - margin
	upper <- mean(x) + margin

	if(two.tailed == FALSE) {
    cat("You are doing a one-tailed test.", "\n")
    cat("If your test is left-tailed, the lower bound", "\n")
    cat("is negative infinity. If your test is right-tailed", "\n")
    cat("the upper bound is infinity.", "\n")
    cat("Either add the margin", margin, "to or subtract it from", "\n")
    cat("the sample mean as appropriate.", "\n")
    cat("For a left-tailed test, the upper bound is", lower, ".", "\n")
    cat("For a right-tailed test, the lower bound is", upper, ".", "\n")
	}
  
  cat("Mean: ", mean(x), "Std. Error: ", stderr, "\n")
	cat("Lower Limit: ", lower, "\n")
	cat("Upper Limit: ", upper, "\n")
}

confint.mean(exmen)

t.test(exmen)

confint.mean(exmen, two.tailed = FALSE)

##### Chapter 12: Correlation and Regression
# Covariance and Pearson product-moment correlation are cov() and cor(), respectively
# Create a matrix of weights and heights

weights <- c(237.1, 220.6, 214.5, 213.3, 209.4, 204.6, 201.5, 198.0,
		 193.8, 191.1, 189.1, 186.6, 179.3, 176.7, 175.8, 175.2,
		 174.8, 173.3, 172.9, 170.1, 169.8, 169.1, 166.8, 166.1,
		 164.7, 164.2, 162.4, 161.9, 156.3, 152.6, 151.8, 151.3,
		 151.0, 144.2, 144.1, 139.0, 137.4, 137.1, 135.0, 119.5)

y <- sort(weights)

y

x <- sort(rnorm(40, 70, 6))

x

matrix <- cbind(x, y)

head(matrix)

cov(x, y)

cor(x, y)

plot(x, y, xlab = "height", ylab = "weight", main = "Weights and Heights")

abline(lm(y ~ x))

##### Three or more variables in a correlation analysis
# Let's add resting heart rate

z <- rnorm(40, 80, 10)

z <- sort(z)

z

matrix <- cbind(x, y, z)

cov(matrix)

cor(matrix)

var(x)

cov(x, y)

cov(x, z)

cor(x, z)

# Computations to calculate effect size

# Suppose the primary study reported a t-test
# value for differences between 2 groups. Then,
# where tes = T Effect Size where
# t = t-value, n.1 = first group size (n), and
# n.2 = second group size (n)
tes(t = 1.74, n.1 = 30, n.2 = 31)

# Or, more simply,
tes(1.74, 30, 31) # Produces effect sizes for MeanDifference, Correlation, LogOdds, Fishers z, and gives the total sample size

# Predicting milk prices
milk.prices <- read.csv("C:\\R\\Data\\RBook\\milkprices.csv", header = TRUE, stringsAsFactors = FALSE)

plot(milk.prices$Index, milk.prices$Average)
abline(lm(milk.prices$Average ~ milk.prices$Index)) # Doesn't look very linear

results <- lm(milk.prices$Average ~ milk.prices$Index)
summary(results)

# Would a quadratic formula be a better fit if we square the index?
milk.prices$indexsq <- milk.prices$Index ^ 2

results <- lm(milk.prices$Average ~ milk.prices$Index + milk.prices$indexsq)
summary(results)

milk.prices$predicted <- predict(results)

plot(milk.prices$Index, milk.prices$Average); lines(milk.prices$predicted)

# Chapter 14: Logistic Regression p.201
# Univariate and multiple regression is great for continuous dependent variable prediction. Sometimes we want to determine
# the outcome of a binary (dichotomous) outcome, where 1 = success and 0 = failure. Fisher developed discriminant
# analysis to determine group membership, but the technique works ONLY WITH CONTINUOUS VARIABLES. Logistic regression
# uses both continuous and binary predictors, a major advantage.
# 
# Examples of dichotomous outcomes include the presence or absence of defects, attendance and absenteeism, and student retention
# versus dropout. Logistic regression seeks out the dichotomous outcome answer, where p = the proportion of 1s (successes) and q is
# the proportion of 0s (failures), in this case q = 1 - p. Correlation and regression is problematic with dichotomous outcomes because
# they may return values < 0 and > 1. The logistic curve, on the other hand, has a very nice property of being asymptotic to 0 and 1
# and always lying between 0 and 1. 
# 
# Probability can be converted to odds, where if p is the probability of success, the odds in favor of success are: p / 1 -p.
# 
# Odds can be converted to probabilities, too. If the odds are 5:1, then the probability of success is 5/6, or 83%. Odds can be greater
# than 1; for example, if the probability of rain is .25 then the odds of rain are .25 / .75 = .33, but the odds against rain are
# .75 / .25 = 3, or 3:1.

# Logistic regression works with LOGIT, the natural logarithm of the odds. Logistic regression allows us to model the probability of 
# "success" as a function of the logistic curve, which is never less than 0 and never greater than 1.

# Logistic Regression with One Dichotomous Predictor
# 50 pairs of observations, which represent binge drinking amongst 25 men and 25 college students.
gender <- c(rep(1, 25), rep(0, 25))
binge <- c(rep(1, 12), rep(0, 13), rep(1, 5), rep(0, 20))

bingedata <- data.frame(gender, binge)

binge.table <- table(bingedata)

chisq.test(table(bingedata)) # p = .07325, approaching significance; could be better with larger sample

# What are the proportions of men and women binge drinking?
men.binge.prop <- binge.table["1", "1"] / sum(binge.table["1", "0"], binge.table["1", "1"]) # .48 or 48%
women.binge.prop <- binge.table["0", "1"] / sum(binge.table["0", "0"], binge.table["0", "1"]) # .2 or 20%

# What are the odds of men and women being binge drinkers?
odds.men <- men.binge.prop / (1 - men.binge.prop) # .9231
odds.women <- women.binge.prop / (1 - women.binge.prop) # .25 or 1:4

# The INTERCEPT term for women is the log(odds)
log(odds.women) # -1.386294

# The INTERCEPT term for men
log(odds.men) # -.08001771

# The slope will the be the difference between the two log(odds) INTERCEPT values
b1 <- log(odds.men) - log(odds.women)

b1 # 1.306252

# Let R do the logistic regression now
results <- glm(binge ~ gender, family = "binomial")

summary(results) # Note the (Intercept) is the WOMEN's INTERCEPT we calculated and the gender ESTIMATE
# is the B1 slope we calculated as the difference between MEN and WOMEN. Unlike the CHI-SQUARE test the
# GLM summary notes that GENDER is significant to the model.

# Logistic Regression with a Continuous Predictor p.205
# The book example reviewed a liberal arts college's returning sophomores and their retention rate, which
# was only 62%. The goal was to increase retention by predicting the likelihood of returning when understanding
# what drives students to stay or leave after their freshman year. The single best predictor turned out to be
# the student's interest in the school in the first place; this was marked by whether the student sent SAT scores
# to the school 1st on their list. Another big predictor was, of course, high school GPA; past behavior is a 
# good predictor of future behavior in this case.

# A T-TEST between HSGPA ~ Retained found a very significant difference in HSGPA between those who returned for their sophomore
# and those who did not (were not retained). Side note: Would an ANOVA do this for all of the variables, including any
# potential interactions?
# 
# The results were calculated with results <- glm(Retained ~ HSGPA, family = "binomial"); summary(results).
# The results$fitted.values were plotted against the HSGPA with:
#   predicted <= results$fitted.values
#   plot(HSGPA, predicted)
# The plot found that students with HSGPAs < 3.0 had less than a .50 chance of staying on, while those with HSGPAs > 4.0
# had about .70 probability of returning for their sophomore year.

# Logistic regression with multiple predictors
# Working with the most recent Lionshare data; can logistic regression tell us the probability of a participant being at 70% IRR?

lion.orig <- read.csv("c:\\r\\data\\Lionshare JPM Data 03282014.csv", stringsAsFactors = TRUE)

lion.orig$begin_date <- as.Date(as.character(lion.orig$begin_date), format = "%m/%d/%Y")
lion.orig$Eligibility_Date <- as.Date(as.character(lion.orig$Eligibility_Date), format = "%m/%d/%Y")

lion.orig$end.IRR.70 <- factor(ifelse(lion.orig$End_IRR < .7, "Less than 70%", "Greater than 70%"))


# Drop unnecessary columns
lion.orig$Change_To_IRR <- NULL
lion.orig$Chg_IRR <- NULL
lion.orig$Begin_IRR <- NULL
lion.orig$End_IRR <- NULL
lion.orig$part <- NULL
lion.orig$snp500_3Yr <- NULL
lion.orig$snp500_5Yr <- NULL
lion.orig$Three_Year_PROR <- NULL
lion.orig$Five_Year_PROR <- NULL
lion.orig$OTTR_2009 <- NULL
lion.orig$OTTR_2011 <- NULL

summary(lion.orig)

# Lots of NA values in the set; let's only use complete rows
lion.samp <- na.omit(lion.orig)

# Get 1000 records to work with; first randomize the data
# Don't need to do this with only 1,044 rows of complete data
# set.seed(12345)
# lion.rand <- lion.orig[order(runif(nrow(lion.orig))), ]
# 
# # Pull 1000 records for use
# lion.samp <- lion.rand[1000:2000, ]

# Dump the original files because we don't need them now
# rm(lion.orig, lion.rand)

# str(lion.samp)

# CUT? begin_date (col 3), snp500_3yr (5), snp500_5yr (6), Eligibility_Date (34)
# GROUP? Number_of_Investments (14), AGE (30)
# Add a descriptor column for Number of Investments
inv.summary <- summary(lion.samp$Number_of_Investments)
lion.samp$inv.group <- ifelse(lion.samp$Number_of_Investments <= inv.summary["1st Qu."], "1Q",
                              ifelse(lion.samp$Number_of_Investments <= inv.summary["Median"], "Med",
                                     ifelse(lion.samp$Number_of_Investments <= inv.summary["3rd Qu."], "3Q","4Q")))
lion.samp$inv.group <- factor(lion.samp$inv.group, levels = c("1Q", "Med", "3Q", "4Q"))
                              
# Add age groupings by GENERATION and BY 10s
lion.samp$generation <- factor(ifelse(lion.samp$AGE <= 33, "Millennial",
                                      ifelse(lion.samp$AGE <= 46, "Gen X",
                                             ifelse(lion.samp$AGE <= 57, "Early Boomer", "Late Boomer"))), levels = c("Millennial", "Gen X", "Late Boomer", "Early Boomer"))

lion.samp$age.cohort <- factor(ifelse(lion.samp$AGE < 30, "< 30",
                                      ifelse(lion.samp$AGE < 40, "30-39",
                                             ifelse(lion.samp$AGE < 50, "40-49", 
                                                    ifelse(lion.samp$AGE < 60, "50-59", "60+")))), levels = c("< 30", "30-39", "40-49", "50-59", "60+"))

# Add a Y/N variable for participants who are CONTRIBUTING, not how much
lion.samp$Pretax_Contrib <- factor(ifelse(lion.samp$PRETAX_CONTRB_PCT == 0, "Zero", 
                                          ifelse(lion.samp$PRETAX_CONTRB_PCT <= 4,"<= 4.0",
                                                 ifelse(lion.samp$PRETAX_CONTRB_PCT <= 7,"<= 7.0", "> 7.0"))), levels = c("Zero", "<= 4.0", "<= 7.0", "> 7.0"))

lion.samp$comp.group <- factor(ifelse(lion.samp$ANNUAL_COMP_AMT <= 45000, "Low",
                                      ifelse(lion.samp$ANNUAL_COMP_AMT <= 115000, "Moderate", "High")), levels = c("Low", "Moderate", "High"))
                              
# Full logistic model run of available variables
lion.irr.mdl <- glm(end.IRR.70 ~ begin_date + segment + Ao1_Managed_Accounts + Personal_Asset_Manager + Ao1_S_and_I_Experience + Personalized_Messaging
                    + After_Tax_Source + Catch_Up_Contributions + Roth_Source + QDIA + Number_of_Investments + Auto_Rebalancing + Auto_Enrollment
                    + Auto_Increase + db_available + NQ_Available + Brokerage + Target_Date_Funds + Re_Enrollment + Company_Stock + Auto_Enrolled +
                      EE_Match + ER_Match1 + Dream_Machine_Interactive + ANNUAL_COMP_AMT + AGE + GENDER_CD + PRETAX_CONTRB_PCT +
                      Eligibility_Date + Strategy + Hardship_Count + Loan_Count +
                      generation + age.cohort + Pretax_Contrib + comp.group, data = lion.samp, family = "binomial")
                              
lion.irr.mdl <- glm(end.IRR.70 ~ begin_date + segment + Ao1_Managed_Accounts + Ao1_S_and_I_Experience + After_Tax_Source
                    + Auto_Rebalancing + Auto_Enrollment + Auto_Increase + NQ_Available + EE_Match + generation +
                      GENDER_CD + Eligibility_Date + Strategy + Hardship_Count + Loan_Count + Pretax_Contrib + comp.group
                    , data = lion.samp, family = "binomial")
summary(lion.irr.mdl)














