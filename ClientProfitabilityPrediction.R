# Using kNN to predict profitable clients
# If we know which clients are profitable, can we use data to determine
# which will be profitable? What data makes the model most valuable?

# Need to use the package class for the kNN algorithm
install.package("class")
install.package("gmodels")
library("class")
library("gmodels")


# Segregate profitable from unprofitable clients and determine which are
# highly versus less profitable clients and vice versa for unprofitable
# clients

# Segregate profitable clients as Low when profitability is 0-18%, High if above 18%
# and unprofitable clients as Low when unprofitability is <0-38%, High if below -38%

# First, import the data
# R imported the CSV fine except some numeric columns came in as CHARACTER
# Went back into Excel multiple times cleaning up the data:
# 1) Replacing blanks (NAs) with 0 for missing features
# 2) Replacing dashes (NAs) with 0 for Excel zeroes
# 3) Updating General columns as Numbers

# Make a dialog box to find CSV?
# Don't let R default to strings being factors; this makes later work
# more difficult. If factors are needed, create them later
clients <- read.csv("c:\\R\\Data\\ProfClients2012.csv", stringsAsFactors = FALSE)

# STR() shows the structure of the data--class, variables and types, and examples
# Need to standardize the big numeric data; initially the emp nbrs,
# balance info, contribution totals, expenses and gross margin
str(clients)

# Add Profitable dummy variable to base data before removing for testing
# This code uses vector looping to check each line's Gross Profit Margin
# against > 0 and adds a LOGICAL T/F to a new variable, profitable, with
# the data set
clients$profitable <- clients$Gross_Margin_Pct_2012 > 0

# How many are profitable?
table(clients$profitable)

# Now the prop.table will give us percentages
round(prop.table(table(clients$profitable)) * 100, digits = 1) # 48% profitable, 52% unprofitable


# Nuke the ClientNm, Direct Expense 2012, Gross Margin 2012 Pct and Gross Margin$ columns
# Leaving the Direct Expense column, though
clients <- clients[c(-1, -9, -10, -11)]

# Standardize by minmax on all columns EXCEPT profitable
# NORMALIZE is a function I wrote to run the minmax standardization,
# found in the Machine Learning.R file
# Here's what's happening:
# 1) Coerce the clients data using lapply (runs functions that don't accept list input)
# 2) Run the normalize function on the clients columns except profitable
# 3) As a data frame, not a list so the results can be stored in clients_minmax
clients_minmax <- as.data.frame(lapply(clients[1:ncol(clients - 1)], normalize))

# Could loop through this 10, 100, 1000 times to test reliability of test
# Select random groups of clients for train and test using SAMPLE()
# against the number of rows in the minmax data set
# NOTE: R has yet to duplicate rows in both data sets
# clients_train <- clients_minmax[sample(nrow(clients_minmax), 139), ]
# clients_test <- clients_minmax[sample(nrow(clients_minmax), 50), ]

# Generating our TRAIN and TEST data sets using a slightly different
# algorithm, by setting a seed and randomizing the order or the original
# data
set.seed(12345) # other seeds(12345, 23456, 34567)
clients_random <- clients_minmax[order(runif(nrow(clients_minmax))), ]

trainct <- round(nrow(clients_random) * .7)
testct <- trainct + 1

clients_train <- clients_random[1:trainct, ]
clients_test <- clients_random[testct:nrow(clients_random), ]


# Remember that the profitability was excluded from the 
# normalized data sets. So, get the probability features from
# the original data sets...
# For training we need the class labels in factor vectors
# for both data sets
# This could be confusing, so let me explain:
# 1) Pull all of the rows (using a sequence 1:# of rows) from the last column in the data
#    NOTE: ncol() returns the number of columns, not a sequence, so R is using the value
# 2) Store this returned vector in the train and test_labels objects

clients_train_labels <- clients_train[1:nrow(clients_train), ncol(clients_train)]
clients_test_labels <- clients_test[1:nrow(clients_test), ncol(clients_test)]



# Use the knn() function from the class package
# Other versions of knn exist in other packages and
# can be investigated from the CRAN site
# For knn() k is a user-specified number
# Training data has 139 rows, which is approximately
# 12 squared, so let's try k = 12
# or use the included calculation
clients_test_pred <- knn(train = clients_train, test = clients_test, cl = clients_train_labels, k = round(sqrt(nrow(clients_train))))

# Evaluate how well the predicted classes in the _pred
# vector match up with the test_labels vector using
# the CrossTable() function without chi-square testing
CrossTable(x = clients_test_labels, y = clients_test_pred, prop.chisq = FALSE)

# TEST RESULTS (8/1/14: Through 20 runs, 1 of 1000 has been incorrect)
# Run 1: 21 unprofitable, 29 profitable; algorithm 100% correct
# Run 2: 30 unprofitable, 20 profitable; algorithm 98% correct, 1 false unprofitable (actually profitable)
# Run 3: 25 unprofitable, 25 profitable; algorithm 100% correct
# Run 4: 28 unprofitable, 22 profitable; algorithm 100% correct
# Run 5: 26 unprofitable, 24 profitable; algorithm 100% correct
# Run 6: 24 unprofitable, 26 profitable; algorithm 100% correct
# Run 7: 29 unprofitable, 21 profitable; algorithm 100% correct
# Run 8: 23 unprofitable, 27 profitable; algorithm 100% correct
# Run 9: 21 unprofitable, 29 profitable; algorithm 100% correct
# Run 10: 26 unprofitable, 24 profitable; algorithm 100% correct
# Run 11: 23 unprofitable, 27 profitable; algorithm 100% correct
# Run 12: 25 unprofitable, 25 profitable; algorithm 100% correct
# Run 13: 22 unprofitable, 28 profitable; algorithm 100% correct
# Run 14: 24 unprofitable, 26 profitable; algorithm 100% correct
# Run 15: 33 unprofitable, 17 profitable; algorithm 100% correct
# Run 16: 27 unprofitable, 23 profitable; algorithm 100% correct
# Run 17: 26 unprofitable, 24 profitable; algorithm 100% correct
# Run 18: 27 unprofitable, 23 profitable; algorithm 100% correct
# Run 19: 26 unprofitable, 24 profitable; algorithm 100% correct
# Run 20: 31 unprofitable, 19 profitable; algorithm 100% correct
# Run 21: 26 unprofitable, 24 profitable; algorithm 100% correct
# Run 22: 23 unprofitable, 27 profitable; algorithm 100% correct
# Run 23: 15 unprofitable, 23 profitable; algorithm 100% correct

# Predict level of profit-/unprofitability
# Segregate the unprofitable and profitable clients based on Gross Margin
clients <- read.csv("c:\\R\\Data\\ProfClients2012.csv", stringsAsFactors = FALSE)

# clients$profitable <- clients$Gross_Margin_Pct_2012 > 0

unprofitables <- clients[clients$Gross_Margin_2012 <= 0, ]

profitables <- clients[clients$Gross_Margin_2012 > 0, ]

##### Begin UNPROFITABLE analysis

# Add an UNPROFITABILITY classifier to the unprofitable data
# In 2012 data 47 of 95 have a margin < median of -35%
unprofitables$belowmargin <- unprofitables$Gross_Margin_Pct_2012 < median(unprofitables$Gross_Margin_Pct_2012)

# Nuke the ClientNm, Direct Expense 2012 Gross Margin 2012 Pct, Gross Margin$ columns
unprofitables <- unprofitables[c(-1, -9, -10, -11)]

# Standardize by minmax on all columns EXCEPT profitable
unprofitables_minmax <- as.data.frame(lapply(unprofitables[1:ncol(unprofitables)], normalize))

unprofitables_minmax$belowmargin <- factor(unprofitables_minmax$belowmargin, levels = c(0, 1), labels = c("Below median", "Above median"))

# Could loop through this 10, 100, 1000 times to test reliability of test
# Select random groups of clients for train and test using SAMPLE()
# against the number of rows in the minmax data set
# NOTE: R has yet to duplicate rows in both data sets
# unprofitables_train <- unprofitables_minmax[sample(nrow(unprofitables_minmax), nrow(unprofitables_minmax) * .8), ]
# unprofitables_test <- unprofitables_minmax[sample(nrow(unprofitables_minmax), nrow(unprofitables_minmax) * .2), ]

# Generating our TRAIN and TEST data sets using a slightly different
# algorithm, by setting a seed and randomizing the order or the original
# data
set.seed(23456) # other seeds(12345, 23456, 34567)
unprofitables_random <- unprofitables_minmax[order(runif(nrow(unprofitables_minmax))), ]

trainct <- nrow(unprofitables_random) * .8
testct <- trainct + 1

unprofitables_train <- unprofitables_random[1:trainct, ]
unprofitables_test <- unprofitables_random[testct:nrow(unprofitables_random), ]

# Remember that the profitability was excluded from the 
# normalized data sets. So, get the probability features from
# the original data sets...
unprofitables_train_labels <- unprofitables_train[1:nrow(unprofitables_train), ncol(unprofitables_train)]
unprofitables_test_labels <- unprofitables_test[1:nrow(unprofitables_test), ncol(unprofitables_test)]

# Need to use the package class for the kNN algorithm
# install.package("class")
# library("class")

# Use the knn() function from the class package
# Other versions of knn exist in other packages and
# can be investigated from the CRAN site
# Initial k = round(sqrt(of rows)) = 9, which resulting in 63% accuracy
# unprofitables_test_pred <- knn(train = unprofitables_train, test = unprofitables_test, cl = unprofitables_train_labels, k = 8)
# unprofitables_test_pred <- knn(train = unprofitables_train, test = unprofitables_test, cl = unprofitables_train_labels, k = round(sqrt(nrow(unprofitables_train))))
unprofitables_test_pred <- knn(train = unprofitables_train, test = unprofitables_test, cl = unprofitables_train_labels, k = 12)

# Evaluate how well the predicted classes in the _pred
# vector match up with the test_labels vector using
# the CrossTable() function without chi-square testing
CrossTable(x = unprofitables_test_labels, y = unprofitables_test_pred, prop.chisq = FALSE)

##### End UNPROFITABLE analysis
















