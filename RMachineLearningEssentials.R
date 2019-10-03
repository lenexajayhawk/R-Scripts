# R Machine Learning Essentials from Packt Publishing
# Started: December 19, 2014

# Chapter 3: Simple Machine Learning Analysis
# Using the Titanic dataset, which comes with base R implementation.
# 
# Introduces the DATA.TABLE, a class that inherits from DATA.FRAME and has some interesting
# implementations of functionality.
# 
# Let's define our data
data(Titanic) # Listed as class = table, not a data frame
Titanic # print the data

# Convert the table into this book's recommended DATA.TABLE
# Try to comment on how to do the same thing with a DATA.FRAME, where applicable
# Would the Titanic table be converted into a DATA.TABLE with one call? No, causes references to be incorrect
# If using DATA.TABLES convert a DATA.FRAME 1st
dfTitanic <- data.frame(Titanic)

str(dfTitanic)

# install.package("data.table")
library(data.table)
dtTitanic <- data.table(dfTitanic)

# How many passengers were on board?
# The big difference in the function use is that the SUM function call is made within the data.table COLUMN reference
# where the equivalent data frame call might be nTot <- sum(dfTitanic$Freq)
nTot <- dtTitanic[ , sum(Freq)] # 2201
nTot

# How many of the total passengers survived the sinking?
# Data.frame call is commented below
# dfSurvived <- aggregate(dfTitanic$Freq, by = list(dfTitanic$Survived), sum)
dtSurvived <- dtTitanic[ , list(n = sum(Freq)), by = 'Survived']
dtSurvived

# Data Table calls are made within the [] references and look more object-oriented
# and less functional, even though the structure is artificial. This centralizes
# the function calls "within the data"

# Visualizing the data with a histogram
# The R histogram is done with BARPLOT()
# We'll use HEIGHT and NAMES.ARG to define the height and labels
barplot(height = dtSurvived[ , n], names.arg = dtSurvived[ , Survived])

# What if we want the percentages instead?
# Easiest to add the percentages to the data.table
# Note syntax for adding a new value (:=), similar to
# TRANSFORM function or just adding the column with the reference symbol
# dfSurvived$percentage <- dfSurvived$x / sum(dfSurvived$x)
dtSurvived[ , percentage := n / sum(n)]

# Convert the decimal to a character percentage for presentation
dtSurvived[ , textpct := paste(round(percentage * 100), '%', sep = '')]

# Let's color the survivors blue and red otherwise
dtSurvived[ , colorPlot := ifelse(Survived == "Yes", "blue", "red")]

# Build the new chart with percentages and colors along with limiting the y-axis between 0 and 1
# because we're using the percentages now. 
barplot(height = dtSurvived[ , percentage],
        names.arg = dtSurvived[ , Survived],
        col = dtSurvived[ , colorPlot],
        ylim = c(0, 1),
        legend.text = dtSurvived[ , textpct],
        ylab = "Percentage",
        main = "Proportion of Titanic survivors"
        ) # 68% survival rate

# Visualizing the impact of a feature
# What impact does GENDER have on survival rate?
# NOTE: This book advocates creating sub-tables from the original work table, something 
# that may or may not be beneficial, depending upon how much data is in the working table
dtGender <- dtTitanic[ , list(n = sum(Freq)), by = c('Survived', 'Sex')]
dtGender

# Add the percentage and text percentage (LOC 1024 in Kindle book)
dtGender[ , percentage := n / sum(n), by = 'Sex']
dtGender[ , textpct := paste(round(percentage * 100), "%", sep = '')]
dtGender[ , colorPlot := ifelse(Survived == "Yes", "blue", "red")]

# Build the bar charts by gender (LOC 1041)
barplot(height = dtGender[Sex == "Male", percentage],
        names.arg = dtGender[Sex == "Male", Survived],
        col = dtGender[Sex == "Male", colorPlot],
        ylim = c(0, 1),
        legend.text = dtGender[Sex == "Male" , textpct],
        ylab = "Percentage",
        main = "Proportion of Male Titanic Survivors"
        )
barplot(height = dtGender[Sex == "Female", percentage],
        names.arg = dtGender[Sex == "Female", Survived],
        col = dtGender[Sex == "Female", colorPlot],
        ylim = c(0, 1),
        legend.text = dtGender[Sex == "Female" , textpct],
        ylab = "Percentage",
        main = "Proportion of Female Titanic Survivors"
)

# Now we can compare the two genders' survival rates on the same histogram
barplot(height = dtGender[Survived == "Yes", percentage],
        names.arg = dtGender[Survived == "Yes", Sex],
        col = dtGender[Survived == "Yes", Sex],
        ylim = c(0, 1),
        legend.text = dtGender[Survived == "Yes" , textpct],
        ylab = "Percentage",
        main = "Titanic Survival Rate by Gender"
)

# What was the survival rate by CLASS?
dtClass <- dtTitanic[ , list(n = sum(Freq)), by = c("Survived", "Class")]

# Add the percentage of survivors
dtClass[ , percentage := n / sum(n), by = "Class"]
dtClass[ , textpct := paste(round(percentage * 100), "%", sep = "")]

barplot(height = dtClass[Survived == "Yes", percentage],
        names.arg = dtClass[Survived == "Yes", Class],
        col = dtClass[Survived == "Yes", Class],
        ylim = c(0, 1),
        legend.text = dtClass[Survived == "Yes", textpct],
        ylab = "Survival Rate",
        main = "Titanic Survival Rate by Class"
        )

# How do these numbers change if we consider GENDER as well as class?
dtGenderClass <- dtTitanic[ , list(n = sum(Freq)), by = c("Sex", "Class")]

# Add the percentage of survivors
dtGenderClass[ , percentage := n / sum(n), by = "Class"]
dtGenderClass <- dtGenderClass[Sex == "Female"]
dtGenderClass[ , textpct := paste(round(percentage * 100), "%", sep = "")]

barplot(height = dtGenderClass[ , percentage],
        names.arg = dtGenderClass[ , Class],
        col = dtGenderClass[ , Class],
        ylim = c(0, 1),
        legend.text = dtGenderClass[ , textpct],
        ylab = "Survival Rate",
        main = "Titanic Percentage of Females"
)

##### Break down the survival ratio by class and gender LOC 1086
dtGenderClass <- dtTitanic[ , list(n = sum(Freq)), by = c('Survived', 'Sex', 'Class')]

# Total the passengers
dtGenderClass[ , nTot := sum(n), by = c('Sex', 'Class')]

# Add the percentage column
dtGenderClass[ , percentage := n / sum(n), by = c('Sex', 'Class')]

# Pull the survival rate where Survived == Yes
dtGenderClass <- dtGenderClass[Survived == 'Yes']

# Add the text percentage
dtGenderClass[ , textpct := paste(round(percentage * 100), '%', sep = '')]

# Use the RAINBOW function to define the multiple colors of the plot
dtGenderClass[ , colorPlot := rainbow(nrow(dtGenderClass))]

# Define the group name to be displayed with the labels, which will be 
# the gender and class combined
dtGenderClass[ , SexAbbr := ifelse(Sex == 'Male', 'M', 'F')]
dtGenderClass[ , barName := paste(Class, SexAbbr, sep = '')]

# Define the labels containing the plot name and number of passengers in each
# group, with a hard return between them
dtGenderClass[ , barLabel := paste(barName, nTot, sep = '\n')]

# Generate the histogram but add xlim to ylim limits to make sure the legend doesn't get overrun
barplot(height = dtGenderClass[ , percentage],
        names.arg = dtGenderClass[ , barLabel],
        col = dtGenderClass[ , colorPlot],
        xlim = c(0, 11),
        ylim = c(0, 1),
        ylab = "Survival Rate",
        legend.text = dtGenderClass[ , textpct]
        )

##### Visualize the survival rate for all the features, which can be done directly with Titanic data
dtTitanic[ , nTot := sum(Freq), by = c('Sex', 'Class', 'Age')]

# Add the survivor percentage to the data
dtTitanic[ , percentage := Freq / nTot]

# Pull the survival rate
dtAll <- dtTitanic[Survived == "Yes", ]

# Add the legend with all three features and pull the class with a substring
dtAll[ , ClassAbbr := substring(Class, 1, 1)]
dtAll[ , SexAbbr := ifelse(Sex == 'Male', 'M', 'F')]
dtAll[ , AgeAbbr := ifelse(Age == 'Child', 'C', 'A')] 
dtAll[ , textLegend := paste(ClassAbbr, SexAbbr, AgeAbbr, sep = '')]

# Add the plot color
dtAll[ , colorPlot := rainbow(nrow(dtAll))]

# Add the percentage for the label
dtAll[ , labelPerc := paste(round(percentage * 100), '%', sep = '')]

# Add the label including the percentage and total number
dtAll[ , label := paste(labelPerc, nTot, sep = '\n')]

# Produce the plot
barplot(height = dtAll[ , percentage],
        names.arg = dtAll[ , label],
        col = dtAll[ , colorPlot],
        xlim = c(0, 23),
        legend.text = dtAll[ , textLegend],
        cex.names = 0.5
        )

##### Using Decision Trees to determine the probability of Titanic survival
# We have a 2nd class male child passenger; what are the chances he survived?
# Use the RPART library with decision trees
install.packages('rpart.plot')
library(rpart.plot)
library(rpart)

# First we need to expand the Titanic summary table into one row for each passenger
# based on the number of each combined type of passenger
# We REPeat the number 1 for each row for each passenger broken down by each descriptor for a passenger
dtLong <- dtTitanic[ , list(Freq = rep(1, Freq)), by = c('Survived', 'Sex', 'Age', 'Class')]

dtLong # Now 2201 rows whereas dtTitanic was only 32 based on our previous summaries

# We don't need Freq b/c each Freq = 1
dtLong[ , Freq := NULL] # Setting the value to NULL removes the column; could have been done with dfLong$Freq <- NULL

# Need to create a DUMMY for the Y/N value of Survived in the new data set
dtLong[ , Survived := ifelse(Survived == 'Yes', 1, 0)]

head(dtLong) # How does the data look?

# Now let's use RPART for the decision tree using Survived ~ Sex + Age + Class
# Define the formula
formulaRpart <- formula('Survived ~ Sex + Age + Class')

# Now build the regression tree
treeRegr <- rpart(formula = formulaRpart, data = dtLong)

treeRegr # Display the tree in the console
summary(treeRegr) # Longer summary in the console
prp(treeRegr) # Display the actual tree in the PLOTS window; this is a NUMBER

# What if we wanted to predict whether the passenger survived or not?
# Add a classification tree by adding METHOD = 'class' to input RPART
treeClass = rpart(formula = Survived ~ Sex + Age + Class, data = dtLong, method = 'class')
prp(treeClass) # This model only takes 5 of 16 possible outcomes into consideration

##### Predicing newer outcomes LOC 1243
# Can we estimate the survival rate for any combination of features, regardless of how many
# passengers we have? In this section we work with the RANDOM FOREST algorithm, which isn't
# the best option in this context, as it performs better when there are more features, but
# it's good for illustrating the general approach
# The RANDOM FOREST algorithm is based on many decision trees, where
# 1) Generate the data to build the tree choosing a random row from the data a sampling number of times,
#    and each row can be selected more than once (somewhat of a bootstrap method)
# 2) Randomly select a number of features
# 3) Build a decision tree based on the sampled data taking account of the selected features only
# Found in the randomForest package
install.packages('randomForest')
library(randomForest)

# Random forest attributes can be either NUMERIC or CATEGORIC (NOMINAL)
# For these purposes we have NOMINAL data, which can be converted into a DUMMY table
dtDummy <- copy(dtLong)
# These statements are equivalent
dtDummy <- dtLong

# Convert Sex and Age into a dummy variable
dtDummy[ , Male := Sex == 'Male']
dtDummy[ , Sex := NULL]

dtDummy[ , Child := Age == 'Child']
dtDummy[ , Age := NULL]

# Convert Class into three dummy variables
dtDummy[ , Class1 := Class == '1st']
dtDummy[ , Class2 := Class == '2nd']
dtDummy[ , Class3 := Class == '3rd']
dtDummy[ , Class := NULL]

# Write the Random Forest formula
formulaRf <- formula(Survived ~ Male + Child + Class1 + Class2 + Class3)

# Build the Forest
forest <- randomForest(formula = formulaRf, data = dtDummy)

# How many trees did the model build?
forest$ntree # 500

# How many variables were used in each iteration?
forest$mtry # 1

# What type of output is coming from the algorithm?
forest$type # regression!

# We can control how many trees, how many tries, and how many random rows are developed
forest <- randomForest(formula = formulaRf, data = dtDummy, ntree = 1000, mtry = 3, sampsize = 1500)

# We have a random forest model; let's use it to predict new outcomes
# Extract a random passenger
rowRandom <- dtDummy[100]
rowRandom # Random row = MALE Adult 1st class

# PREDICT to apply the model on the new data
predict(forest, rowRandom) # .3901004, just above 39% chance; pretty poor

# We can use the same approach for all passengers, but this means we apply the model to the same
# data we used to create it, which is poor for testing because predicted values will be related to
# the initial data. We can use predict just to compare the prediction with the real data
prediction = predict(forest, dtDummy)

# Pick six random rows to see how the prediction did
sample(prediction, 6)

# Let's add a column to dtDummy of predicted survival rate
dtDummy[ , SurvivalRatePred := predict(forest, dtDummy)]

# Now convert that value into a dummy value of 1 yes, 0 no
dtDummy[ , SurvivedPred := ifelse(SurvivalRatePred > .5, 1, 0)]

# Compare the predicted survival with the initial data
dtDummy[ , error := SurvivedPred != Survived]

# Compute the general error as percent of passengers where prediction was wrong versus real data
# by dividing the number of error by the number of passengers
# .N = Number of rows of the data set
percError <- dtDummy[ , sum(error) / .N]
percError # .2094502, or 21%; the model got 79% of the predictions one way or the other correct

# This doesn't make much sense since we're working against the TRAINING data and we could
# have guessed the outcome for each passenger based on what we'd graphed earlier. What's the overall
# survival rate without any prediction anyway?
dtTitanic[Survived == 'No', sum(Freq)] / dtTitanic[ , sum(Freq)] # About 68% loss rate

# This model improves on the actual rate by only 11%, so not only does it not make sense
# to work against the TRAINING data and without any features we only improved the prediction percentage
# a small amount

##### Validating the model LOC 1331
# To evaluate the real accuracy of the model we can build it using a part of the original data and then
# apply the results against the remaining leftover data to validate the model. Building the model uses
# TRAINING data; the remaining data we test against is called TEST data.
# 
# Building the TRAINING data in this book not through random record selection as done in the past. This
# example will build a logical vector where each row of the TRAINING data is set to TRUE using the SAMPLE
# function, where x = possible values, size = vector length, replace = T/F if each value can be sampled
# more than once, and prob = a vector of probabilities of sampling values of X.
indexTrain <- sample(x = c(TRUE, FALSE), size = nrow(dtDummy), replace = TRUE, prob = c(0.8, 0.2))

# Now extract the rows where indexTrain = TRUE
dtTrain <- dtDummy[indexTrain]
head(dtTrain)
dtTest <- dtDummy[!indexTrain]
head(dtTest)

# Now build the model from the TRAINING data
forest <- randomForest(formula = formulaRf, data = dtTrain, ntree = 1000, mtry = 3, sampsize = 1200)

# Use the FOREST model to predict the TEST data
dtTest[ , SurvivalRatePred := predict(forest, dtTest)]
dtTest[ , SurvivedPred := ifelse(SurvivalRatePred > 0.5, 1, 0)]
dtTest[ , error := SurvivedPred != Survived]
percError <= dtTest[ , sum(error) / .N]
percError

# Chapter 4 Step 1: Data Exploration and Feature Engineering LOC 1374
# The approach can be divided into three steps: 1) Define features to be used 2) Apply one or more techniques
# to solve the problem 3) Evaluate the result and optimize the performance. Feature selection is a cycle rather than
# a step, and it takes place in each part of the procedure. The feature engineering process is: exploring the data,
# defining/transforming new features, and identifying the most relevant features.
# 
# This chapter shows an example of flags, predicting the country's language. The features in the base dataset include
# the colors in the flag, patterns in the flag, some additional elements in the flag such as stars or text, some geographical data
# such as continent, geographic quadrant area, and population, and the language and religion of the country
dfFlag <- read.csv("c:\\r\\data\\flag_data.csv", header = FALSE)

# 30 columns in dfFlag with no defined names
# Start with country name
nameCountry <- 'name'
# Define 3 geographic feature names
namesGeography <- c('continent', 'zone', 'area')
# Define names of three features of the countries' citizens, including language
namesDemography <- c('population', 'language', 'religion')
# Define the vector with the previous three in the right order
namesAttributes <- c(nameCountry, namesGeography, namesDemography)
# Define names of flag features
namesNumbers <- c('bars', 'stripes', 'colors')
# For some colors there is a binary 1/0 if the flag contains the color or not
namesColors <- c('red', 'green', 'blue', 'gold', 'white', 'black', 'orange')
# Define the name of the predominant color
nameMainColor <- 'mainhue'
# Define the name of the attributes that display how many patterns/drawings are contained in the flag
namesDrawings <- c('circles', 'crosses', 'saltires', 'quarters', 'sunstars', 'crescent', 'triangle', 'icon', 'animate', 'text')
# The color in two out of four angles
namesAngles <- c('topleft', 'botright')
# Define namesFlag that contains all the names in the right order
namesFlag <- c(namesNumbers, namesColors, nameMainColor, namesDrawings, namesAngles)
# Set the dfFlag column names that bind namesAttributes and namesFlag
names(dfFlag) <- c(namesAttributes, namesFlag)

# Now that the columns have headers, build the DATA.TABLE
dtFlag <- data.table(dfFlag)

# Look at the continent column
dtFlag[1:20, continent] # All numeric values; convert to names

vectorContinents <- c('N. America', 'S. America', 'Europe', 'Africa', 'Asia', 'Oceania')

# Convert continent into factor based on the just-created vector
dtFlag[ , continent := factor(continent, labels = vectorContinents)]

# Convert zone into FACTOR
vectorZones <- c('NE', 'SE', 'SW', 'NW')
dtFlag[ , zone := factor(zone, labels = vectorZones)]

# Convert languages into FACTOR
vectorLanguages <- c('English', 'Spanish', 'French', 'German', 'Slavic', 'Other Indo-European', 'Chinese', 'Arabic', 'Japanese/Turkish/Finnish/Magyar', 'Others')
dtFlag[ , language := factor(language, labels = vectorLanguages)]

# Convert religion into FACTOR
vectorReligions <- c('Catholic', 'Other Christian', 'Muslim', 'Buddhist', 'Hundu', 'Ethnic', 'Marxist', 'Others')
dtFlag[ , religion := factor(religion, labels = vectorReligions)]

str(dtFlag)

# Exploring and visualizing the features LOC 1504 (45%)
# We've defined the features, so let's explore them, looking at MAINHUE, the predominant color of a flag.
table(dtFlag[ , mainhue]) # Three most prominent colors: red, blue, green
# Also would have worked: dtFlag[ , table(mainhue)]

# How could we perform the same operatio over any other column?
# First, define a string called colName, then use GET() inside the square
# brackets of dtFlag
nameCol <- 'mainhue'
dtFlag[ , table(get(nameCol))]

# This notation is useful because we can easily include it inside a function using 
# the name string, visualing the same results for all the other columns
listTableCol = lapply(namesAngles, function(nameCol) { dtFlag[ , table(nameCol)]})

# What if we want to build a chart instead, building a histogram with BARPLOT?
nameCol <- 'language'
freqValues <- dtFlag[ , table(get(nameCol))]
names(freqValues)
barplot(height = freqValues,
        names.arg = names(freqValues),
        main = nameCol,
        col = rainbow(length(freqValues)),
        ylab = 'Number of Flags', 
        cex.names = 0.5
        )

# This is very useful for examining one feature; can we "automate" the call through a function?
barplotAttribute <- function(dtData, nameCol) {
  # Define the frequency
  freqValues <- dtData[ , table(get(nameCol))]
  # Define the percentage
  percValues <- freqValues / sum(freqValues)
  percValues <- round(percValues * 100)
  percValues <- paste(percValues, '%')
  # Generate the histogram
  barplot(height = freqValues,
          names.arg = names(freqValues),
          main = nameCol,
          col = rainbow(length(freqValues)),
          legend.text = percValues,
          ylab = "Number of Flags",
          cex.names = .75
          )
}

barplotAttribute(dtFlag, 'stripes')

# Cycle through all attributes with a FOR loop, pausing for each histogram with a READLINE
for(nameCol in namesFlag) {
  barplotAttribute(dtFlag, nameCol)
  readline()
}

# Given a color how many flags have that color?
dtFlag[ , sum(red)]
# or...
# dtFlag[ , sum(get('red'))]

# Can we cycle through all of the colors like we did with the names? They're in the namesColors variable
dtFlag[ , sum(get(namesColors[1]))]

# Cycle through all of the colors with SAPPLY
sapply(namesColors, function(nameColor) { dtFlag[ , sum(get(nameColor))]})

# Use a decision tree with the formula
formulaRpart <- 'language ~'

for(name in namesFlag) {
  formulaRpart <- paste(formulaRpart, '+', name)
}

formulaRpart <- formula(formulaRpart)

tree <- rpart(formula = formulaRpart, data = dtFlag)
prp(tree)

# Define a function to visualize the tree
# First set up a new table
dtFeatures <- dtFlag[ , c('language', namesFlag), with = FALSE]

plotTree <- function(dtFeatures) {
  formulaRpart <- paste(names(dtFeatures)[1], '~') # LANGUAGE is the DEPENDENT variable, thus the first in this data table
  
  # Cycle through the rest of the INDEPENDENT variables, without the first variable, and build the formula
  for(name in names(dtFeatures)[-1]) {
    formulaRpart <- paste(formulaRpart, '+', name)
  }
  # Define the string as a formula
  formulaRpart <- formula(formulaRpart)
  # Build the tree
  tree <- rpart(formula = formulaRpart, data = dtFeatures)
  # Display the tree
  prp(tree)
}
# Call PLOTTREE on this data table
plotTree(dtFeatures)

# Modifying the features LOC 1598 (48%)
# Some of the features for flag description might not be in the right format; let's fix that. To track
# the features we have processed, let's use a tracking vector, which contains the features we've already
# fixed.
namesProcessed <- c()

# Let's start with numeric columns, such as RED, with outcomes of 0 or 1. The value should be categorical
# instead of numeric, so convert it from 1 = yes and 0 = no. A series of attributes are 1/0, so let's see if
# we can convert them all at once.
nameFeat <- 'red'

# Does nameFeat display two values?
length(unique(dtFeatures[ , get(nameFeat)])) == 2 # The RED column does only have two values; TRUE

# Convert the RED column to a factor with YES/NO values
vectorFactor <- dtFeatures[ , factor(get(nameFeat), labels = c('no', 'yes'))]
head(vectorFactor)

# A FOR loop will help us convert all attributes with two values
for(nameFeat in namesFlag) {
  if(length(unique(dtFeatures[ , get(nameFeat)])) == 2) {
    vectorFactor <- dtFeatures[ , factor(get(nameFeat), labels = c('no', 'yes'))]
    dtFeatures[ , eval(nameFeat) := vectorFactor]
    namesProcessed <- c(namesProcessed, nameFeat)
  }
}

setdiff(namesFlag, namesProcessed) # Remaining: bars, stripes, colors, mainhue, circles, crosses, quarters, sunstarts, topleft, botright

# Bars is a numeric atribute that displays the number of vertical bars in a flag. If we use bars the model will find a relationship
# between language and the model; for example all Spanish-speaking countries have 0 or 3 flags, so a rule might say, "The language can
# be Spanish if the flag has less than 4 bars." But no Spanish-speaking country has a flag with 1 or 2 bars. Maybe we can group countries
# based on number of bars.
barplotAttribute(dtFeatures, 'bars') #82% have no bars, 11% have three

# Let's set up an attribute with three groups: flags with no bars, 3 bars and all others
# This is called DISCRETIZATION, where a limited number of values are separated from one attribute into their own binary values
dtFeatures[ , nBars0 := bars == 0]
dtFeatures[ , nbars1_2 := bars %in% c(1, 2)]
dtFeatures[ , nbars3 := bars == 3]
# Delete the original BARS column
dtFeatures[ , bars == NULL]

# Add to the NAMES processed
namesProcessed <- c(namesProcessed, 'bars')

# Let's discretize STRIPES this way, too
barplotAttribute(dtFeatures, 'stripes') # 57% have 0 stripes, 23% have 3, 8% have 2, and 6% have 5

dtFeatures[ , nStripes0 := stripes == 0]
dtFeatures[ , nStripes2 := stripes == 2]
dtFeatures[ , nStripes3 := stripes == 3]
dtFeatures[ , nStripes5 := stripes == 5]
# Cut the original stripes column
dtFeatures[ , stripes == NULL]
# Add to our names processed
namesProcessed <- c(namesProcessed, 'stripes')

# Can COLORS be discretized?
barplotAttribute(dtFeatures, 'colors') # Almost a normal distribution, slight skew

dtFeatures[ , nCol12 := colors %in% c(1, 2)]
dtFeatures[ , nCol3 := colors == 3]
dtFeatures[ , nCol45 := colors %in% c(4, 5)]
dtFeatures[ , colors = NULL]
namesProcessed <- c(namesProcessed, 'colors')

# What attributes are left to process?
for(nameCol in setdiff(namesDrawings, namesProcessed)) {
  barplotAttribute(dtFeatures, nameCol)
  readline()
}

# Many of these can be BINARIZED to Yes/No
# CIRCLES: 0 or 1
# CROSSES: 0 or 1
# QUARTERS: 0 or 1
# SUNSTARS: 0, 1, 2, 4, 5
for(nameCol in setdiff(namesDrawings, namesProcessed)) {
  dtFeatures[ , eval(nameCol) := ifelse(get(nameCol) > 0, 'yes', 'no')]
  namesProcessed <- c(namesProcessed, nameCol)
}

# What attributes are left to process?
for(nameCol in setdiff(namesFlag, namesProcessed)) {
  barplotAttribute(dtFeatures, nameCol)
  readline()
} # MAINHUE, TOPLEFT, BOTRIGHT

# Let's handle the COLOR situation with a DUMMY variable
namesToDummy <- c('topleft', 'botright', 'mainhue')

for(nameCol in namesToDummy) {
  frequencyColors <- dtFeatures[ , list(.N), by = nameCol]
  
  for(color in frequencyColors[N > 20, get(nameCol)]) {
    nameFeatNew <- paste(nameCol, color, sep = '')
    dtFeatures[ , eval(nameFeatNew) := get(nameCol) == color]
  }
  
  dtFeatures[ , eval(nameCol) := NULL]
  namesProcessed <- c(namesProcessed, nameCol)
}

str(dtFeatures)
# All columns are transformed to Yes/No, but some are of the LOGICAL class
for(nameCol in names(dtFeatures)) {
  if(dtFeatures[ , class(get(nameCol))] == 'logical') {
    print(nameCol)
    dtFeatures[ , eval(nameCol) := ifelse(get(nameCol), 'yes', 'no')]
  }
}

# Now how does the TREE look?
plotTree(dtFeatures)

# Ranking the Features Using a Filter or a Dimensionality Reduction LOC 1683 (51%)
# Are all of the features really relevant to the problem of determining the spoken language
# associated with the flag? EMBEDDED MODELS can automatically select the most relevant
# features, or we could build the same model with DIFFERENT sets of features and select which
# is better. Both take tremendous computational power.
# 
# FILTERS are techniques that identify the most relevant features, which are used BEFORE
# the model is applied, which helps cut computational costs. One such filter is Pearson's
# CORRELATION COEFFICIENT, a measure of the linear relationship between variables.
# An INFORMATION-GAIN RATIO is an index that quantifies the improvement that comes from
# adding features to a model; ex: no features to knowing the color red to also knowing
# how many stripes, etc.

# Correlation and information-gain ratios take account of each feature separately, so they
# completely ignore the interaction between them. We can have two features with a high impact
# on the language and are so strongly related to each other that they contain the same information.
# This is MULTICOLLINEARITY when the relationship is linear. Sometimes two features have little relevance
# when considered separately but a huge impact together. We don't want to exclude them individually, then.
# 
# Instead of ranking the features we can find relevant combinations through PRINCIPAL COMPONENT ANALYSIS (PCA).
# PCA defines a set of variabls called principal components, which are linearly independent of each other,
# and are less than the number of features and the components ranked by variance. The goal is to find the 
# combination of variables that covers the highest total amount of variance. PCA is limited because it can only
# work against linear relationships, and it doesn't take account of the attribute to predict things.
# 
# Let's see how INFORMATION GAIN RATIO works.
install.packages('FSelector')
library(FSelector)

namesFeatures <- names(dtFeatures)[-1]
dfGains <- information.gain(language ~ ., dtFeatures)

dfGains$feature <- row.names(dfGains) # This wasn't necessary, I don't think

# Build a DATA TABLE
dtGains <- data.table(dfGains)

# Sort the relevance on the DATA TABLE
dtGains <- dtGains[order(attr_importance, decreasing = TRUE)]
head(dtGains)

# Visualize the most relevant features
dtGainsTop <- dtGains[1:12]

barplot(height = dtGainsTop[ , attr_importance],
        names.arg = dtGainsTop[ , feature],
        main = 'Information Gain',
        col = rainbow(nrow(dtGainsTop)),
        legend.text = dtGainsTop[ , feature],
        xlim = c(0, 20)
        )

# Now that'we've defined the feature ranking, we can build the model from the most relevant features.
# We can either include all the features whose relevance is above a chosen threshold, or pick a defined
# number of features starting at the top. However, we still aren't taking into account any interactions
# between features (such as stars are always with stripes or "flag contains blue, blue is the main color,
# and the bottom right is blue".) Each of the blues is relevant but redundant when used together, so we can
# exclude one of them.
# 
# Filters are fast and useful methods to rank features, but we must be very careful in using them when
# building the model.

##### Chapter 5 Step 2 -- Applying machine learning techniques LOC 1745 (53%)
# Using the flag data from the previous chapter. Learning to 1) ID homogeneous groups of items,
# 2) explore and visualize the item groups 3) estimate a new country language and 4) set the configuration
# of a machine learning technique
# 
# Identifying a homogenous group of items
# Can we ID groups of countries with similar flag attributes? CLUSTERING techniques
str(dtFeatures)

# Identify groups of similar flags using k-means clustering, which uses numeric features to group,
# or cluster, data based on their similarities with centers (centroids), to produce homogeneous groups
# (each cluster's individual data is similar but dissimilar from data in other clusters).

# Pull out the numeric features to use in k-means clustering
dtFeatures

arrayFeatures <- names(dtFeatures)[-1] # Pull the names of all columns EXCEPT language



# Define the k-means data table
dtFeaturesKm <- dtFeatures[ , arrayFeatures, with = FALSE]

# Loop through converting CHR strings and FACTORS into 0/1 binary numerics
for(colNames in arrayFeatures) {
  if(is.character(dtFeaturesKm[ , get(colNames)]))
    dtFeaturesKm[ , eval(colNames) := ifelse(get(colNames) == "no", 0, 1)]
  if(is.factor(dtFeaturesKm[ , get(colNames)]))
    dtFeaturesKm[ , eval(colNames) := as.numeric(get(colNames)) - 1]
}

# Convert a generic column (a character string column) into the numeric format
dtFeatures[ , as.numeric(red)] # Converts to 1 and 2, but we need 0 and 1

dtFeaturesKm

# KMEANS expects a MATRIX
matrixFeatures <- as.matrix(dtFeaturesKm)

# Cluster the data using KMEANS
nCenters <- 8

modelKm <- kmeans(x = matrixFeatures, centers = nCenters)

names(modelKm)

modelKm$cluster
modelKm$centers
modelKm$size

# Add the cluster # to the data table
dtFeatures[ , clusterKM := modelKm$cluster]

# Aggregate the data by clusters
nameCluster <- 'clusterKM'

# Determine how many rows we have in each cluster using .N
dtFeatures[ , list(.N), by = nameCluster]
# The next line does the same thing as above but titles the number of Countries in the cluster with nCountries
dtFeatures[ , list(nCountries = .N), by = nameCluster]

# Pulls the number of languages by cluster as a list
dtFeatures[ , as.list(table(language)), by = nameCluster]

# What if we want the same table visualizing the percentage of countries speaking each language?
dtFeatures[ , as.list(table(language) / .N * 100), by = nameCluster]

# Put the by-cluster descriptive data into a data table
# COMBINE total number of countries and the percent of languages in each cluster into each cluster row
dtClusters <- dtFeatures[ , c(list(nCountries = .N), as.list(table(language) / .N)), by = nameCluster]
dtClusters # This is a summary data table, similar to what we did with Titanic

# Build histograms to visualize the related cluster data
# First, get the unique languages from the dtFeatures data table
arrayLanguages <- dtFeatures[ , as.character(unique(language))] # Had to use AS.CHARACTER, not in the book

# Second, build a barplot object with the language columns
dtBarplot <- dtClusters[ , arrayLanguages, with = FALSE]
dtBarplot

# Convert dtBarplot into a MATRIX; to build the chart we need to transpose the columns and rows
matrixBarplot <- t(as.matrix(dtBarplot))
matrixBarplot

# Define a vector with the cluster sizes, the number of countries
nBarplot <- dtClusters[ , nCountries]
nBarplot

# Define the legend names as the country names
namesLegend <- names(dtBarplot)
namesLegend

# Cut the legend names down with SUBSTRING so as not to overlap the charts
namesLegend <- substring(namesLegend, 1, 12)

# Define the colors to be used in the charts
arrayColors <- rainbow(length(namesLegend))

# Define the chart title
plotTitle <- paste('Languages in each cluster of', nameCluster)

# Finally, build the histogram
barplot(
  height = matrixBarplot,
  names.arg = nBarplot,
  col = arrayColors,
  legend.text = namesLegend,
  xlim = c(0, ncol(matrixBarplot) * 2),
  main = plotTitle,
  xlab = 'Cluster',
  cex.names = 0.75
  )

# The previous code set can be turned into a function called PLOTCLUSTER

# Visualize the language clusters into a WORLD MAP
install.packages('rworldmap')
library(rworldmap)

dtFeatures[ , country := rownames(dtFeatures)]

# The data is pretty old, so let's combine Germany and the USSR into Russia
dtFeatures[country == 'Germany-FRG', country := 'Germany']
dtFeatures[country == 'USSR', country := 'Russia']

# Build a function to build the world map with the clusters
plotMap <- function(
  dtFeatures, # data table with the countries
  colPlot, # feature to visualize
  colorPalette = 'negpos8') # colors 
  {
  # Define the column to plot
  dtFeatures[ , colPlot := NULL]
  dtFeatures[ , colPlot := substring(get(colPlot), 1, 12)]
  
  # Build mapFeatures containing the data we need to build the chart
  mapFeatures <- joinCountryData2Map(dtFeatures[ , c('country', 'colPlot'), with = FALSE],
                                     joinCode = 'NAME',
                                     nameJoinColumn = 'country'
                                     )
  # Build the chart
  mapCountryData(mapFeatures,
                 nameColumnToPlot = 'colPlot',
                 catMethod = 'categorical',
                 colourPalette = colorPalette,
                 missingCountryCol = 'gray',
                 mapTitle = colPlot
                 )
  
  }

# Visualize the k-means clusters
plotMap(dtFeatures, colPlot = 'clusterKM')

# Identifying a cluster's hierarchy LOC 1937 (58%)
# Hierarchic clustering build clusters and merge objects iteratively (step by step). At the
# beginning we have a cluster for each country. We define a measure of how similar two clusters are
# and, at each step, we identify the two clusters whose flag is the most similar and merge them 
# into a unique cluster. In the end we have a cluster including all the countries.
# Use the DIST function to build our input by reusing the matrixDistances matrix we built earlier
matrixDistances <- dist(matrixFeatures, method = 'manhattan') # manhattan refers to the length of a city block

# Build the hierarchical clustering model
modelHc <- hclust(d = matrixDistances, method = 'complete')

# Visualize the model
plot(modelHc, labels = FALSE, hang = -1) # Produces a dendrogram

# Define the clusters
heightCut <- 23.5
abline(h = heightCut, col = 'red')

cutree(modelHc, h = heightCut)

dtFeatures[ , clusterHC := cutree(modelHc, h = heightCut)]
dtFeatures





