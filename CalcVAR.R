# Calculating Risk-adjusted Returns by Participant with 5-year PRORs using the Johnson Effect
# We are NOT using Sharpe ratios but closer to standardized scores (z-scores)

# Adding this new comment to see how it works when I commit the change in GitHub

##### BEGIN CODE NOTES #####
# Volatility-adjusted Rates of Return (VAR) are calculated based on two principal methodologies: Sharpe ratios and statistical standardization.
# Sharpe ratios are the result of time-driven returns of individual investments such as mutual funds; for example, Sharpe ratios are developed
# for a mutual fund over the course of 10 years given their excess return over a risk-free rate, which is typically a T-bill such as the 3-month
# BoA/ML Treasury Bill. Risk-free, in this case, is the minimum positive return that could be expected from an investment during the selected time
# period, which in our case is usually 1, 3 and 5 years. The Sharpe ratio is almost always between 0 and 1. The formula for the Sharpe ratio is...
# 
# Sharpe ratio = Average of Excess Return / Standard Deviation of Excess Return, where Excess Return = Expected or Actual Return - Risk-free Rate.
# 
# An example of a Sharpe ratio: Over the last 10 years mutual fund has had returns of -4.6, 0.3, 3.1, 11.4, 15.8, 28.3, 11.0, 4.7, 7.0 percent.
# The risk-free rate in those 10 years is 0.012. The Sharpe ratio is calculated...
# 
# Total Excess = (-4.6 - .012) + (0.3 - 0.12) + (3.1 - .012) + (11.4 - .012) + (15.8 - .012) + (28.3 - .012) + (11.0 - .012) + (4.7 - .012) + (7.0 - .012)
# 
# Sharpe = 8.5 (Average of Excess Return) / 9.1 (Standard deviation of Excess Returns) = 0.94
# 
# Higher Sharpe ratios are better, but they suffer from context; how does someone use this information to make a decision?
# 
# Statistics affords a way to compare two sample sets even when their data is on different scales. Standardization contextualizes different data
# with the following formula...
# 
# z-score = (Sample score - Sample average) / Sample standard deviation
# 
# The resulting z-score results in the number of standard deviations away from the average for the sample score. Standardization assumes a normal
# distribution of data, more commonly known as a Bell curve. The similarities to the Sharpe ratio formula are clear; substitute risk-free rate
# for sample average. Standard scores, though, have no time component; they are primarily point-in-time calculations.
# 
# Our resulting Volatility-Adjusted Return combines Sharpe and standard scores to highlight the risk within an investment strategy or by an individual
# participant. A participant has a calculated 5-year PROR; the VAR uses this score versus determining a time-based excess return versus the risk-free rate
# in that time period. For example, a DIY participant with a 11.5% 5-year PROR has a VAR of...
# 
# VAR = 11.5 - 0.0072 / 5.5 = 2.1
# 
# The VAR calculation is: Excess Return / Std Deviation of Excess Returns, where Excess Return = Rate of Return - Risk-free Rate
# 
# VAR represents a standard, volatility-adjusted value that affords a way to compare VARs amongst investment strategies and/or participants. Whereas
# a DIY participant with a 11.5% ROR has taken a great deal more risk than, say, a TDF user with a 8.7% ROR over the same period, and who has the exact
# same VAR.
# 
# The following code requires only a few variables and assumes that all participants with returns in any time period of analysis are included, which would
# be the participant population. This analysis is ONLY to develop the VARs, not further analysis or comparison.

##### END CODE NOTES #####

##### BEGIN REQUIRED VARIABLES #####
# 1) Plan Number
# 2) Plan Name
# 3) SSN
# 4) Investment strategy
# 5-7) Personal Rate of Return for each time period
# 8-10) Risk-free rate for each time period
##### END REQUIRED VARIABLES #####

##### BEGIN OUTPUT #####
# Assuming calculations for 1, 3 and 5-year PRORs
# 
# Output includes the original variables plus...
# 
# 11-13) Excess ROR for each time period
# 14-16) VAR for each time period
# 17-22) Two Ranks of PROR by time period: 1) within plan 2) across participant population
# 23-28) Two Ranks of VAR by time period: 1) within plan 2) across participant population
# 29-34) Two Percent of PROR Ranks by time period, as above (PROR is in the x percentile)
# 35-40) Two Percent of VAR Ranks by time period, as above
# 41-46) Two Decile representations of the PROR Percentile ranks by time period, as 1) and 2) above; for example, 43% is in the 50th percentile
# 47-52) Two Decile representations of the VAR Percentile ranks by time period, as 1) and 2) above; for example, 43% is in the 50th percentile
##### END OUTPUT #####

##### BEGIN LIBRARIES #####
library(xlsx)

##### END LIBRARIES #####

# LOAD THE RISK-FREE RATES
# Document a vector/array with each of the RISK-FREE rates
rfrates <- c("1" = 0.03, "3" = 0.07, "5" = 0.09) # 1, 3 and 5-year RF as of 12/31/14 from Morningstar Direct for the Citi 3-month T-Bill


##### 12/31/14 PRORs
# Bring in the 1-year PRORs, more than 1.2M of them, broken out by STRATEGY
pror1.brok <- read.csv("c:\\r\\data\\BROK_PROR1_12312014.csv", header = TRUE, stringsAsFactors = TRUE)
pror1.chg <- read.csv("c:\\r\\data\\CHG_PROR1_12312014.csv", header = TRUE, stringsAsFactors = TRUE)
pror1.diy <- read.csv("c:\\r\\data\\DIY_PROR1_12312014.csv", header = TRUE, stringsAsFactors = TRUE)
pror1.tdf <- read.csv("c:\\r\\data\\TDF_PROR1_12312014.csv", header = TRUE, stringsAsFactors = TRUE)
pror1.ma <- read.csv("c:\\r\\data\\MA_PROR1_12312014.csv", header = TRUE, stringsAsFactors = TRUE)

# Combine the individual STRATEGY data into a single PROR1 data set
pror1 <- rbind(pror1.brok, pror1.chg, pror1.diy, pror1.tdf, pror1.ma)

# Convert a couple of the columns to FACTORS to simplify functions
# pror1$PLAN <- factor(pror1$PLAN)
# pror1$PRORYR <- factor(pror1$PRORYR)
# 
# # Store the EXCESS PROR
# # Subtract the correct period's risk-free rate by using the participant's PRORYEAR as an index into the RFRATES vector/array
# pror1$EXCESSPROR <- pror1$PROR - rfrates[as.character(pror1$PRORYR)]
# 
# # Store the MEAN EXCESS PRORS by Strategy and Year
# mean <- aggregate(pror1$EXCESSPROR, by = list(pror1$STRAT, pror1$PRORYR), mean)
# names(mean) <- c('Strategy', 'PRORYR', 'Average')
# 
# # Store the STANDARD DEVIATION of the EXCESS PRORS by Strategy and Year
# sd <- aggregate(pror1$EXCESSPROR, by = list(pror1$STRAT, pror1$PRORYR), sd)
# names(sd) <- c('Strategy', 'PRORYR', 'SD')
# 
# # Merge the MEAN and SD calculations based on STRATEGY and PRORYR
# meansd <- merge(mean, sd, by = c("Strategy", "PRORYR"))
# meansd$VAR <- meansd$Average / meansd$SD
# 
# # Merge the MEANSD VARs into the main data
# pror1 <- merge(pror1, meansd[ , c(1, 2, 4)], by.x = c("STRAT", "PRORYR"), by.y = c("Strategy", "PRORYR"))
# 
# pror1$VAR <- pror1$EXCESSPROR / pror1$SD
# 
# pror1$PRORDEC <- factor(paste(as.numeric(cut(pror1$PROR, quantile(pror1$PROR, probs = seq(from = 0, to = 1, by = .1)), include.lowest = TRUE)),"0th Percentile", sep = ''),
#                         levels = c("10th Percentile", "20th Percentile", "30th Percentile", "40th Percentile", "50th Percentile",
#                                    "60th Percentile", "70th Percentile", "80th Percentile", "90th Percentile", "100th Percentile"))
# 
# pror1$VARDEC <- factor(paste(as.numeric(cut(pror1$VAR, quantile(pror1$VAR, probs = seq(from = 0, to = 1, by = .1)), include.lowest = TRUE)),"0th Percentile", sep = ''),
#                        levels = c("10th Percentile", "20th Percentile", "30th Percentile", "40th Percentile", "50th Percentile",
#                                   "60th Percentile", "70th Percentile", "80th Percentile", "90th Percentile", "100th Percentile"))
# 
# # What is the proportion of STRATEGY users through the entire population?
# (proportion <- round(prop.table(table(pror1$STRAT)) * 100, 1)) # BROK 1.3%, CHG 6.3%, DIY 54.5%, TDF 31.4%, MA 6.5%
# barplot(proportion)

# Which plans have similar proportions of STRATEGY use?


##### Bring in the 3-year PRORs
pror3 <- read.csv('c:\\r\\data\\COMPLEX_PROR3_12312014.csv', stringsAsFactors = TRUE)
##### Bring in the 5-year PRORs
pror5 <- read.csv('c:\\r\\data\\COMPLEX_PROR5_12312014.csv', stringsAsFactors = TRUE) # Carried over 24 extra columns
pror5 <- pror5[ , c(1:7)]

# Combine the three by-year data sets into a single working file
pror <- rbind(pror1, pror3, pror5) # Almost 2.47 million records

pror$PRORYR <- factor(pror$PRORYR)

aggregate(pror$PROR, by = list(pror$PLAN, pror$STRAT, pror$PRORYR), mean)

# Store the EXCESS PROR
# Subtract the correct period's risk-free rate by using the participant's PRORYEAR as an index into the RFRATES vector/array
pror$EXCESSPROR <- pror$PROR - rfrates[as.character(pror$PRORYR)]

# Store the MEAN EXCESS PRORS by Strategy and Year
mean <- aggregate(pror$EXCESSPROR, by = list(pror$STRAT, pror$PRORYR), mean)
names(mean) <- c('Strategy', 'PRORYR', 'Average')

# Store the STANDARD DEVIATION of the EXCESS PRORS by Strategy and Year
sd <- aggregate(pror$EXCESSPROR, by = list(pror$STRAT, pror$PRORYR), sd)
names(sd) <- c('Strategy', 'PRORYR', 'SD')

# Merge the MEAN and SD calculations based on STRATEGY and PRORYR
meansd <- merge(mean, sd, by = c("Strategy", "PRORYR"))
meansd$VAR <- meansd$Average / meansd$SD

# Merge the MEANSD VARs into the main data
pror <- merge(pror, meansd[ , c(1, 2, 4)], by.x = c("STRAT", "PRORYR"), by.y = c("Strategy", "PRORYR"))

pror$VAR <- pror$EXCESSPROR / pror$SD

pror$PRORDEC <- factor(paste(as.numeric(cut(pror$PROR, quantile(pror$PROR, probs = seq(from = 0, to = 1, by = .1)), include.lowest = TRUE)),"0th Percentile", sep = ''),
                        levels = c("10th Percentile", "20th Percentile", "30th Percentile", "40th Percentile", "50th Percentile",
                                   "60th Percentile", "70th Percentile", "80th Percentile", "90th Percentile", "100th Percentile"))

pror$VARDEC <- factor(paste(as.numeric(cut(pror$VAR, quantile(pror$VAR, probs = seq(from = 0, to = 1, by = .1)), include.lowest = TRUE)),"0th Percentile", sep = ''),
                       levels = c("10th Percentile", "20th Percentile", "30th Percentile", "40th Percentile", "50th Percentile",
                                  "60th Percentile", "70th Percentile", "80th Percentile", "90th Percentile", "100th Percentile"))

# Write an Excel file of average VARs by year, age cohort, and Strategy to my local drive on a named sheet without row numbers
# write.xlsx(x = aggregate(pror$VAR, by = list(pror$PRORYR, pror$AGECOHORT, pror$STRAT), mean), file = "c:\\r\\data\\allvar.xlsx",
#           sheetName = "AllVAR", row.names = FALSE)

# Rough by-plan VARs
# Need to write by-plan Excel file with two tabs: summary VAR table and by-participant
# Store the unique plan numbers
allPlans <- sort(unique(pror$PLAN))

for(eachplan in 1:length(allPlans)) {

  temp <- pror[pror$PLAN == allPlans[eachplan], c(1:8)] # Pull the by-plan rows; cut the all participant SD and VAR to re-do by plan
  
  # Store the MEAN EXCESS PRORS by Strategy and Year
  mean <- aggregate(temp$EXCESSPROR, by = list(temp$STRAT, temp$PRORYR), mean, na.rm = TRUE)
  names(mean) <- c('Strategy', 'PRORYR', 'Average')
  
  # Store the STANDARD DEVIATION of the EXCESS PRORS by Strategy and Year
  sd <- aggregate(temp$EXCESSPROR, by = list(temp$STRAT, temp$PRORYR), sd, na.rm = TRUE)
  names(sd) <- c('Strategy', 'PRORYR', 'SD')
  
  # Merge the MEAN and SD calculations based on STRATEGY and PRORYR
  meansd <- merge(mean, sd, by = c("Strategy", "PRORYR"))
  meansd$VAR <- meansd$Average / meansd$SD
  
  # Merge the MEANSD VARs into the main data
  temp <- merge(temp, meansd[ , c(1, 2, 4)], by.x = c("STRAT", "PRORYR"), by.y = c("Strategy", "PRORYR"))
  
  temp$VAR <- temp$EXCESSPROR / temp$SD
  
  temp$PRORDEC <- factor(paste(as.numeric(cut(temp$PROR, quantile(temp$PROR, probs = seq(from = 0, to = 1, by = .1)), include.lowest = TRUE)),"0th Percentile", sep = ''),
                         levels = c("10th Percentile", "20th Percentile", "30th Percentile", "40th Percentile", "50th Percentile",
                                    "60th Percentile", "70th Percentile", "80th Percentile", "90th Percentile", "100th Percentile"))
  # If only 1 participant is in a STRATEGY for any of the time periods the SD and VAR values will be NA
  # This is not an issue with the PROR as each participant will have one, and the value is not calculated like VAR
  temp$VARDEC <- factor(paste(as.numeric(cut(temp$VAR, quantile(temp$VAR, probs = seq(from = 0, to = 1, by = .1), na.rm = TRUE), include.lowest = TRUE)),"0th Percentile", sep = ''),
                        levels = c("10th Percentile", "20th Percentile", "30th Percentile", "40th Percentile", "50th Percentile",
                                   "60th Percentile", "70th Percentile", "80th Percentile", "90th Percentile", "100th Percentile"))
  
  # Write an output file of average VARs by year, age cohort, and Strategy to my local drive on a named sheet without row numbers
  agg <- aggregate(temp$VAR, by = list(temp$PRORYR, temp$AGECOHORT, temp$STRAT), mean, na.rm = TRUE)
  colnames(agg) <- c("PRORYR", "AGECOHORT", "STRATEGY", "VAR")
  
  # Set the filepath
  filepath <- "c:\\r\\data\\123114VAR\\"
  # Store the plan number
  plannbr <- as.character(unique(temp$PLAN)) # Don't have to cast the number to a character but better to do here than let R do it implicitly
  # Set the file extension
  ext <- ".csv"
  
  # Combine the elements into the full file and path names
  summary_filename <- paste(filepath, plannbr, '_summary', ext, sep = '')
  all_filename <- paste(filepath, plannbr, '_all', ext,sep = '')
  
  # Write the files to disk
  write.csv(x = agg, file = summary_filename, row.names = FALSE)
  write.csv(x = temp, file = all_filename, row.names = FALSE)
}





# RANK THE PRORs and VARs BY PRORYEAR
# AVE does GROUP AVERAGES over level combinations of FACTORS
ccp.work$PRORRANK <- ave(ccp.work$PROR, ccp.work$PRORYEAR, FUN = rank, na.last = 'keep', ties.method = 'first')
ccp.work$VARRANK <- ave(ccp.work$VAR, ccp.work$PRORYEAR, FUN = rank, na.last = 'keep', ties.method = 'first')

# DETERMINE THE PERCENTAGE OF THE PROR AND VAR
ccp.work$PRORPCT <- ccp.work$PRORRANK / ave(ccp.work$PROR, ccp.work$PRORYEAR, FUN = length)
ccp.work$VARPCT <- ccp.work$VARRANK / ave(ccp.work$VAR, ccp.work$PRORYEAR, FUN = length)

# DETERMINE THE QUANTILE INTO WHICH THE PROR AND VAR FALL

# Can CUT() be used with the returned QUANTILE values or do I need to something else to determine this?
# CUT rolls up the number of records that fall within the determined cuts, not the designation of a single record
# Found this alternative using CUT and QUANTILE, which works against all PRORs, not by year
acut <- cut(ccp.work$PROR, quantile(ccp.work$PROR, probs = seq(from = 0, to = 1, by = .1)), include.lowest = TRUE)

# ACUT has the ACTUAL VALUE of the CUT, but is stored as a FACTOR, so to see the DECILE we can CAST the value
# Might cut this into multiple lines to pull the cuts by PRORYEAR first
as.numeric(acut)

cut1 <- cut(ccp.work[ccp.work$PRORYEAR == 1, ]$PROR, quantile(ccp.work[ccp.work$PRORYEAR == 1, ]$PROR, probs = seq(from = 0, to = 1, by = .1)), include.lowest = TRUE)
cut3 <- cut(ccp.work[ccp.work$PRORYEAR == 3, ]$PROR, quantile(ccp.work[ccp.work$PRORYEAR == 3, ]$PROR, probs = seq(from = 0, to = 1, by = .1)), include.lowest = TRUE)
cut5 <- cut(ccp.work[ccp.work$PRORYEAR == 5, ]$PROR, quantile(ccp.work[ccp.work$PRORYEAR == 5, ]$PROR, probs = seq(from = 0, to = 1, by = .1)), include.lowest = TRUE)



# Create quantile classification function
fQuantClass <- function(valrank) {
  ifelse(valrank < quantiles[1], "Bottom 10%", 
         ifelse(valrank < quantiles[2], "20th Percentile",
                ifelse(valrank < quantiles[3], "30th Percentile",
                       ifelse(valrank < quantiles[4], "40th Percentile",
                              ifelse(valrank < quantiles[5], "50th Percentile",
                                     ifelse(valrank < quantiles[6], "60th Percentile",
                                            ifelse(valrank < quantiles[7], "70th Percentile",
                                                   ifelse(valrank < quantiles[8], "80th Percentile",
                                                          ifelse(valrank < quantiles[9], "90th Percentile", "Top 10%")))))))))  
}

quantiles <- quantile(ccp.work$PRORPCT, seq(from = .1, to = 1, by = .1)) # This works
ccp.work$PRORPCTRANK <- fQuantClass(ccp.work$PRORPCT)

quantiles <- quantile(ccp.work$VARPCT, seq(from = .1, to = 1, by = .1)) # This works
ccp.work$VARPCTRANK <- fQuantClass(ccp.work$VARPCT)



# Bring in the 3-year PRORs




















# This is a small file with only CCP data, but am using it for by-plan work
work.df <- read.csv("C:\\r\\data\\CCP_RE_ENROLL_SMALL.csv", header = TRUE, stringsAsFactors = FALSE)

str(work.df) # Goofy CCP file has 27 extra columns for some reason

# Make STRATEGY a factor
work.df$STRATEGY <- factor(work.df$STRATEGY)

# Nuke extra columns
work.df <- work.df[ , c(1:10)]

# Now added extra six rows, nuke them, too
work.df <- work.df[c(1:367), ]

# Calculate Excess Return by time period
work.df$EXCESSPROR1Y <- work.df$PROR1Y - work.df$RFRATE1Y
work.df$EXCESSPROR3Y <- work.df$PROR3Y - work.df$RFRATE3Y
work.df$EXCESSPROR5Y <- work.df$PROR5Y - work.df$RFRATE5Y

# Set up a "constant" for the column headers 
colHeads <- c("Strategy", "Average")
# Calculate AVERAGE excess return by strategy for all time periods
pror1y.mean <- aggregate(work.df$EXCESSPROR1Y, by = list(work.df$STRATEGY), mean, na.rm = TRUE)
names(pror1y.mean) <- colHeads

pror3y.mean <- aggregate(work.df$EXCESSPROR3Y, by = list(work.df$STRATEGY), mean, na.rm = TRUE)
names(pror3y.mean) <- colHeads

pror5y.mean <- aggregate(work.df$EXCESSPROR5Y, by = list(work.df$STRATEGY), mean, na.rm = TRUE)
names(pror5y.mean) <- colHeads

# Calculate standard deviation of excess returns by strategy for all time periods
colHeads <- c("Strategy", "SD")
pror1y.sd <- aggregate(work.df$EXCESSPROR1Y, by = list(work.df$STRATEGY), sd, na.rm = TRUE)
names(pror1y.sd) <- colHeads

pror3y.sd <- aggregate(work.df$EXCESSPROR3Y, by = list(work.df$STRATEGY), sd, na.rm = TRUE)
names(pror3y.sd) <- colHeads

pror5y.sd <- aggregate(work.df$EXCESSPROR5Y, by = list(work.df$STRATEGY), sd, na.rm = TRUE)
names(pror5y.sd) <- colHeads

# Split the work file into 1, 3 and 5-years
pror1y <- work.df[!is.na(work.df$EXCESSPROR1Y), c(3, 4, 11)]
pror1y <- merge(pror1y, pror1y.sd, by.x = "STRATEGY", by.y = "Strategy")
pror1y <- merge(pror1y, pror1y.mean, by.x = "STRATEGY", by.y = "Strategy")

pror3y <- work.df[!is.na(work.df$EXCESSPROR3Y), c(3, 4, 12)]
pror3y <- merge(pror3y, pror3y.sd, by.x = "STRATEGY", by.y = "Strategy")
pror3y <- merge(pror3y, pror3y.mean, by.x = "STRATEGY", by.y = "Strategy")

pror5y <- work.df[!is.na(work.df$EXCESSPROR5Y), c(3, 4, 13)]
pror5y <- merge(pror5y, pror5y.sd, by.x = "STRATEGY", by.y = "Strategy")
pror5y <- merge(pror5y, pror5y.mean, by.x = "STRATEGY", by.y = "Strategy")


# Calculate by-participant VAR with matching strategy MEAN and SD
pror1y$VAR1Y <- (pror1y$EXCESSPROR1Y - pror1y$Average) / pror1y$SD
pror3y$VAR3Y <- (pror3y$EXCESSPROR3Y - pror3y$Average) / pror3y$SD
pror5y$VAR5Y <- (pror5y$EXCESSPROR5Y - pror5y$Average) / pror5y$SD

# Merge the separate years (SSN and VARx) back into the main plan file by SSN
work.df <- merge(work.df, pror1y[ , c(2, 6)], by = "SSN", all = TRUE)
work.df <- merge(work.df, pror3y[ , c(2, 6)], by = "SSN", all = TRUE)
work.df <- merge(work.df, pror5y[ , c(2, 6)], by = "SSN", all = TRUE)

# Add the PRORx and VARx RANKs to the data file
work.df$PROR1RANK <- rank(work.df$PROR1, na.last = "keep", ties.method = 'first')
work.df$PROR3RANK <- rank(work.df$PROR3, na.last = "keep", ties.method = "first")
work.df$PROR5RANK <- rank(work.df$PROR5, na.last = "keep", ties.method = "first")

work.df$VAR1RANK <- rank(work.df$VAR1, na.last = "keep", ties.method = 'first')
work.df$VAR3RANK <- rank(work.df$VAR3, na.last = "keep", ties.method = "first")
work.df$VAR5RANK <- rank(work.df$VAR5, na.last = "keep", ties.method = "first")

# Add the PRORx and VARx RANK% to the data file
pror.len <- length(which(!is.na(work.df$PROR1RANK)))
work.df$PROR1PCT <- work.df$PROR1RANK / pror.len 

pror.len <- length(which(!is.na(work.df$PROR3RANK)))
work.df$PROR3PCT <- work.df$PROR3RANK / pror.len

pror.len <- length(which(!is.na(work.df$PROR5RANK)))
work.df$PROR5PCT <- work.df$PROR5RANK / pror.len

# Add the PRORx and VARx DECILEs to the data file
pror1rank.quant <- quantile(work.df$PROR1RANK, c(.10, .20, .30, .40, .50, .60, .70, .80, .90, 1.00), na.rm = TRUE)
work.df$PROR1DEC <- ifelse(work.df$PROR1RANK < pror1rank.quant[1], "Bottom 10%", 
               ifelse(work.df$PROR1RANK < pror1rank.quant[2], "20th Percentile",
                      ifelse(work.df$PROR1RANK < pror1rank.quant[3], "30th Percentile",
                             ifelse(work.df$PROR1RANK < pror1rank.quant[4], "40th Percentile",
                                    ifelse(work.df$PROR1RANK < pror1rank.quant[5], "50th Percentile",
                                           ifelse(work.df$PROR1RANK < pror1rank.quant[6], "60th Percentile",
                                                  ifelse(work.df$PROR1RANK < pror1rank.quant[7], "70th Percentile",
                                                         ifelse(work.df$PROR1RANK < pror1rank.quant[8], "80th Percentile",
                                                                ifelse(work.df$PROR1RANK < pror1rank.quant[9], "90th Percentile", "Top 10%")))))))))

pror3rank.quant <- quantile(work.df$PROR3RANK, c(.10, .20, .30, .40, .50, .60, .70, .80, .90, 1.00), na.rm = TRUE)
work.df$PROR3DEC <- ifelse(work.df$PROR3RANK < pror3rank.quant[1], "Bottom 10%", 
                           ifelse(work.df$PROR3RANK < pror3rank.quant[2], "20th Percentile",
                                  ifelse(work.df$PROR3RANK < pror3rank.quant[3], "30th Percentile",
                                         ifelse(work.df$PROR3RANK < pror3rank.quant[4], "40th Percentile",
                                                ifelse(work.df$PROR3RANK < pror3rank.quant[5], "50th Percentile",
                                                       ifelse(work.df$PROR3RANK < pror3rank.quant[6], "60th Percentile",
                                                              ifelse(work.df$PROR3RANK < pror3rank.quant[7], "70th Percentile",
                                                                     ifelse(work.df$PROR3RANK < pror3rank.quant[8], "80th Percentile",
                                                                            ifelse(work.df$PROR3RANK < pror3rank.quant[9], "90th Percentile", "Top 10%")))))))))

pror5rank.quant <- quantile(work.df$PROR5RANK, c(.10, .20, .30, .40, .50, .60, .70, .80, .90, 1.00), na.rm = TRUE)
work.df$PROR5DEC <- ifelse(work.df$PROR5RANK < pror5rank.quant[1], "Bottom 10%", 
                           ifelse(work.df$PROR5RANK < pror5rank.quant[2], "20th Percentile",
                                  ifelse(work.df$PROR5RANK < pror5rank.quant[3], "30th Percentile",
                                         ifelse(work.df$PROR5RANK < pror5rank.quant[4], "40th Percentile",
                                                ifelse(work.df$PROR5RANK < pror5rank.quant[5], "50th Percentile",
                                                       ifelse(work.df$PROR5RANK < pror5rank.quant[6], "60th Percentile",
                                                              ifelse(work.df$PROR5RANK < pror5rank.quant[7], "70th Percentile",
                                                                     ifelse(work.df$PROR5RANK < pror5rank.quant[8], "80th Percentile",
                                                                            ifelse(work.df$PROR5RANK < pror5rank.quant[9], "90th Percentile", "Top 10%")))))))))


var1rank.quant <- quantile(work.df$VAR1RANK, c(.10, .20, .30, .40, .50, .60, .70, .80, .90, 1.00), na.rm = TRUE)
work.df$VAR1DEC <- ifelse(work.df$VAR1RANK < var1rank.quant[1], "Bottom 10%", 
                           ifelse(work.df$VAR1RANK < var1rank.quant[2], "20th Percentile",
                                  ifelse(work.df$VAR1RANK < var1rank.quant[3], "30th Percentile",
                                         ifelse(work.df$VAR1RANK < var1rank.quant[4], "40th Percentile",
                                                ifelse(work.df$VAR1RANK < var1rank.quant[5], "50th Percentile",
                                                       ifelse(work.df$VAR1RANK < var1rank.quant[6], "60th Percentile",
                                                              ifelse(work.df$VAR1RANK < var1rank.quant[7], "70th Percentile",
                                                                     ifelse(work.df$VAR1RANK < var1rank.quant[8], "80th Percentile",
                                                                            ifelse(work.df$VAR1RANK < var1rank.quant[9], "90th Percentile", "Top 10%")))))))))

var3rank.quant <- quantile(work.df$VAR3RANK, c(.10, .20, .30, .40, .50, .60, .70, .80, .90, 1.00), na.rm = TRUE)
work.df$VAR3DEC <- ifelse(work.df$VAR3RANK < var3rank.quant[1], "Bottom 10%", 
                          ifelse(work.df$VAR3RANK < var3rank.quant[2], "20th Percentile",
                                 ifelse(work.df$VAR3RANK < var3rank.quant[3], "30th Percentile",
                                        ifelse(work.df$VAR3RANK < var3rank.quant[4], "40th Percentile",
                                               ifelse(work.df$VAR3RANK < var3rank.quant[5], "50th Percentile",
                                                      ifelse(work.df$VAR3RANK < var3rank.quant[6], "60th Percentile",
                                                             ifelse(work.df$VAR3RANK < var3rank.quant[7], "70th Percentile",
                                                                    ifelse(work.df$VAR3RANK < var3rank.quant[8], "80th Percentile",
                                                                           ifelse(work.df$VAR3RANK < var3rank.quant[9], "90th Percentile", "Top 10%")))))))))
var5rank.quant <- quantile(work.df$VAR5RANK, c(.10, .20, .30, .40, .50, .60, .70, .80, .90, 1.00), na.rm = TRUE)
work.df$VAR5DEC <- ifelse(work.df$VAR5RANK < var5rank.quant[1], "Bottom 10%", 
                          ifelse(work.df$VAR5RANK < var5rank.quant[2], "20th Percentile",
                                 ifelse(work.df$VAR5RANK < var5rank.quant[3], "30th Percentile",
                                        ifelse(work.df$VAR5RANK < var5rank.quant[4], "40th Percentile",
                                               ifelse(work.df$VAR5RANK < var5rank.quant[5], "50th Percentile",
                                                      ifelse(work.df$VAR5RANK < var5rank.quant[6], "60th Percentile",
                                                             ifelse(work.df$VAR5RANK < var5rank.quant[7], "70th Percentile",
                                                                    ifelse(work.df$VAR5RANK < var5rank.quant[8], "80th Percentile",
                                                                           ifelse(work.df$VAR5RANK < var5rank.quant[9], "90th Percentile", "Top 10%")))))))))





# Writing the WORK.DF data to an Excel .xlsx file
write.xlsx(work.df, "c:\\r\\data\\workdf.xlsx")




##### Working with an Excel CSV in a more data.frame-friendly format

# NOTE: Always consider breaking big problems into smaller ones and then combining the answers back together when they're done.
# In this case I'm working with a "big" file without breaking into smaller pieces (1, 3 and 5 years as above) because the data
# better supports a DATA.FRAME structure.

# READING THE DATA INTO R AND CLEANING UP THE STRUCTURE
# Restructured some of the CCP file into something more R-friendly in terms of FACTORS and other variable types
ccp.work <- read.csv("c:\\r\\data\\ccp_re_enroll_small_restruc.csv", header = TRUE, stringsAsFactors = TRUE)
str(ccp.work) # Something goofy again, as the file believes it has 373 rows and 29 variables
ccp.work <- ccp.work[c(1:48), c(1:6)] # Figure out a dynamic way to eliminate the unnecessary rows and columns

# REMOVING UNNECESSARY COLUMNS
# Remove PLAN NAME
ccp.work$PLN_LONG_NM <- NULL

# CONVERT SOME COLUMNS INTO FACTORS FOR AGGREGATION AND ORGANIZATION PURPOSES
# Convert some columns to FACTORS
ccp.work$SSN <- factor(ccp.work$SSN)
ccp.work$PRORYEAR <- factor(ccp.work$PRORYEAR)

# LOAD THE RISK-FREE RATES
# Document a vector/array with each of the RISK-FREE rates
rfrates <- c("1" = 0.06, "3" = 0.07, "5" = 0.12) # 1, 3 and 5-year RF

# Store the EXCESS PROR
# Subtract the correct period's risk-free rate by using the participant's PRORYEAR as an index into the RFRATES vector/array
ccp.work$EXCESSPROR <- ccp.work$PROR - rfrates[as.character(ccp.work$PRORYEAR)]

# Store the MEAN EXCESS PRORS by Strategy and Year
mean <- aggregate(ccp.work$EXCESSPROR, by = list(ccp.work$STRATEGY, ccp.work$PRORYEAR), mean)
names(mean) <- c('Strategy', 'PRORYR', 'Average')

# Store the STANDARD DEVIATION of the EXCESS PRORS by Strategy and Year
sd <- aggregate(ccp.work$EXCESSPROR, by = list(ccp.work$STRATEGY, ccp.work$PRORYEAR), sd)
names(sd) <- c('Strategy', 'PRORYR', 'SD')

# Merge the MEAN and SD calculations based on STRATEGY and PRORYR
meansd <- merge(mean, sd, by = c("Strategy", "PRORYR"))
meansd$VAR <- meansd$Average / meansd$SD

# Merge the MEANSD VARs into the main data
ccp.work <- merge(ccp.work, meansd[ , c(1, 2, 4)], by.x = c("STRATEGY", "PRORYEAR"), by.y = c("Strategy", "PRORYR"))

ccp.work$VAR <- ccp.work$EXCESSPROR / ccp.work$SD

# RANK THE PRORs and VARs BY PRORYEAR
# AVE does GROUP AVERAGES over level combinations of FACTORS
ccp.work$PRORRANK <- ave(ccp.work$PROR, ccp.work$PRORYEAR, FUN = rank, na.last = 'keep', ties.method = 'first')
ccp.work$VARRANK <- ave(ccp.work$VAR, ccp.work$PRORYEAR, FUN = rank, na.last = 'keep', ties.method = 'first')

# DETERMINE THE PERCENTAGE OF THE PROR AND VAR
ccp.work$PRORPCT <- ccp.work$PRORRANK / ave(ccp.work$PROR, ccp.work$PRORYEAR, FUN = length)
ccp.work$VARPCT <- ccp.work$VARRANK / ave(ccp.work$VAR, ccp.work$PRORYEAR, FUN = length)

# DETERMINE THE QUANTILE INTO WHICH THE PROR AND VAR FALL

# Can CUT() be used with the returned QUANTILE values or do I need to something else to determine this?
# CUT rolls up the number of records that fall within the determined cuts, not the designation of a single record
# Found this alternative using CUT and QUANTILE, which works against all PRORs, not by year
acut <- cut(ccp.work$PROR, quantile(ccp.work$PROR, probs = seq(from = 0, to = 1, by = .1)), include.lowest = TRUE)

# ACUT has the ACTUAL VALUE of the CUT, but is stored as a FACTOR, so to see the DECILE we can CAST the value
# Might cut this into multiple lines to pull the cuts by PRORYEAR first
as.numeric(acut)

cut1 <- cut(ccp.work[ccp.work$PRORYEAR == 1, ]$PROR, quantile(ccp.work[ccp.work$PRORYEAR == 1, ]$PROR, probs = seq(from = 0, to = 1, by = .1)), include.lowest = TRUE)
cut3 <- cut(ccp.work[ccp.work$PRORYEAR == 3, ]$PROR, quantile(ccp.work[ccp.work$PRORYEAR == 3, ]$PROR, probs = seq(from = 0, to = 1, by = .1)), include.lowest = TRUE)
cut5 <- cut(ccp.work[ccp.work$PRORYEAR == 5, ]$PROR, quantile(ccp.work[ccp.work$PRORYEAR == 5, ]$PROR, probs = seq(from = 0, to = 1, by = .1)), include.lowest = TRUE)



# Create quantile classification function
fQuantClass <- function(valrank) {
  ifelse(valrank < quantiles[1], "Bottom 10%", 
        ifelse(valrank < quantiles[2], "20th Percentile",
               ifelse(valrank < quantiles[3], "30th Percentile",
                      ifelse(valrank < quantiles[4], "40th Percentile",
                             ifelse(valrank < quantiles[5], "50th Percentile",
                                    ifelse(valrank < quantiles[6], "60th Percentile",
                                           ifelse(valrank < quantiles[7], "70th Percentile",
                                                  ifelse(valrank < quantiles[8], "80th Percentile",
                                                         ifelse(valrank < quantiles[9], "90th Percentile", "Top 10%")))))))))  
}

quantiles <- quantile(ccp.work$PRORPCT, seq(from = .1, to = 1, by = .1)) # This works
ccp.work$PRORPCTRANK <- fQuantClass(ccp.work$PRORPCT)

quantiles <- quantile(ccp.work$VARPCT, seq(from = .1, to = 1, by = .1)) # This works
ccp.work$VARPCTRANK <- fQuantClass(ccp.work$VARPCT)








# Don't use PLAN or SSN for anything
# FACTORS: AgeCohort, Strategy, MgdSolution
work.data$AgeCohort <- factor(work.data$AgeCohort, levels = c("20 - 29", "30 - 39", "40 - 49", "50 - 59", "60 - 69", "Over 70"))
work.data$Strategy <- factor(work.data$Strategy)
work.data$MgdSolution <- factor(work.data$MgdSolution)

# Generate the Excess Return for each participant by subtracting the Risk-Free Rate
work.data$ExcessReturn <- work.data$FiveYrPROR - work.data$RiskFreeRate

# Get the aggregated averages by Strategy
StratAvgs <- aggregate(work.data$ExcessReturn, by = list(Strategy = work.data$Strategy), mean)
StratSDs <- aggregate(work.data$ExcessReturn, by = list(Strategy = work.data$Strategy), sd)

work.data$RAR <- work.data$ExcessReturn / StratSDs[work.data$Strategy, ]$x

work.data$RAR.Group <- factor(ifelse(work.data$RAR <= 1.489, "First Quartile",
                                     ifelse(work.data$RAR <= 2.292, "Median",
                                            ifelse(work.data$RAR <= 2.892, "Third Quartile", "Fourth Quartile"))), levels = c("First Quartile", "Median", "Third Quartile", "Fourth Quartile"))
# Store the Low and High RARs to work with
lowRAR <- -3
highRAR <- 10

# Store the PROR and RAR points for graphing
diy.pror.pts <- subset(work.data$FiveYrPROR, work.data$Strategy == "DIY" & work.data$RAR >= lowRAR & work.data$RAR <= highRAR)
diy.rar.pts <- subset(work.data$RAR, work.data$Strategy == "DIY" & work.data$RAR >= lowRAR & work.data$RAR <= highRAR)
ma.pror.pts <- subset(work.data$FiveYrPROR, work.data$Strategy == "MA Users" & work.data$RAR >= lowRAR & work.data$RAR <= highRAR)
ma.rar.pts <- subset(work.data$RAR, work.data$Strategy == "MA Users" & work.data$RAR >= lowRAR & work.data$RAR <= highRAR)
brok.pror.pts <- subset(work.data$FiveYrPROR, work.data$Strategy == "Brokerage Users" & work.data$RAR >= lowRAR & work.data$RAR <= highRAR)
brok.rar.pts <- subset(work.data$RAR, work.data$Strategy == "Brokerage Users" & work.data$RAR >= lowRAR & work.data$RAR <= highRAR)
chg.pror.pts <- subset(work.data$FiveYrPROR, work.data$Strategy == "Changers" & work.data$RAR >= lowRAR & work.data$RAR <= highRAR)
chg.rar.pts <- subset(work.data$RAR, work.data$Strategy == "Changers" & work.data$RAR >= lowRAR & work.data$RAR <= highRAR)
tdf.pror.pts <- subset(work.data$FiveYrPROR, work.data$Strategy == "TDF Users" & work.data$RAR >= lowRAR & work.data$RAR <= highRAR)
tdf.rar.pts <- subset(work.data$RAR, work.data$Strategy == "TDF Users" & work.data$RAR >= lowRAR & work.data$RAR <= highRAR)

# Plot all of the points from their vectors
plot(c(diy.pror.pts, ma.pror.pts, brok.pror.pts, chg.pror.pts, tdf.pror.pts), 
     c(diy.rar.pts, ma.rar.pts, brok.rar.pts, chg.rar.pts, tdf.pror.pts), 
     xlab = "5-Year PROR", ylab = "Risk-adjusted Return", main = "Equivalent Risk-adjusted Return", type = "n", ylim = c(lowRAR - 1, highRAR + 1))

points(diy.pror.pts, diy.rar.pts, col = "red")
points(ma.pror.pts, ma.rar.pts, col = "blue", pch = 16)
points(brok.pror.pts, brok.rar.pts, col = "green")
points(chg.pror.pts, chg.rar.pts, col = "gray")
points(tdf.pror.pts, tdf.rar.pts, col = "purple")

legend(locator(1), c("DIY", "Mgd Accts", "Brokerage", "Changers", "TDF"), col = c("red", "blue", "green", "gray", "purple"))

# Plotting only the plan results
plan.nbr <- 159700

low.plan.RAR <- min(subset(work.data$RAR, work.data$Plan == plan.nbr))
high.plan.RAR <- max(subset(work.data$RAR, work.data$Plan == plan.nbr))

diy.pror.pts <- subset(work.data$FiveYrPROR, work.data$Strategy == "DIY" & work.data$RAR >= low.plan.RAR & work.data$RAR <= high.plan.RAR & work.data$Plan == plan.nbr)
diy.rar.pts <- subset(work.data$RAR, work.data$Strategy == "DIY" & work.data$RAR >= low.plan.RAR & work.data$RAR <= high.plan.RAR & work.data$Plan == plan.nbr)
ma.pror.pts <- subset(work.data$FiveYrPROR, work.data$Strategy == "MA Users" & work.data$RAR >= low.plan.RAR & work.data$RAR <= high.plan.RAR & work.data$Plan == plan.nbr)
ma.rar.pts <- subset(work.data$RAR, work.data$Strategy == "MA Users" & work.data$RAR >= low.plan.RAR & work.data$RAR <= high.plan.RAR & work.data$Plan == plan.nbr)
brok.pror.pts <- subset(work.data$FiveYrPROR, work.data$Strategy == "Brokerage Users" & work.data$RAR >= low.plan.RAR & work.data$RAR <= high.plan.RAR & work.data$Plan == plan.nbr)
brok.rar.pts <- subset(work.data$RAR, work.data$Strategy == "Brokerage Users" & work.data$RAR >= low.plan.RAR & work.data$RAR <= high.plan.RAR & work.data$Plan == plan.nbr)
chg.pror.pts <- subset(work.data$FiveYrPROR, work.data$Strategy == "Changers" & work.data$RAR >= low.plan.RAR & work.data$RAR <= high.plan.RAR & work.data$Plan == plan.nbr)
chg.rar.pts <- subset(work.data$RAR, work.data$Strategy == "Changers" & work.data$RAR >= low.plan.RAR & work.data$RAR <= high.plan.RAR & work.data$Plan == plan.nbr)
tdf.pror.pts <- subset(work.data$FiveYrPROR, work.data$Strategy == "TDF Users" & work.data$RAR >= low.plan.RAR & work.data$RAR <= high.plan.RAR & work.data$Plan == plan.nbr)
tdf.rar.pts <- subset(work.data$RAR, work.data$Strategy == "TDF Users" & work.data$RAR >= low.plan.RAR & work.data$RAR <= high.plan.RAR & work.data$Plan == plan.nbr)

# Plot all of the points from their vectors
plot(c(diy.pror.pts, ma.pror.pts, brok.pror.pts, chg.pror.pts, tdf.pror.pts), 
     c(diy.rar.pts, ma.rar.pts, brok.rar.pts, chg.rar.pts, tdf.pror.pts), 
     xlab = "5-Year PROR", ylab = "VAR", main = paste("Equivalent Volatility-Adjusted Return for Plan #", plan.nbr), 
     type = "n", ylim = c(round(low.plan.RAR), round(high.plan.RAR)))

# Hex equivalents to Empower RGB color from the Generic PPT Template
# 32 = 20, 61 = 3d, 124 = 7c Empower Blue
# 222 = de, 124 = 7c, 0 = 00 Empower Orange
# 153 = 99, 164 = a4, 173 = ad Empower Gray
# 74 = 4a, 119 = 77, 60 = 3c Empower Green
# 0 = 00, 37 = 25, 84 = 54 Empower Black?
points(diy.pror.pts, diy.rar.pts, col = "#203d7c", pch = 16)    # Blue
points(ma.pror.pts, ma.rar.pts, col = "#de7c00", pch = 16)      # Orange
points(brok.pror.pts, brok.rar.pts, col = "#99a4ad", pch = 16)  # Gray
points(chg.pror.pts, chg.rar.pts, col = "#4a773c", pch = 16)    # Green
points(tdf.pror.pts, tdf.rar.pts, col = "#002554", pch = 16)    # Black

abline(lm(diy.rar.pts ~ diy.pror.pts), col = "#203d7c")
abline(lm(ma.rar.pts ~ ma.pror.pts), col = "#de7c00")
abline(lm(brok.rar.pts ~ brok.pror.pts), col = "#99a4ad")
abline(lm(chg.rar.pts ~ chg.pror.pts), col = "#4a773c")
abline(lm(tdf.rar.pts ~ tdf.pror.pts), col = "#002554")

##### Display the equivalent PROR
# Set the PROR to compare
PROR.value = 10.3

# Set the Strategy that received that PROR
strat <- "MA Users"

# Look the RAR equivalent in the full WORK data
# 1) In the WORK data find the matching RAR by rounding the entered PROR and the matching Strategy as entered
# 2) If there's more than 1 value returned take the smallest value
# 3) Round the found RAR to 1.2 (3) digits
RAR.value = round(min(subset(work.data$RAR, round(work.data$FiveYrPROR, 2) == PROR.value & work.data$Strategy == strat)), 2)

# Find the matching rows in the WORK data of the RAR
# 1) In the WORK data create a matrix of Strategies and Five Yr PRORs that are NOT the entered strategy and match the RAR
RAR.matrix <- subset(work.data[ , c("Strategy", "FiveYrPROR")], work.data$Strategy != strat & round(work.data$RAR, 2) == RAR.value)

# Publish the Strategy and equivalent PROR
results <- aggregate(RAR.matrix$FiveYrPROR, by = list(Strategy = RAR.matrix$Strategy), range)
cat("The", strat, "strategy with a", PROR.value, "% 5-year PROR in other investment strategies would be:\n")
results

# Plot the equivalent PRORs by Strategy
plot(results)




##### Working with individual client files calculating VAR, this being CCP's 11/10/14 data file
ccp <- read.csv("c:\\r\\data\\CCP_Re_ENROLL.csv", header = TRUE)

levels(ccp$VARDEC5Y) <- c('', "Bottom 10%", "20th", "30th", "40th", 'Median (50th)', '60th', '70th', '80th', '90th', 'Top Decile (up to 100th)')

levels(ccp$PRORDEC5Y) <- c('', "Bottom 10%", "20th", "30th", "40th", 'Median (50th)', '60th', '70th', '80th', '90th', 'Top Decile (up to 100th)')

ccp$THREEYES <- ifelse(ccp$DECMATCH5Y == ccp$DECMATCH3Y,
                       ifelse(ccp$DECMATCH3Y == ccp$DECMATCH1Y, "Y", "N"), "N")
