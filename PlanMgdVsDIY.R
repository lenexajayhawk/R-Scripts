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
plandf <- read.csv("C:\\Users\\n344244\\Desktop\\Downside Deviation\\Sharpe_Ratios_5yr_PROR_InvCt.csv", header = TRUE, stringsAsFactors = FALSE)

# Sharpe ratios were read in as characters, so need to convert to numerics
plandf$Sharpe <- as.numeric(plandf$Sharpe)

# Put the SHARPEDF data.frame in the search path for easier variable reference
attach(plandf)

# Pull the list of plans from the main data file
plans <- sort(unique(Plan))

# Pull the list of the possible strategies from the main data file
strategies <- sort(unique(Strategy))

# Pull the list of Age Cohorts and sort them by youngest to oldest
ages <- sort(unique(AgeCohort))





# Use AGGREGATE to calculate averages by age cohort of Sharpe, Five Yr PROR, Age, and InvCt
# Now add by STRATEGY
allagg <- aggregate(plandf[ , c(4, 5, 8, 9)], by = list(agecohort = AgeCohort, strategy = Strategy, plan = Plan), mean)

# RENAME variable names "old" = "new"
allagg <- rename(allagg, c("Sharpe" = "AvgSharpe", "FiveYrPROR" = "AvgFiveYrPROR", "Age" = "AvgAge", "InvCt" = "AvgInvCt"))


newplandf <- merge(plandf, allagg, by.x = c("Plan", "Strategy", "AgeCohort"), by.y = c("plan", "strategy", "agecohort"))

# New variable: Does this participant have more than the average # of investments?
newplandf$AboveInv <- ifelse(newplandf$InvCt > newplandf$AvgInvCt, "Y", "N")

# Re-order the new data by Plan, Strategy and AgeCohort
newplandf <- newplandf[order(newplandf$Plan, newplandf$Strategy, newplandf$AgeCohort), ]

allaggnew <- aggregate(newplandf[ , c(5, 6, 8, 9)], by = list(agecohort = newplandf$AgeCohort, strategy = newplandf$Strategy, plan = newplandf$Plan, aboveInv = newplandf$AboveInv), mean)

allaggnew <- rename(allagg, c("Sharpe" = "AvgSharpe", "FiveYrPROR" = "AvgFiveYrPROR", "Age" = "AvgAge", "InvCt" = "AvgInvCt"))

allaggnew <- allaggnew[order(allaggnew$plan, allaggnew$strategy, allaggnew$agecohort, allaggnew$aboveInv), ]

















# What are the counts of participants in Managed solutions or Changers?
table(MgdSolution) # C = 29,711, Not Mgd = 328,119, Mgd = 91,403


table(plandf[InvCt <= mean(InvCt, na.rm = TRUE), ]$Strategy)
table(plandf[InvCt > mean(InvCt, na.rm = TRUE), ]$Strategy)


# What % of participants are in Managed solutions or Changers?
round(prop.table(table(plandf$MgdSolution)) * 100, 1) # C = 6.6%, Not Mgd = 73.0%, Mgd = 20.3%


# Test the Sharpes between managed solution parts and non-managed solution parts
# Default to the Welch t-test because it assumes unequal variances and does not pool variances as the standard t-test does
welcht <- t.test(plandf[MgdSolution == "Y", ]$Sharpe, plandf[MgdSolution == "N", ]$Sharpe)

# Test the Sharpes between participants at or below the median # of investments and those above
medianwelcht <- t.test(plandf[InvCt <= median(InvCt, na.rm = TRUE), ]$Sharpe, plandf[InvCt > median(InvCt, na.rm = TRUE), ]$Sharpe)
meanwelcht <- t.test(plandf[InvCt <= mean(InvCt, na.rm = TRUE), ]$Sharpe, plandf[InvCt > mean(InvCt, na.rm = TRUE), ]$Sharpe)

# Parts <= investments have PROR = 12.38, while those > have PRORs 14.00, a huge signficant difference
meanprorwelcht <- t.test(plandf[InvCt <= mean(InvCt, na.rm = TRUE), ]$FiveYrPROR, plandf[InvCt > mean(InvCt, na.rm = TRUE), ]$FiveYrPROR)

# Effect size is huge @ 2.62
# The number of rows is large enough to need a NUMERIC versus an INTEGER; integer counts crashed the TES() function
effsize <- tes(welcht$statistic,
               as.numeric(nrow(subset(plandf, MgdSolution == "Y"))),
               as.numeric(nrow(subset(plandf, MgdSolution == "N")))) # Use effsize$MeanDifference["d.t"]

# Effect size is Small @ 0.017 (0.02); the mean differences are significant between 2.68 for <= median and 2.65 for > median investment use
medianeffsize <- tes(medianwelcht$statistic,
               as.numeric(nrow(subset(plandf, InvCt <= median(InvCt, na.rm = TRUE)))),
               as.numeric(nrow(subset(plandf, InvCt <= median(InvCt, na.rm = TRUE))))) # Use effsize$MeanDifference["d.t"]

# Effect size is Small @ -0.28 between PRORs
meanproreffsize <- tes(meanprorwelcht$statistic,
                as.numeric(nrow(subset(plandf, InvCt <= mean(InvCt, na.rm = TRUE)))),
                as.numeric(nrow(subset(plandf, InvCt <= mean(InvCt, na.rm = TRUE))))) # Use effsize$MeanDifference["d.t"]



# Save the by-plan mean participant # of investments used and overall Sharpe ratio
for(planct in 1:length(plans)) {

  # Initialize our counting variables each time
  spart <- agepart <- nbrgreater <- nbrlesseq <- 0
  
  plandata <- plandf[Plan == plans[planct], ]
  cat("Plan #", plans[planct], "and # of rows =", nrow(plandata), "\n")
  # restdata <- sharpedf[PLAN != plans[planct], ]
  # Sort the AGES into a more consistent order--"20 - 29", "30 - 39", etc
  sort(ages)
  # If there are less than 20 records for a plan, move on
  if(nrow(plandata) >= 20) {
    for(stratct in 1:length(strategies)) {
      # The CAT statement below could be written cat(strategies, "\n") to avoid the FOR loop altogether
      cat(strategies[stratct], "\n")
      
      for(agect in 1:length(ages)) {      
        # New code?
        # This Welch TTEST should be in the FOR loop for all Strategies, Age Cohorts--run this at the command line changing strategy and age cohort manually
        # Need an IF statement to not run this if less than 3 participants in the strategy; see below
        spart <- nrow(plandata[plandata$Strategy == strategies[stratct], ])
        agepart <- nrow(plandata[plandata$AgeCohort == ages[agect], ])
        nbrgreater <- length(plandata[plandata$Strategy == strategies[stratct] & plandata$AgeCohort == ages[agect] & plandata$InvCt > mean(plandata[plandata$AgeCohort == ages[agect] & plandata$Strategy == strategies[stratct], ]$InvCt, na.rm = TRUE), ]$Sharpe)
        nbrlesseq <- length(plandata[plandata$Strategy == strategies[stratct] & plandata$AgeCohort == ages[agect] & plandata$InvCt <= mean(plandata[plandata$AgeCohort == ages[agect] & plandata$Strategy == strategies[stratct], ]$InvCt, na.rm = TRUE), ]$Sharpe)
        cat("Age cohort = ", ages[agect], "# in Strategy =", spart, "\n")
        if(spart >= 3 & agepart > 0 & nbrgreater > 1 & nbrlesseq > 1 & !is.na(plandata$InvCt)) {
          tt = t.test(plandata[plandata$Strategy == strategies[stratct] & plandata$AgeCohort == ages[agect] & plandata$InvCt > mean(plandata[plandata$AgeCohort == ages[agect] & plandata$Strategy == strategies[stratct], ]$InvCt, na.rm = TRUE), ]$Sharpe, 
               plandata[plandata$Strategy == strategies[stratct] & plandata$AgeCohort == ages[agect] & plandata$InvCt <= mean(plandata[plandata$AgeCohort == ages[agect] & plandata$Strategy == strategies[stratct], ]$InvCt, na.rm = TRUE), ]$Sharpe)
          # Consider Effect Size
          # Write the results to a DATA.FRAME and append after the first row
          if(planct == 1)
            planinvctsharpe <- data.frame(Plan = plans[planct], Strategy = strategies[stratct], AgeCohort = ages[agect], Pvalue = tt$p.value, AvgInvCt = mean(plandata[plandata$AgeCohort == ages[agect] & plandata$Strategy == strategies[stratct], ]$InvCt, na.rm = TRUE),
                                          Significant.p.value = ifelse(abs(tt$p.value) <= .05, "Yes","No"),
                                          "Nbr Greater" = nbrgreater,
                                          "Avg Sharpe Greater" = round(tt$estimate["mean of x"], 2),
                                          "Nbr Less or Equal To" = nbrlesseq,
                                          "Avg Sharpe Less or Equal To" = round(tt$estimate["mean of y"], 2))
          else
            planinvctsharpe <- rbind(planinvctsharpe, data.frame(Plan = plans[planct], Strategy = strategies[stratct], AgeCohort = ages[agect], Pvalue = tt$p.value, AvgInvCt = mean(plandata[plandata$AgeCohort == ages[agect] & plandata$Strategy == strategies[stratct], ]$InvCt, na.rm = TRUE),
                                                                 Significant.p.value = ifelse(abs(tt$p.value) <= .05, "Yes","No"),
                                                                 "Nbr Greater" = nbrgreater,
                                                                 "Avg Sharpe Greater" = round(tt$estimate["mean of x"], 2),
                                                                 "Nbr Less or Equal To" = nbrlesseq,
                                                                 "Avg Sharpe Less or Equal To" = round(tt$estimate["mean of y"], 2)))
        }
      }      
    }
  }
}  
      # Using 3 as the minimum number of Sharpes to compare
      # Maybe find way to compare to minimum % of all rows?
#      if(planPartsByStrat >= 3) {
#        cat("Plan has >= 3 parts in the strategy")
#         welcht <- t.test(plandatabystrat$Sharpe, restdatabystrat$Sharpe)
#         
#         effsize <- tes(welcht$statistic, planPartsByStrat, allPartsByStrat) # Use effsize$MeanDifference["d.t"]
#         
#         tdiff <- abs(effsize$MeanDifference["d.t"])
#         
#         effectSizeLayman <- ifelse(tdiff == 0, "None",
#                                    ifelse(tdiff <= .20, "Small",
#                                           ifelse(tdiff <= .49, "Small to Medium", 
#                                                  ifelse(tdiff <= .64, "Medium",
#                                                         ifelse(tdiff <= .79, "Medium to Large", "Large")))))
#         cat("Welcht =", welcht$statistic, ", Effect Size =", effsize$MeanDifference["d.t"], "and Layman = ", effectSizeLayman, "\n")        
#         # WRITE out to a TABLE by PLAN with initial ROW when the new plan's first strategy is ready for writing
#         if(stratct == 1)
#           byPlanEffectSizeTable <- data.frame(Strategy = strategies[stratct],
#                                               "Number of Parts" = planPartsByStrat, 
#                                               "Plan Mean Sharpe Ratio" = mean(plandatabystrat$Sharpe, na.rm = TRUE),
#                                               "Overall Sharpe Ratio" = mean(restdatabystrat$Sharpe, na.rm = TRUE),
#                                               "Significant Difference?" = ifelse(welcht$p.value <= 0.05, "Yes", "No"),
#                                               "Effect Size" = effectSizeLayman)
#         else {
#           # All remaining STRATEGY rows are appended by creating a new data frame and then rbinding
#           newRow <- data.frame(Strategy = strategies[stratct], 
#                                "Number of Parts" = planPartsByStrat, 
#                                "Plan Mean Sharpe Ratio" = mean(plandatabystrat$Sharpe, na.rm = TRUE),
#                                "Overall Sharpe Ratio" = mean(restdatabystrat$Sharpe, na.rm = TRUE),
#                                "Significant Difference?" = ifelse(welcht$p.value <= 0.05, "Yes", "No"),
#                                "Effect Size" = effectSizeLayman)
#           byPlanEffectSizeTable <- rbind(byPlanEffectSizeTable, newRow)
#         }
#       } 
#     }
#     # Write the data.frame to a file
#     # Write data out to CSV file
#     # Build the file name including the Client Name using PASTE
#     outfile <- paste("C:\\R\\Data\\Effect Size\\", as.character(plans[planct]), ".csv", sep = "")
#     
#     ##### WRITE the tables to the data file, appending where required
#     ##### TRICK: Undocumented col.names = NA ensures column headers in correct columns
#     write.table(byPlanEffectSizeTable, file = outfile, quote = FALSE, sep = ",", col.names = NA)
#  }
# }


# Build Effect Size differences for each of the TTEST results, too





# These correlations should be in a FOR loop or try them with VECTORs
cor(subset(plandf$InvCt, Strategy == "DIY"), subset(plandf$Sharpe, Strategy == "DIY"), use = "complete.obs")
cor(subset(plandf$InvCt, Strategy == "TDF Users"), subset(plandf$Sharpe, Strategy == "TDF Users"), use = "complete.obs")
cor(subset(plandf$InvCt, Strategy == "Brokerage Users"), subset(plandf$Sharpe, Strategy == "Brokerage Users"), use = "complete.obs")
cor(subset(plandf$InvCt, Strategy == "MA Users"), subset(plandf$Sharpe, Strategy == "MA Users"), use = "complete.obs")
cor(subset(plandf$InvCt, Strategy == "Changers"), subset(plandf$Sharpe, Strategy == "Changers"), use = "complete.obs")

# Build a histogram of average investments used and mean Sharpe ratio
plot(planinvctsharpe$AvgInvsUsed, 
     planinvctsharpe$AvgSharpe, 
     xlab = "Average Investments Used", 
     ylab = "Average Sharpe Ratio", 
     main = "Plot of Investments Used and Sharpes")

# What's the correlation between these two values?
# Use = lets me skip those plans that don't have a listed number of investments
cor(planinvctsharpe$AvgInvsUsed, planinvctsharpe$AvgSharpe, use = "complete.obs")

# These nested FOR loops run T-TESTS and generate EFFECT SIZES
# for every plan with a 5-year PROR
for(planct in 75:75) {
# for(planct in 1:length(plans)) {
  
}

