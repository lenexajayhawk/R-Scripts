###################################################################################################################################################################
#                                                                             														#
#	Title: Lionshare.r                                                      														#
#																											#
#	Date: July 8, 2014																							#
#																											#
#	Description: Backward engineering the Lionshare IRR analysis																#
#																											#
#	Data: March 28, 2014 data stored at K:\RP\Product Organization\Research\2014 RESEARCH\PRODUCT RESEARCH\IRR STUDY\LIONSHARE CORRELATIONS\Data to Lionshare	#
#																											#
#	Notes:	This attempts to re-build the IRR change regression model that I recreated in SAS											#
#			The analysis I created in SAS regresses EndIRR - BeginIRR with presence of the service										#
#			The Lionshare analysis regresses the service against the Change_to_IRR value, which is a percentage change between begin and end			#																					#
#	Version:																									#
#		1.0: First try; using the SAS-modified data LionshareConverted.csv																						#
#																											#
###################################################################################################################################################################

##### Begin Options #####
options(digits = 5)



##### End Options  #####


##### Begin Data Manipulation #####

##### Things done in SAS that may or may not need to be done in R #####
# 1) Convert the Y/N to 1/2
# 2) Convert gender_cd from M/F to 1/2
# 3) Create new agegroup code from age column
# 4) Create new Dream Machine Interactive column with 1/2 instead of Y/N
# 5) IQR # of investments and calc Q1, median, and Q3
# 6) If missing loan_count then make loan_count = 1, else 2
# 7) If missing hardship_count then make hardship_count = 1, else 2
# 8) If pretax_contrb_pct missing or 0 then make 1, else 2
# 9) Set actual_irr_chg as end_irr - beg_irr

# Open the CSV file with 3/28/14 data
# This version has been exported from SAS and all transformations (including original data) was included
irrds <- read.csv("c:\\r\\data\\LionshareConverted.csv")

# To select the CSV file...
irrds <- read.csv(file.choose())

# Check the first few rows; not necessary to run but good to confirm data
head(irrds)

# Replace NA with 0
irrds[is.na(irrds)] <- 0


##### Replace all Y/N with 2/1
##### Another way to convert data frame factors into numerics
# SAPPLY is a wrapper function
# First, create a logical vector with TRUE/FALSE whether the column is defined as a FACTOR or not
i <- sapply(irrds, is.factor)

# Apply the logical vector i to each column of IRRDS using
# sapply function, which allows functions such as as.numeric
# to be used with a data frame, when it normally cannot be
irrds[i] <- sapply(irrds[i], as.numeric)

# Confirm the first few rows of the data set for the conversion of factors into numerics
#head(irrds)


##### End Data Manipulation #####

##### Begin Regression #####

# Can add a Subset modifier vector to the Linear Model
segment <- c(161271)

# Store the linear model results of the variable versus actual IRR change in the IRRDS Data Frame
mod1 <- lm(Change_To_IRR ~ NQ_Available, irrds)

# Print the MOD1 results
summary(mod1)

##### End Regression #####


##### Begin Descriptive Statistics #####


# Print the descriptive statistics of the actual IRR change variable
summary(irrds$actualIRRchg)
summary(irrds$Change_To_IRR)

##### Begin Descriptive Statistics #####

