##### The R Book, 2nd Edition by Crawley
#     Downloaded the PDF on August 22, 2014

###### Chapter 2
# 4 x 3 x 2 x 1
factorial(4)

# How many 13s are in 119?
119 %/% 13

# What's the remainder (modulo) of that equation?
119 %% 13

# Equality of floating point numbers
x <- 0.3 - 0.2
y <- 0.1
# Does R consider these values equal? Nope.
x == y

# IDENTICAL is x == y and R says FALSE here, too
identical(x, y)

# all.equal allows for comparison of insignificant differences
all.equal(x, y) # TRUE

# all.equal can be helpful in comparing LENGTHS
n1 <- c(1, 2, 3)
n2 <- c(1, 2, 3, 4)
all.equal(n1, n2) # Lengths differ

# ...or comparing variable modes and types
n2 <- as.character(n2)
all.equal(n1, n2) # numeric, character


##### Chapter 3: Data input

# Enter data through the combine (concatenate) function for small sets,
# the SCAN() function, or through the data.frame for lots of data
y <- c(6, 7, 3, 4, 8, 5, 6, 2)

x <- scan()

# SCAN may also be used with pasted COLUMNS of data from spreadsheets such
# as EXCEL. CTRL + C to copy and then CTRL + V to paste the column, then
# ENTER to finish and put the content into the assigned variable. If ROWS
# are entered this way they'll be concatenated into a single multi-digit number,
# which ain't what you want. Use COLUMNS, not ROWS for this.
z <- scan()

# To see the files in a directory...
dir("c:\\temp") # Put the location between the quotes

# Picking a file from a directory...
data <- read.table(file.choose(), header = TRUE) # header = T would do the same thing, but NOT recommended

# Saving time by cutting the HEADER option using...
data <- read.delim(file.choose())

# Common read.table errors include
# 1) Spaces in any variable names in row 1 of the data frame (underscores or dots!)
# 2) Forgetting whole path and file name or changing the working directory
# 3) Forgetting the HEADER statement
# 4) Using single, not double, slashes in the file path

# READ.TABLE() can be used for content with blanks in strings, but
# export the spreadsheet using commas to separate the fields and tell
# READ.TABLE() to separate the fields with sep = "," to override tabs
# because the default separator is " "
# READ.TABLE() converts characters to factors; to avoid this behavior
# use as.is to specify columns that should NOT be converted
murder <- read.table("c:\\temp\\murders.txt", header = TRUE, as.is = "region") # example!

# Use READ.CSV() for comma separated files

# Read data off the web...
# This example doesn't work because of a 400 Bad Request; takes too long to get, so dumps out
data2 <- read.table("http://www.bio.ic.ac.uk./research/mjcraw/therbook/data/cancer.txt", header = TRUE)
head(data2)

# 3.3 Input from files using SCAN() p. 163
# READ.TABLE() is great for DATA FRAMES. For other, more complicated where read.table struggles.
# SCAN reads data into  list when used to read from a file and less friendly with dataframes.
# SCAN assumes double precision numbers for input; if not, then need to use WHAT argument to explain
# what is being input. Filename is relative to current working directory unless specify absolute
# path. If WHAT is a list then scan assumes that lines of data file are records, each containing
# one or more items and the number of fields on that line is given by length(what). SCAN defaults
# to reading space-delimited or tab-delimited input fields so be sure to use the sep= to specify 
# a different separator. Might want to skip header row using SCAN, so use skip = 1 or any number of 
# lines to ignore field names. If a single record is more than one line long, use multi.line = TRUE.

# 3.4 Reading data from  file using ReadLines
line <- readLines("c:\\SASData\\Input\\allscores.txt")

line # Each line is a single string displaying the TABS

# STRSPLIT pulls apart the data when it knows the delimiter
db <- strsplit(line, "\t")

# Displays the data in a list format
db

# Eliminate the list structure with the UNLIST() function
bb <- unlist(db)

bb

dim(bb) <- c(6,3)

bb

# Transpose the data because everything's in columns instead of rows
# This data didn't have a header row, which could have been deleted with t(bb)[-1, ]
t(bb)

# Now we should be able to convert this to a DATA FRAME
frame <- as.data.frame(t(bb))
head(frame)

# We could add the column names if no header row in original data
names(frame) <- c("Last Name", "Score 1", "Score 2", "Score 3", "Score 4", "Score 5")

# 3.4.2 Reading non-standard files using readLines
# Each record has differing input sizes
readLines("c:\\SASData\\Input\\music.txt")

strsplit(readLines("c:\\SASData\\Input\\music.txt"),",")

rows <- lapply(strsplit(readLines("c:\\SASData\\Input\\music.txt"),","), as.numeric) # Coerces strings into NAs

# Remove the NAs from each vector in the list
# By writing our own function and applying it to the list ROWS through a SEQUENCE
# FUNCTION is necessary to pass in the sequence; without it the sequence isn't run
sapply(1:5, function(i) as.numeric(na.omit(rows[[i]])))

# 3.5 Warnings about using ATTACH with a DATA FRAME

# Name data frames carefully; if they duplicate elements within the frame itself
# and then is attached the system will throw an error

# 3.6 Masking
# Maybe the same dataframe has been attached twice or two DFs have the same element names.
# Masking (two objects with the same attached name) is common when variables are poorly named.
# The warning from R after ATTACH should be the alert to the issue. Best practice, though, is
# NOT to attach but use functions like WITH() and 1) use longer, more self-explanatory variable
# names, 2) don't calculate on variables with the same name as those in a DATA FRAME 3) always
# DETACH dataframes when finished with them and 4) remove calculated variables when finished
# with them RM()

# 3.7 Input and output formats
# See p. 172 for each type

# 3.8 Checking files from the command line p. 173
# Does the file we're trying to open exist where we say it does?
file.exists("c:\\SASData\\Input\\music.txt") # Returns T/F; in this case, TRUE

# 3.9 Reading dates and times from files
# R has a robust system for working with dates and times but takes getting used to.
# Usually read in as strings and then converted using STRPTIME() to explain the elements

# 3.10 Built-in data files
data() # Lists all built-in data sets

# Documentation on the data can be found with ?<dataset name>

# Can use TRY() function to view data names and trap errors that occur during evaluation
try(data(package = "MASS")); Sys.sleep(3)

# Built-in data sets can be ATTACHED and DETACHED normally

# 3.13 Reading data from a database
# First, set up the DSN; this example uses Northwind

# 3.13.2 Setting R to read from the DB
library(RODBC)

channel <- odbcConnect("northwind")

query <- "select * from Categories"

stock <- sqlQuery(channel, query)

stock

# Chapter 4 Dataframes (Data Frames everywhere else I've read it)
# Challenges the way we typically think of data and spreadsheets
# If an experiment has three treatments--control, preheated and prechilled--and
# four measurements per treatment, what might seem a normal spreadsheet is:

# control preheated prechilled
# 6.1     6.3       7.1
# 5.9     6.2       8.2
# 5.8     5.8       7.3
# 5.4     6.3       6.9

# This is NOT a DATA FRAME; the correct entry is in two columns:

# Response  Treatment
# 6.1       Control
# 5.9       Control
# 5.8       Control
# 5.4       Control
# 6.3       Preheated
# 6.2       Preheated
# 5.8       Preheated
# 6.3       Preheated
# 7.1       Prechilled
# 8.2       Prechilled
# 7.3       Prechilled
# 6.9       Prechilled

# Good way to practice is use Excel's Pivot Table function

worms <- read.table("c:\\R\\Data\\Worm.txt", header = TRUE)

# Recommend saving Excel file as tab-delimited and using read.table
# while replacing all spaces in column names with dots (.) and removing
# all apostrophes. Once the DATA FRAME has been read in there are four things
# to do:

# 1) Attach the DATA FRAME in the search path to simplify variable usage
# 2) Use NAMES() to get a list of variable names
# 3) Use HEAD() to look at first few rows of data
# 4) Use TAIL() to look at last few rows of data

# An alternative is to use STR() for the structure and some variable examples
attach(worms)
names(worms)
head(worms)
tail(worms)

str(worms)

# Look at the entire dataframe
worms

# Don't forget SUMMARY() gives arithmetic mean and five non-parametric values
# (max, min, median, Q1, and Q3); can also use Tukey's five-number function
# fivenum() for slightly different representation.
summary(worms)

# Two functions, BY() and AGGREGATE(), allow summary of a dataframe based on factor levels.
# What are the means of the numeric variables in WORMS for each VEGETATION type?
by(worms, Vegetation, mean) # NOTE: Damp has been coerced into a numeric and averaged

# Models can also be fit into the BY() call; in this case worm density as function of soil density
# for each vegetation type
by(worms, Vegetation, function(x) lm(Worm.density ~ Soil.pH, data = x))

# 4.1 Subscripts and indices
# Get comfortable with subscripts (AKA indices)--critical to understanding data usage
# Always in square brackets ([])
# DATAFRAME = 2-dimensional object where [row, col]
worms[3, 5] # 4.3

# Generate a group of rows and columns use the colon operator (:)
worms[14:19, 7]

worms[1:5, 2:3]

# CONFUSING but IMPORTANT
# Pull all columns in row 3
worms[3, ]

# Pull all rows in column 3
worms[ , 3]

# Are these really two different objects?
class(worms[3, ]) # data.frame--returns a data.frame because all columns same length
class(worms[ , 3]) # integer--returns a vector of integers

# Create a set of rows and columns using the COMBINE (CONCATENATE) function
worms[ , c(1, 5)]

# In bootstrapping or cross-validation we might want to select random rows from the dataframe
# Use the SAMPLE() function with replace = FALSE to shuffle (each row selected once and only once)
# while replace = TRUE allows for multiple copies of certain rows and omission of others
worms[sample(1:20, 8), ]

# 4.3 Sorting dataframes
# Common to want to sort by rows but rarely by columns
# ORDER() function lets us do this; SORT() works similarly
worms[order(Slope), ]

# Can reverse order the data with REV() or by ORDER(x, decreasing = TRUE)
worms[rev(order(Slope)), ]

worms[order(Slope, decreasing = TRUE), ]

# ORDER can handle complicated sorts of multiple variables
# where R sorts on left-hand most variable and breaks ties with the next right variable
worms[order(Vegetation, Worm.density), ]

# NOTE: Ties are not broken but represented in their original record order; in this case soil pH
# Try to eliminate ties by adding to the sort order
worms[order(Vegetation, Worm.density, Soil.pH), ]

# TIP: When in doubt use more variables than you think you need to be certain rows are in
# the order you want

# What if you only want certain columns from the sorted dataframe?
worms[order(Vegetation, Worm.density, Soil.pH), c(4, 7, 5, 3)]

# This can also be done with the variable names, though more typing and potential for error
worms[order(Vegetation, Worm.density, Soil.pH), c("Vegetation", "Worm.density", "Soil.pH", "Slope")]

# 4.4 Using logical conditions to select rows from the dataframe p. 191
# Very common to select certain rows from a dataframe on the basis of values in one or more
# variables; in this case, restrict the data to only damp fields
worms[Damp == TRUE, ]

# Suppose we want data from the fields where worm density was higher than the median
# and soil pH was less than 5.2. The LOGICAL AND OPERATOR is &.
worms[Worm.density > median(Worm.density) & Soil.pH < 5.2, ]

# Now we want to extract all columns that contain numbers; use is.numeric with sapply()
worms[ , sapply(worms, is.numeric)]

# Extract all the factor columns; all characters have been coerced to factors
# so is.character() would return NULL
worms[ , sapply(worms, is.factor)]

# To drop rows or cols use a negative (-) subscript
# Here drop the middle 10 rows
worms[-(6:15), ] # Drops rows 6-15

# Drop all rows where Vegetation is NOT Grassland
worms[!Vegetation == "Grassland", ] # Parens not necessary but better visually worms[!(Vegetation == "Grassland"), ]

# Above brings rows 2, 4, 5, 8, 9, 11, 15, 16, 17, 18, and 20
# Is this equivalent?
worms[Vegetation != "Grassland", ] # Yes, and it makes more sense to me, too, potentially with fewer computing operations

# Minus signs can be used in place of logical NOT to drop rows;
# the expression used must evaluate to numbers, and WHICH() is
# good for this
worms[-which(Damp == FALSE), ]

# This is more elegant, though
worms[!Damp == FALSE, ]

# and this is the most logical
worms[Damp == TRUE, ]

# 4.5 Omitting rows containing missing values, NA
wormsmiss <- read.table("c:\\R\\Data\\Worms.missing.txt", header = TRUE)

# Let's leave out all rows with NA, using NA.OMIT()
# This displays the rows with all data but does not permanently alter the original dataframe
na.omit(wormsmiss)

# This alters the original dataframe by cutting all rows with NA
wormsmiss <- na.omit(wormsmiss)

# NA.EXCLUDE() can also be used; EXCLUDE pads the dataframe for residuals and predictions
# with NAs for omitted cases; in this case the length would still be 20 instead of 17)
wormsmiss.exclude <- na.exclude(wormsmiss)

# To test for the presence of missing values use COMPLETE.CASES()
complete.cases(wormsmiss) # Returns a logical vector for each record

# Worth checking individual variables separately; possible that one+ variables
# have most NAs, which you may want to be rid of, but not lose the explanatory
# data, too. Use SUMMARY() to count missing values for each variable in the dataframe
# or use APPLY() with IS.NA() to sum missing values in each variable
apply(apply(wormsmiss, 2, is.na), 2, sum) # Totals of columns with missing data

summary(is.na(wormsmiss)) # Logical vector output more verbose but bit more elegant

# 4.5.1 Replacing NAs with zeros
# At some point missing values might need to be replaced with some other value
# indicating the same thing
wormsmiss[is.na(wormsmiss)] <- 0

# 4.6 Using ORDER() and !DUPLICATED to eliminate pseudoreplication
# Pull a single record foreach vegetation type with each vegetation type
# with the highest worm density. Two steps: 1) Order all rows by Worm.density,
# 2) Select subset of rows that aren't duplicated within each vegetation type

# This version orders the returned rows 9, 11, 16, 2, 10
# while the book orders them 9, 16, 11, 10, 2 using REV()
new.worms <- worms[order(Worm.density, decreasing = TRUE), ]

# REV() reverses the sort order
new.worms <- worms[rev(order(Worm.density)), ]

new.worms[!duplicated(new.worms$Vegetation), ]

# Not sure why REV() is better than ORDER(x, decreasing = TRUE) but think
# must be that ties are broken differently when the sort order is simply reversed

# 4.7 Complex ordering with mixed directions
# Sometimes with multiple sort variables one or many of them must be sorted in
# the opposite direction (ex: one ascending, one descending). The trick is to
# ORDER() but to use a minus sign. The MINUS SIGN ONLY WORKS WITH SORTING NUMERIC values.
worms[order(Vegetation, -Worm.density), ]

# NOTE: SORT() is best when sorting on an individual vector or factor, while
# ORDER is best used for dataframes

# FACTORS can be sorted with RANK()
# This code orders WORMS in opposite rank order of Vegetation and then by
# opposite worm density based on Vegetation order
worms[order(-rank(Vegetation), -Worm.density), ]

# Does this work?
worms[order(-Vegetation, -Worm.density), ] # No, pops Warning that - not meaningful for FACTORS

# To pull COLUMNS (rare, but possible), such as finding all columns that begin with 'S'
# use GREP(), which returns a subscript (number or set of numbers) indicating which character
# strings within a vector of character strings contained the searched for string or character.
# NAMES gives us the variables within the dataframe
names(worms)

grep("S", names(worms))

# Use GREP results to pull matching columns
# COOL but valuable?
worms[ , grep("S", names(worms))]

# 4.8 A dataframe with row names instead of row numbers
# Can suppress row numbers and create own unique names to each row
# by altering syntax of READ.TABLE
worms2 <- read.table("c:\\R\\Data\\Worm.txt", header = TRUE, row.names = 1)
worms2

# 4.9 Creating a dataframe from another kind of object
# Dataframes are best built by reading a table of data in, but can be produced
# by bringing together other objects as long as they are all the same length
x <- runif(10) # Random series of 10 numbers < 1
y <- letters[1:10] # First 10 lowercase letters of the alphabet
z <- sample(c(rep(TRUE, 5), rep(FALSE, 5))) # Sample of 5 TRUEs and FALSES in random order

new <- data.frame(y, z, x) # Order of columns controlled by sequence of combined vector names

# Create a table of counts of random integers from a Poisson distribution
yy <- rpois(1500, 1.5)
table(yy)

short <- as.data.frame(table(yy))
short

# Might want to expand a dataframe with separate row for every distinct count; done
# with subscripts by creating a vector of indices
index <- rep(1:8, short$Freq) # Repeats ROW NUMBERS, not yy values
length(index)

hist(index, -0.5:8.5)

# 4.10 Eliminating duplicate rows from a dataframe
# Sometimes a dataframe will have duplicate rows where all variables are exactly the same
dups <- read.table("c:\\R\\Data\\dups.txt", header = TRUE)

dups # Row 5 is exact duplicate of row 3

# Use UNIQUE to strip out all duplicates
unique(dups) # NOTE row names in new data frame are identical to original

# To view duplicated rows (if any), use DUPLICATED to create logical T/F vector as filter
dups[duplicated(dups), ]

# 4.11 Dates in dataframes
# Order a dataframe by date
nums <- read.table("c:\\R\\Data\\sortdata.txt", header = TRUE)

attach(nums)

head(nums)

# Let's try the first idea for sorting
nums[order(date), ] # Doesn't work b/c read in as factor

# Use STRPTIME to convert the data
dates <- strptime(date, format = "%d/%m/%Y")

# Bind the reformatted dates in yyyy-mm-dd format with the original data
nums <- cbind(nums, dates)

# Do these get put in the right order now?
nums[order(dates), ] # Yes, but look to the far right for the DATES column

# 4.12 Using the MATCH function in dataframes
# Five vegetation types in our worm dataframe
unique(worms$Vegetation)

# Which herbicide should we use in each type of field?
herbicides <- read.table("c:\\R\\Data\\herbicides.txt", header = TRUE)
herbicides

# Let's match the correct herbicide with the 20 rows in the worms dataframe
# and create a new column with this information where they MATCH
# First, let's see how MATCH works
herbicides$Herbicide[match(worms$Vegetation, herbicides$Type)]

# Now add the herbicides to the worms dataframe
# Match is similar to an Excel VLOOKUP or a SQL join
worms$hb <- herbicides$Herbicide[match(worms$Vegetation, herbicides$Type)]

# 4.13 Merging two dataframes
# Want to combine two dataframes into one
lifeforms <- read.table("c:\\R\\Data\\lifeforms.txt", header = TRUE)
flowering <- read.table("c:\\R\\Data\\fltimes.txt", header = TRUE)

# Use the identical variable names across the two dataframes, Genus and species
merge(flowering, lifeforms) # Only where complete match across entire row

# To include all matches, partial and complete...
both <- merge(flowering, lifeforms, all = TRUE) # Missing or incomplete data is NA

# What if the key field across two dataframes is named differently?
# If the data can be fixed before reading into R, do it
# If this unavoidable the by.x() and by.y() functions are available
seeds <- read.table("c:\\R\\Data\\seedwts.txt", header = TRUE)

# How does MERGE work trying to combine BOTH and SEEDS?
merge(both, seeds) # Gives every possible combination, looks like Cartesian product

# Need to tell MERGE that Genus and name1 are synonymous
# BY.X = the BOTH dataframe, BY.Y = the SEEDS dataframe
# Note that multiple key columns are combined
# Note that resulting variable names are from the X dataframe
merge(both, seeds, by.x = c("Genus", "species"), by.y = c("name1", "name2"))

# 4.14 Adding margin (variance?) to a dataframe
# A dataframe shows sales by person in each season
# How much margin is each producing?
sales <- read.table("c:\\R\\Data\\sales.txt", header = TRUE)
# Print the existing sales data
sales

# Calculate row averages for the 2nd through 5th columns
people <- rowMeans(sales[ , 2:5])
# Calculate the difference between each person's average and the overall average
people <- people - mean(people)
people

new.sales <- cbind(sales, people)

new.sales

# Column means are calculated the same way
seasons <- colMeans(sales[ , 2:5])

seasons <- seasons - mean(seasons)
seasons # Best sales are in summer, worst in fall

# Can't simply rbind the seasons data because only 4 columns,
# whereas new.sales has 6
# So, make a new row from an existing row
new.row <- new.sales[1, ]

# Edit the row to include the data we want
new.row[1] <- "Seasonal Effects"
new.row[2:5] <- seasons
new.row[6] <- 0
new.row

# Now we can rbind to the end of the new.sales dataframe
new.sales <- rbind(new.sales, new.row)

# Calculate the grand mean of the new sales data
grandmean <- mean(unlist(new.sales[1:5, 2:5])) # 13.45

# Repeat the grand mean four times for comparisons
grandmean <- rep(grandmean, 4)

# SWEEP replaces original data (x), with the difference of margin (z), by column (y) 
new.sales[1:5, 2:5] <- sweep(new.sales[1:5, 2:5], 2, grandmean)

# Finish the dataframe by putting the grand mean in the bottom right
new.sales[6, 6] <- grandmean[1]

# SIDE NOTE: Building arrays
# The next code builds two matrices of 4 rows and 3 columns
# by assigning the numbers 1-24 to 2 dim(ensioned) arrays of
# 4 rows, which assumes 3 rows
array(1:24, dim = 4:2)

array(1:24, dim = 4,2:2) # Produces [1] 1, 2, 3, 4

array(1:24, dim = 3:2) # Produces single array of 3 rows and 2 columns 1-6

array(1:24, dim = 3:3) # Produces a vector of 1, 2, 3

# 4.15 Summarizing the contents of dataframes
# To get mean or median for a single vector, use TAPPLY,
# but to summarize whole dataframes use SUMMARY, AGGREGATE,
# and BY

# AGGREGATE is like TAPPLY to the levels of a specified
# CATEGORICAL variable that are specified using their subscripts
# as a column index
# What's this doing?
# 1) Pull only the 2nd, 3rd, 5th and 7th columns from WORMS
# 2) BY the factor VEGETATION, referenced as veg (which is required unless you want R to call the column Group.1)
# 3) and get the AVERAGE of those four columns based on the factor
aggregate(worms[ , c(2, 3, 5, 7)], by = list(veg = Vegetation), mean)

# Still need to use a list, even for one classifying FACTOR,
# in this case by both Vegetation and Damp
aggregate(worms[ , c(2, 3, 5, 7)], by = list(veg = Vegetation, d = Damp), mean)

# Chapter 5 Graphics

# Four types: plots with two variables, plots for a single sample,
# multivariate plots, and special plots for special purposes

# 5.1 Plots with two variables
# Usually the response (y axis) and explanatory (x axis) variables
# If the explanatory variable is continuous (length, height, weight)
# then SCATTERPLOT. If explanatory = categorical (political party, color, gender)
# then box-and-whisker or barplot, whether want to raw data or emphasize
# effect sizes

# Most common:
# 1) plot(x, y) = scatterplot of y against x
# 2) plot(factor, y) = box-and-whisker of y at each factor level
# 3) barplot(y) = heights from a vector of y values (one bar per factor level)
plot(Soil.pH, Worm.density) # Scatter
plot(Vegetation, Soil.pH) # Box and whisker of Soil.pH by Vegetation factor
barplot(Soil.pH) # Bar plot of each soil pH value

# 5.2 Plotting with two continuous variables: scatterplots
# Continuous variables have fractional values, not single integer values, 
# like weight, height or length. Two PLOT types are available: Cartesian
# and formula. Cartesian plots are like grid references on a map, with
# Eastings first, then Northings (x and then y). Formula plotting is
# exactly the opposite: y then x.

plot(Soil.pH, Worm.density) # Cartesian (x then y)scatter
plot(Worm.density ~ Soil.pH) # Formula scatter (y (response) then x (explanatory))

# Use XLAB and YLAB to change the default axis names, otherwise they are the variable names
# Use MAIN to title the graph

# Easy to add things to the plotting, such as the regression line,
# in this case added to a linear model object
# ABLINE adds the regression line--how the hell did they come up with ABLINE?
abline(lm(Worm.density ~ Soil.pH))

# Straightforward to add lines to the plot, just as easy to add more points
# Many of the points DON'T appear with the 2nd plotting because R defaults
# to pretty plotting of the 1st set of points to be drawn. Points of the 2nd
# plot that don't fit the first plot are dropped with no warning
points(Slope, Soil.pH, col = "blue", pch = 16)

# Now let's add the regression line
abline(lm(Soil.pH ~ Worm.density))

# How to fix the missing plotting?
# PLOT now has combined x1 and x2, then y1 and y2 with x-axis and y-axis titles while TYPE 
plot(c(Worm.density, Slope), c(Soil.pH, Soil.pH), xlab = "Explanatory", ylab = "Response", type = "n")

points(Worm.density, Soil.pH, col = "red")
points(Slope, Soil.pH, col = "blue", pch = 16)

abline(lm(Soil.pH ~ Worm.density))
abline(lm(Soil.pH ~ Slope))

# How to set limits for axes? YLIM and XLIM
# To find the axis values use RANGE
range(c(Worm.density, Slope)) # 0 to 11
range(c(Soil.pH)) # 3.5 to 5.7 (3 to 6)

plot(c(Worm.density, Slope), c(Soil.pH, Soil.pH), xlim = c(0, 11), ylim = c(3, 6),
     xlab = "Explanatory", ylab = "Response", type = "n")

points(Worm.density, Soil.pH, col = "red")

# 5.2.1 Plotting symbols

# PCH = Plotting CHaracter (symbol), of which there are 255 available in Windows (+, triangle, etc.)
points(Slope, Soil.pH, col = "blue", pch = 16)

abline(lm(Soil.pH ~ Worm.density))
abline(lm(Soil.pH ~ Slope))

# A legend (description) to explain the difference in color might be helpful
# LOCATOR tells R to wait for a mouse click on the graph, which will place the legend
# X and Y axis values can be used in substitute for LOCATOR
legend(locator(1), c("Worm.Density", "Slope"), pch = c(1, 16), col = c("red", "blue"))

# 5.2.3 Adding text to scatterplots p. 219
# Want to add the text "(b)" at (80, 65)?
text(80, 65, "(b)")

# Lots more here I'm not interested on 9/12/14

# 5.7 Plots for single samples p. 242

# More restricted in plot choices:

# HIST(y) = histrograms for frequency distribution
# PLOT(y) = index plots th show values of y in sequence
# PLOT.TS(y) = Time series plots
# PIE(x) = compositional plots like pie diagrams

# 5.7.1 Histrograms and bar charts
# Histograms have the response variable on the x axis and y shows the frequency 
# of the response (the probability density). Bar charts are exactly the opposite.

# 5.7.6 Index plots
# Useful for single samples, PLOT() takes a single continuous variable argument
# and plots the values on the y axis, with x determined by the position of the number
# in the vector--its index--up to length(y). This is especially useful for error checking.

response <- read.table("c:\\R\\Data\\RBook\\das.txt", header = TRUE)

plot(response$y) # Clearly one point is way out of bounds; data entry error?

# Which item is out of bounds?
which(response$y > 15)

# Use the subscript to see the precise value of y
response$y[which(response$y > 15)]

# Correct the value, which was incorrectly entered
response$y[101] <- 2.146733

plot(response$y) # Much better

# 5.7.7 Time series plots
# Time series plots are relatively easy when data is complete, but when missing values
# are in the time series the behavior can be unpredictable. R uses TS.PLOT() and PLOT.TS()

# Use the R base data set UKLungDeaths
data(UKLungDeaths)

# Upper line is ALL deaths, middle line is MALE deaths, lower line is FEMALE deaths
ts.plot(ldeaths, mdeaths, fdeaths, xlab = "Year", ylab = "Deaths", lty = c(1:3))

# Alternative function PLOT.TS() works for plotting objects inheriting from class = ts
# rather than simple vectors of numbers as is the case for TS.PLOT()
data(sunspots)
plot(sunspots)

# This works because SUNSPOTS inherits from the time series class and has the dates
# for plotting on the x axis built into the object

class(sunspots) # "ts" = time series

is.ts(sunspots) # is this a time series? TRUE

str(sunspots) # Time-Series [1:2820]

# 5.7.8 Pie charts
# Most people hate pie charts, and statisticians hate them more because they assume
# everyone should know what 50% looks like, but they can be useful to show the proportional
# makeup of a sample in presentations. Essential to label which pie segment is which, and the
# label is provided as a vector of character strings. READ.TABLE() is not as valuable here
# because this data has blanks in names, so we use READ.CSV()
data <- read.csv("c:\\R\\Data\\RBook\\piedata.csv")

# PRINT the data to the console
data

# Produce the pie chart with default colors, but using the NAMES as labels
pie(data$amounts, labels = as.character(data$names))

# 5.7.9 Stripchart function
# When box-and-whisker plots don't work due to smaller sample sizes, a STRIPCHART
# might be a good alternative. A model (y ~ factor which means y = factor) that looks
# at the location of individual values in a small sample and can be shown vertically
# or horizontally
# Use a built-in data set
data(OrchardSprays)

# NOTE: WITH() is used instead of ATTACH() here
# Generally looks like box and whisker without lines but showing all of the values
# The y-axis is a logarithmic plot and the strip charts are vertical
with(OrchardSprays,
     stripchart(decrease ~ treatment,
                ylab = "Decrease", vertical = TRUE, log = "y"))

# 5.7.10 Using a plot to test for normality
normal.plot <- function(y) {
  s <- sd(y)
  
  plot(c(0,3), c(min(0, mean(y) - s * 4 * qnorm(0.75)), max(y)), xaxt = "n", xlab = "", type = "n", ylab = "")
  
  # For your datas boxes and whiskers centered at x = 1
  
  top <- quantile(y, 0.75)
  bottom <- quantile(y, 0.25)
  
  w1u <- quantile(y, 0.91)
  w2u <- quantile(y, 0.98)
  w1d <- quantile(y, 0.09)
  w2d <- quantile(y, 0.02)
  
  rect(0.8, bottom, 1.2, top)
  
  lines(c(0.8, 1.2), c(mean(y), mean(y)), lty = 3)
  lines(c(0.8, 1.2), c(median(y), median(y)))
  lines(c(1,1), c(top, w1u))
  lines(c(0.9, 1.1), c(w1u, w1u))
  lines(c(1, 1), c(w2u, w1u), lty = 3)
  lines(c(0.9, 1.1), c(w2u, w2u), lty = 3)
  
  nou <- length(y[y > w2u])
  points(rep(1, nou), jitter(y[y > w2u]))
  
  lines(c(1, 1), c(bottom, w1d))
  lines(c(0.9, 1.1), c(w1d, w1d))
  lines(c(1, 1), c(w2d, w1d), lty = 3)
  lines(c(0.9, 1.1), c(w2d, w2d), lty = 3)
  
  nod <- length(y[y < w2d])
  points(rep(1, nod), jitter(y[y < w2d]))
  
  # For the normal box and whiskers, centered at x = 2
  n75 <- mean(y) + s * qnorm(0.75)
  n25 <- mean(y) - s * qnorm(0.75)
  n91 <- mean(y) + s * 2 * qnorm(0.75)
  n98 <- mean(y) + s * 3 * qnorm(0.75)
  n9 <- mean(y) - s * 2 * qnorm(0.75)
  n2 <- mean(y) - s * 2 * qnorm(0.75)
  
  rect(1.8, n25, 2.2, n75)
  
  lines(c(1.8, 2.2), c(mean(y), mean(y)), lty = 3)
  lines(c(2, 2), c(n75, n91))
  lines(c(1.9, 2.1), c(n91, n91))
  lines(c(2, 2), c(n98, n91), lty = 3)
  lines(c(1.9, 2.1), c(n98, n98), lty = 3)
  lines(c(2, 2), c(n25, n9))
  lines(c(1.9, 2.1), c(n9, n9))
  lines(c(2, 2), c(n9, n2), lty = 3)
  lines(c(1.9, 2.1), c(n2, n2), lty = 3)
  lines(c(1.2, 1.8), c(top, n75), lty = 3, col = "gray")
  lines(c(1.1, 1.9), c(w1u, n91), lty = 3, col = "gray")
  lines(c(1.1, 1.9), c(w2u, n98), lty = 3, col = "gray")
  lines(c(1.2, 1.8), c(bottom, n25), lty = 3, col = "gray")
  lines(c(1.1, 1.9), c(w1d, n9), lty = 3, col = "gray")
  lines(c(1.1, 1.9), c(w2d, n2), lty = 3, col = "gray")
  
  # label the boxes
  axis(1, c(1, 2), c("Data", "Normal"))
}

y <- rnbinom(100, 1, 0.2)

normal.plot(y)

# 5.8 Plots with multiple variables
# PAIRS() for a matrix of scatterplots of every variable against every other
# COPLOT() for conditioning plots where y is plotted against x for different values of z
# XYPLOT() where a set of panel plots is produced

# 5.8.1 Pairs function
# With 2 of more explanatory variables such as in a multiple regression it's helpful
# to check for subtle dependencies between the explanatory variables.
ozonedata <- read.table("c:\\R\\Data\\RBook\\ozone.data.txt", header = TRUE)

attach(ozonedata)

names(ozonedata)

# Only the DATA is required; the panel.smooth argument adds
# a non-parametric smoother to the plots. Response variables
# are named in the rows while explanatory are in the columns.
# In the upper row labeled RAD the response variable on the y axis
# is solar radiation. There appears to be a strong negative non-linear
# relationship between OZONE and WIND speed
pairs(ozonedata, panel = panel.smooth)

# 5.8.2 The coplot function
# Multivariate data relationships may be obscured by the effects of
# other processes. Let's look at the OZONE data again.

# This plot shows the interaction of WIND and OZONE at differing
# levels of TEMP (conditions). The interest is that in the lowest
# two TEMP ranges there seems to be very little interaction, but
# in the top 4 TEMP ranges there's definite interaction. The panels
# are read from bottom to top, left to right, so the lowest TEMP
# range is on the bottom left
coplot(ozone ~ wind | temp, panel = panel.smooth)

# 5.8.3 Interaction plots
# Useful when the response to one factor depends upon the level of another
# factor, especially for factorial experiments. This example covers grain
# yields in response to irrigation and fertilizer application
yields <- read.table("c:\\R\\Data\\RBook\\splityield.txt", header = TRUE)

attach(yields)

names(yields)

# Note the response variable (YIELD) comes LAST in the argument list
# The first factor provides the X-AXIS while the 2nd argument produces
# the Y-AXIS
interaction.plot(fertilizer, irrigation, yield)

# 5.9 Special plots

# 5.9.1 Design plots
# Used to visualize effect sizes in designed experiments
# Data in the DAPHNIA data set for the book; not referenced until Chapter 6
plot.design(Growth.rate ~ Water * Detergent * Daphnia)


# Chapter 6 Tables
# Tables are an alternative to graphics and are best to convey
# detail versus effect. Tables are best to summarize data when
# explanatory variables are categorical than continuous

# TABLE() is for counting things; TAPPLY() is for averaging things
# and applying other functions across factor levels

# 6.1 Tables of counts
# TABLE() is most useful of all simple VECTOR functions
# How many of each value is present in the vector?
counts <- rpois(1000, 0.6)

table(counts) # 525 0s, 342 1s, 111 2s, 17 3s, and 5 4s

# TABLE() also works with characters and for classifying multiple
# variables
infections <- read.table("C:\\R\\Data\\RBook\\disease.txt", header = TRUE) # NOT in the Book data

attach(infections)
head(infections)

# Figure out how many males and females were infected and how many clear
table(status, gender) # STATUS = rows, GENDER = columns

# Reverse the order
table(gender, status)

# 6.2 Summary tables
# TAPPLY is the somewhat obscurely named function for generating summary tables
# Named this way because it allows for function use across factor variables
# to create a table; similar to an Excel PivotTable
data <- read.table("C:\\R\\Data\\RBook\\daphnia.txt", header = TRUE)
attach(data)
names(data)

# The RESPONSE variable is the GROWTH RATE of the animals, and three explanatory
# variables: the river from which water was sampled, kind of detergent experimentally added,
# and the clone of daphnia in the experiment. What are the mean growth rates of the four
# brands of tested detergent?
tapply(Growth.rate, Detergent, mean)

# or for the two rivers
tapply(Growth.rate, Water, mean)

# or the three daphnia clones
tapply(Growth.rate, Daphnia, mean)

# More than one variable can be used with a LIST; in this case
# the daphnia clones as the ROWS and detergent as COLUMNS (rows, columns)
tapply(Growth.rate, list(Daphnia, Detergent), mean)

# What if we wanted the median Growth Rate values?
tapply(Growth.rate, list(Daphnia, Detergent), median) # Ta-da!

# What if we want something not calculable in R, like standard error of the mean?
# Write an anonymous function!
# SE = sqrt(sd ^ 2 / n)
tapply(Growth.rate, list(Daphnia, Detergent), function(x) sqrt(var(x) / length(x)))

# When asked to produce a three-dimensional table, TAPPLY() produces a stack of
# two-dimensional tables, determined by the number of levels of categorical variable
# that is THIRD in the list (in this case, WATER)
tapply(Growth.rate, list(Daphnia, Detergent, Water), mean)

# The function FTABLE (flat table) often produces more pleasing output when
# there are multiple dimensions; DON'T FORGET TO USE TAPPLY, though, as
# FTABLE is a wrapper for presentation
ftable(tapply(Growth.rate, list(Daphnia, Detergent, Water), mean))

# ROWS, COLS, and TABLES are in alpha sequence by FACTOR levels by default,
# but this can be overridden with an assignment
# NOTE that this assignment is a separate FACTOR variable set, and the base
# data remains in original order
water <- factor(Water, levels = c("Wear", "Tyne"))

ftable(tapply(Growth.rate, list(Daphnia, Detergent, water), mean)) # Note use of water, not Water

# TRIM is part of the MEAN function and specifies a fraction (between 0 and 0.5) of the
# observations to be trimmed from each end of the sorted vector of values BEFORE the mean
# is computed
tapply(Growth.rate, Detergent, mean, trim = 0.1)

# Don't forget to ignore NA!
tapply(Growth.rate, Detergent, mean, na.rm = TRUE) # Without na.rm any missing value will result in NA answer

# TAPPLY can also create new, abbreviated dataframes comprising summary parameters estimated
# from the larger dataframe; we want a dataframe of mean growth rate classified by detergent
# and daphnia clone
dets <- as.vector(tapply(as.numeric(Detergent), list(Detergent, Daphnia), mean))
levels(Detergent) [dets]

clones <- as.vector(tapply(as.numeric(Daphnia), list(Detergent, Daphnia), mean))
levels(Daphnia) [clones]

# The 12 mean values for our RESPONSE variable in the new reduced dataframe are given by:
tapply(Growth.rate, list(Detergent, Daphnia), mean)

# The 12 mean values can now be converted into a vector
means <- as.factor(tapply(Growth.rate, list(Detergent, Daphnia), mean))
detergent <- levels(Detergent) [dets]
daphnia <- levels(Daphnia) [clones]

# The three vectors are now combined in a new dataframe
data.frame(means, detergent, daphnia)

# All of this can be done with the following statement
as.data.frame.table(tapply(Growth.rate, list(Detergent, Daphnia), mean))

# To get the variable names correct, though...
new <- as.data.frame.table(tapply(Growth.rate, list(Detergent, Daphnia), mean))

names(new) <- c("Detergents", "Daphnia", "Means")
head(new)

# 6.3 Expanding a table into a dataframe
# Often expanding a table of explanatory variables to create
# a dataframe with repeated rows as specified by a count
count.table <- read.table("c:\\R\\Data\\RBook\\tabledata.txt", header = TRUE)

attach(count.table)

head(count.table)

# There are 12 rows of male, young and healthy participants.
# We want 12 copies of the first row for young healthy males,
# 7 copes of the second row, and so on. Use LAPPLY() (list apply)
# and use the REP()--repeat--function.
lapply(count.table, function(x) rep(x, count.table$count))

# Now convert the LIST to a DATAFRAME
dbtable <- as.data.frame(lapply(count.table, function(x) rep(x, count.table$count)))

head(dbtable)

# The redundant vector count can be cut:
dbtable <- dbtable[ , -1]

head(dbtable)

# 6.4 Converting from a dataframe to a table
# Very easy, done with the TABLE() function
table(dbtable)

# If we want this tabulated object to be a dataframe...
as.data.frame(table(dbtable))

# R added Freq as the title of the counts, which can be changed...
frame <- as.data.frame(table(dbtable))
names(frame)[4] <- "Count"
frame

# 6.5 Calculating table proportions with prop.table

# Table margins (row or column totals) are often useful for calculating proportions
# instead of counts
counts <- matrix(c(2, 2, 4, 3, 1, 4, 2, 0, 1, 5, 3, 3), nrow = 4)

counts

# Finding proportions using prop.table(counts, margin) where margin = row or column subscripts
# and 1 = rows, 2 = column
prop.table(counts, 1) # First row = .5, .25, and .25 which is the % proportion the value takes in the row

# Row 1 values are 2, 1, 1 so proportion of row total = 50%, 25%, and 25%

# What's the proportion by column?
prop.table(counts, 2)

# If you don't trust R to do math, check the proportions with col or rowSums
colSums(prop.table(counts, 2))

# Great, but what if we want the proportion of each value against the grand total?
# Easy, drop the margin number!
prop.table(counts)

# These tables are ugly; can we make them look prettier?
round(prop.table(counts, 1), 3) * 100 # Rounding to 3 prints one digit after the decimal

# 6.6 The scale function

# For some numeric matrices you might want to scale the values within a column to have a mean
# of 0 (zero) and also know the standard deviation of the values, which can be done with SCALE()

scale(counts) # This produces two ATTR statements: first, the column means then the SD

# 6.7 The expand.grid function
# Useful for creating factorial combination tables by level; suppose we have height with
# five levels between 60 and 80 in steps of 5, weight with five levels between 100 and 300
# in steps of 50, and two sexes.
expand.grid(height = seq(60, 80, 5), weight = seq(100, 300, 50), sex = c("Male", "Female"))

# 6.8 The model.matrix function
# Creating tables of dummy variables for use in statistical modeling is easy with this.
data <- read.table("c:\\R\\Data\\RBook\\parasites.txt") # No header!
names(data) <- "parasite"

attach(data)

head(data)

levels(parasite)

# We could build a dummy factor variable for each parasite when it is or isn't present,
# but that would take away from model.matrix!
model.matrix(~parasite - 1) # the -1 creates the dummy variable instead of an intercept

# I'm not sure what the value is of the information above because I can't think of a need
# to use it right now

# 6.9 Comparing table() and tabulate()
# TABLE() produces names for each element and counts only those elements that are present
# TABULATE() counts all of the integers starting at 1 and ending at the maximum while
# putting zero in the resulting vector where values are missing
table(c(2, 2, 2, 7, 7, 11)) # Shows the counts of 2s, 7s, and 11s

tabulate(c(2, 2, 2, 7, 7, 11)) # Shows the counts of 1s through 11s, including zeros


# Chapter 7 Mathematics

# 7.3.1 Normal distribution
# Suppose we measured the heights of 100 people and the mean was 170 cm with a 
# SD of 8 cm. What is the probability a selected individual will be:
# 1) shorter than a particular height?
# 2) taller than a particular height?
# 3) Between one specified height and another?
# Given the above values we measure one person at 160 cm; we need to convert
# this measurement to a standard (z-score) score
z <- (160 - 170) / 8

# What's the probability of a standard normal taking a value of less than -1.25?
pnorm(z) # Just over 10%, pushing 11% if rounded

# What about if we choose someone taller than the mean?
z <- (185 - 170) / 8

pnorm(z) # 0.9696, but that's the probability someone will be less than or equal to 185 cm

# We need the complement to this number to know the probability someone will be taller than 185 cm
1 - pnorm(z) # Much better, just more than 3%

# What if we want to know the probability of someone being between 165 cm and 180 cm?
z1 <- (165 - 170) / 8
z2 <- (180 - 170) / 8

pnorm(z2) - pnorm(z1) # About 63%

# 7.3.5 Comparing data with a normal distribution
# Can we find skew or kurtosis in our data?
par(mfrow = c(1, 1))
fishes <- read.table("C:\\R\\Data\\RBook\\fishes.txt", header = TRUE)
attach(fishes)
names(fishes)

mean(mass)

max(mass)

# Show the histogram of mass specifying integer bins 1 gram in width
# up to 16.5 grams
hist(mass, breaks = -0.5:16.5, col = "green", main = "")

# Let's add the normal density function line inside the LINES() function
lines(seq(0, 16, 0.1), length(mass) * dnorm(seq(0, 16, 0.1), mean(mass), sqrt(var(mass))))

# 7.4.8 Wilcoxon rank-sum statistic using dwilcox(q, m, n)
# Also known as Mann-Whitney, returns the values for the exact probability at discrete values of q,
# where q is a vector of quantiles, m = # of observations in sample x (not more than 50), and n
# is # of observations in sample y (also not more than 50)

# 7.5 Matrix algebra
# Let's start with a matrix a with three rows and two columns. Data is usually entered columnwise,
# so the first three numbers go in column 1
a <- matrix(c(1, 0, 4, 2, -1, 1), nrow = 3)

a

b <- matrix(c(1, -1, 2, 1, 1, 0), nrow = 2)

b

# 7.5.1 Matrix multiplication
# Let's take a look at the first rows of both a and b before we start calculations
a[1, ]

b[ , 1]

# To multiply one matrix by another take the rows of of the first matrix and columns of the second
a[1, ] * b[ , 1]


# Chapter 8 Classical Tests
# The classical tests deal with some of the most frequently used kinds of analysis for
# single-sample and two-sample problems.
# 
# 8.1 Single samples
# What is we want to answer the following questions?
# 1) What is the mean value for this single sample?
# 2) Is the mean value significantly different from current expectation or theory?
# 3) What is the level of uncertainty associated with our estimate of the mean value?
# 
# First we need to establish some facts about the distribution of the data:
# 1) Are values normally distributed or not?
# 2) Are there outliers?
# 3) If data was collected over time, is there evidence of serial correlation?

# 8.1.1 Data summary
data <- read.table("c:\\r\\data\\rbook\\classic.txt", header = TRUE)

names(data)

attach(data)

# We begin with a single sample of plots: an index plot (scatterplot with a single
# argument where data is plotted in the order in which they appear in the dataframe),
# a box-and-whisker plot and a frequency plot (histogram with bins selected by R)

# Set some PARameters first
par(mfrow = c(2, 2)) # MFROW presents the following four plots in 2 rows x 2 cols

plot(y) # Index plot of single argument
boxplot(y) # Box and whisker plot
hist(y, main = "") # Histogram frequency plot

y2 <- y
y2[52] <- 21.75 # Put in a goofy value for visualization's sake
plot(y2) # 4th plot including bizarre plot

# Summarizing the data? Couldn't be simpler
summary(y)

# Can also summarize with Tukey's five-number summary: min,
# lower hinge (similar to Q1), median, upper hinge (similar to Q3),
# and maximum. Hinges are different with small sample
fivenum(y)

# 8.1.2 Plots for testing normality
# The simplest (and many ways the best) plot for normality is the quantile-quantile plot.
# This plots the ranked samples from the distribution aginst a similar number of ranked quantiles
# taken from a normal distribution. If the sample is normal the line will be straight, whereas
# non-normal data will be shown with S-shapes or banana shapes. Use QQNORM and QQLINE.
par(mfrow = c(1,1)) # Fill the display with a 1x1 plot, otherwise the earlier 2x2 parameter will be used

qqnorm(y)
qqline(y, lty = 2)

# 8.1.3 Testing for normality
# The SHAPIRO.TEST() returns whether the data in a vector comes from a normal distribution; the
# null hypothesis is that the sample data ARE normally distributed
x <- exp(rnorm(30))
shapiro.test(x) # If W = 0.9256 and p-value = 0.03756, we reject the null hypothesis

# p-values are interesting but don't tell the whole story; effect sizes and sample sizes are
# equally important in drawing conclusions

# 8.1.4 An example of single-sample data
# Let's look at Michelson's famous 1879 experiment in measuring the speed of light
light <- read.table("c:\\r\\data\\rbook\\light.txt", header = TRUE)

attach(light)

hist(speed, main = "", col = "green")

summary(speed)

# Median is much bigger (940) than mean (909), a consequence of the strong negative skew
# of the plot. The IQR = Q3 - Q1 (980 - 850 = 130); a good rule of thumb is outliers are
# 1.5x the IQR above Q3 and below Q1 (980 + 195 and 850 - 195, or 1175 and 655 respectively).
# In this case there are very few outliers, but they're all below the Q1 value.

# We want to test Michelson's estimate of the speed of light is significantly different than
# the value of 299,990 thought to prevail at the time. The data has had 299,990 subtracted
# from them, so the test value is 990. Because the data is non-normal the Student's t-test is
# not advised, but Wilcoxon's signed-rank test will work.
wilcox.test(speed, mu = 990) # Reject the null hypothesis; the speed of light is significantly less than 299,990

8.2 Bootstrapping in hypothesis testing
# Bootstrapping is exactly what it sounds like: making something from nothing.
# You have a single sample of n measurements, but you can sample from this in a wide
# variety of ways, so long as you allow some values to appear more than once, and
# other samples to be left out (sampling with replacement). All you do is calculate
# the sample mean lots of times, once for each sampling from the data and then build
# a confidence interval by looking at extreme highs and lows of the estimated means
# using a quantile function to extract the interval you want.
# 
# Let's look at the mean value from above, 909. How likely is it that the population
# mean we are trying to estimate with our random sample of 100 values is as big as 990?
# We take 10,000 random samples with replacement using n = 100 from the 100 values 
# of light and calculate 10,000 values of the mean. What is the probability of getting
# a mean as large as 990 by inspecting the right-hand tail of the cumulative probability
# distribution of our 10,000 bootstrapped mean values?

# First set up a 10000 length vector
a <- numeric(10000)

# For each empty value in the a vector, put a mean of a sample of the speed data from above with replacement allowed
for(i in 1:10000) a[i] <- mean(sample(speed, replace = TRUE))

# Plot the results of vector a
hist(a, main = "", col = "blue")

# What's the max mean value in a of the 10,000 generated?
max(a) # 981.5

# Because the test value of 990 is way off to the right in this histogram, the probability of returning a
# mean of 990 is extremely low. In the 10,000 sample means in a, not once did a mean of 990 come back, 
# so the probability of a mean of 990 is clearly p < 0.0001 (1 in 10,000).

# 8.3 Skew and kurtosis
# Has to do with moments: the first moment is the aritmetic mean of a sample (sum of y / number of items).
# The 2nd moment includes the sum of squares (sum of (y - avg y) squared) to calculate sample variance
# s2 = (sum of (y - avg y) squared) / (n - 1).
# 
# 8.3.1 Skew
# Skew measures the extent to which a distribution has long, drawn-out tails on one side or the other.
# Normal distributions have symmetrical tails
windows(7, 4) # Create an output window 7 inches by 4 inches
par(mfrow = c(1, 2))

x <- seq(0, 4, 0.01) # Create a sequence of numbers starting at 0 going up by .01 to 4
plot(x, dgamma(x, 2, 2), type = "l", ylab = "f(x)", xlab = "x", col = "red")
text(2.7, 0.5, "Positive Skew")

plot(4 - x, dgamma(x, 2, 2), type = "l", ylab= "f(x)", xlab = "x", col = "red")
text(1.3, 0.5, "Negative Skew")

# Let's write a SKEW() function
skew <- function(x) {
  m3 <- sum((x - mean(x)) ^ 3) / length(x)
  s3 <- sqrt(var(x)) ^ 3
  m3 / s3
}

# Let's test our skew function
data <- read.table("c:\\r\\data\\rbook\\skewdata.txt", header = TRUE)

attach(data)

names(data) # "values"

hist(values) # Positive (right)-skewed with longer tail to the right

# How skewed?
skew(values) # 1.318905

# Is this skew significant? Do a t-test by dividing observed skew by
# its standard error
skew(values) / sqrt(6 / length(values)) # 2.949161

# What's the probability of getting this value by chance alone when
# the skew value is really zero?
1 - pt(2.949, 28) # 0.0032 = Complement of the p-value with 28 degrees of freedom (n - 2)

# Value of 0.0032 shows significant non-normality of the data
# How can we transform the data to normalize it for testing?
# Try taking the square root
skew(sqrt(values)) / sqrt(6 / length(values)) # 1.474851

# Is that value significant?
1 - pt(1.475, 28) # 0.7568 which is non-significant

# There are other ways to "normalize" values; maybe log?
skew(log(values)) / sqrt(6 / length(values)) # -0.66

1 - pt(-0.66, 29) # 0.742769 which is even less significant; maybe log values are best going forward

# 8.3.2 Kurtosis
# This measures "peakyness", or flat-toppedness, of a distribution. Kurtotic distributions are not
# bell-shaped; flat are platykurtic and pointy distributions are leptokurtic. Kurtosis is not a
# built-in function, either

kurtosis <- function(x) {
  m4 <- sum((x - mean(x)) ^ 4) / length(x)
  s4 <- var(x) ^ 2
  m4 / s4 - 3
}

# Let's look at the VALUES data again from a kurtosis perspective:
kurtosis(values) # 1.297751; is this significantly different from zero?

kurtosis(values) / sqrt(24 / length(values)) # 1.45093

1 - pt(1.45093, 28) # 0.07895566 The original values are NOT significantly different than zero

# But what if we take the log values again?
kurtosis(log(values)) # 0.7176515; is this significantly different from zero?

kurtosis(log(values)) / sqrt(24 / length(values)) # 0.8023588

1 - pt(0.8023588, 28) # 0.2145517 The log values are NOT significantly different than zero

# Can we build a function that includes skew and kurtosis?
# Why not call it skewtosis?
# FIX SWITCH based on what form of data is passed in

skewtosis <- function(stuff, transform) {
  # Subtract 2 from length to account for degrees of freedom
  df <- length(stuff) - 2
  
  # SWITCH on the TRANSFORM value
  switch(transform,
                 mean = mean(stuff),
                 sqrt = mean(sqrt(stuff)),
                 log = mean(log(stuff)),
                 stop("Transform value not valid: 1 = MEAN, 2 = SQRT of, 3 = LOG of"))
  cat("Transform value =", transform, "\n")
  
  # Calculate skew first
  m3 <- sum((stuff - mean(stuff)) ^ 3) / length(stuff)
  s3 <- sqrt(var(stuff)) ^ 3
  skew <- m3 / s3 # Actual skew value
  
  # What's the standard error of the skew?
  s.se <- skew / sqrt(6 / length(stuff))
  
  # Is the standard error significant?
  s.se.sig <- 1 - pt(s.se, df)
  
  # Calculate kurtosis
  m4 <- sum((stuff - mean(stuff)) ^ 4) / length(stuff)
  s4 <- var(stuff) ^ 2
  kurt <- m4 / s4 - 3 # Actual kurtosis
  
  # What's the standard error of the kurtosis?
  k.se <- kurt / sqrt(24 / length(stuff))
  
  # Is the standard error significant?
  k.se.sig <- 1 - pt(k.se, df)
  
  
  return(c(ifelse(s.se.sig < 0.05, "Non-normal skew", "Normal"), ifelse(k.se.sig < 0.05, "Non-normal Kurtosis", "Normal")))
}

skewtosis(values, "mean")

skewtosis(fishes$mass) # Skew and kurtosis indicate non-normal data values
skewtosis(log(fishes$mass)) # Log-ging data makes skew and kurtosis values not different enough from zero
skewtosis(sqrt(fishes$mass)) # SQRT keeps non-normal skew but kurtosis normal

hist(fishes$mass)
hist(log(fishes$mass))
hist(sqrt(fishes$mass))

# 8.4 Two samples
# Classical two sample tests include:
#   Comparing two variances with Fisher's F test, var.test
#   Comparing two sample means with normal errors with Student's t test, t.test
#   Comparing two means with non-normal errors with Wilcoxon's rank test, Wilcoxon's rank test, wilcox.test
#   Comparing two proportions with binomial test, prop.test
#   Correlating two variables with Pearson's or Spearman's rank correlation, cor.test
#   Test for independence of two variables in a contingency table with chi-squared, chisq.test, or Fisher's
#     exact fisher.test
# 
# 8.4.1 Comparing two variances
# Before we test against two sample means we need to test whether the sample variances are different.
# This is easy, as we simply divide the larger variance by the smaller variance (Fisher's F), and if they
# are 1, they're equivalent, of course. After dividing them we consider the ratio between them, which
# is Fisher's F. The R function for this is QF(), or "quantiles of the F distribution".

# In this example we're looking at two gardens with 10 replicates in each, so there are 9 degrees of freedom.
# Usually Fisher's F test is one-tailed since we're always testing for one value being larger than the other
# but in this case it's a two-tailed test because we're only testing for difference, not one way.
qf(0.975, 9, 9) #4.026 = the critical statistic

# A calculated variance ratio needs to be greater than 4.026 to conclude the two variances are significantly different
# Let's look at the variances in ozone concentration for market gardens B and C
f.test.data <- read.table("c:\\R\\Data\\RBook\\f.test.data.txt", header = TRUE)

attach(f.test.data)
names(f.test.data)

# First compute two variances
var(gardenB)
var(gardenC)

# We have two variances, but what's their ratio?
F.ratio <- var(gardenC) / var(gardenB)
F.ratio # 10.67 = the test statistic, significantly higher than the critical statistic, so we reject the null hypothesis
# that the two variances were not significantly different
# It's better to present the p-value, so use PF() and double the result to show a two-tailed test
2 * (1 - pf(F.ratio, 9, 9)) # p = .0016 (< .002) Because variances are different, a Student's t-test would be wrong

# The function VAR.TEST() speeds this up
var.test(gardenB, gardenC) # Same result of p < .002, but var ratio = 0.09375 b/c put smaller variance first

# NOTE: This test is HIGHLY subject to OUTLIERS; use with care

# Consistency of variance is very important (most important) to underlying regression and analysis of variance.
# For comparing two samples Fisher's F test is fine; for multiple samples use Bartlett and Fligner-Killeen.
refs <- read.table("c:\\R\\Data\\RBook\\refuge.txt", header = TRUE)
attach(refs)
names(refs) # "B", "T"
str(refs)

# Because T is an ordered factor, we have to use TAPPLY()
tapply(B, T, var) # 9 variances, but #9 is NA because there have to be at least 2 replicates at each level

# Can we figure out which data item is with factor 9?
which(T == 9) # Item 31, where the value is actually 0

# There are 8 variances to compare, so let's cut item 31 and go with Bartlett
bartlett.test(B[-31], T[-31]) # No significant difference between the 8 variances; p > .05 (.067)

# What does Fligne say?
fligner.test(B[-31], T[-31]) # Oops, Fligner says there are significant differences, p < .05 (.045)

# Next steps might be to plot the variables for a visual inspection
plot(T, B) # Appear to be well-behaved

# Build a linear model from them
model <- lm(B ~ T)

plot(model)

detach(refs)

# These two tests can give wildly different interpretations; sometimes go with the gut feeling

# Here are ozone data from three market gardens
ozone <- read.table("c:\\R\\Data\\RBook\\gardens.txt", header = TRUE)
attach(ozone)
names(ozone) # "gardenA", "gardenB", "gardenC"
str(ozone)

y <- c(gardenA, gardenB, gardenC)
garden <- factor(rep(c("A", "B", "C"), c(10, 10, 10)))

# Does ozone concentration differ from garden to garden?
# Fishers F to compare B and C; sensitive to outliers!
var.test(gardenB, gardenC)

# Bartlett's says there's a difference between the three too
bartlett.test(y ~ garden) # p < .001; sensitive to outliers!

# Fligner-Killeen?
fligner.test(y ~ garden) # p > .05 (0.4053); non-parametric using ranks and weights; preferred!

# Be careful to abandon Fisher or Bartlett due to outliers, though; in this case gardens B and C
# both had a mean of 5 parts per million (pphm), well below the damage threshold of 8, but garden
# B never suffered damaging levels of ozon whereas garden C did on 30% of days. This difference is
# scientifically important and deserves to be significant.

# 8.4.2 Comparing two means
# Given what we know about the variatio from replicate to replicate within each sample (the within-sample variance),
# how likely is it that our two sample means were drawn from populations with the same average? We can calculate
# the probability that the two samples were drawn from populations with the same mean. This can never be 100%
# certain as the apparent difference might just be due to random sampling where one sample had inordinately low
# values while the other had high ones.
# 
# The two classic tests:
#   Student's t-test when samples are independent, variances constant, and errors normally distributed
#   Wilcoxon's rank-sum test when samples independent but errors NOT normally distributed; ranks or scores of some sort

# 8.4.3 Student's t-test
# The value is calculated by subtracting the two sample means and dividing by the standard error of the difference, which
# is the square root of the combined variance of the two samples.
# 
# Using the garden data again; we can first determine the critical value of the t-test with QT() with 18 DF (20 - 2)
qt(0.975, 18) # 2.10; the test value must be larger than this to reject the null hypothesis

t.test.data <- read.table("c:\\R\\Data\\RBook\\t.test.data.txt", header = TRUE)
attach(t.test.data)
names(t.test.data) # gardenA, gardenB
str(t.test.data)

par(mfrow = c(1, 1))

# Combine the data into a single vector
ozone <- c(gardenA, gardenB)

label <- factor(c(rep("A", 10), rep("B", 10))) # Add lettered A & B factors

# Visualize differences looking for notches to overlap; they don't so the medians
# are significantly different at the 5% level, but the variability is similar,
# as the ranges (whiskers) and IQR (boxes)
boxplot(ozone ~ label, notch = TRUE, xlab = "Garden", ylab = "Ozone")

# T.TEST() helpfully gives us our calculations
t.test(gardenA, gardenB) # Uses Welch by default assuming differences in variances

# The mean ozone concentration is significantly higher in GardenB than GardenA

# 8.4.4 Wilcoxon rank-sum test
# The non-parametric alternative to the Student's t-test if data isn't normal.
# The test ranks the values in order, sums the two sample ranks, and compares
# the smaller total rank to a value that signifies the .05 alpha; if the value
# is lower the difference is significant.
wilcox.test(gardenA, gardenB) # p < .05 (0.002988), so significant difference in ozone between A and B

# Wilcoxon considered more conservative and definitely necessary if data isn't normal,
# especially in the presence of data outliers; if a difference is significant in Wilcoxon
# then it's most certainly even more significant in a t-test

# 8.5 Tests on paired samples
# 
# Two-sample data can come from paired observations.
# 
# In this example, data was taken from the same river, one set upstream and the other downstream.
streams <- read.table("c:\\R\\Data\\RBook\\streams.txt", header = TRUE)
attach(streams) # "down", "up"
str(streams)
names(streams)

# If we ran the t.test() without pairing the "independent" samples would have no impact
# on their biodiversity score
t.test(down, up) # p-value = 0.6856

# The elements are paired, though, because they come from the same river, one upstream
# while the other is downstream from the same sewage outfall. When we pair the samples,
# the results are completely different:
t.test(down, up, paired = TRUE) # p < .05 (0.0081)

# The same test can be done on the difference between the scores as a single-sample
# t-test
difference <- up - down
t.test(difference)

# 8.6 The sign test
# What if differences can't be measured, but seen? For example, 9 springboard divers
# were scored as better or worse having trained under a new regime and under the more
# conventional original regime randomly (new then traditional, traditional then new).
# Divers were judged twice: one diver was worse in the new regime training and 8 were
# better. What is the evidence that the new regime produces significantly better scores
# in competition? We use a binomial test for this.
binom.test(1, 9)

# 8.7 Binomial test to compare two proportions
# What if only 4 women were promoted versus 196 men? Is this blatant sexism? We need to know
# the sizes of the populations, in this case 40 women and 3270 male candidates. Is the 10%
# versus 6% promotion ratio positive discrimination signficant or a difference that could
# have arisen by chance?
prop.test(c(4, 196), c(40, 3270)) # p > .05 (0.4696), no evidence of positive discrimination
# and this would occur by chance 45+% of the time. If just one woman had not been in the
# population, the rate of 3 / 39 would have dropped the ratio to 7.7% instead of 10%, making
# small sample change have big effects.

# 8.8 Chi-squared contingency tables
# In statistics contingencies are all the events that could possibly happen; a contingency
# table shows the count of how many times each of the contingencies actually happened in a
# particular sample, such as hair and eye color in white people. The significance of observed
# versus expected frequencies can be measured in a number of ways:
#   Pearson's chi-squared
#   G test
#   Fisher's exact test
# 8.8.1 Pearson's chi-squared
# Critical values are calculated with QCHISQ(certainty, df)--quantiles of the approximate distribution
# using the CERTAINTY level (0.95) and the degrees of freedom
qchisq(0.95, 1) # 3.841 is the critical value; the test stat must be greater than this to be significant

# Testing hair and eye color is easy by building a matrix
count <- matrix(c(38, 14, 11, 51), nrow = 2) # Data is entered columnwise, not row-wise
count

# CHISQ.TEST() to test the observed versus expected results
chisq.test(count) # Result includes Yates' correction; correction can be turned off, correct = FALSE

# To extract the expected frequencies under the null hypothesis...
chisq.test(count, correct = FALSE)$expected

# 8.8.4 Chi-squared tests on table objects
# Testing the random number generator as a simulator of the throws of a six-sided die 100 times
die <- ceiling(runif(100, 0, 6))
table(die)

chisq.test(table(die)) # Is the distribution fair? Yes, as p = 0.4159; this distribution would occur by luck almost 42% of the time

# 8.8.5 Contingency tables with small expected frequencies: Fisher's exact test
# Don't use Pearson's or G (log-linear) tests when expected frequencies are less than 5 (or 4).
x <- as.matrix(c(6, 4, 2, 8))

dim(x) <- c(2, 2)

x

fisher.test(x)

# Can also provide two vectors containing factor levels instead of two-dimensional matrix of counts
# so you don't have to count combinations of each factor level
table <- read.table("c:\\R\\Data\\RBook\\fisher.txt", header = TRUE)
head(table)
attach(table)
fisher.test(tree, nests)

# Fisher's test can be used with matrices much larger than 2 x 2

# 8.9 Correlation and covariance
# With two continuous variables x and y, the question arises whether their values are correlated
# with each other. Correlation is defined in terms of the variance of x, variance of y, and covariance
# of x and y (the way the two vary together, how they covary) on the assumption that both are normally
# distributed.
rm(data)
data1 <- read.table("c:\\R\\Data\\RBook\\twosample.txt", header = TRUE)
attach(data1)
plot(x, y, pch = 21, col = "red", bg = "orange")

# Clearly strong correlation between x and y; what are the variances?
var(x)
var(y)
# Covariance is calculated when x and y are put in the same VAR() function
var(x, y)

# Correlation is the COR() function
# Correlation = covariance(x, y) / sqrt of var(x) * var(y)
cor(x, y)

# 8.9.1 Data dredging
# COR() returns the correlation matrix of a data matrix, or a single value showing the correlation
# between one vector and another (as above)
# Data dredging refers to producing a correlation table like the one below and hunting for high
# correlation values in search of something to publish
pollute <- read.table("c:\\R\\Data\\RBook\\Pollute.txt", header = TRUE)
attach(pollute)
cor(pollute) # Produces a full table or correlations

cor(Pollution, Wet.days) # Correlation only between these two variables

# 8.9.2 Partial correlation
# With more than 2 variables, you often want to know the correlation between x and y when a 3rd variable,
# say z, is held constant. The partial correlation coefficient measures this, which is necessary
# to do path analysis. R has a package called SEM for structural equation modeling and another called
# CORPCOR for converting correlations into partial correlations.

# 8.9.3 Correlation and the variance of differences between variables
# Looking back at the upstream and downstream biodiversity data from before, and looking at samples
# exhibiting positive correlations resulting from pairing. Look at the depth of the water in winter
# and summer at 10 locations
wtable <- read.table("c:\\R\\Data\\RBook\\wtable.txt", header = TRUE) # File doesn't exist
attach(wtable)
str(wtable)
names(wtable)

# Is there a correlation between summer and winter water depth?
cor(summer, winter) # Pretty high at 0.66, which is marginally significant, tested with...

cor.test(summer, winter) # p-value = 0.03795

# 8.9.4 Scale-dependent correlations
# Scatterplots can give a highly misleading impression of what's going on.
productivity <- read.table("c:\\R\\Data\\RBook\\productivity.txt", header = TRUE)
attach(productivity)
head(productivity)
str(productivity)

# Let's plot the x and y variables to visualize their relationship
plot(productivity$x, productivity$y, pch = 21, col = "blue", bg = "green", xlab = "Productivity", ylab = "Mammal species")

# Indicates a STRONG POSITIVE correlation
cor.test(productivity$x, productivity$y)

# Note that when the productivity is broken out by REGION (f) each of the panels
# from left to right, bottom to top, shows a NEGATIVE correlation
coplot(productivity$y ~ productivity$x | productivity$f, panel = panel.smooth)

# 8.10 Kolmogorov-Smirnov test
# Are two sample distributions the same or are they significantly different from one another
# in one or more (unspecified) ways? USED MOST OFTEN
# Does a particular sample distribution arise from a particular hypothesized distribution?
# K-S works on cumulative distribution functions to give the probability that a randomly selected
# value of X is less than or equal to x. Suppose we had insect wing sizes (y) for two geographically
# separated populations (A and B) and wanted to test whether the distribution of wing lengths was
# the same in two places.
ksdata <- read.table("c:\\R\\Data\\RBook\\ksdata.txt", header = TRUE) # Not in the RBook directory, again
attach(ksdata)
names(ksdata)

# 8.11 Poweranalysis p.404
# 
# 8.12 Bootstrap p.407
# We want to use bootstrapping to reach a 95% confidence interval for the mean of a vector

skewdata <- read.table("c:\\R\\Data\\RBook\\skewdata.txt", header = TRUE)
attach(skewdata)
str(skewdata) # "values" with nums
names(skewdata) # "values"

# We'll sample with replacement 10,000 and store the means
ms <- numeric(10000)
for(i in 1:10000) {
  ms[i] <- mean(sample(values, replace = TRUE))
}

# What are the extreme values of the means in a two-tailed distribution?
quantile(ms, c(0.025, 0.975))

# So the intervals below and above the mean are...
mean(values) - quantile(ms, c(0.025, 0.975)) # 6.02 and -6.99

# How does this compare to the parametric confidence interval?
1.96 * sqrt(var(values) / length(values)) # 6.57; close but slightly skewed

# Instead of manually creating bootstrapped values, we can use BOOT(data, statistic, R)
# where R = number of resamplings, data = name of data object, and statistic = an
# index (vector of subscripts) to select random assortments of values.
library(boot)
mymean <- function(values, i) mean(values[i]) # 2nd argument of BOOT()

myboot <- boot(values, mymean, R = 10000)
myboot

# Chapter 9 Statistical Modeling p.410
# Hardest part is getting started. One of the hardest things to do is determine the right kind of statistical analysis.
# The choice depends on the nature of your data and the particular question you are trying to answer. The key is to
# understand what kind of response variable you have, and to know the nature of your explanatory variables. The response
# variable is the one you're working on, the variable whose variation you're trying to understand, and goes on the y-axis
# of the graph. The explanatory variable(s) are on the x-axis and explain the extent to which variation in the response
# variable is associated with variation in the explanatory variable. Also consider the way the variables in the analysis
# measure what they purport to measure. Understand the impact of continuous (weight, height) versus categorical (gender,
# party affiliation). Which is the response variable? Which are explanatory? What are the explanatory variable types?
# What type is the response variable?
# 
# The object is to determine the values of the parameters in a specific model that lead to the best fit of the model
# to the data. The model is fitted to the data, not the other way around. The goal is a minimal model that is adequate
# because there is no point in retaining an inadequate model that doesn't describe a signficant fraction of the variation
# in the data. In most circumstances there will be a large number of different, more or less plausible models that might 
# be fitted to any given set of data.
# 
# 9.1 First things first p.411
# Most common mistake is to begin modeling immediately. The best thing is to spend a lot of time getting to know your
# data and what they show. This helps guide thinking as to exactly what kind of statistical modeling is most appropriate.
# 
# Some repeatable steps:
# 
# 1) Make the sure the data (dataframe) is correct in structure and content
#   a) Do all values of each variable appear in the same column?
#   b) All are zeros really 0 or should they be NA?
#   c) Does every row contain the same number of entries?
#   d) Are there any variables with blank spaces in them?
# 2) Read the data into R (use read.csv if factor levels or place names contain blank spaces)
# 3) Check the head() and tail() for obvious errors
# 4) Plot EVERY variable on its own to check for gross errors(plot(x), plot(y), etc.
# 5) Look at relationships between variables with tapply(), plot(), tree(), and gam()
# 6) Think about model choice: which explanatory variables should be used? What transformation of the response is most
#   appropriate? Which interactions should be included? Which non-linear terms should be included? Is there pseudoreplication,
#   and if so how to deal with it? Should explanatory variables be transformed?
# 7) Try to use the simplest analysis appropriate to the data and the question you're trying to answer
# 8) Fit a maximal model for constancy of of variance and normality of errors using plot(model) (p.405)
# 9) Emphasize effect sizes and standard errors (summary.lm) and play down analysis of deviance table (summary.aov) (p.382)
# 10) Document carefully

# The best model is one of maximum likelihood. Given the data, and given our choice of model, what values of the parameter of that
# model make the observed data most likely? The correct explanation is the simplest explanation (Occam's Razor). In explaining something,
# don't needlessly multiply assumptions. Things not known to exist should not unless absolutely necessary. Models should have as few
# parameters as possible, linear models are preferred over non-linear, experiments relying on few assumptions are preferred
# to those relying on many, models should be pared down until they are minimally adequate, and simple explanations should be preferred
# over complex explanations.
                                                                                               
# Start again on p.413 of the PDF




# For fun: Trying to read XML files
install.packages("XML")
library(XML)

fileloc <- "c:\\r\\data\\ftsi14500.xml"

doc <- xmlRoot(xmlTreeParse(fileloc))

tmp <- xmlSApply(doc, function(x) xmlSApply(x, xmlValue))

ds <- t(tmp)





































