# Investor type k-means clustering
# What types of investors do we have?
# Hypothesis: Stupid aggressive (DIY or Brok with lots of investments and low PROR), Lucky aggressive (DIY or Brok with lots of invs and higher PROR),
#             Moderates (managed solution, fewer invs, and steady PROR), Conseratives (older and/or managed solution, fewer invs, steady PROR)

##### LIBRARIES #####
library(reshape) # To rename variables


##### END LIBRARIES #####


##### BEGIN DATA MUNGING #####
# How does the CLEANDATA look? 1,199,140 records
summary(cleandata)

# Allocation percentages (...PCTs) are in whole numbers, not decimals; ex: 4.18 versus .0418
# AGE MIN 6.6, MAX 96.5 (no included birthdays)
# SALARY has a listed MIN of -1,273,500 and MAX of 133,200,000
# BALANCE has listed MIN of .01 and MAX of 7,923,000
# Current numbers of investments (NBRINVESTMENTS) and 1, 3 and 5 year investments spans 0 to 30, with 1,599, 516,200, and 699,900 NAs respectively
# Investment strategies have more NAs as go deeper with 694,180 in 5-year PROR
# AGECOHORT, STRAT1, STRAT3, STRAT5, MGDSOL1, MDGSOL3, and MGDSOL5 should be FACTORs
# Is FUNDS necessary? Range 1-32

# Decisions for data
# 1) Only use those with 5-year PRORs
# 2) Consider four types of investor: Set-and-Forget, Day Trader, Steady Eddie, Do-it-for-Me
# 3) Use the PRORs?

# Problematic values of BALANCE, SALARY mean
# we need to standardize these so kNN algorithm doesn't
# overvalue one over any of the others
# Write a normalize function with the minmax
normalize <- function(x) 
{
  return((x - min(x)) / (max(x) - min(x)))
}

# Get the BASE DATA
basedata <- read.csv("C:\\Users\\n344244\\Desktop\\Downside Deviation\\Complex_Wide_TDFMANEITHER_09162014.csv", header = TRUE)

# Clean up the data
basedata.clean <- basedata[, -c(1, 2, 6, 12, 14:25)]

# RENAME variable names "old" = "new"
basedata.clean <- rename(basedata.clean, c("SPONSOR_NUMBER" = "SponsorNbr", 
                                 "SPONSOR_NAME" = "SponsorNm",
                                 "PLAN" = "PlanNbr", 
                                 "EQTY_IVST_PC" = "EquityInvPct",
                                 "TRGT_DT_FUND_PC" = "TargetDtPct",
                                 "BRKG_IVST_PC" = "BrkgPct",
                                 "SALARY" = "Salary",
                                 "TOTAL_BALANCE" = "Balance",
                                 "AGE" = "Age",
                                 "INVEST_COUNT" = "NbrInvestments",
                                 "oneyr_eqty_pct" = "EqtyPctOneYrAgo",
                                 "oneyr_tdf_pct" = "TDFPctOneYrAgo",
                                 "oneyr_ivst_ct" = "NbrInvOneYrAgo",
                                 "threeyr_eqty_pct" = "EqtyPctThreeYrsAgo",
                                 "threeyr_tdf_pct" = "TDFPctThreeYrsAgo",
                                 "threeyr_ivst_ct" = "NbrInvThreeYrsAgo",
                                 "fiveyr_eqty_pct" = "EqtyPctFiveYrsAgo",
                                 "fiveyr_tdf_pct" = "TDFPctFiveYrsAgo",
                                 "fiveyr_ivst_ct" = "NbrInvFiveYrsAgo",
                                 "Five_Year_ROR" = "FiveYrPROR",
                                 "One_Year" = "OneYrPROR",
                                 "Three_Year_ROR" = "ThreeYrPROR",
                                 "age2" = "AgeCohort",
                                 "brok_bal" = "BrkgBal",
                                 "PROR1" = "Strat1",
                                 "PROR3" = "Strat3",
                                 "PROR5" = "Strat5",
                                 "MGDSOL1" = "MgdSol1",
                                 "MGDSOL3" = "MgdSol3",
                                 "MGDSOL5" = "MgdSol5",
                                 "NbrOfFunds" = "PlanNbrOfFunds"))


# Pull out only the participants with 5-year PRORs
five.year.data <- subset(basedata.clean, !is.na(basedata.clean$FiveYrPROR)) # 504,960 records

# What does FIVE.YEAR.DATA look like?
summary(five.year.data)

# SPONSORNBR, SPONSORNM, PLANNBR, SSN are what they are
# SALARY MIN = -1,273,500 and MAX = 131,550,000; IQR? How many SALARIES < 0? 18,164; > 1,000,000? 528
# BALANCE MIN = .01 and MAX = 7923000; workable?
# AGE MIN = 8.5 and MAX = 96.5 with 19 NAs; how many <20? 24 Greater than 70? 3,073 (Cut all 70+)
# NAs in investment strats at each year: 1-year = 1,029, 3-year = 14,091, 5-year 17,204
# AGECOHORT, Strats, MgdSols can be converted to FACTORS
# 85 records of JPM 141356 say they're using 30 of 31 investments currently
five.year.data.trim <- five.year.data[five.year.data$Age >= 20, ]
five.year.data.trim <- five.year.data.trim[five.year.data.trim$Age < 70, ]
five.year.data.trim <- five.year.data.trim[!is.na(five.year.data.trim$NbrInvFiveYrsAgo), ]
five.year.data.trim <- five.year.data.trim[!is.na(five.year.data.trim$PlanNbr), ]
five.year.data.trim <- five.year.data.trim[!is.na(five.year.data.trim$NbrInvThreeYrsAgo), ]
five.year.data.trim <- five.year.data.trim[!is.na(five.year.data.trim$NbrInvOneYrAgo), ]
five.year.data.trim <- five.year.data.trim[five.year.data.trim$Salary > 0 & five.year.data.trim$Salary < 1000000, ]

# FIVE.YEAR.DATA.TRIM has 482,779 records
# Shorten the data for k-means analysis: Drop SponsorNbr, SponsorNm, PlanNbr, SSN, AgeCohort, all Strats and MgdSols, and count of Funds
five.year.test <- five.year.data.trim[ , -c(1:4, 24, 26:32)]

# Now that we have the records cleaned up, let's NORMALIZE them
five.year.test.n <- as.data.frame(lapply(five.year.test, normalize))

summary(five.year.test.n)





##### END DATA MUNGING #####

##### BEGIN FIRST ANALYSIS #####
inv.type.clusters <- kmeans(five.year.test.n, 4)

inv.type.clusters$size

inv.type.clusters$centers

# Turn the clusters into actionable information by applying the clusters
# back onto the original dataset.
five.year.data.trim$cluster <- inv.type.clusters$cluster

round(prop.table(table(five.year.data.trim$AgeCohort, five.year.data.trim$Strat5, five.year.data.trim$cluster), 1) * 100, 1)

aggregate(five.year.test, by = list(Cluster = five.year.test$cluster), summary)

attach(five.year.data.trim)
inv.type.pca <- princomp(~Salary + Balance + Age + NbrInvestments +
                          EquityInvPct + TargetDtPct + BrkgPct +
                          EqtyPctOneYrAgo + TDFPctOneYrAgo + NbrInvOneYrAgo +
                          EqtyPctThreeYrsAgo + TDFPctThreeYrsAgo + NbrInvThreeYrsAgo +
                          EqtyPctFiveYrsAgo + TDFPctFiveYrsAgo + NbrInvFiveYrsAgo +
                          FiveYrPROR + OneYrPROR + ThreeYrPROR + BrkgBal)




##### END FIRST ANALYSIS #####

##### BEGIN SECOND ANALYSIS #####
# Can we create clusters based on how 5-year PROR participants alter their allocation,
# change strategies, or change # of investments?
# FIVE.YEAR.DATA.TRIM has 482,779 records
# Shorten the data for k-means analysis: Drop SponsorNbr, SponsorNm, PlanNbr, SSN, Salary, Balance, Age, and count of Funds
five.year.inv.strat <- five.year.data.trim[ , -c(1:4, 8:10, 21:23, 25, 29:33)]

five.year.inv.strat.n <- normalize(five.year.inv.strat)

inv.strat.clusters <- kmeans(five.year.inv.strat.n, 4)

inv.strat.clusters$size
