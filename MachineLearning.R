# Machine Learning with R
# eBook from Amazon
# Exploring and Understanding Data
# Using the usercars.csv file
# Thought I could c(getwd(),<rest of address>), but didn't work
# Don't let R believe repetitive strings are FACTORS
usedcars <- read.csv("H:\\Stuff\\R\\r-tutorial-src\\Machine_Learning_with_R\\2148OS_code\\chapter 2\\usedcars.csv", stringsAsFactors = FALSE)

# What's the structure of the usercars dataframe?
# CLASS = data.frame (structure or object type)
# MODE = list (lists allow for different types of data and ragged lengths)
# STR() similar to head() but gives you detail of variables
str(usedcars)

# summary() displays common stats
summary(usedcars) # Against the whole data frame
summary(usedcars$year) # Summary of the year feature only
summary(usedcars[c("price", "mileage")]) # Summary of several numeric variables

range(usedcars$price) # Display the range of used car prices
diff(range(usedcars$price)) # Display the difference between the min and max

# Calculate the IQR of used car prices, the difference between Q1 and Q3
IQR(usedcars$price)

# quantile returns the default five-number summary
quantile(usedcars$price)

# The probs parameter using a vector sets cut points for quantiles
quantile(usedcars$price, probs = c(0.01, 0.99))

# Using sequences builds evenly-spaced values
quantile(usedcars$price, probs = seq(from = 0, to = 1, by = 0.20))

# Visualizing numeric variables with boxplots
boxplot(usedcars$price, main = "Boxplot of Used Car Prices", ylab = "Price ($)")
boxplot(usedcars$mileage, main = "Boxplot of Used Car Mileage", ylab = "Odometer (mi.)")

# Histograms are another visualization tool
hist(usedcars$price, main = "Boxplot of Used Car Prices", ylab = "Price ($)")
hist(usedcars$mileage, main = "Boxplot of Used Car Mileage", ylab = "Odometer (mi.)")

# Measuring spread with variance and standard deviation
var(usedcars$price) # Calculate the variance of the used car prices
sd(usedcars$price) # Calculate the standard deviation of used car prices

var(usedcars$mileage) # Calculate the variance of the used car mileage
sd(usedcars$mileage) # Calculate the standard deviation of used car mileage

# Exploring categorical variables using tables
# First, one-way tables for single categorical variables using table()
table(usedcars$year)
table(usedcars$model)
table(usedcars$color)

# Proportion tables can be had with prop.table()
prop.table(table(usedcars$model)) # 52% of all used cars are SE models

# Prettying the results of the prop.table() call
# How this works (working inside out):
# 1) Run the table function on usedcars$model
# 2) Run the prop.table function on the results of the table function
# 3) Run the round function on the results of the prop.table function
round(prop.table(table(usedcars$model)) * 100, digits = 1)
round(prop.table(table(usedcars$color)) * 100, digits = 1)

# Questions for investigation about the used car data
# Does the price data imply we are examining only economy-class cars,
# or does it include luxury cars with high mileage?
# Do relationships between model and color data provide insight into
# the types of cars we're reviewing?

# Scatterplots
plot(x = usedcars$mileage, y = usedcars$price, 
     main = "Scatterplot of Price vs. Mileage",
     xlab = "Used Car Odometer (miles)",
     ylab = "Used Car Price")

# Examining relationships -- two-way cross-tabulations
# Cross-tab (contingency) tables for two nominal variables
# Don't forget to run the install.packages(gmodels) and library(gmodels)
# to use the gmodels package with CrossTable
library(gmodels)

# Let's add a dummy variable (binary indicator) to define whether the
# car's color is conservative or not
# NOTE: We're ADDING the dummy variable directly to the data
# and doing that with the %in% operator, similar to SAS,
# which returns TRUE or FALSE
usedcars$conservative <- usedcars$color %in% c("Black", "Gray", "Silver", "White")

# How many are conservative?
table(usedcars$conservative) # About 2/3rds are conservative (99 of 150)

# Now let's crosstab conservative by model to see if there's any relation
CrossTable(x = usedcars$model, y = usedcars$conservative)
# Chi-square test for independence; p = 93% (variations probably by chance and no association between model and color)
CrossTable(x = usedcars$model, y = usedcars$conservative, chisq = TRUE) 

# Machine Learning with R: Chapter 3
# Lazy Learning -- Classification using nearest neighbors using kNN algorithm
# Things that are alike are likely to have properties that are alike
# Using these similar properties to classify data with most similar,
# or "nearest" neighbors
# Nearest neighbor classifiers are defined by their characteristic
# of classifying unlabeled examples by assigning them the class of
# the most similar labeled examples
# If a concept is difficult to define but you know it when you see it,
# then nearest neighbors might be appropriate

# First need a training dataset of examples classified into several
# categories, labeled by a nominal variable; for example, whether a
# tumor is Malignant or Benign. The kNN algorithm treats the features
# as coordinates in a multidimensional feature space; ex: two features
# (variables) is a two-dimensional feature space.

# Calculating distance: we need a distance function to find how
# far our examples are from the training data set to determine
# how close they are to the training data. Traditionally kNN uses
# Euclidean distance (straight lines as the crow flies), but can
# use others like Manhattan distance (the number of city blocks
# in walking distance). 

# Choosing an appropriate k: Deciding how many neighbors to use
# for kNN determines how well the model will generalize to future
# data. The over- versus underfitting of training data is the 
# bias-variance tradeoff; a large k reduces the impact of noisy
# data but can bias the learner such that it runs the risk of ignoring
# small but important patterns. Using a single neighbor allows
# outliers or noisy data to unduly affect the classification of
# examples. Typically k is between 3 and 10, and can also be
# calculated by setting it equal to the square root of the number
# of training examples. This might not always be best, so 
# experiment with several k values against numerous test
# datasets for the best classification performance.

# Preparing data for use with kNN
# Features are typically transformed to a standard range before
# applying the algorithm; ex: z-scores or minmax normalization.
# This eliminates larger values dominating the distance
# measurements; for example, if classifying food as Sweet and
# Crunchy on a 1-10 scale and add Scoville as 1-10,000,000 then
# Scoville will alter the food differentiation

# Nominal variables (male/female, tall/short) can be dummy coded.
# If the nominal feature is ordinal (cold, warm, hot) could be 
# numbered 1, 2, and 3. This CAN ONLY BE USED IF THE DISTANCE
# BETWEEN THE VALUES IS EQUIVALENT.

# Using kNN to predict breast cancer
# Import the Wisconsin data set from the Chapter 3 folder
wbcd <- read.csv("H:\\Stuff\\R\\r-tutorial-src\\Machine_Learning_with_R\\2148OS_code\\chapter 3\\wisc_bc_data.csv", stringsAsFactors = FALSE)

# Review the structure of the data; always get rid of ID features, as they can mess up the kNN weighting
str(wbcd)

# Punt the ID variable
wbcd <- wbcd[-1]

str(wbcd)

# Diagnosis is of particular interest; count the values
table(wbcd$diagnosis) # 357 benign, 212 malignant

# Many R machine language classifiers require factors,
# so we'll need to recode the diagnosis variable and
# give it more informative labels
wbcd$diagnosis <- factor(wbcd$diagnosis, levels = c("B", "M"), labels = c("Benign", "Malignant"))

# Now the prop.table will give us percentages
round(prop.table(table(wbcd$diagnosis)) * 100, digits = 1) # 62.7% benign, 37.3% malignant

# Remaining features are numeric; let's look at 3 of them
# NOTE: This code works with or without the comma designating
# the columns for summary
# summary(wbcd[c("radius_mean", "area_mean", "smoothness_mean")],)
summary(wbcd[c("radius_mean", "area_mean", "smoothness_mean")])

# Problematic values of radius, area, and smoothness mean:
# Area is far larger value than either of the other two;
# We need to standardize these so kNN algorithm doesn't
# overvalue one over any of the others
# Write a normalize function with the minmax
normalize <- function(x) 
{
  return((x - min(x)) / (max(x) - min(x)))
}
# Confirm normalize works as it should
normalize(c(1, 2, 3, 4, 5))
normalize(c(100, 200, 300, 400, 500))

# Standardize the remaining 30 variables with
# normalize() function using lapply to apply
# the function to each element of the data
# frame. After using lapply() we have to
# treat the returned data as a data frame
# for consistency
# CAUTION! Running normalize() against the data frame
# results in the results being wrong!
# CAUTION! Running lapply without as.data.frame returns
# the right values but makes wbcd_n a list instead of a
# data frame
wbcd_n <- as.data.frame(lapply(wbcd[2:31], normalize))

summary(wbcd_n$area_mean)

# Not much value in predicting what we already know about
# this data, that all 569 are benign or malignant. Would
# be much better to have new data to run through our model,
# but we can simulate this scenario by dividing the existing
# data into two portions: training for building the kNN
# model and a test dataset for estimating predictive
# accuracy.
# NOTE: This data is already randomly organized, so pulling
# these rows results in random selections. Remember that
# selecting random data in other situations is probably necessary.
# If the data were chronological then we'd need to randomly
# select each data set.
wbcd_train <- wbcd_n[1:469, ]
wbcd_test <- wbcd_n[470:569, ]

# Remember that the diagnosis was excluded from the 
# normalized data sets. So, get the diagnosis features from
# the original data sets...
# For training we need the class labels in factor vectors
# for both data sets
wbcd_train_labels <- wbcd[1:469, 1]
wbcd_test_labels <- wbcd[470:569, 1]

# Need to use the package class for the kNN algorithm
install.package("class")
library("class")

# Use the knn() function from the class package
# Other versions of knn exist in other packages and
# can be investigated from the CRAN site
# For knn() k is a user-specified number
# Training data has 469 rows, which is approximately
# 21 squared, so let's try k = 21
wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k = 21)

# What happens if we calculate k? In this case k = 22 because of the calculation
# where k = 21.65641, rounding up to 22. Results are identical to k = 21, with 
# 2 False Negatives again, resulting in 98% overall accuracy
wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k = round(sqrt(nrow(wbcd_train))))

# Evaluate how well the predicted classes in the _pred
# vector match up with the test_labels vector using
# the CrossTable() function without chi-square testing
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred, prop.chisq = FALSE)

# The intersection of the results comparison look like the following in col/row:
# Benign-Benign = True Negative (both predicted and test data were benign)
# Benign-Malignant = False Negative (predicted was benign but data was malignant)
# Malignant-Benign = False Positive (predicted was malignant but data was benign)
# Malignant-Malignant = True Positive (both predicted and test data were malignant)
# Our test was 97% accurate in Benign diagnoses, missing 2 malignancies, which
# was 98% correct overall, getting 98 of 100 total diagnoses correct.

# Can we improve prediction accuracy with z-scores?
# The scale() function can be used with data frames so we don't have to use
# lapply() to coerce the structure into the function
# Scale() is built in to R and standardizes data automagically with mean = 0
# and stddev = 1
wbcd_z <- as.data.frame(scale(wbcd[-1]))

# Confirm the transformation after removing the diagnosis feature and standardizing
summary(wbcd_z$area_mean)

# Set up the train and test data
wbcd_train <- wbcd_z[1:469, ]
wbcd_test <- wbcd_z[470:569, ]

# Get the diagnosis labels for comparison
wbcd_train_labels <- wbcd[1:469, 1]
wbcd_test_labels <- wbcd[470:569, 1]

# Do the knn() again with the z-score standardized data
wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k = 21)

# Build the crosstab table with the results
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred, prop.chisq = FALSE)

# Predictions got worse, as only 87% of malignancies (34 of 39) were correct
# which was 95% overall correct (all 61 benigns were correct); the false
# negatives went up, which makes this model less reliable

# TIP: run knn() with different values of k to determine if other models
# might have better results. Can also create multiple sets of test data
# and repeatedly retest results with models for future data runs.

# Using kNN to predict profitable clients
# If we know which clients are profitable, can we use data to determine
# which will be profitable? What data makes the model most valuable?

# First, import the data
# R imported the CSV fine except some numeric columns came in as CHARACTER
# Went back into Excel multiple times cleaning up the data:
# 1) Replacing blanks (NAs) with 0 for missing features
# 2) Replacing dashes (NAs) with 0 for Excel zeroes
# 3) Updating columns stored as General as Numbers

clients <- read.csv("c:\\R\\Data\\ProfClients2012.csv", stringsAsFactors = FALSE)

# Need to standardize the big numeric data; initially the emp nbrs,
# balance info, contribution totals, expenses and gross margin
str(clients)

# Add Profitable dummy variable to base data before removing for testing
clients$profitable <- clients$Gross_Margin_Pct_2012 > 0

# How many are profitable?
table(clients$profitable)

# Now the prop.table will give us percentages
round(prop.table(table(clients$profitable)) * 100, digits = 1) # 48% profitable, 52% unprofitable


# Nuke the ClientNm, Gross Margin 2012 Pct and Gross Margin$ columns
clients <- clients[c(-1, -10, -11)]

# Standardize by minmax on all columns EXCEPT profitable
clients_minmax <- as.data.frame(lapply(clients[1:ncol(clients - 1)], normalize))

# Select random groups of clients for train and test
clients_train <- clients_minmax[sample(nrow(clients_minmax), 139), ]
clients_test <- clients_minmax[sample(nrow(clients_minmax), 50), ]

# WARNING: This is NOT random, clients are in ALPHA order
# clients_train <- clients_minmax[1:139, ]
# clients_test <- clients_minmax[140:189, ]

# Remember that the diagnosis was excluded from the 
# normalized data sets. So, get the diagnosis features from
# the original data sets...
# For training we need the class labels in factor vectors
# for both data sets

# The 2 lines below assume using the already-random CLIENTS file
# clients_train_labels <- clients[1:139, ncol(clients)]
# clients_test_labels <- clients[140:189, ncol(clients)]

clients_train_labels <- clients_train[1:nrow(clients_train), ncol(clients_train)]
clients_test_labels <- clients_test[1:nrow(clients_test) , ncol(clients_test)]

# Need to use the package class for the kNN algorithm
# install.package("class")
# library("class")

# Use the knn() function from the class package
# Other versions of knn exist in other packages and
# can be investigated from the CRAN site
# For knn() k is a user-specified number
# Training data has 469 rows, which is approximately
# 21 squared, so let's try k = 21
clients_test_pred <- knn(train = clients_train, test = clients_test, cl = clients_train_labels, k = round(sqrt(nrow(clients_train))))

# Evaluate how well the predicted classes in the _pred
# vector match up with the test_labels vector using
# the CrossTable() function without chi-square testing
CrossTable(x = clients_test_labels, y = clients_test_pred, prop.chisq = FALSE)

# Chapter 4: Probabilistic Learning with Naive Bayes
# Data comes from http://www.dt.fee.unicamp.br/~tiago/smsspamcollection

# Need to process the raw data for analysis by transforming into a bag-of-words
# Import the CSV file
sms_raw <- read.csv("H:\\Stuff\\R\\r-tutorial-src\\Machine_Learning_with_R\\2148OS_code\\chapter 4\\sms_spam.csv", stringsAsFactors = FALSE)

# Since TYPE is a character variable (ham or spam) it would work better as a FACTOR
sms_raw$type <- factor(sms_raw$type)

# Quick table of SPAM versus HAM (non-spam messages)
table(sms_raw$type)

# Handling complex text data, including removing punctuation and numbers, uninteresting
# words like and, but and or, and breaking apart sentences into individual words can all
# be done in a TEXT MINING package called tm
# install.packages("tm")
library(tm)

# Create a CORPUS, which refers to a collection of documents. In this case, a text
# document refers to a single SMS text message
# CORPUS creates an R object to store the text documents
# VECTORSOURCE tells CORPUS to use the messages in the TEXT vector
sms_corpus <- Corpus(VectorSource(sms_raw$text))

# PRINT(corpusname) tells us how many items are in the corpus
# INSPECT(corpusname) lets us inspect within the corpus
inspect(sms_corpus[1:3])

# Need to clean up each text and remove punctuation and other clutter characters
# For example, need HELLO, hello! and Hello to be treated identically
# Convert all messages to lowercase and remove numbers
corpus_clean <- tm_map(sms_corpus, tolower)
corpus_clean <- tm_map(corpus_clean, removeNumbers)

# Remove stop words like to, and, but and or; get rid of punctuation, too
corpus_clean <- tm_map(corpus_clean, removeWords, stopwords())
corpus_clean <- tm_map(corpus_clean, removePunctuation)

# Remove extra whitespace
corpus_clean <- tm_map(corpus_clean, stripWhitespace)

# Data processed to our liking; now need to segment
# individual components through tokenization where
# a token = single element of text string; in our case
# a token = word; create a sparse matrix
# This will let us perform analyses involving word frequency
sms_dtm <- DocumentTermMatrix(corpus_clean)

# Create the TRAINING (75%) and TEST (25%) datasets
# SMS file is already randomly sorted; don't forget that
# the ROL comments will NOT be, for example
# Must create RAW sms messages, Document-Term Matrices, and Corpuses
sms_raw_train <- sms_raw[1:4169, ]
sms_raw_test <- sms_raw[4170:5559, ]

sms_dtm_train <- sms_dtm[1:4169, ]
sms_dtm_test <- sms_dtm[4170:5559, ]

sms_corpus_train <- corpus_clean[1:4169]
sms_corpus_test <- corpus_clean[4170:5559]

# Are the proportions of HAM and SPAM similar across TRAINING and TEST?
prop.table(table(sms_raw_train$type))

prop.table(table(sms_raw_test$type))

# Build a wordcloud to visually depict word frequency
# install.packages("wordcloud")
library(wordcloud)

# Builds a wordcloud including all SMS messages
wordcloud(sms_corpus_train, min.freq = 40, random.order = FALSE)

# Let's sort the spam and ham messages using the SUBSET() function
spam <- subset(sms_raw_train, type == "spam")

ham <- subset(sms_raw_train, type == "ham")

# Build wordclouds for SPAM and HAM; SCALE() lets us manage font size
# Wordclouds are random, so running more than once to get the best visualization may be necessary
wordcloud(spam$text, min.freq = 40, scale = c(3, 0.5))
wordcloud(ham$text, min.freq = 40, scale = c(3, 0.5))

# Transform the sparse matrix into a data structure to train the naive Bayes classifier
# Need to eliminate any words that appear < 5 messages, or about 0.1% of training data
# Use findFreqTerms and Dictionary (which terms to find in the document-term matrix)
sms_dict <- Dictionary(findFreqTerms(sms_dtm_train, 5))

# Cut down on the potential number of terms to search against
sms_train <- DocumentTermMatrix(sms_corpus_train, list(dictionary = sms_dict))
sms_test <- DocumentTermMatrix(sms_corpus_test, list(dictionary = sms_dict))

# Typical naive Bayes classified trained on data with categorical features
# Need to change word count into a factor variable (Y/N) whether word appears at all
convert_counts <- function(x) {
  x <- ifelse(x > 0, 1, 0)
  x <- factor(x, levels = c(0, 1), labels = c("No", "Yes"))
  return(x)
}

# Have to APPLY the new function to the sparse matrix columns
# APPLY specifies the data, MARGIN = rows (1) or columns (2), and the function to be applied
# Replaces all the counts with Yes or No factors for each word
sms_train <- apply(sms_train, 2, convert_counts)
sms_test <- apply(sms_test, 2, convert_counts)

# Data can be represented by statistical model. In this case,
# we'll use naive Bayes against the presence or absence of words
# to estimate the probability that an SMS message is spam or ham.
# Using the e1071 package, though there are many other functionally
# equivalent packages such as klaR.
# install.packages("e1071")
library(e1071)

# Unlike the kNN algorithm, Bayes training occurs in separate stages
# First, build the TRAIN matrix
sms_classifier <- naiveBayes(sms_train, sms_raw_train$type)

# Now that classifier is ready, it's time to test its predictions
# PREDICT is used with the classifier and the cleaned up test messages,
# which are the messages that HAVEN'T been classified yet (even though
# they really have)
sms_test_pred <- predict(sms_classifier, sms_test)

# Use CrossTable to build a prediction-correct crosstab table
# to numerically assess how correct the model was 
# library(gmodels)
CrossTable(sms_test_pred, sms_raw_test$type, prop.chisq = FALSE, prop.t = FALSE, dnn = c("Predicted", "Actual"))

# Initial run classified 99% of ham messages correctly, and 84% of spam
# For so little effort, this was pretty good. It would not be good enough
# to miss 15% of messages especially if the situation was an emergency or
# another urgent message. Our initial model did not include a Laplace estimator,
# which is really a dummy addition of 1 (usually) to the count of words in
# our classifier so that zeros (0) don't have such a negative effect on our
# model
sms_classifier_lap <- naiveBayes(sms_train, sms_raw_train$type, laplace = 1)

sms_test_pred_lap <- predict(sms_classifier_lap, sms_test)

CrossTable(sms_test_pred_lap, sms_raw_test$type, prop.chisq = FALSE, prop.t = FALSE, dnn = c("Predicted", "Actual"))

# This run got 99.7% of ham and 82% of spam right. Overall the model got 87%
# of the text classification correct. While this success level may seem low,
# we need to remember that misclassification could result in very negative
# consequences, such as missing emergency or urgent texts.

# Chapter 5: Divide and conquer with classification using decision trees and rules
# This chapter covers decision trees (DT) and rule learners--two machine learning methods that apply a similar
# strategy of dividing data into smaller and smaller portions to identify patterns that can be used
# for prediction and this is presented in logical structures that can be understood without any statistical
# knowledge.
# 
# Decision tree learners build a model in the form of a tree structure, a model that comprises a series of
# logical decisions similar to a flowchart, with decision nodes that indicate a decision to be made on an
# attribute. These split into branches that indicate the decision's choices and terminate by leaf nodes that
# denote the result of following a combination of decisions. 
# 
# Decision trees are particularly appropriate for applications in which the classification mechanism needs 
# to be transparent for legal reasons or the results need to be shared in order to facilitate decision-making.
# Some potential uses: credit scoring models where criteria may lead to applicant rejection but must be well-specified;
# marketing studies of customer churn or satisfaction that will be shared with management or agencies; diagnosis
# of medical conditions based on lab measurements, symptoms, or rate of disease progression.
# 
# Decision trees are the single most widely-used machine learning technique for any type of data, often
# with unparalleled performance.
# 
# DT may NOT be applicable where the data has a large number of nominal features with many levels or if the
# data has a large number of numeric features.
# 
# DT are built using a heuristic called recursive partitioning, also known as "divide and conquer" because
# it continues splitting the data into smaller and smaller subsets or similar classes.

# The C5.0 DT algorithm
# Most popular and powerful of publicly available DT models. First challenge is to ID which feature to split
# the data upon. If the segments of data contain only a single class, they are considered pure. C5.0 uses entropy
# for measuring purity, where entropy of a sample of data indicates how mixed the class values are, where 0
# indicates complete homogeneity and 1 indicates the maximum amount of disorder. A decision tree can grow indefinitely,
# choosing splitting features and dividing into smaller and smaller partitions until each example is perfectly classified
# or the algorithm runs of out of features to split on. Pruning involves reducing a DT size such that it generalizes better
# to unseen data. One solution to this is to only let the tree grow so big with a pre-determined number of nodes, called
# pre-pruning. This may result in missing subtle but important patterns were it to grow to a larger size. Post-pruning
# reduces a too-big DT based on error rates at the nodes. Post-pruning is MORE EFFECTIVE because more certain to 
# discover the important data structures. C5.0's default is to post-prune; it is opinionated in how to do so.

# Identifying risky bank loans using C5.0 DT
# Building a simple credit approval model and see how the results can be tuned to minimize errors that result in a financial
# loss.
credit <- read.csv("c:\\r\\data\\packt\\chapter 5\\credit.csv")

str(credit)

# Tables of Checking Balance and Savings Balances; all amounts in Deutsche Marks (DM) since German in origin
table(credit$checking_balance)
table(credit$savings_balance)

# Some loan features are numeric, like duration, and amount requested
summary(credit$months_loan_duration)
summary(credit$amount)

# The default variable indicates whether the loan applicant was unable to meet the agreed upon payment terms
# and went into default; 30% of the loans went into default, which is bad for the bank.
table(credit$default)

# Our model will ID applicants that are likely to default to reduce this number, we hope.
# We will use 90% of the data for training and 10% for testing, similar to before. We need to randomly
# order the data because the loans are ordered by size from smallest to largest. ORDER() is used to
# rearrange a list of items in ascending or descending order and RUNIF() is used for random number
# generation. SET.SEED() is used to generate random numbers in a predefined sequence, which allows for
# reproducing the analysis if repetition is required.
set.seed(12345)
credit.rand <- credit[order(runif(1000)), ] # Get 1000 random numbers because we have that many loan records

summary(credit$amount)
summary(credit.rand$amount) # These should be identical

# Heads of both, though, should not
head(credit$amount)
head(credit.rand$amount)

# Build the TRAINING data set
credit.train <- credit.rand[1:900, ]

# Build the TEST data set
credit.test <- credit.rand[901:1000, ]

# Are default rates about 30% for TEST and TRAINING?
table(credit.test$default) # 32% yes
table(credit.train$default) #26.8% yes, pretty close

# Install the C50 package
install.packages("C50")
# Make the library active
library(C50)

# First we'll use the default C50 configuration with the 17th column in the TRAIN data, the class
# variable DEFAULT, that we need to exclude to build the model.
credit.model <- C5.0(credit.train[-17], credit.train$default)

credit.model # The tree has 67 decisions!

summary(credit.model) # why would applicant with very good credit history default? Sometimes the model is contradictory

# The Confusion Matrix, beginning with Evaluation on Training Data section, found 13.9% errors, misclassifying 125 applicants
# where 23 actual NO values were classified as YES and 102 YES values were misclassified as NOs (false negatives). DTs tend
# to overfit the model on training data, which may state the error rate is overly optimistic.

# Step 4: evaluating model performance
# Let's use PREDICT() with the tree
credit.pred <- predict(credit.model, credit.test)

# Created a vector of predicted class values we can compare to the actual class values with the CrossTable from the GMODELS library
library(gmodels)

CrossTable(credit.test$default, credit.pred,
           prop.chisq = FALSE,
           prop.c = FALSE,
           prop.r = FALSE,
           dnn = c("Actual Default", "Predicted Default")) # PROP.C and .R removes COLUMN and ROW percentages from output table

# The unknown data resulted in a 73% accuracy rate (73 of 100), but got only 50% accuracy for Actual Defaults (16 of 32). This
# would be unacceptable for the lending institution.

# Step 5: Improving model performance
# Boosting can help the DT model. Boosting is combining a number of weak performing learners to create a team that is much
# stronger than any one of the learners alone. The C5.0 function makes boosting easy through the use of the TRIALS parameter, 
# where we'll set an upper limit that the algorithm will use to stop if additional trials don't seem to be helping. The de facto 
# standard of TRIALS = 10, which can reduce error rates by as much as 25%
credit.boost10 <- C5.0(credit.train[-17], credit.train$default, trials = 10)

credit.boost10

summary(credit.boost10) # Only 29 total errors this time--1 in the No Defaults and 28 in the Yes defaults, an error rate of 3.2%!

# Let's run the model against the TEST data now
credit.boost.pred10 <- predict(credit.boost10, credit.test)

CrossTable(credit.test$default, credit.boost.pred10,
           prop.chisq = FALSE,
           prop.c = FALSE,
           prop.r = FALSE,
           dnn = c("Actual Default", "Predicted Default"))

# Overall success is improved at 75% (75 of 100), but Defaults are still 50% (16 of 32). This may indicate a sample that's too
# small or this is a really tough nut to crack.

# Why not apply boosting all the time? Might be computationally impractical (take too long), and if TRAINING data is noisy then
# boosting might not make any difference. But feel free to give it a try.

# Making some mistakes can be more costly than others
# Giving out loans to an applicant more likely to default can be an expensive mistake. The C5.0 algorithm allows for assigning
# penalties to different types of errors in order to discourage a tree from making costly mistakes. These are put into a
# COST MATRIX which specifies how much more costly each error is relative to any other. In this case we believe a loan default
# costs the bank 4x as much as a missed opportunity. The cost matrix looks like:
error.cost <- matrix(c(0, 1, 4, 0), nrow = 2)

error.cost # False negatives cost 4 versus a false positive's cost of 1

credit.cost <- C5.0(credit.train[-17], credit.train$default, costs = error.cost)

credit.cost.pred <- predict(credit.cost, credit.test)

CrossTable(credit.test$default, credit.cost.pred,
           prop.chisq = FALSE,
           prop.c = FALSE,
           prop.r = FALSE,
           dnn = c("Actual Default", "Predicted Default"))

# This time the model got fewer overall right at 68% (68 of 100), but only missed 6 of 32 actual defaults, much better
# This might be acceptable if we believed our cost estimates were accurate (4x cost for false negatives)

# Understanding Classification Rules p.142
# Classification rules represent knowledge in the form of logical if-else statements that assign a class of unlabeled examples,
# specified in terms of ANTECEDENT (before) and CONSEQUENT (post) form. These are in the form of "If this happens, then that
# happens." The antecedents are combinations of feature values, while the consequent specifies the class value to assign if 
# the rule's condition is met. Rule learners are often used similarly to decision tree learners. Like decision trees, they can be
# used to generate knowledge for future action, such as identifying conditions that lead to a hardware failure in mechanical
# devices, describing the defining characteristics of groups of people for customer segmentation and finding conditions that precede
# large drops or increases in the prices of shares on the stock market.
# 
# Distinct advantages of rule learners over DTs rules are stand-alone. Rule learners tend to be more parsimonious, direct, and
# easier to understand than a decision tree built on the same data. We use rule learners over DTs sometimes because DTs bring certain
# biases to the the task that a rule avoids by identifying the rules directly.
# 
# Rule Learners are best served with NOMINAL data, either primarily or exclusively. They ID rare events well.
# 
# Separate and Conquer
# This process identifies a rule that covers a subset of examples in the training data, then separates this partition from the 
# remaining data. As rules are added, additional subsets of data are separated until the entire dataset has been covered and no more
# examples remain. Divide and conquer and separate and conquer algorithms are called GREEDY LEARNERS because data is used on a first-come,
# first-served basis. This may be efficient but not guaranteed to generate the best rules or minimum number of rules for a particular
# dataset.  
# 
# The One Rule algorithm
# ZeroR is a rule learner that literally learns no rules, as for every unlabeled example regardless of the values of its features, it
# predicts the most common class. The One Rule algorithm (1R or OneR) improves over ZeroR by selecting one and only one rule, which
# tends to work pretty well. Limits include too much simplicity and the potential for error, as a medical diagnosis system on one symptom
# would be dangerous, or an automated driving system that accelerates or stops based on one factor?
# 
# The RIPPER algorithm
# Intro'd in 1995 by William W. Cohen, the Repeated Incremental Pruning to Produce Error Reduction (RIPPER) algorithm updated and improved
# the original IREP to generate rules that match or exceed the performance of decision trees. Many others are under consideration, too,
# such as IREP++, SLIPPER, and TRIPPER to name a few. RIPPER works in three steps: Grow, Prune, and Optimize. First, RIPPER uses separate-and-conquer
# to greedily add conditions to a rule until it perfectly classifies a subset of data or runs out of attributes for splitting. When entropy stops,
# the rule is immediately pruned and steps 1 and 2 are repeated until reaching a stopping criterion, at which point the entire set of rules are
# optimized using a variety of heuristics.
# 
# DT algorithm C5.0 will produce a model using classification rules if you specify RULES = TRUE when training the model. DTs generating 
# rules downsides are that they are often more complex than rule-learning algorithms and can be biased by the developing tree, but they
# can be more computationally efficient.
# 
# Identifying Poisonous Mushrooms with Rule Learners p.150
# It's not as easy as many other plants: "Leaves of three let them be."
# Step 1 Collecting Data and Step 2 Exploring and prepping the data
mushrooms <- read.csv("c:\\r\\data\\packt\\chapter 5\\mushrooms.csv", stringsAsFactors = TRUE)

str(mushrooms) # veil_type all same factor value of 1; probably a mistake; let's drop it

mushrooms$veil_type <- NULL # R eliminates the feature from the mushrooms data frame

# Look at the distribution of the class variable mushroom$type. If class levels are distributed unevenly, or imbalanced, some models
# such as rule learners can have trouble predicting the minority class.
table(mushrooms$type) # 4208 edible, 3916 poisonous; pretty good split

# Consider this an exhaustive set, which means we don't need to split out TRAINING data for testing purposes. We are merely
# trying to find rules that accurately depict the complete set of mushroom types. The model can be built and tested on the same
# data.

# Step 3 Training a model on the data
# Let's first try the 1R single rule and see how predictively accurate it is. 1R is found in the RWeka package
library(RWeka)

mushrooms.1R <- OneR(type ~ ., data = mushrooms)

mushrooms.1R # The rule correctly classified 98.6% of the mushrooms

summary(mushrooms.1R) # General rule: If the mushroom smells unappetizing, it's probably poisonous

# Step 4: Evaluating model performance
# The model predicted 120 mushrooms as poisonous when they weren't but overall the almost 99% correct classification
# is pretty good. The OneR played the rules safe--if you avoid unappetizing smells when foraging for mushrooms you
# will avoid eating poisonous mushrooms, but you might also miss some good ones, too.
# 
# Step 5: Improving model performance
# Let's see how the JRip() function works, from the same library.
mushroom.Jrip <- JRip(type ~ ., data = mushrooms)

mushroom.Jrip

str(mushroom.Jrip) #JRip came up with 9 rules, like if-else statements, except #9 which is "else..." 100% accurate
# with the remaining 4,208 varieties in the 9th rule being all edible

# Can rule learner determine what makes a participant have an IRR > 70?
IRR.70.JRip <- JRip(end.IRR.70 ~ ., data = lion.orig[-c()])


# Can a rule learner determine which plans belong in what Segment?
svcs2013$Segment <- as.factor(svcs2013$Segment)

services.Jrip <- JRip(Segment ~ ., data = svcs2013[ , c(1, 20:97)])

services.Jrip # Came up with 8 rules

str(services.Jrip)

# Can a rule learner determine which participants will be DIY users?
# Use the finaldata data set, which is only the 487,756 participants with 5-year PRORs
# Save the original data as a working set
fiveyrdata <- finaldata

# Convert all of the Character fields to factors
fiveyrdata <- as.data.frame(unclass(fiveyrdata), stringsAsFactors = TRUE)

# Classify all of the remaining numeric fields with dummy variables that can be factors


strat.Jrip <- JRip(Strat5 ~ ., data = fiveyrdata[ , c(2, 7:25)])

strat.Jrip

summary(strat.Jrip)

# The BRUCEREQUEST.csv file
bruce <- read.csv("c:\\r\\data\\brucerequest.csv", stringsAsFactors = TRUE)

str(bruce)

# Just for grins let's add a column with 150,000 participants having LOANS
bruce$Loan <- as.factor(c(rep("Yes", 150000), rep("No", nrow(bruce) - 150000)))


# Cols 1-5 (Plan.Name, Plan.Nbr, Plan.ID, Acct.ID, SSN) don't have any effect on the study
# State has 81 levels! Needs to be cleaned up if we're developing rules on where people live. Keep DC and PR, too, for 52
# Gender has 4 levels: Female, Invalid (23), Male, Unknown (49,360). Keep only Males and Females
bruce.states <- bruce[bruce$State %in% c("AK", "AL", "AR", "AZ",
                                        "CA", "CO", "CT", "DC",
                                       "DE", "FL", "GA", "HI",
                                       "IA", "ID", "IL", "IN",
                                       "KS", "KY", "LA", "MA",
                                        "MD", "ME", "MI", "MN",
                                         "MO", "MS", "MT", "NC",
                                         "ND", "NE", "NH", "NJ",
                                         "NM", "NV", "NY", "OH",
                                         "OK", "OR", "PA", "PR",
                                         "RI", "SC", "SD", "TN",
                                         "TX", "UT", "VA", "VT",
                                         "WA", "WI", "WV", "WY"), ]
bruce.states.gender <- bruce.states[bruce.states$Gender %in% c("Male", "Female"), ]

# Add a category column for the Balance to simplify the data for classification
range(bruce.states.gender$Current.Bal) # Max just over $8M

bruce.states.gender$Cur.Bal.Group <- ifelse(bruce.states.gender$Current.Bal <= 25000, "<= $25,000",
                                            ifelse(bruce.states.gender$Current.Bal <= 50000, "$25,000-$50,000",
                                                   ifelse(bruce.states.gender$Current.Bal <= 100000, "$50,000-$100,000",
                                                          ifelse(bruce.states.gender$Current.Bal <= 250000, "$100,000-$250,000",
                                                                 ifelse(bruce.states.gender$Current.Bal <= 500000, "$250,000-$500,000",
                                                                        ifelse(bruce.states.gender$Current.Bal <= 1000000, "$500,000-$1,000,000",
                                                                               ifelse(bruce.states.gender$Current.Bal <= 5000000, "$1,000,000-$5,000,000",">$5 million")))))))
bruce.states.gender$Cur.Bal.Group <- as.factor(bruce.states.gender$Cur.Bal.Group)

bruce.states.gender$invtype <- as.factor(ifelse(bruce.states.gender$Inv.Type == "Equity", "Equity", "Not Equity"))

# Let's classify participants as living either East or West
bruce.states.gender$Region <- as.factor(ifelse(bruce.states.gender$State %in% c("AL", "AR", "CT", "DC",
                                                                "DE", "FL", "GA",
                                                                "IA", "IL", "IN",
                                                                "KS", "KY", "LA", "MA",
                                                                "MD", "ME", "MI", "MN",
                                                                "MO", "MS", "NC",
                                                                "ND", "NE", "NH", "NJ",
                                                                "NY", "OH",
                                                                "OK", "PA", "PR",
                                                                "RI", "SC", "SD", "TN",
                                                                "VA", "VT",
                                                                "WI", "WV"), "East", "West"))

str(bruce.states.gender)

# How does the OneR algorithm do determining which state a participant lives in?
# Let's pull out 90% of the records for the TRAINING set
# We need to RANDOMIZE the records to separate those with Loans from those without
set.seed(12345)
bruce.rand <- bruce.states.gender[order(runif(996832)), ] # Get 996832 random numbers because we have that many records

# Let's cut the unnecessary columns before we run the tests
bruce.rand.sample <- bruce.rand[-c(1:6,12)]

bruce.train <- bruce.rand.sample[1:900000, ]
bruce.test <- bruce.rand.sample[900001:996832, ]

prop.table(table(bruce.train$Loan))
prop.table(table(bruce.test$Loan))

library(RWeka)

state.1R <- OneR(Loan ~ ., data = bruce.train)

state.1R # OneRule selected Compensation Group as the way to determine which state the participant lives in

summary(state.1R)

# How does JRip work out? THIS TIES UP MEMORY FOREVER
loan.Jrip <- JRip(Loan ~ ., data = bruce.train)

loan.Jrip

# Can the C5.0 work?
library(C50)

# Don't use the Loan column (#7) in the training data for the model
bruce.model <- C5.0(bruce.train[-6], bruce.train$Loan)

bruce.model # 

summary(bruce.model) # why would applicant with very good credit history default? Sometimes the model is contradictory

loan.pred <- predict(bruce.model, bruce.test)

# Created a vector of predicted class values we can compare to the actual class values with the CrossTable from the GMODELS library
library(gmodels)

CrossTable(bruce.test$Loan, loan.pred,
           prop.chisq = FALSE,
           prop.c = FALSE,
           prop.r = FALSE,
           dnn = c("Actual Loan", "Predicted Loan")) # PROP.C and .R removes COLUMN and ROW percentages from output table





























# Chapter 6: Forecasting numeric data -- regression models
# Set the working directory
setwd("H:\\Stuff\\R\\r-tutorial-src\\Machine_Learning_with_R\\2148OS_code\\")

# The following uses data from NASA on shuttle launches, specifically focusing
# on the Challenger launch, which resulted in a disaster in January 1986.
launch <- read.csv("chapter 6\\challenger.csv", stringsAsFactors = FALSE)

# Find the covariance (calculating b for regression) in y = b + xa
b <- cov(launch$temperature, launch$distress_ct) / var(launch$temperature)

# Calculate a with the mean() function
a <- mean(launch$distress_ct) - b * mean(launch$temperature)

# We can write Pearson's product moment correlation ourselves
r <- cov(launch$temperature, launch$distress_ct) / (sd(launch$temperature) * sd(launch$distress_ct))

#...or just use the built-in COR() function
r <- cor(launch$temperature, launch$distress_ct)

# Most of the time regression isn't determined with a single independent variable, but more than 1
# Create a regression function taking a parameter y and x and returning a matrix of estimated beta coefficients
reg <- function(y, x) {
  # Force x into a matrix form
  x <- as.matrix(x)
  # Add a new column onto X with (1, x) for each value, denoting Intercept as the name of new column
  x <- cbind(Intercept = 1, x)
  # SOLVE inverses the matrix
  # t transposes the matrix
  # %*% multiplies two matrices
  solve(t(x) %*% x) %*% t(x) %*% y
}

# Compare this model's results with the earlier a = 4.30 and b = -.057 with an r = -.7256
reg(y = launch$distress_ct, x = launch[3:5])[ , 1]

# All done writing our own regressions. Let's move to a more complicated problem
# Predicting medical expenses
setwd("c:\\r\\data\\packt\\")

insurance <- read.csv("chapter 6\\insurance.csv", stringsAsFactors = TRUE)

# Our dependent variable is CHARGES; let's look at how it's distributed
summary(insurance$charges) # Mean greater than median; CHARGES is right-skewed

# Confirm skew with a simple histogram
hist(insurance$charges)

# Because linear regression assume normally distributed data, we have a problem.
# "In practice, the assumptions of linear regression are often violated."
# We may be able to correct the skew later, though. Linear regression also requires
# numeric features, and we have three factor types.
# Look at the REGION data more closely
table(insurance$region) # Data relatively evenly distributed by region

# Before fitting a model, consider how the independent variables are related
# to each other and the dependent variable with a correlation matrix:
cor(insurance[(c("age", "bmi", "children", "charges"))]) # No strong correlations

# Some notable associations: age and bmi have a moderate correlation, meaning 
# that as age increases so does bmi; same for age and charges, bmi and charges,
# and children and charges

# SCATTERPLOTS and SCATTERPLOT MATRIX: Reviewing age, bmi, children, and charges (numerics)
# PAIRS() provides basic functionality for scatterplot matrices in base R
pairs(insurance[c("age", "bmi", "children", "charges")])

# The PSYCH package has a more detailed matrix pairs.panels()
library(psych)

pairs.panels(insurance[c("age", "bmi", "children", "charges")])

# Training a model using the lm() function in the stats() package
# lm() stands for linear model
# Structure: lm(dependent variable ~ (tilde) independent var + ivar + ..., data = <data>)
# If using all features in the data set, use . after the tilde
ins_model <- lm(charges ~ age + children + bmi + sex + smoker + region, data = insurance)
# ...is the same as
ins_model <- lm(charges ~ ., data = insurance)

# The results of lm() are here
ins_model

# Results are straightforward: intercept = -11938.5 (charges are this amount if everything else is 0)
# Often the intercept is ignored since it's impossible for someone to have a BMI of 0 or age of 0, for
# example. For each increase of 1 year of age, charges increase $256.90, increase of 1 BMI increases
# charges $339.20, and if you're a male charges go DOWN $131.30. lm() automatically converted non-numerics
# with dummy variables; R uses the first level of FACTOR variables as the reference. To use another
# level, use the relevel() function

# Evaluating the regression model, p. 181-182
summary(ins_model)

# Improving model performance
# Linear regression assumes (duh) linear relationships between dependent and independent variables, but
# this might not necessarily be true for all features; age may be constant throughout all age values.
# Accounting for non-linear relationships can be done by adding a higher order term to the model, 
# treating the model as polynomial. Adding the non-linear age to the model:
insurance$age2 <- insurance$age ^ 2

# What is the histogram of the AGE squared variable now?
hist(insurance$age)
hist(insurance$age2)


# What if we think certain features aren't cumulative, but are triggers, such as normal BMI people
# don't spend more but obese do? We can create a binary indicator variable if BMI > 30 and 0 otherwise.
# We can use this new BMI variable in addition to BMI or in lieu of it, depending on whether or we think
# or not the effect of obesity occurs in addition to a separate BMI effect. RULE OF THUMB: Add the feature
# to the model; if it is not significant, dump it
insurance$bmi30 <- ifelse(insurance$bmi >= 30, 1, 0)

# What if certain features work together for a combined impact on the dependent variable, such as 
# smoking and obesity combined may be worse than each alone. Two features with a combined effect 
# is an interaction. Telling R to use interactions is done with the * symbol
# NOTE: Always include the individual features along with the interaction, but know R
# will automatically include them
ins_model <- lm(charges ~ bmi30 + smoker + bmi30*smoker, data = insurance)
# The next line of code would be equivalent
# ins_model <- lm(charges ~ bmi30*smoker, data = insurance)

# Creating the final, improved model with a non-linear term for age,
# an indicator for obesity and a specified interaction between obesity
# and smoking. This model accounts for almost 87% of variance, up 12% from the original model
ins_model <- lm(charges ~ age + age2 + children + bmi + sex + bmi30*smoker + region, data = insurance)

# MY NOTES on this REGRESSION example
# AGE is not significant; remove it
ins_model <- lm(charges ~ age2 + children + bmi + sex + bmi30*smoker + region, data = insurance) # Model changes very little

# Living in the NW is insignificant and barely significant in SE--but removing this from the model would require removing all regions to make sense
# and the SW is significant to the model



# Understanding regression trees and model trees
# Regression trees make predictions based on the average value of examples that reach
# a leaf of the tree; they don't use linear regression methods. Model trees are 
# less widely known but more powerful, as they build multiple regression models at
# each leaf's node. These can be more confusing to explain but also more powerful.

# How to use decision trees with Standard Deviation Reduction, a common splitting criterion
# original data
tee <- c(1, 1, 1, 2, 2, 3, 4, 5, 5, 6, 6, 7, 7, 7, 7)
# Node 1, group A
at1 <- c(1, 1, 1, 2, 2, 3, 4, 5, 5)
# Node 2, group A
at2 <- c(6, 6, 7, 7, 7, 7)
# Node 1, group B
bt1 <- c(1, 1, 1, 2, 2, 3, 4)
# Node 2, group B
bt2 <- c(5, 5, 6, 6, 7, 7, 7, 7)

sdr_a <- sd(tee) - (length(at1) / length(tee) * sd(at1) + length(at2) / length(tee) * sd(at2)) # 1.21
sdr_b <- sd(tee) - (length(bt1) / length(tee) * sd(bt1) + length(bt2) / length(tee) * sd(bt2)) # 1.40

# The SDR for A was 1.2 versus 1.4 for B; since the standard deviation was reduced more for B,
# the decision tree would use B first; if bt1 were selected, it would give a mean(bt1) = 2, otherwise
# mean(bt2) = 6.25.

# 12/8/14: Regression trees and PDG data
# This is a CSV only with plans that have an IRR
pdg.orig <- read.csv("c:\\r\\data\\pdg2014IRR.csv", stringsAsFactors = TRUE) # 204 records

# Randomize the file, which is ordered by IRR high to low
set.seed(12345)
pdg.rand <- pdg.orig[order(runif(nrow(pdg.orig))), ]

str(pdg.rand)
summary(pdg.rand)

# Clean up some data
# Remove Plan.Number (2), Plan.Name (4), Plan.Sponsor.Num (5), Sponsor.Name (6), Client.Common.Name (7), SponsorMO (8), ClientMO (9),
# and all # of EMPL counts (11:18)
pdg <- pdg.rand[-c(2, 4:9, 11:18)]

str(pdg)
summary(pdg)

# Let's NORMALIZE the big variables and see what that does to the services model
# We're mixing Yes/No values with descriptive variables about each plan so let's run MINMAX
normalize <- function(x) 
{
  return((x - min(x)) / (max(x) - min(x)))
}

pdg$Nbr.of.Investments <- normalize(pdg$Nbr.of.Investments)
pdg$TOTAL_EMPL_CNT <- normalize(pdg$TOTAL_EMPL_CNT)
pdg$TERM_EMPL_CNT <- normalize(pdg$TERM_EMPL_CNT)
pdg$ELIG_EMPL_CNT <- normalize(pdg$ELIG_EMPL_CNT)
pdg$PART_EMPL_CNT <- normalize(pdg$PART_EMPL_CNT)
pdg$EMPL_WITH_BAL_CNT <- normalize(pdg$EMPL_WITH_BAL_CNT)
pdg$TERM_WITH_BAL_CNT <- normalize(pdg$TERM_WITH_BAL_CNT)
pdg$OTHER_WITH_BAL_CNT <- normalize(pdg$OTHER_WITH_BAL_CNT)
pdg$ALL_WITH_BAL_CNT <- normalize(pdg$ALL_WITH_BAL_CNT)
pdg$Employee_Sum <- normalize(pdg$Employee_Sum)
pdg$Employer_Sum <- normalize(pdg$Employer_Sum)


# Set up the TRAIN and TEST data
pdg.train <- pdg[1:154, ]
pdg.test <- pdg[155:204, ]

# install.packages("rpart")
library(rpart)

# Specify quality as the outcome (dependent) variable and use all other features for predictors
pdg.rpart <- rpart(IRR ~ ., data = pdg.train)

# Easier to visualize the nodes
# install.packages("rpart.plot")
library(rpart.plot)

rpart.plot(pdg.rpart, digits = 2) # The regression tree overemphasizes the larger characteristics

# Many control options for a more detailed tree
rpart.plot(pdg.rpart, digits = 4, fallen.leaves = TRUE, type = 3, extra = 101)

# Evaluating model performance using predict()
p.pdg.test.rpart <- predict(pdg.rpart, pdg.test)

pdg.test$p.IRR <- p.pdg.test.rpart

NQ.lm <- lm(Lionshare.JPM.Data.03282014$Chg_IRR ~ Lionshare.JPM.Data.03282014$NQ_Available, weights = Lionshare.JPM.Data.03282014$plan,
            subset = Lionshare.JPM.Data.03282014$Change_To_IRR >= (summary(Lionshare.JPM.Data.03282014$Change_To_IRR)["1st Qu."] - IQR(Lionshare.JPM.Data.03282014$Change_To_IRR) 
                          & 
              + Lionshare.JPM.Data.03282014$Change_To_IRR <= (summary(Lionshare.JPM.Data.03282014$Change_To_IRR)["3rd Qu."] + IQR(Lionshare.JPM.Data.03282014$Change_To_IRR)))
            + )

NQ.lm <- lm((Lionshare.JPM.Data.03282014$End_IRR - Lionshare.JPM.Data.03282014$Begin_IRR) / Lionshare.JPM.Data.03282014$Begin_IRR ~ Lionshare.JPM.Data.03282014$NQ_Available,
              weights = Lionshare.JPM.Data.03282014$plan)






# Estimating the quality of wines with regression trees and model trees
setwd("H:\\Stuff\\R\\r-tutorial-src\\Machine_Learning_with_R\\2148OS_code\\")

# All data is numeric so we can skip the stringsAsFactors
wine <- read.csv("chapter 6\\whitewines.csv")

# Build a histogram to determine if wine is bimodal, either very good or very bad,
# which could cause problems for our model
hist(wine$quality) # Relatively normal distribution centering between 5 and 6, which should be expected

# Set up training and test data sets
# Modeling Cortez study by using 75% train, 25% test
wine_train <- wine[1:3750, ]
wine_test <- wine[3751:4898, ]

# Need the recursive partitioning package
install.packages("rpart")
library(rpart)

# Specify quality as the outcome (dependent) variable and use all other features for predictors
m.rpart <- rpart(quality ~ ., data = wine_train)

# Easier to visualize the nodes
install.packages("rpart.plot")
library(rpart.plot)

rpart.plot(m.rpart, digits = 3)

# Many control options for a more detailed tree
rpart.plot(m.rpart, digits = 4, fallen.leaves = TRUE, type = 3, extra = 101)

# Evaluating model performance using predict()
p.rpart <- predict(m.rpart, wine_test)

# Model is predicting well between Q1 and Q3, where Q1p = 5.563 and Q1a (actual) = 5.00, Q3p = 6.202 and Q3a = 6.00
# Extremes are getting lost, though: Min Predict = 4.545 versus Actual 3.00, Max Predict = 6.597 versus actual = 9.0
# A simple correlation compares how well the model is predicting quality
# While .54 is acceptable, the correlation only measures how strongly the predictions are related to the true
# value; not a measure of how far off the predictions were from the true values
cor(p.rpart, wine_test$quality) # 0.536925

# Measuring performance with mean absolute error
# Better way to see how far off the prediction is to see how far off, on average, 
# the prediction was from the true value, called MEAN ABSOLUTE ERROR (MAE).
# Essentially the formula takes the mean of the absolute values of the errors, a
# function we can write ourselves.
MAE <- function(actual, predicted) {
  mean(abs(actual - predicted))
}

# Value indicates, on average, our predictions are off by 0.59 points in quality,
# pretty good, but not great.
MAE(p.rpart, wine_test$quality) # returns 0.59

# What's the mean quality of our training wines, anyway?
mean(wine_train$quality) # 5.87

# If we predicted 5.87 for all test wines we'd have a MAE of 0.67,
# which comes really close to our tree's 0.59 predicted MAE
MAE(mean(wine_train$quality), wine_test$quality) # 0.67

# IMPROVING model performance
# The Cortez study reported MAEs of 0.58 for the neural network model and
# 0.45 for a support vector machine, which means we can improve our model.
# Building a model tree, which replaces leaf nodes with regression models.
install.packages("RWeka")
library(RWeka)

# M5-prime (M5') algorithm acknowledged as state-of-the-art for model trees
# Dependent on Java, which as of 8/20/14 will not load correctly. FIXED by
# running update of TechHub apps.

m.m5p <- M5P(quality ~ ., data = wine_train) # Tree is very big

# Running a summary of the model tree to see how well the stats fit
# the training data. Just a rough diagnostic, though, since based on 
# the training data, not all of the data!
summary(m.m5p)

# Let's run the model on the TEST data with the predict() function
p.m5p <- predict(m.m5p, wine_test)
summary(p.m5p)

# Let's compare this model's results to the previous:
# MODEL     MIN    1Q     MEDIAN  MEAN     3Q     MAX
# p.rpart  4.545  5.563   5.971   5.893   6.202  6.597
# p.m5p    4.389  5.430   5.863   5.874   6.305  7.437

# Proof that wine quality is 1) tough to predict and 2) incredibly subjective
# While the model tree had wider extreme values, it still falls short.
# What does a correlation say?
cor(p.m5p, wine_test$quality) # 0.6272973

# Has the mean absolute error (MAE) improved?
MAE(wine_test$quality, p.m5p) # 0.5463023, which is better than the linear regression model's 0.59

# Chapter 7 Black Box Methods -- Neural Networks and Support Vector Machines
# Referred to as "black box" because the mechanism that transforms the input
# into the output is obfuscated by a figurative box. This black box in machine
# learning is because the underlying models are based on complex mathematical
# systems and the results are dificult to interpret.
# 
# Neural network use concepts borrowed from an understanding of human brains in
# order to model arbitrary functions. Support Vector Machines use multidimensional
# surfaces to define the relationship between features and outcomes. 
# 
# An Artificial Neural Network (ANN) models the relationship between a set of
# input signals and an output signal using a model derived from our understanding
# of how a biological brin responds to stimuli from sensory inputs. Much like a
# brain the ANN uses a network of artificial neurons or NODES to solve learning
# problems.
# 
# ANNs are best applied to problems where the input data and output data are
# well-understood or at least fairly simple, yet the process that relates the input
# to output is extremely complex.
# 
# Neural networks are characterized by the following characteristics:
#   
# * An activation function, which transforms a neuron's net input signal into
#   a single output signal to be broadcasted further in the network
# * A network topology (or architecture), which describes the number of neurons
#   in the model as well as the number of layers and manner in which they are
#   connected
# * The training algorithm that specifies how connection weights are set in order
#   to inhibit or excite neurons in proportion to the input signal

# Test the strength of concrete
setwd("C:\\R\\Data\\Packt\\")

# Step 2: Exploring and preparing the data
# All data is numeric so we can skip the stringsAsFactors
concrete <- read.csv("chapter 7\\concrete.csv")

str(concrete)

summary(concrete)

# Neural networks work best when the input data are scaled to a narrow
# range around zero, and here the values range from zero to over a 1000
# We defined a minmax normalization function earlier; let's uses it
# on this data
# TIP: Always keep the original data because after analysis the data
# has to be reverted to original form
concrete.norm <- as.data.frame(lapply(concrete, normalize))

summary(concrete.norm)

# Partition the original data into 75% training and 25% test
concrete.train <- concrete.norm[1:773, ]
concrete.test <- concrete.norm[774:1030, ]

# Train the data using the NEURALNET package. The NNET package
# ships with the standard R installation and is slightly more
# sophisticated
install.packages("neuralnet")
library(neuralnet)

# Step 3: Start by training the simplest multilayer feedforward network
# with only a single hidden node:
concrete.model <- neuralnet(strength ~ cement + slag + ash + water + superplastic + coarseagg + fineagg + age, data = concrete.train)

# Plot the network topology
plot(concrete.model) # One input node for each of the eight features, followed by a single hidden node and a single output node predicting concrete strength

# The weight for each of the connections is also visualized, as are the bias terms (signified by 1 in a circle)
# The Sum of Squared Errors is also reported as Error: along with the number of training steps (Steps), which
# will be useful when evaluating the model performance

# Step 4: Evaluating model performance
# The topology diagram peeks into the black box of the ANN but doesn't give us much
# about the performance of the model or how well it fits our data. We use COMPUTE() for this:
model.results <- compute(concrete.model, concrete.test[1:8])

# Compute works differently than predict; it returns a list with two components: $neurons,
# which stores the neurons for each layer in the network, and $net.result, which stores the
# predicted values, which is what we want to see:
predicted.str <- model.results$net.result

# Use a correlation between predicted concrete strength and the true value, which
# provides an insight into the strength of the linear association between the two variables.
cor(predicted.str, concrete.test$strength)[, 1] # 0.8063; closer to 1 the better in terms of match

# Neural networks with a single hidden node can be thought of as a distant cousin of the linear
# regression models from Chapter 6. The weight between each input node and the hidden node is similar
# to the regression coefficients, and the weight for the bias term is similar to the intercept.

# Step 5: Improving model performance
# Increase the numberof hidden nodes to five by modifying the hidden parameter
concrete.model.five <- neuralnet(strength ~ cement + slag + ash + water + superplastic + coarseagg + fineagg + age, data = concrete.train, hidden = 5)

plot(concrete.model.five)

# Note the reported SSE has been reduced from 5.08 to 1.59 and training Steps up to 29,254 from 4,748
# Let's test the model again
model.results.five <- compute(concrete.model.five, concrete.test[1:8])

# Compute works differently than predict; it returns a list with two components: $neurons,
# which stores the neurons for each layer in the network, and $net.result, which stores the
# predicted values, which is what we want to see:
predicted.str.five <- model.results.five$net.result

# Use a correlation between predicted concrete strength and the true value, which
# provides an insight into the strength of the linear association between the two variables.
cor(predicted.str.five, concrete.test$strength)[, 1] # 0.9254; closer to 1 the better in terms of match

# Understanding Support Vector Machines
# An SVM is an imagined surface that defines a boundary between various points of data
# that represent examples plotted in multidimensional space according to their feature
# values. The goal of an SVM is to create a flat boundary called a hyperplane, which leads
# to fairly homogeneous partitions of data on either side similarly to the instance-based
# lazy learning presented in Chapter 3 and linear regression, representing an extremely
# powerful combination which allows for modeling highly complex relationships.
# 
# SVMs are most easily understood when used for binary classification but the same
# principles can be adapted to other learning tasks such as numeric prediction.

# Classification with hyperplanes
# The task of the SVM algorithm is to identify a line that separates two classes, noting
# that the hyperplane is traditionally depicted as a line in 2D space. When there's more
# than one choice in dividing line between two groups, how does the algorithm choose?
# 
# Finding the maximum margin
# The answer is the algorithm search for the Maximum Margin Hyperplane (MMH) that creates
# the greatest separation between the two classes.

# Using SVMs with Optical Character Recognition (OCR)
# Step 1: Collecting data
letters <- read.csv("chapter 7\\letterdata.csv")

str(letters)

# SVM learners require all features to be numeric and that each feature is scaled to a
# fairly small interval. All features are integers in this data, so we don't need to
# convert any factors into numbers. But some of these ranges are pretty wide, which
# would normally need to be normalized as we've done before, but the package we'll
# be using will rescale the data for us. We can go directly to building the model
# because this data has already been randomized
letters.train <- letters[1:16000, ]
letters.test <- letters[16001:20000, ]

# Step 3: Training a model on the data
install.packages("kernlab")
library(kernlab)

letter.classifier <- ksvm(letter ~ ., data = letters.train, kernel = "vanilladot") # Takes time; doesn't say much about how model works

# Step 4: Evaluating model performance
letter.predictions <- predict(letter.classifier, letters.test) # defaults type = "response"

# Returned a vector containing a predicted letter for each row of values in the test data
# Look at the beginning of the data...
head(letter.predictions)

# How did the prediction work?
table(letter.predictions, letters.test$letter)

# While the table is cool, what's the actual number correct?
agreement <- letter.predictions == letters.test$letter # Create a logical matrix to determine where matches were made

table(agreement) # Quick table showing how many were right in total; 3357 right and 643 wrong

prop.table(table(agreement)) # Almost 84% correct

# Step 5: improving model performance
# Using a more complex kernel function to map the data into a higher dimensional space
letter.classifier.rbf <- ksvm(letter ~ ., data = letters.train, kernel = "rbfdot")


# Step 4: Evaluating model performance
letter.predictions.rbf <- predict(letter.classifier.rbf, letters.test) # defaults type = "response"

# Returned a vector containing a predicted letter for each row of values in the test data
# Look at the beginning of the data...
head(letter.predictions.rbf)

# How did the prediction work?
table(letter.predictions.rbf, letters.test$letter)

# While the table is cool, what's the actual number correct?
agreement.rbf <- letter.predictions.rbf == letters.test$letter # Create a logical matrix to determine where matches were made

table(agreement.rbf) # Quick table showing how many were right in total; 3725 right and 275 wrong

prop.table(table(agreement.rbf)) # Almost 93% correct

# Chapter 8: finding Patterns -- Market Basket Analysis Using Association Rules
# In years past, recommendation systems were based on subjective experience of marketing
# professionals and inventory managers or buyers. Machine learning is now used to learn
# these purchasing behaviors. These methods are to identify associations among items in
# transactional data, known as market basket analysis.
# 
# Understanding association rules
# Association rules are the result of a market basket analysis that specifies the
# patterns of relationships among items. For example, if peanut butter and jelly 
# are purchased, then bread is also likely to be purchased. Groups of one or more items
# are surrounded by brackets to indicate they form a set, also called an ITEMSET, that
# appears in the data with some regularity. Association rules are learned from subsets
# of itemsets.
# 
# Association rules are not used for prediction, but rather for unsupervised knowledge
# discovery in large databases. Because association rule learners are unsupervised, there
# is no need for the algorithm to be trained; data does not need to be labeled ahead of
# time. Association rules are helpful for finding patterns in lots of different types
# of data, such as: searching for intersting and frequently occurring patterns of DNA
# and protein sequences in cancer data; patterns of purchases or medical claims that
# occur with fraudulent credit card of insurance use; identifying combinnations of behavior
# that precede customers dropping their cell service or upgrading their cable TV package.
# 
# The complexity of transactional data makes association rule mining a challenge. A retailer
# that sells only 100 different items could have about 2 ^ 100 itemsets that a learner would
# have to evaluate. The most-widely used heuristic learning approach for searching large
# databases for rules is Apriori (prior knowledge). The Apriori property says that all subsets
# of a frequent itemset must also be frequent; so, motor oil and lipstick can only be frequent
# if BOTH motor oil and lipstick are frequent. If not, then any set containing either of these
# can be excluded from the search.
# 
# Measuring rule interest -- support and confidence
# Whether or not an association rule is deemed interesting is determined by two statistical
# measures: support and confidence. Support of an itemset or rule measures how frequently it
# occurs in the data. A rule's confidence is a measure of its predictive power or accuracy,
# defined as the support of the itemset containing both X and Y divided by the support of the
# itemset containing only X. (See similarities with naive Bayes?)
# 
# The first phase of creating rules is to iterate through the itemset combinations to create
# increasingly large itemsets. For instance, iteration 1 involves evaluating the set of 1-item
# itemsets, iteration 2 through all 2-item itemsets, etc.

# Identifying frequently purchased groceres with association rules
# Step 1 collecting data
# Can't just read in the CSV file because a dataframe would not represent each purchase correctly.
# Need a sparse matrix similar to the naive Bayes earlier. A dataframe or standard data structure
# would quickly become too large to fit into memory.
setwd("c:\\R\\Data\\Packt")
install.packages("arules")
library(arules)

groceries <- read.transactions("Chapter 8\\groceries.csv", sep = ",")

summary(groceries) # Density value of 0.02609 says we sold 43,367 items (9835 rows * 169 cols * 0.02609)
# The average purchase was 4.409 items (43,367 items / 9,835 purchases)
# Whole milk was in about 26% of purchases (2,555 / 9,835)
# 22% of purchases were of 1 item; 62% of purchases were 1-4 items

# To review the SPARSE matrix we made, use INSPECT()
inspect(groceries[1:10]) # Shows the first 10 transactions

# To review individual row and columns...
itemFrequency(groceries[ , 1:8]) # Item frequency of cols 1-3; items are in alpha order!
# Beef is in 5.2% of all transactions, whereas baby food is in 0.01%

# Visualizing item support with item frequency plots
itemFrequencyPlot(groceries, support = 0.1) # Plot items with 10% support

# Can also show by the topX number of items
itemFrequencyPlot(groceries, topN = 10) # Plot items in the top 10 of support %

# Visualizing transaction data--plotting the sparse matrix
image(groceries[1:5]) # Can help ID data errors, say if an item is in every purchase maybe it's not a real item but an ID number

# Sorting the data by date might reveal seasonal effects in the numbers and/or types of items purchased
# This is helpful in smaller data sets, but use SAMPLE() for a randomly sampled set of transactions from
# a larger data set, say 100 from the groceries set:
image(sample(groceries, 100))

# Step 3: training a model on the data
# There can be a fair amount of trial and error when finding support and confidence parameters
# to produce a reasonable number of association rules. If levels are set too high, you might find
# no rules or rules that are too generic to be useful. Set a treshold too low and the number of
# rules gets out of control or the operation takes too long to run and/or runs out of memory during
# the learning phase. Let's first look at the defaults for the groceries.
apriori(groceries) # Defaults of 10% support and 80% confidence; an item had to be in 10% of 9835 purchases!

# Consider the minimum number of transactions to consider a pattern interesting; is a purchase 2x a day worth it?
# 2x a day in 30 days of data = 60 times; 60 of 9835 = 0.006; let's try that. Appropriate confidence level
# depends on the goals of the analysis; starting conservatively lets you reduce them to broaden the search
# if you aren't finding actionable intelligence. Let's go to 0.25, or that the rule has to be right 25% of the time.
groceryrules <- apriori(groceries, parameter = list(support = 0.006, confidence = 0.25, minlen = 2)) # MINLEN = how many transactions the item is in minimally

# Produced 463 rules, but are any of them helpful?
summary(groceryrules) # LIFT is a measure of how much more likely one item is to be purchased relative to its typical purchase rate
# given that you know another item has been purchased. A large lift value (greater than 1) is a strong indicator that a rule is
# important, a reflects a true connection between the items.
# We can again INSPECT the rules
inspect(groceryrules[1:10]) # First rule says 'if a customer buys potted plants they will also buy whole milk.'
# This rule covers 0.7% of all transactions, and is correct in 40% of purchases involving potted plants. But
# does this actually make sense?

# A common approach is to classify the result of learning association rules and divide them into three categories:
# Actionable, Trivial, and Inexplicable. Actionable rules provide a clear and useful insight. Trivial rules are so
# obvious they aren't worth mentioning; clear but not useful. If you reported diapers and formula as an important rule
# you'd be laughed out of the room. Inexplicable rules are when the connection between the items is so unclear
# that figuring out how to use the information would require additional research. The best rules are hidden gems, 
# undiscovered insight into patterns that seem obvious once discovered.

# Step 5: improving model performance
# We can sort the rules to reorder them by quality, for example. Use the by parameter of "support", "confidence",
# or "lift".
inspect(sort(groceryrules, by = "lift")[1:10]) # Defaults to decreasing, largest first; set DECREASING = FALSE to change this

# We can subset the rules. For example, marketing wants to push berries because they're in season.
berryrules <- subset(groceryrules, items %in% "berries") # items %in% c("berries", "yogurt") is also workable

inspect(berryrules) # Berries are purchased with whipped/sour cream and yogurt; tied to breakfast or lunch?

# SUBSET() very powerful. ITEMS keyword matches an item appearing anywhere in the rule. To limit subset to 
# where the match occurs only on the left- or right-hand side use LHS or RHS instead. The %IN% operator means
# that least one of the items must be found in the defined list. %PIN% is a partial match operator; %AIN% is a 
# complete (all) match. Subsets can be limited by support, confidence or lift, such as confidence > 0.50.
# Matching criteria can be combined with standard R logical operators.

# Rules can be written to a CSV file
write(groceryrules, file = "groceryrules.csv", quote = TRUE, row.names = FALSE, sep = ",")
write(groceryrules, file = "groceryrules.csv")


groceryrules.df <- as(groceryrules, "data.frame") # This forces an object to belong to a class
# Does this work the same way?
groceryrules.df <- as.data.frame(groceryrules) # No, this doesn't work

# Chapter 9: Finding groups of data -- clustering with k-means
# Stereotypes are dangeous to apply to individuals--no two people are exactly alike. Used
# in aggregate, however, the labels may reflect some underlying pattern of similarity among
# the individuals falling within the group. Clustering works in a process very similar to
# observational research. Clustering is an unsupervised machine learning task that automatically
# divides the data into clusters, or groupings of similar items. It does this without having been
# told what the groups should look like ahead of time. As we may not even know what we're looking
# for, clustering is used for knowledge discovery rather than prediction. It provides an insight into
# the natural groupings found within data. Clustering is guided by the principle that records inside
# a cluster should be very similar to each other, but very different from those outside. The basic
# idea is always the same: group the data such that related elements are placed together. Clustering
# is useful whenever diverse and varied data can be exemplified by a much smaller number of groups.
# It results in meaningful and actionable structures within data that reduce complexity and provide
# insight into patterns of relationships.
# 
# Clustering creates new data. Unlabled examples are given a cluster label and inferred entirely from
# the relationships within the data. For this reason, you will sometimes see the clustering task referred
# to as unsupervised classification because, in a sense, this is classifying unlabeled examples. CLUSTERING
# WILL TELL YOU WHICH GROUPS OF EXAMPLES ARE CLOSELY RELATED--FOR INSTANCE, IT MIGHT RETURN GROUPS A, B, 
# AND C-- BUT IT'S UP TO YOU TO APPLY AN ACTIONABLE AND MEANINGFUL LABEL.
# 
# Unlike decision trees and rules, which would provide us with a clean rule like "if the scholar has few
# math publications, then s/he is a computer science expert", we do not know the true class value for 
# each point, so we cannot deploy supervised learning algorithms. If you begin with unlabeled data, you 
# can use clustering to create class labels. From there, you could apply a supervised learner such as 
# decision trees to find the most important predictors of these classes, known as semi-supervised
# learning.
# 
# If k-means sounds familiar, it is. Recall the kNN lazy learning algorithm from before; similarities
# are very high. K-means starts with an initial guess for the cluster assignments and then modifies
# the assignments slightly to see if the changes improve the homogeneity within the clusters. K-means
# works in two phases; first, it assigns examples to an initial set of k clusters. Then it updates
# the assignments by adjusting the cluster boundaries according to the examples that currently fall into
# the cluster. The process of updating and assigning occurs several times until making changes no longer
# improves the cluster fit.
# 
# Because k-means uses distance calculations ALL DATA MUST BE NUMERIC, similar to lazy learning from
# Chapter 3. Centroids are the mathematical mean of each cluster, which are adjusted after the initial 
# assignment of means based on the number of clusters, k. Choosing the number of clusters requires a
# delicate balance. You might have some idea, a prior belief (a priori), about the true groupings, and 
# can begin applying k-means using this information. Sometimes the clusters are dictated by business
# requirements or the motivation for the analysis. If there's no a priori knowledge, a RULE OF THUMB 
# SAYS TO SET K EQUAL TO THE SQUARE ROOT OF (N / 2), WHERE N = THE NUMBER OF EXAMPLES IN THE DATASET.
# This might result in an unwieldly number of clusters for large datasets. A technique called THE ELBOW
# METHOD attempts to gauge how the homogeneity or heterogeneity within the clusters changes for various
# values of k. The purpose is to find k such that there are diminishing returns beyond that point. 
# Sometimes working with setting the value of k can lead to interesting insights; don't worry about getting
# k exactly right.

# The following data is based on 30000 US high school students who had profiles on a well-known social network
# in 2006 (MySpace?). Data was sampled evenly across four high school graduation years, 2006 through 2009, and a
# text mining tool was used to divide the SNS page content into words. 36 words were chosen to represent five
# categories of interests, namely extracurricular activities, fashion, religion, romance, and antisocial behavior.
setwd("c:\\R\\Data\\Packt")

teens <- read.csv("Chapter 9\\snsdata.csv")

str(teens) # GENDER contains NA; oops, there's missing values

# Let's look further into GENDER by tabling the data
table(teens$gender) # Where's the NA count?

# Right here
table(teens$gender, useNA = "ifany") # 2,724 NAs or 9%

# 4x as many females as males; might indicate males are less inclined to use SNS
summary(teens)

# AGE has 5,086 missing values, too, and min of 3.086 and max of 106.927 are concerning
# Let's clean up the AGE data by assigning age based on birthday
teens$age <- ifelse(teens$age >= 13 & teens$age < 20, teens$age, NA)

# This creates a bit of a larger problem, though, as we have to fix the 5,523 NAs
# We could dump all complete records, but this would result in losing 26% of the data
# based on two missing variables. Let's dummy code a FEMALE variable:
teens$female <- ifelse(teens$gender == "F" & !is.na(teens$gender), 1, 0) # If GENDER is female put a 1 and not missing
teens$no.gender <- ifelse(is.na(teens$gender), 1, 0) # If GENDER is NA then put a 1

table(teens$gender, useNA = "ifany") # 22,054 F, 5,222 M, 2,724 NA
table(teens$female, useNA = "ifany") # 7,946 Zeros, 22,054 1s = correct
table(teens$no.gender, useNA = "ifany") # 27276 Zeros, 2,724 1s = correct

# Imputing missing values
# Let's fix the missing ages by calculating age based on birthday
mean(teens$age, na.rm = TRUE) # Average age is 17.25

# How can we calculate the average age of each class? AGGREGATE()
aggregate(data = teens, age ~ gradyear, mean, na.rm = TRUE)

# This is human-readable but requires extra work to merge back into the original data
# The AVE() function returns a vector with the group means repeated such that the result
# is equal in length to the original vector:
ave.age <- ave(teens$age, teens$gradyear, FUN = function(x) mean(x, na.rm = TRUE))

# Drop this vector back onto our original data with another IFELSE()
teens$age <- ifelse(is.na(teens$age), ave.age, teens$age)

# Now how do the ages look?
summary(teens$age) # Min now 13.03, max 20.0

# Data is fixed so let's start looking at clusters with the KMEANS() function
# in the base STATS package. We'll use only the 36 features that represent the 
# number of times various interests appeared in the SNS profiles of teens. These
# features can be found in columns 5-40.
interests <- teens[5:40]

# We want to normalize the data in these interests because we don't know whether
# 3 mentions of football is a lot or a little compared to peers. We'll do this
# with the SCALE() function and LAPPLY(). We coerce the returned matrix from lapply
# into a dataframe.
interests.z <- as.data.frame(lapply(interests, scale))

# To help classify these high schoolers, let's use the creative genius of John
# Hughes from Breakfast Club's five stereotypes: Brain, Athlete, Basket Case,
# Princess and Criminal. Thus, 5 clusters.
teen.clusters <- kmeans(interests.z, 5)

# Find the size of each cluster by checking the size attribute
teen.clusters$size # One huge cluster but none with 1; let's look deeper

teen.clusters$centers

# Turn the clusters into actionable information by applying the clusters
# back onto the original dataset.
teens$cluster <- teen.clusters$cluster

# Which cluster has each teen been assigned to?
teens[1:5, c("cluster", "gender", "age", "friends")]

# Does anything stand out by aggregating the ages of the clusters?
aggregate(data = teens, age ~ cluster, mean) # Not much difference

# What about gender?
aggregate(data = teens, female ~ cluster, mean) # Princesses in cluster 3 @ 87%? Only 41% female in cluster 5 (criminals)

# Does gender say anything about # of friends?
aggregate(data = teens, friends ~ cluster, mean) # C1: 30.4, C2: 41.4, C3: 36.9, C4: 27.7, C5: 33.7

# 2014 PDG experiment
pdg <- read.csv("c:\\R\\Data\\PDG2014.csv", header = TRUE, stringsAsFactors = FALSE)

# Only use the Main plans
pdg.main <- subset(pdg, ClientMO == "Main")
pdg.main <- pdg

# Convert Segment into a dummy numeric variable
pdg.main$segment.nbr <- ifelse(pdg.main$Segment == "Core", 0, ifelse(pdg.main$Segment == "Large", .5, 1))

# Add the Generosity ratio; might consider a dummy variable of low, medium and high, too
pdg.main <- transform(pdg.main, gen.ratio = Employer_Sum / Employee_Sum)

pdg.main.stats <- pdg.main[c(9, 20:99)] # Use only the numerics; cut out-of-scale values like Employer/Employee contributions that skew size

pdg.main.stats$Nbr.of.Investments <- scale(pdg.main.stats$Nbr.of.Investments)
pdg.main.stats$Nbr.of.Investments <- normalize(pdg.main.stats$Nbr.of.Investments) # MINMAX function for investments
# pdg.stats$Employee_Sum <- scale(pdg.stats$Employee_Sum)
# pdg.stats$Employer_Sum <- scale(pdg.stats$Employer_Sum)


pdg.clusters <- kmeans(pdg.main.stats, 4)

pdg.clusters$size

pdg.clusters$centers

centers <- as.data.frame(t(pdg.clusters$centers))

pdg.main$cluster <- pdg.clusters$cluster

write.csv(pdg, "c:\\R\\Data\\PDGclusterSegment.csv", row.names = FALSE)
write.csv(centers, "c:\\R\\Data\\PDGcentersSegment102814.csv", row.names = TRUE)

# Weighted by participating eligibles
pdg.weighted <- read.csv("c:\\R\\Data\\PDGWeighted.csv", header = TRUE, stringsAsFactors = FALSE)

pdg.weighted.stats <- pdg.weighted[9:87]

pdg.weighted.stats.norm <- as.data.frame(scale(pdg.weighted.stats))

pdg.weighted.clusters <- kmeans(pdg.weighted.stats.norm, 2)

pdg.weighted.clusters$size

# Number of investments changing prediction based on 1, 3, and 5-year PROR data
# Logistic regression using the CLEANDATA set of 1.194 million records
# Does changing # of investments have a material difference on PROR?
# Can number of investments predict whether they'll change again?
# Consider MINMAX to standardize data

# First, set up the data for use by pulling the "best" columns
# Current: EquityInvPct, TargetDtPct, BrkgPct, Salary, Balance, BrkgBal, Age, NbrInvestments
# One year ago: EqtyPctOneYrAgo, TDFPctOneYrAgo, oneyr_ivst_ct
# Three years ago: EqtyPctThreeYrsAgo, TDFPctThreeYrsAgo, threeyr_ivst_ct
# Five years ago: EqtyPctFiveYrsAgo, TDFPctFiveYrsAgo, fiveyr_ivst_ct
# PROR: FiveYrPROR, ThreeYrPROR, OneYrPROR

# Pull the data from the script PROREffectByInvs.R, which creates the CLEANDATA set
base <- cleandata[ , c("PlanNbr", 
                       "SSN",
                       "EquityInvPct",
                       "TargetDtPct",
                       "BrkgPct",
                       "Salary",
                       "Balance",
                       "BrkgBal",
                       "Age",
                       "AgeCohort",
                       "NbrInvestments",
                       "EqtyPctOneYrAgo",
                       "TDFPctOneYrAgo",
                       "oneyr_ivst_ct",
                       "EqtyPctThreeYrsAgo",
                       "TDFPctThreeYrsAgo",
                       "threeyr_ivst_ct",
                       "EqtyPctFiveYrsAgo",
                       "TDFPctFiveYrsAgo",
                       "fiveyr_ivst_ct",
                       "FiveYrPROR",
                       "ThreeYrPROR",
                       "OneYrPROR")]

# Document the changes between 5, 3, 1 and current # of investments
base$chg12 <- ifelse(base$NbrInvestments - base$oneyr_ivst_ct 
base$chg36 <- base$oneyr_ivst_ct - base$threeyr_ivst_ct
base$chg60 <- base$threeyr_ivst_ct - base$fiveyr_ivst_ct
base$totalchg <- base$chg12 + base$chg36 + base$chg60

# Slightly more than 20% of all participants made NO changes in five years as measured by these counts
length(subset(base$SSN, base$chg12 == 0 & base$chg36 == 0 & base$chg60 == 0)) / nrow(base) # 20.5%

mean(subset(base$FiveYrPROR, !is.na(base$chg12 + base$chg36 + base$chg60) > 0, na.rm = TRUE)) # 13.18 5-year PROR
mean(subset(base$FiveYrPROR, base$chg12 == 0 & base$chg36 == 0 & base$chg60 == 0, na.rm = TRUE), na.rm = TRUE) # 13.26 5-year PROR

# Let's cut the ridiculous 1-year rates of return by trimming the data with IQR
# lowIQR gets the 4th item in the summary function, which is MEAN
lowIQR <- summary(base$OneYrPROR)[4] - (1.5 * IQR(base$OneYrPROR))
hiIQR <- summary(base$OneYrPROR)[4] + (1.5 * IQR(base$OneYrPROR))

# Now we trim out the LOW and HIGH 1-year PRORs and go from 1,199,140 to 1,015,296, cutting 15% of the records
newbase <- subset(base, base$OneYrPROR >= lowIQR & baseOneYrPROR <= hiIQR)

summaryPROR <- summary(newbase$OneYrPROR)

# There are NAs in some of the 1-year investment counts so let's cut those records, too
newbase.x <- subset(newbase, !is.na(oneyr_ivst_ct)) # Down to 1,013,959 records

newbase.x$chg12 <- as.factor(ifelse(newbase.x$NbrInvestments != newbase.x$oneyr_ivst_ct, "Different", "Same"))
                     
chg.inv.pror.table <- table(newbase.x$chg12, newbase.x$OneYrPROR)

# Plot the results table
plot(colnames(chg.inv.pror.table), chg.inv.pror.table["Different", ] / (chg.inv.pror.table["Different", ] + chg.inv.pror.table["Same", ]),
     xlab = "1-Year PROR", ylab = "Percent Change")

# Cut all NA values
newbase.x <- newbase.x[!is.na(newbase.x$Age) & !is.na(newbase.x$OneYrPROR) & !is.na(newbase.x$Balance), ]
                     

# Classify PROR by a nominal value
newbase.x$OneYrPROR.class <- ifelse(newbase.x$OneYrPROR <= 11.02, "-3SD",
                                    ifelse(newbase.x$OneYrPROR <= 15.06, "-2SD",
                                           ifelse(newbase.x$OneYrPROR <= 19.1, "-1SD",
                                                  ifelse(newbase.x$OneYrPROR <= 23.14, "+1SD",
                                                         ifelse(newbase.x$OneYrPROR <= 27.18, "+2SD", "+3SD")))))

# Normalize Age, PROR, and Balance
newbase.x$Age.trans <- normalize(newbase.x$Age)
newbase.x$OneYrPROR.trans <- normalize(newbase.x$OneYrPROR)
newbase.x$Balance.trans <- normalize(newbase.x$Balance)
                     
chg.inv.mdl <- glm(chg12 ~ OneYrPROR.trans + Age.trans + Balance.trans, newbase.x, family = "binomial" (link = logit))

summary(chg.inv.mdl)

chg.prob <- function(y) {
  eta <- chg.inv.mdl$coefficients[1] + chg.inv.mdl$coefficients[2] * y
  1 / (1 + exp(-eta))
}

plot(colnames(chg.inv.pror.table), chg.inv.pror.table["Different", ] / (chg.inv.pror.table["Different", ] + chg.inv.pror.table["Same", ]),
                          xlab = "1-Year PROR", ylab = "Percent Change")
# lines(lowIQR:hiIQR, chg.prob(lowIQR:hiIQR), new = TRUE)
lines(8:29, chg.prob(8:29), new = TRUE)                    