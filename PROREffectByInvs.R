##### Sharpe ratios and Effect Sizes *****

##### Arguuments
# 1) Investors demand more choices -- see last Participant survey when asked about 18 versus 3 choices
# 2) Sponsors tend to offer more choices for variety, not for better investments

##### Hypotheses
# 1) More options is not better results--Plans offering > median # investments do worse than those with less
# 2) More actual investments is not better results
# 3) Investors in > median number of investments take more risk than those at or below
# 4) TDF users are significantly below median investments but significantly higher RA returns
# 5) TDF users in 1 TDF investment do better than TDF users in > 1 investment

##### Notes
# 1) Determine median and mean number of available investments overall, by strategy, by plan
# 2) Determine median and mean PROR and RA-return
# 3) Compare participants in Managed versus non-Managed solutions
# 4) Compare participants in > median number of active investments versus those at or below
# 5) Don't include plans with less than 20 participants or less than 3 in the investment



library(compute.es)
library(xlsx)
library(reshape) # To rename variables

# Effect Sizes for differences in specific plan Sharpe ratios versus the overall
basedata <- read.csv("C:\\Users\\n344244\\Desktop\\Downside Deviation\\Complex_Wide_TDFMANEITHER_09162014.csv", header = TRUE, stringsAsFactors = FALSE)


# Clean up the data
cleandata <- basedata[, -c(1, 2, 6, 12, 14:25)]

# RENAME variable names "old" = "new"
cleandata <- rename(cleandata, c("SPONSOR_NUMBER" = "SponsorNbr", 
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
                                 "oneyr_ivst_pct" = "NbrInvOneYrAgo",
                                 "threeyr_eqty_pct" = "EqtyPctThreeYrsAgo",
                                 "threeyr_tdf_pct" = "TDFPctThreeYrsAgo",
                                 "threeyr_ivst_pct" = "NbrInvThreeYrsAgo",
                                 "fiveyr_eqty_pct" = "EqtyPctFiveYrsAgo",
                                 "fiveyr_tdf_pct" = "TDFPctFiveYrsAgo",
                                 "fiveyr_ivst_pct" = "NbrInvFiveYrsAgo",
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

# Put the SHARPEDF data.frame in the search path for easier variable reference
attach(cleandata)

cleandata$Strat1 <- factor(cleandata$Strat1)
cleandata$Strat3 <- factor(cleandata$Strat3)
cleandata$Strat5 <- factor(cleandata$Strat5)

# Pull out only the participants with 5-year PRORs
fiveyears <- subset(cleandata, !is.na(FiveYrPROR))

# Calculate skew
m3 <- sum(fiveyears$FiveYrPROR - mean(fiveyears$FiveYrPROR)) ^ 3 / length(fiveyears$FiveYrPROR)
s3 <- sqrt(var(fiveyears$FiveYrPROR)) ^ 3

skew <- m3 / s3

s.se <- skew / sqrt(6 / length(fiveyears$FiveYrPROR))

s.se.sig <- 1- pt(s.se, length(fiveyears$FiveYrPROR)- 2)

# Do participants with higher PRORs over 5 years have consistently high PRORs over 1 and 3 years?
# Rank the FIVEYEARS PROR data by participant; - indicates a reversed sort order
fiveyears$oneyrrank <- rank(-fiveyears$OneYrPROR, ties.method = "max")
fiveyears$threeyrrank <- rank(-fiveyears$ThreeYrPROR, ties.method = "max")
fiveyears$fiveyrrank <- rank(-fiveyears$FiveYrPROR, ties.method = "max")

# What is the 5-year PROR for each strategy?
top.10.pct <- tapply(fiveyears$FiveYrPROR, fiveyears$Strat5, quantile, .9)


