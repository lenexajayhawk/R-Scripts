# Messing around with the 11/10/14 S&I file

library("class")

sandi.orig <- read.csv("c:\\r\\data\\Part_Data_11102014.csv", stringsAsFactors = TRUE)

str(sandi.orig) # 40 variables with 12 factors

summary(sandi.orig)

# Don't need the following for analysis: CLIENT_ID (6), ACCT_ID (8)
# Not sure what NEW_IRR (40) value means?
sandi <- sandi.orig[-c(6,8,40)]

sandi[is.na(sandi)] <- 0

str(sandi)

sandi.c <- kmeans(sandi, 4)



# Separate the NUMERIC columns into a working data set for KMEANS clustering
sandi.nbrs <- sandi[-c(6:13, 21, 30:36)]




str(sandi.nbrs) # Some NAs that need to be converted to zero

sandi.nbrs[is.na(sandi.nbrs)] <- 0

# Let's NOT standardize the data the first time through and see what KMEANS comes back with
# Let's NOT randomize the file, either and pick the first 90% for TRAINING and the last 10% for TESTING
sandi.clusters <- kmeans(sandi.nbrs, 6)

sandi.clusters$size

sandi.clusters$centers





# Let's add a descriptive variable for IRR > 70%
sandi$IRR70 <- as.factor(ifelse(sandi$IRR_Current >= .7, "Yes", "No"))

# Fix some columns with weird data?
# Age max = 99.65
hist(sandi$Age) # While not normal by any means the outliers look to be past age 65; cut them out?

table(sandi$Age > 75) # 26,117 are 66+, 6,539 71+, 1,741 76+


# Income max = $9,865,001
hist(sandi$Income) # Not a good representation

boxplot(sandi$Income) # Still doesn't look good

# Convert INCOME into a categorical FACTOR variable, with Low, Medium and High
# Low < 50,000, Medium 50K to 115K, High > 115K
sandi$Income.Group <- as.factor(ifelse(sandi$Income < 50000, "Low",
                             ifelse(sandi$Income < 115000, "Medium", "High")))
# Punt the INCOME value
sandi$Income <- NULL

str(sandi) # Structure of the SANDI working data set

# Can we cluster these participants by
# 1) Not participating?
# 2) Not participating enough?
# 3) Could be doing better
# 4) Review for improvements

# We should normalize the numeric values
normalize <- function(x) 
{
  return((x - min(x)) / (max(x) - min(x)))
}

sandi_n <- as.data.frame(lapply(sandi[c(1:5, 14:20, 22:31, 33, 36)], normalize))

summary(wbcd_n$area_mean)

# Goofing around with Lionshare data
lion.orig <- read.csv("c:\\r\\data\\Lionshare JPM Data 03282014.csv", stringsAsFactors = FALSE)

names(lion.orig) # Column names
str(lion.orig)
summary(lion.orig)

# CUT? begin_date (col 3), snp500_3yr (5), snp500_5yr (6), Eligibility_Date (34)
# GROUP? Number_of_Investments (14), AGE (30)
# Add a descriptor column for Number of Investments
inv.summary <- summary(lion.orig$Number_of_Investments)
lion.orig$inv.group <- ifelse(lion.orig$Number_of_Investments <= inv.summary["1st Qu."], "1Q",
                              ifelse(lion.orig$Number_of_Investments <= inv.summary["Median"], "Med",
                                     ifelse(lion.orig$Number_of_Investments <= inv.summary["3rd Qu."], "3Q","4Q")))
lion.orig$inv.group <- factor(lion.orig$inv.group, levels = c("1Q", "Med", "3Q", "4Q")

# Add age groupings by GENERATION and BY 10s
lion.orig$generation <- factor(ifelse(lion.orig$AGE <= 33, "Millennial",
                               ifelse(lion.orig$AGE <= 46, "Gen X",
                                      ifelse(lion.orig$AGE <= 57, "Early Boomer", "Late Boomer"))), levels = c("Millennial", "Gen X", "Late Boomer", "Early Boomer"))

lion.orig$age.cohort <- factor(ifelse(lion.orig$AGE < 30, "< 30",
                               ifelse(lion.orig$AGE < 40, "30-39",
                                      ifelse(lion.orig$AGE < 50, "40-49", 
                                             ifelse(lion.orig$AGE < 60, "50-59", "60+")))), levels = c("< 30", "30-39", "40-49", "50-59", "60+"))

# Add a Y/N variable for participants who are CONTRIBUTING, not how much
lion.orig$Pretax_Contrib <- factor(ifelse(lion.orig$PRETAX_CONTRB_PCT == 0, "Zero", 
                                          ifelse(lion.orig$PRETAX_CONTRB_PCT <= 4,"<= 4.0",
                                                 ifelse(lion.orig$PRETAX_CONTRB_PCT <= 7,"<= 7.0", "> 7.0"))), levels = c("Zero", "<= 4.0", "<= 7.0", "> 7.0"))

# Add a DUMMY category variable for End_IRR > 70%
lion.orig$end.IRR.70 <- factor(ifelse(lion.orig$End_IRR < .7, "Less than 70%", "Greater than 70%"))

lion.orig$comp.group <- factor(ifelse(lion.orig$ANNUAL_COMP_AMT <= 45000, "Low",
                                      ifelse(lion.orig$ANNUAL_COMP_AMT <= 115000, "Moderate", "High")), levels = c("Low", "Moderate", "High"))

# Can a LOGISTIC REGRESSION determine whether a participant will be above 70% IRR?
# No appreciable difference: segment, PAM, Personalized_Messaging, ATS, Catch Up, Auto Enrollment, Auto Increase, NQ available, Brokerage, TDFs, Re-enrollment,
# Employee or Employer Match, Dream Machine, Gender, Three or Five-Year PROR, Loan Count, # of available investments
# 2nd run after eliminating the above: Cut Roth Source, Auto-enrolled
# 3rd run: Cut MA
IRR.70.mdl <- glm(end.IRR.70 ~ Ao1_S_and_I_Experience + comp.group
                  + QDIA + Auto_Rebalancing
                  + db_available + Company_Stock
                  + Strategy + Hardship_Count + Loan_Count
                  + generation + Pretax_Contrib, data = lion.orig, family = "binomial")
IRR.70.mdl
summary(IRR.70.mdl)

predict(IRR.70.mdl, lion.test)

IRR.70.predict <- function(x) {
  eta <- .74103 + .72681 * x$Ao1_S_and_I_Experience +
                  x$comp.group * ifelse(x$comp.group == "Moderate", .86995, 
                                        ifelse(x$comp.group == "High", 1.86602, 0)) +
                  -.7799 * x$QDIA +
                  .87151 * x$Auto_Rebalancing +
                  -.67531 * x$db_available +
                  .30259 * x$Company_Stock +
                  x$Strategy * switch(x$Strategy, "Brokerage Users", -2.82449, "Changers", -.65932, "DIY", -.70764, "MA Users", -.63965, "TDF Users", -1.0053) +
                  .09991 * x$Hardship_Count +
                  -.28718 * x$Loan_Count +
                  x$generation * switch(x$generation, "Millennial", 2.3726, "Late Boomer", -.94678, "Early Boomer", -.6793, "Gen X", 0) +
                  x$Pretax_Contrib * switch(x$Pretax_Contrib, "Zero", -2.3, "> 7", .48895, "<= 4", -.16653, "<= 7", 0)
  1 / (1 + exp(-eta))
}
IRR.70.predict(lion.test[1, ])


library(nnet)

multinom(end.IRR.70 ~ Ao1_S_and_I_Experience + comp.group
         + QDIA + Auto_Rebalancing
         + db_available + Company_Stock
         + Strategy + Hardship_Count + Loan_Count
         + generation + Pretax_Contrib, data = lion.train)


comp <- switch(lion.orig[2, ]$comp.group, "Moderate", .86995, "High", 1.86602, "Low", 0)

IRR.70.table <- table(lion.orig$end.IRR.70, lion.orig$generation)

plot(colnames(IRR.70.table), IRR.70.table[1, ] / IRR.70.table[2, ])





chgirr.aov <- aov(lion.orig$Change_To_IRR ~ segment * 
                                            Ao1_Managed_Accounts *
                                            Personal_Asset_Manager *
                                            Ao1_S_and_I_Experience *
                                            Personalized_Messaging *
                                            After_Tax_Source *
                                            Catch_Up_Contributions *
                                            Roth_Source *
                                            QDIA *
                                            Auto_Rebalancing *
                                            Auto_Enrollment *
                                            Auto_Increase *
                                            db_available *
                                            NQ_Available *
                                            Brokerage *
                                            Target_Date_Funds *
                                            Re_Enrollment *
                                            Company_Stock *
                                            Auto_Enrolled *
                                            Dream_Machine_Interactive *
                                            OTTR_Amt_Begin *
                                            ANNUAL_COMP_AMT *
                                            age.cohort *
                                            GENDER_CD *
                                            PRETAX_CONTRB_PCT *
                                            generation *
                                            Strategy
                                            , data = lion.orig)

chgirr.aov <- aov(lion.orig$Change_To_IRR ~ 
  Personal_Asset_Manager +
  Ao1_S_and_I_Experience +
  After_Tax_Source +
  Roth_Source +
  QDIA +
  Auto_Rebalancing +
  Auto_Increase +
  db_available +
  NQ_Available +
  Brokerage +
  Target_Date_Funds +
  Company_Stock +
  Auto_Enrolled +
  OTTR_Amt_Begin +
  ANNUAL_COMP_AMT +
  age.cohort +
  GENDER_CD +
  Strategy, data = lion.orig)

chgirr.lm <- lm(lion.orig$End_IRR ~ 
  Personal_Asset_Manager +
  Ao1_S_and_I_Experience +
  After_Tax_Source +
  Roth_Source +
  QDIA +
  Auto_Rebalancing +
  Auto_Enrollment +
  db_available +
  NQ_Available +
  Brokerage +
  Target_Date_Funds +
  Company_Stock +
  OTTR_Amt_Begin +
  age.cohort +
  GENDER_CD +
  Strategy, data = lion.orig)


# THIS REGRESSION COMES CLOSEST TO THE 2014 LIONSHARE RESULTS
# Change_To_IRR % has been IQR'd at the TOP end, where the results are ridiculous
# WEIGHTS is the numeric representation of the SEGMENTS
summary(lm(data = lion.orig[lion.orig$Change_To_IRR <= irrpctchg.iqr.high & lion.orig$segment != "#N/A",], Chg_IRR ~ Ao1_S_and_I_Experience, weights = as.numeric(segment)))


# Build a model based on FEATURES, CHOICES, or ATTRIBUTES from the Lionshare data

# TRAIN and TEST models
lion.train <- lion.orig[1:800000, ]
lion.test <- lion.orig[800001:918325, ]

# Attributes first
chgirr.attrib.lm <- lm(Change_To_IRR ~ GENDER_CD * generation * age.cohort + segment, data = lion.orig)

summary(chgirr.attrib.lm)

chgirr.choice.lm <- lm(Change_To_IRR ~ Auto_Enrolled * Hardship_Count * Loan_Count * PRETAX_CONTRB_PCT * Strategy, data = lion.orig)

summary(chgirr.choice.lm)

# Original run shows Auto_IncreaseY and Dream_MachineY as not significant to Change
lion.train.lm <- lm(Change_To_IRR ~ After_Tax_Source
                        + Ao1_Managed_Accounts
                        + Auto_Enrollment
                        + Auto_Rebalancing
                        + Catch_Up_Contributions
                        + Company_Stock
                        + db_available
                        + NQ_Available
                        + Personal_Asset_Manager
                        + QDIA
                        + Re_Enrollment
                        + Roth_Source
                        + Target_Date_Funds, data = lion.train)
summary(chgirr.feature.lm)

lion.test.predict <- predict(lion.train.lm, lion.test)

# Can R handle the features as INTERACTIONS?
chgirr.featint.lm <- lm(Change_To_IRR ~ segment * After_Tax_Source
                        * Ao1_Managed_Accounts
                        * Auto_Enrollment
                        * Auto_Rebalancing
                        * Catch_Up_Contributions
                        * Company_Stock
                        * db_available
                        * NQ_Available
                        * Personal_Asset_Manager
                        * QDIA
                        * Re_Enrollment
                        * Roth_Source
                        * Target_Date_Funds, data = lion.orig)
summary(chgirr.featint.lm)

prop.table(table(lion.orig$generation, lion.orig$Pretax_Contrib), 1)
plot(prop.table(table(lion.orig$Pretax_Contrib, lion.orig$generation), 1), col = c("light blue", "light green", "gray", "plum"), main = "Deferral Rates by Generation", ylab = "Generation", xlab = "Pretax Contribution %")

prop.table(table(lion.orig$generation, lion.orig$Pretax_Contrib), 2)
plot(prop.table(table(lion.orig$Pretax_Contrib, lion.orig$generation), 2), col = c("light blue", "light green", "gray", "plum"), main = "Generation Deferral Rates", ylab = "Generation", xlab = "Pretax Contribution %")

table(lion.orig$generation, lion.orig$Pretax_Contrib, lion.orig[lion.orig == 161960, ]$plan)

plot(prop.table(table(lion.orig$Pretax_Contrib, lion.orig$age.cohort), 1), col = c("light blue", "light green", "gray", "plum", "magenta"), main = "Deferral Rates by Age Cohort", ylab = "Generation", xlab = "Pretax Contribution %")



## Using addNA()
Month <- airquality$Month
table(addNA(Month))
table(addNA(Month, ifany=TRUE))

(ff <- factor(substring("statistics", 1:10, 1:10), levels=letters))
as.integer(ff)  # the internal codes
(f. <- factor(ff))# drops the levels that do not occur
(ff[, drop=TRUE]) # the same, more transparently

factor(letters[1:20], labels="letter")

class(ordered(4:1)) # "ordered", inheriting from "factor"
z <- factor(LETTERS[3:1], ordered = TRUE)
## and "relational" methods work:
stopifnot(sort(z)[c(1,3)] == range(z), min(z) < max(z))


## suppose you want "NA" as a level, and to allow missing values.
(x <- factor(c(1, 2, NA), exclude = NULL))
is.na(x)[2] <- TRUE
x  # [1] 1    <NA> <NA>
is.na(x)
# [1] FALSE  TRUE FALSE
