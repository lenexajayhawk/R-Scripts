library(tm)
library(wordcloud)
library(e1071) # NaiveBayes
library(gmodels) # Cool cross-tab table

subjectLines <- read.csv("X:\\Users\\sjohnson-pc\\Intouch\\Data\\SubjectLinesOneTab.csv", stringsAsFactors = FALSE)

str(subjectLines)

subjectLines$Opened <- factor(subjectLines$Opened)

table(subjectLines$Opened)

# Randomize the data
subjectLines <- subjectLines[sample(nrow(subjectLines),nrow(subjectLines)), ]


subjectLines_corpus <- Corpus(VectorSource(subjectLines$SubjectLine))

print(subjectLines_corpus)

inspect(subjectLines_corpus[1:10])

# All of the next five lines of cleanup code are failing; move forward with the existing corpus
# corpus_clean <- tm_map(subjectLines_corpus, tolower)
# corpus_clean <- tm_map(corpus_clean, removeNumbers)
corpus_clean <- tm_map(subjectLines_corpus, removeWords, stopwords())
# corpus_clean <- tm_map(corpus_clean, removePunctuation)
# corpus_clean <- tm_map(corpus_clean, stripWhitespace)

# inspect(corpus_clean[1:10])

subject_dtm <- DocumentTermMatrix(subjectLines_corpus)

# Try to rebuild the clean corpus one cleanup at a time
# First, try STOPWORDS() function
subject_dtm <- DocumentTermMatrix(corpus_clean)

# Set up the TRAINING and TEST raw data
subject_raw_train <- subjectLines[1:80000, ]
subject_raw_test <- subjectLines[80001:100000, ]

# Partition the document-term matrix
subject_dtm_train <- subject_dtm[1:80000, ]
subject_dtm_test <- subject_dtm[80001:100000, ]

# Finally the corpus
subject_corpus_train <- subjectLines_corpus[1:80000]
subject_corpus_test <- subjectLines_corpus[80001:100000]

# Are the two data sets representative?
prop.table(table(subject_raw_train$Opened))
prop.table(table(subject_raw_test$Opened))

wordcloud(subject_corpus_train, min.freq = 20000, random.order = FALSE)

# A word must appear at least X times in the document-term matrix
findFreqTerms(subject_dtm_train, 1000)

# Save a list of the frequent terms for later use in a Dictionary
# 1/13/16: Dictionary has been depracated; trying to just use what's returned from findFreqTerms
subject_dict <- findFreqTerms(subject_dtm_train, 1000)

subject_train <- DocumentTermMatrix(subject_corpus_train, list(dictionary = subject_dict))
subject_test <- DocumentTermMatrix(subject_corpus_test, list(dictionary = subject_dict))

convert_counts <- function(x) {
  x <- ifelse(x > 0, 1, 0)
  x <- factor(x, levels = c(0, 1), labels = c('No', 'Yes'))
  return(x)
}

subject_train <- apply(subject_train, MARGIN = 2, convert_counts)
subject_test <- apply(subject_test, MARGIN = 2, convert_counts)

subject_classifier <- naiveBayes(subject_train, subject_raw_train$Opened)

subject_test_pred <- predict(subject_classifier, subject_test)

CrossTable(subject_test_pred, subject_raw_test$Opened, prop.chisq = FALSE, prop.t = FALSE, dnn = c('predicted', 'actual'))

# What if words didn't appear in any opened or unopened messages?
subject_classifier_lap <- naiveBayes(subject_train, subject_raw_train$Opened, laplace = 1)

subject_test_lap_pred <- predict(subject_classifier_lap, subject_test)

CrossTable(subject_test_lap_pred, subject_raw_test$Opened, prop.chisq = FALSE, prop.t = FALSE, dnn = c('predicted', 'actual'))






