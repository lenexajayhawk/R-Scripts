##### Sharpe ratios and Effect Sizes *****

library(compute.es)
library(xlsx)


# Effect Sizes for differences in specific plan Sharpe ratios versus the overall
sharpedf <- read.csv("C:\\Users\\n344244\\Desktop\\Downside Deviation\\Sharpe_Ratios_5yr_pror.csv", header = TRUE, stringsAsFactors = FALSE)

# Sharpe ratios were read in as characters, so need to convert to numerics
sharpedf$Sharpe <- as.numeric(sharpedf$Sharpe)

# Put the SHARPEDF data.frame in the search path for easier variable reference
attach(sharpedf)

# Pull the list of plans from the main data file
plans <- unique(sharpedf$PLAN)

# Pull the list of the possible strategies from the main data file
strategies <- unique(sharpedf$Strategy)

# These nested FOR loops run T-TESTS and generate EFFECT SIZES
# for every plan with a 5-year PROR
for(planct in 75:75) {
# for(planct in 1:length(plans)) {
  cat("Plan #", plans[planct], "\n")
  plandata <- sharpedf[PLAN == plans[planct], ]
  restdata <- sharpedf[PLAN != plans[planct], ]
  
  # If there are less than 20 records for a plan, move on
  if(nrow(plandata) > 20) {
    for(stratct in 1:length(strategies)) {
      cat(strategies[stratct], "\n")
      
      welcht <- effsize <- planPartsByStrat <- allPartsByStrat <- tdiff <- 0
      effectSizeLayman <- "Not defined"
      
      plandatabystrat <- subset(plandata, Strategy == strategies[stratct])
      restdatabystrat <- subset(restdata, Strategy == strategies[stratct])
      
      planPartsByStrat <- nrow(plandatabystrat)
      allPartsByStrat <- nrow(restdatabystrat)
      cat("Plandatabystrat count =", planPartsByStrat, "and Restdatabystrat count =", allPartsByStrat, "\n")
      
      # Using 3 as the minimum number of Sharpes to compare
      # Maybe find way to compare to minimum % of all rows?
      if(planPartsByStrat >= 3) {
        welcht <- t.test(plandatabystrat$Sharpe, restdatabystrat$Sharpe)
        
        # Some plans have too many rows for an integer and TES() outputs an NA, so put as.numeric() around planPartsByStrat and allPartsByStrat
        effsize <- tes(welcht$statistic, planPartsByStrat, allPartsByStrat) # Use effsize$MeanDifference["d.t"]
        
        tdiff <- abs(effsize$MeanDifference["d.t"])
        
        effectSizeLayman <- ifelse(tdiff == 0, "None",
                                   ifelse(tdiff <= .20, "Small",
                                          ifelse(tdiff <= .49, "Small to Medium", 
                                                 ifelse(tdiff <= .64, "Medium",
                                                        ifelse(tdiff <= .79, "Medium to Large", "Large")))))
        cat("Welcht =", welcht$statistic, ", Effect Size =", effsize$MeanDifference["d.t"], "and Layman = ", effectSizeLayman, "\n")        
        # WRITE out to a TABLE by PLAN with initial ROW when the new plan's first strategy is ready for writing
        if(stratct == 1)
          byPlanEffectSizeTable <- data.frame(Strategy = strategies[stratct],
                                              "Number of Parts" = planPartsByStrat, 
                                              "Plan Mean Sharpe Ratio" = mean(plandatabystrat$Sharpe, na.rm = TRUE),
                                              "Overall Sharpe Ratio" = mean(restdatabystrat$Sharpe, na.rm = TRUE),
                                              "Significant Difference?" = ifelse(welcht$p.value <= 0.05, "Yes", "No"),
                                              "Effect Size" = effectSizeLayman)
        else {
          # All remaining STRATEGY rows are appended by creating a new data frame and then rbinding
          newRow <- data.frame(Strategy = strategies[stratct], 
                               "Number of Parts" = planPartsByStrat, 
                               "Plan Mean Sharpe Ratio" = mean(plandatabystrat$Sharpe, na.rm = TRUE),
                               "Overall Sharpe Ratio" = mean(restdatabystrat$Sharpe, na.rm = TRUE),
                               "Significant Difference?" = ifelse(welcht$p.value <= 0.05, "Yes", "No"),
                               "Effect Size" = effectSizeLayman)
          byPlanEffectSizeTable <- rbind(byPlanEffectSizeTable, newRow)
        }
      } 
    }
    # Write the data.frame to a file
    # Write data out to CSV file
    # Build the file name including the Client Name using PASTE
    outfile <- paste("C:\\R\\Data\\Effect Size\\", as.character(plans[planct]), ".csv", sep = "")
    
    ##### WRITE the tables to the data file, appending where required
    ##### TRICK: Undocumented col.names = NA ensures column headers in correct columns
    write.table(byPlanEffectSizeTable, file = outfile, quote = FALSE, sep = ",", col.names = NA)
  }
}






