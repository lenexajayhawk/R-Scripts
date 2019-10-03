# Script: ROL comment classification

# Started: August 20, 2014

# Purpose: Classify comment as Angry/Not Angry--indicate low satisfaction?

# Data:   August 20, 2014: C:\R\Data\All_ROL.csv (survey results between 2007 and 2012)
# Version:
#         1.0: Initial data pull and classification; not the best data, as clean data wiped out more than 1500 responses that were primarily NA

##### Begin Libraries #####
# install.packages("tm")
library(tm)
# Build a wordcloud to visually depict word frequency
# install.packages("wordcloud")
library(wordcloud)
# Data can be represented by statistical model. In this case,
# we'll use naive Bayes against the presence or absence of words
# to estimate the probability that an SMS message is spam or ham.
# Using the e1071 package, though there are many other functionally
# equivalent packages such as klaR.
# install.packages("e1071")
library(e1071)
library(gmodels)
##### End Libraries #####


# Set the working directory
setwd("C:\\R\\Data\\")

# Need to process the raw data for analysis by transforming into a bag-of-words
# Import the CSV file
rol_raw <- read.csv("All_ROL.csv", stringsAsFactors = FALSE)

# Raw data is not randomly ordered, so let's fix that
set.seed(23456) # other seeds(12345, 23456, 34567)
rol_raw <- rol_raw[order(runif(nrow(rol_raw))), ]

# Clean up data: what don't we need to do this analysis?
# Keep scores, comments, and Constructive indicator
rol_clean <- rol_raw[10:19]

# Convert Constructive to a factor
rol_clean$Constructive <- factor(rol_clean$Constructive)

table(rol_clean$Constructive) # N = 526, Y = 1500


# Create a CORPUS, which refers to a collection of documents. In this case, a text
# document refers to a single ROL comment
# CORPUS creates an R object to store the text documents
# VECTORSOURCE tells CORPUS to use the messages in the TEXT vector
rol_corpus <- Corpus(VectorSource(rol_clean$Comment))

# PRINT(corpusname) tells us how many items are in the corpus
# INSPECT(corpusname) lets us inspect within the corpus
inspect(rol_corpus[1:3])

# Need to clean up each text and remove punctuation and other clutter characters
# For example, need HELLO, hello! and Hello to be treated identically
# Convert all messages to lowercase and remove numbers
rol_corpus_clean <- tm_map(rol_corpus, tolower)
rol_corpus_clean <- tm_map(rol_corpus_clean, removeNumbers)

# Remove stop words like to, and, but and or; get rid of punctuation, too
rol_corpus_clean <- tm_map(rol_corpus_clean, removeWords, stopwords())
rol_corpus_clean <- tm_map(rol_corpus_clean, removePunctuation)

# Remove extra whitespace
rol_corpus_clean <- tm_map(rol_corpus_clean, stripWhitespace)

# Data processed to our liking; now need to segment
# individual components through tokenization where
# a token = single element of text string; in our case
# a token = word; create a sparse matrix
# This will let us perform analyses involving word frequency
rol_dtm <- DocumentTermMatrix(rol_corpus_clean)

# Define the counts for our TRAIN and TEST data sets
trainct <- round(nrow(rol_clean) * .75)
testct <- trainct + 1

rol_clean_train <- rol_clean[1:trainct, ]
rol_clean_test <- rol_clean[testct:nrow(rol_clean), ]

rol_dtm_train <- rol_dtm[1:trainct, ]
rol_dtm_test <- rol_dtm[testct:nrow(rol_dtm), ]

rol_corpus_train <- rol_corpus_clean[1:trainct]
rol_corpus_test <- rol_corpus_clean[testct:length(rol_corpus_clean)]

# Are the proportions of HAM and SPAM similar across TRAINING and TEST? Pretty good, yes.
prop.table(table(rol_clean_train$Constructive)) # 26.1% Not Constructive, 73.9% Constructive

prop.table(table(rol_clean_test$Constructive)) # 25.7% Not Constructive, 74.3% Constructive

##### Begin Wordcloud #####
# Builds a wordcloud including all comments that occur at least 40x
# wordcloud(rol_corpus_train, min.freq = 40, random.order = FALSE)

# Let's sort the constructive and unconstructive messages of the TRAINING data using the SUBSET() function
unconstructive <- subset(rol_clean_train, Constructive == "N")

constructive <- subset(rol_clean_train, Constructive == "Y")

# Build wordclouds for Constructive and Unconstructive; SCALE() lets us manage font size
# Wordclouds are random, so running more than once to get the best visualization may be necessary
# wordcloud(unconstructive$Comment, min.freq = 10, scale = c(3, 0.5))
# wordcloud(constructive$Comment, min.freq = 40, scale = c(3, 0.5))

##### End Wordcloud #####

# Transform the sparse matrix into a data structure to train the naive Bayes classifier
# Eliminate any words that appear < about 0.3% of training data
# Use findFreqTerms and Dictionary (which terms to find in the document-term matrix)
mustbein = round(nrow(rol_clean_train) * 0.0015)
rol_dict <- Dictionary(findFreqTerms(rol_dtm_train, mustbein))

# Cut down on the potential number of terms to search against
rol_dtm_train <- DocumentTermMatrix(rol_corpus_train, list(dictionary = rol_dict))
rol_dtm_test <- DocumentTermMatrix(rol_corpus_test, list(dictionary = rol_dict))

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
rol_dtm_train <- apply(rol_dtm_train, 2, convert_counts)
rol_dtm_test <- apply(rol_dtm_test, 2, convert_counts)

# Unlike the kNN algorithm, Bayes training occurs in separate stages
# First, build the TRAIN matrix
rol_classifier <- naiveBayes(rol_dtm_train, rol_clean_train$Constructive)

# Now that classifier is ready, it's time to test its predictions
# PREDICT is used with the classifier and the cleaned up test messages,
# which are the messages that HAVEN'T been classified yet (even though
# they really have)
rol_test_pred <- predict(rol_classifier, rol_dtm_test)

# Use CrossTable to build a prediction-correct crosstab table
# to numerically assess how correct the model was 
# library(gmodels)
CrossTable(rol_test_pred, rol_clean_test$Constructive, prop.chisq = FALSE, prop.t = FALSE, dnn = c("Predicted", "Actual"))

# Our initial model did not include a Laplace estimator,
# which is really a dummy addition of 1 (usually) to the count of words in
# our classifier so that zeros (0) don't have such a negative effect on our
# model
rol_classifier_lap <- naiveBayes(rol_dtm_train, rol_clean_train$Constructive, laplace = 1)

rol_test_pred_lap <- predict(rol_classifier_lap, rol_dtm_test)

CrossTable(rol_test_pred_lap, rol_clean_test$Constructive, prop.chisq = FALSE, prop.t = FALSE, dnn = c("Predicted", "Actual"))

# This run (@ > 5 references) got 84% of Unconstructive and 77% of Constructive right, for 78% Overall correct. 
# This run (@ > 3 references) got 82% of Unconstructive and 79% of Constructive right, for 80% Overall correct.
# This run (@ > 6 references) got 84% of Unconstructive and 76% of Constructive right, for 78% Overall correct.
# This run (@ > 2 references) got 82% of Unconstructive and 82% of Constructive right, for 82% Overall correct.
# This run (@ > 2 references) got 75% of Unconstructive and 91% of Constructive right, for 79% Overall correct. (Seed 23456)
