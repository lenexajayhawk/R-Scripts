###################################################################################################################################################################
#                                                                             														#
#	Title: PROR.r                                                      														#
#																											#
#	Author: Sam Johnson																							#
#
#	Date: July 11, 2014																							#
#																											#
#	Description: Recreating the PROR bi-annual analysis being done in Excel																#
#																											#
#	Data: K:\RP\Product Organization\Research\2014 Research\Product Research\PROR Study	#
#																											#
#	Notes:	Incorporating R to recreate some of the manual calculations completed in Excel for the PROR study	#																					#
#	Version:																									#
#		1.0: First version started July 11, 2014 by Sam Johnson using 7/9/14 PROR data																					#
#		1.1: July 16, 2014: Updated methods for each strategy; writing to Research directory																									#
#   1.2: August 6, 2014: Updated IQRVALS function to catch zero length vectors and NaN errors on calculations;                                                    #
#        Additional Tableau functionality found here: http://www.tableausoftware.com/about/blog/2013/10/tableau-81-and-r-25327                                    #
#        Add library(Rserve) for access to four Tableau function calls that pass results out of R
###################################################################################################################################################################

##### Begin Libraries #####
library(foreign)
library(gmodels) # Includes the CrossTable function for cross-tab tables


##### End Libraries  #####


##### Begin Options #####
options(digits = 5)



##### End Options  #####

##### Begin Functions #####

partsinstrat <- function(agefactors) {
  
  return(prop.table(table(agefactors)) * 100)
  
}

stockchartvals <- function(prors, agefactors) {
  
  maxpror <- tapply(prors, agefactors, max)
  minpror <- tapply(prors, agefactors, min)
  avgpror <- tapply(prors, agefactors, mean)
  
  stockchart <- data.frame(maxpror, minpror, avgpror)
  
  return(stockchart)
}

# IQRVALS finds the LOW and HIGH values of an IQR'd data set
# Compare the LOW and HIGH VALS to the MIN and MAX of the data set to determine whether
# using the IQR values is even required
# Remember to use apply() if more than one column passed in

# Need to return the correct values to use before creating the box plots
iqrvals <- function(x) {
  cat("Length of x =", length(x), "\n")
  
  # If no records OR the passed values are NA then return  
  if(length(x) == 0) return(c(1, "No users", "No users", "No users"))
  
  # If all passed values average a Not A Number (NaN) then return a statement to that fact
  if(is.nan(mean(x))) return("All users NA PROR")
  
	# Get the min and max values
	minx <- min(x, na.rm = TRUE)
	maxx <- max(x, na.rm = TRUE)
  
  if(is.na(minx) || is.na(maxx)) return("No users with valid PROR")
  
  
	# Get the IQR value
	iqrx <- IQR(x, na.rm = TRUE)
	# Calculate the IQR multiplier, which will be used to calculate LOW and HIGH values
	iqrmult <- 1.5 * iqrx
	# Calculate the LOW IQR value for the data
	lowiqrval <- quantile(x, 0.25, na.rm = TRUE) - iqrmult
	# Calculate the HIGH IQR value for the data
	highiqrval <- quantile(x, 0.75, na.rm = TRUE) + iqrmult
  
  # Print the values
  cat("Minx =", minx, ", Maxx =", maxx, ", Lowiqrval =", lowiqrval, ", Highiqrval =", highiqrval, "\n")

	# Don't use IFELSE because returns NULL for argument that isn't used
	# Don't use IQR values if one or both is above the MAX or below the MIN of the data
	if(lowiqrval < minx || highiqrval > maxx) {
		cat("Use data min:", minx, "and max: ", maxx, "\n")
    # Return 4 values: Mean type (IQR = 2 or STD = 1 for standard), max PROR, min PROR, mean PROR
		return(c(1, maxx, minx, mean(x, na.rm = TRUE)))
	}
	else {
		cat("Low IQR value: ", lowiqrval, "and High IQR value: ", highiqrval, "\n")
		return(c(2, highiqrval, lowiqrval, mean(x, .5, na.rm = TRUE)))
	}
}

##### End Functions #####


########## Begin Data Manipulation ##########
# Open a dialogue box to select the data to use
# Don't let R define strings as factors; convert to factors later if necessary
prords <- read.csv(file.choose(), stringsAsFactors = FALSE)

##### How to convert factors back to character
# Convert all FACTORS into CHARACTERS
# First build a logical matrix (T/F) that determines if the column is a FACTOR
i <- sapply(prords, is.factor)

# Rewrite the data using the logical matrix
prords[i] <- sapply(prords[i], as.character)
##### End converting factors

# Review first few lines of data; unnecessary for script
str(prords)

##### Begin ATTACH #####
# Put the PRORDS Data Frame in the search path to simplify variable references
attach(prords)
##### End ATTACH #####

########## End Data Manipulation ##########


##### Begin Descriptive Statistics #####

# Put the plan sponsor names in a separate vector
sponsors <- unique(SPONSOR_NAME)

for(x in seq(1:length(sponsors)))
{

  cat("x = ", x, "and sponsor name =", sponsors[x],"\n")
  sponsor <- prords[SPONSOR_NAME == sponsors[x], ]
  
  # Check with strategies need to be run
  stratlist <- list(OneYr = unique(sponsor$PROR1), ThreeYr = unique(sponsor$PROR3), FiveYr = unique(sponsor$PROR5))
  
  # Need the age2 column to be a factor now to simplify the mean PROR by age group
  sponsor$age2 <- as.factor(sponsor$age2)
  
  # Initialize count variables each sponsor
  diycounts <- mgdcounts <- tdfcounts <- chgcounts <- brkcounts <- exccounts <- 0;
  
  # What's the sponsor overall 1, 3 and 5 year PROR?
  OneYrMeanPROR <- mean(sponsor$One_Year, na.rm = TRUE)
  ThreeYrMeanPROR <- mean(sponsor$Three_Year_ROR, na.rm = TRUE)
  FiveYrMeanPROR <- mean(sponsor$Five_Year_ROR, na.rm = TRUE)
  
  ########## Begin DIY ########## 

  ##### DIY NOTES #####
  # LENGTH is important when combining the resulting lists and vectors later
  # when writing to an OUTPUT CSV file
  ##### END DIY NOTES
  
  ##### 7/16/14: Vectorized operation to save by-year MGD ACCTS data for analysis
  ##### This creates each by-year by-strategy data set and stores each in a single,
  ##### referenceable list object DIYLIST, which is LENGTH = 3
  
  diylist <- list(sponsor[sponsor$PROR1 == "DIY User", ], 
                  sponsor[sponsor$PROR3 == "DIY User", ], 
                  sponsor[sponsor$PROR5 == "DIY User", ])
  
  # If all three lists have zero (0) records, then don't run the rest of this
  finaldiy <- "No DIY users for any annual PROR period"
  totaldiypartsbyage1 <- "None"
  totaldiypartsbyage3 <- "None"
  totaldiypartsbyage5 <- "None"
  diy1stockchart <- "No avg DIY PROR"
  diy3stockchart <- "No avg DIY PROR"
  diy5stockchart <- "No avg DIY PROR"
  
  # How many participants are in each strategy?
  # Use SAPPLY to apply NROW to ragged (different) length lists
  # This vector is LENGTH = 3
  diycounts <- sapply(diylist, nrow)
  
  if(sum(diycounts) > 0) {
    
    # Does the 1, 3 or 5 year PROR need to be trimmed due to outliers?
    # IQRVALS now returns the correct MEAN value by TRIMMING if IQR'd values are required
    ##### 7/16/14: Single line vectorized combination to store the by-year MGD ACCT PRORs
    diyprorlist <- list(diylist[[1]]$One_Year, 
                        diylist[[2]]$Three_Year_ROR, 
                        diylist[[3]]$Five_Year_ROR)
    
    cat("About to call IQRVALS in DIY\n")
    
    finaldiy <- sapply(diyprorlist, iqrvals)
    
    dimnames(finaldiy) <- list(Rows = c("DIY IQR?", "Max", "Min", "Avg"), Cols = c("One-Year", "Three-Year", "Five-Year"))
    
    # Build the BY-AGE tables
    # Use TAPPLY and TABLE to produce the results against the existing DIYLIST list
    # This is crude; convert all of these into FUNCTION calls with TABLE return values
    ##### Pull all of the 1-year PROR participants
    
    totaldiypartsbyage1 <- partsinstrat(diylist[[1]]$age2)
    diy1stockchart <- stockchartvals(diylist[[1]]$One_Year, diylist[[1]]$age2)
    
    totaldiypartsbyage3 <- partsinstrat(diylist[[2]]$age2)
    diy3stockchart <- stockchartvals(diylist[[2]]$Three_Year_ROR, diylist[[2]]$age2)
  
    totaldiypartsbyage5 <- partsinstrat(diylist[[3]]$age2)
    diy5stockchart <- stockchartvals(diylist[[3]]$Five_Year_ROR, diylist[[3]]$age2)

  }
  ########## End DIY ##########

  ########## Begin Managed Accounts ##########
  
  ##### 7/16/14: Vectorized operation to save by-year MGD ACCTS data for analysis
  ##### This creates each by-year by-strategy data set and stores each in a single,
  ##### referenceable list object, which is LENGTH = 3
  mgdlist <- list(sponsor[sponsor$PROR1 == "Managed Accounts User", ],
                  sponsor[sponsor$PROR3 == "Managed Accounts User", ],
                  sponsor[sponsor$PROR5 == "Managed Accounts User", ])
  
  # If all three lists in MGDLISTS have zero (0) records, then don't run the rest of this
  finalmgd <- "No MA users for any annual PROR period"
  totalmgdpartsbyage1 <- "None"
  totalmgdpartsbyage3 <- "None"
  totalmgdpartsbyage5 <- "None"
  mgd1stockchart <- "No avg MA PROR"
  mgd3stockchart <- "No avg MA PROR"
  mgd5stockchart <- "No avg MA PROR"
  
  # How many participants are in each strategy?
  # This vector is LENGTH = 3
  mgdcounts <- sapply(mgdlist, nrow)
  
  # Initialize the strategy structures before determining if there's data for them
  # What's necessary, where x = strategy name: finalx; totalxpartsbyage1, 3, 5; avgxprorbyage1, 3, 5
  # If there are records for any of the years then...
  if(sum(mgdcounts) > 0) {
    # Does the 1, 3 or 5 year PROR need to be trimmed due to outliers?
    # IQRVALS now returns the correct MEAN value by TRIMMING if IQR'd values are required
    # Make sure the strategy returns rows or don't run the IQRVALS function
    # This no-rows solution is inelegant but effective
    ##### 7/16/14: Single line vectorized combination to store the by-year MGD ACCT PRORs
    mgdprorlist <- list(mgdlist[[1]]$One_Year, mgdlist[[2]]$Three_Year_ROR, mgdlist[[3]]$Five_Year_ROR)
    
    cat("About to call IQRVALS in MGD\n")
    # finalmgd <- c(ifelse(mgdcounts == 0, "No users", sapply(mgdprorlist, iqrvals)))
    finalmgd <- sapply(mgdprorlist, iqrvals)
    
    dimnames(finalmgd) <- list(Rows = c("MA IQR?", "Max", "Min", "Avg"), Cols = c("One-Year", "Three-Year", "Five-Year"))
    
    # Build the BY-AGE tables
    # Use TAPPLY and TABLE to produce the results against the existing strategy list
    # This is crude; convert all of these into FUNCTION calls with TABLE return values
    # Should be able to run similar code to FINALMGD vector COMBINE above
    # NOTE: No PROR IQR run against these values

    totalmgdpartsbyage1 <- partsinstrat(mgdlist[[1]]$age2)
    mgd1stockchart <- stockchartvals(mgdlist[[1]]$One_Year, mgdlist[[1]]$age2)
    
    totalmgdpartsbyage3 <- partsinstrat(mgdlist[[2]]$age2)
    mgd3stockchart <- stockchartvals(mgdlist[[2]]$Three_Year_ROR, mgdlist[[2]]$age2)
    
    totalmgdpartsbyage5 <- partsinstrat(mgdlist[[3]]$age2)
    mgd5stockchart <- stockchartvals(mgdlist[[3]]$Five_Year_ROR, mgdlist[[3]]$age2)
  }


  
  
  ########## End Managed Accounts ##########
  
  
  
  ########## Begin Changed Strategies ##########
  
  ##### 7/16/14: Vectorized operation to save by-year MGD ACCTS data for analysis
  ##### This creates each by-year by-strategy data set and stores each in a single,
  ##### referenceable list object, which is LENGTH = 3
  chglist <- list(sponsor[sponsor$PROR1 == "Changed Strategies", ],
                  sponsor[sponsor$PROR3 == "Changed Strategies", ],
                  sponsor[sponsor$PROR5 == "Changed Strategies", ])
  
  # If all three lists in MGDLISTS have zero (0) records, then don't run the rest of this
  finalchg <- "No Managed Account users for any annual PROR period"
  totalchgpartsbyage1 <- "None"
  totalchgpartsbyage3 <- "None"
  totalchgpartsbyage5 <- "None"
  chg1stockchart <- "No avg CHGD PROR"
  chg3stockchart <- "No avg CHGD PROR"
  chg5stockchart <- "No avg CHGD PROR"
  
  # How many participants are in each strategy?
  # This vector is LENGTH = 3
  chgcounts <- sapply(chglist, nrow)
  
  if(sum(chgcounts) > 0) {
    # Does the 1, 3 or 5 year PROR need to be trimmed due to outliers?
    # IQRVALS now returns the correct MEAN value by TRIMMING if IQR'd values are required
    # Make sure the strategy returns rows or don't run the IQRVALS function
    # This no-rows solution is inelegant but effective
    ##### 7/16/14: Single line vectorized combination to store the by-year MGD ACCT PRORs
    chgprorlist <- list(chglist[[1]]$One_Year, chglist[[2]]$Three_Year_ROR, chglist[[3]]$Five_Year_ROR)
    
    cat("About to call IQRVALS in CHG\n")
    # finalchg <- c(ifelse(chgcounts == 0, "No users", sapply(chgprorlist, iqrvals)))
    finalchg <- sapply(chgprorlist, iqrvals)
    
    dimnames(finalchg) <- list(Rows = c("CHGD IQR?", "Max", "Min", "Avg"), Cols = c("One-Year", "Three-Year", "Five-Year"))
    
    totalchgpartsbyage1 <- partsinstrat(chglist[[1]]$age2)
    chg1stockchart <- stockchartvals(chglist[[1]]$One_Year, chglist[[1]]$age2)
    
    totalchgpartsbyage3 <- partsinstrat(chglist[[2]]$age2)
    chg3stockchart <- stockchartvals(chglist[[2]]$Three_Year_ROR, chglist[[2]]$age2)
    
    totalchgpartsbyage5 <- partsinstrat(chglist[[3]]$age2)
    chg5stockchart <- stockchartvals(chglist[[3]]$Five_Year_ROR, chglist[[3]]$age2)    
  }

  ########## End Changed Strategies ###########
  
  ########## Begin TDF Users ##########
  
  ##### 7/16/14: Vectorized operation to save by-year MGD ACCTS data for analysis
  ##### This creates each by-year by-strategy data set and stores each in a single,
  ##### referenceable list object, which is LENGTH = 3
  tdflist <- list(sponsor[sponsor$PROR1 == "TDF User", ],
                  sponsor[sponsor$PROR3 == "TDF User", ],
                  sponsor[sponsor$PROR5 == "TDF User", ])
  
  # If all three lists in MGDLISTS have zero (0) records, then don't run the rest of this
  finaltdf <- "No Managed Account users for any annual PROR period"
  totaltdfpartsbyage1 <- "None"
  totaltdfpartsbyage3 <- "None"
  totaltdfpartsbyage5 <- "None"
  tdf1stockchart <- "No avg TDF PROR"
  tdf3stockchart <- "No avg TDF PROR"
  tdf5stockchart <- "No avg TDF PROR"  
  
  # How many participants are in each strategy?
  # This vector is LENGTH = 3
  tdfcounts <- sapply(tdflist, nrow)
  
  # Does the 1, 3 or 5 year PROR need to be trimmed due to outliers?
  # IQRVALS now returns the correct MEAN value by TRIMMING if IQR'd values are required
  # Make sure the strategy returns rows or don't run the IQRVALS function
  # This no-rows solution is inelegant but effective
  ##### 7/16/14: Single line vectorized combination to store the by-year MGD ACCT PRORs
  tdfprorlist <- list(tdflist[[1]]$One_Year, tdflist[[2]]$Three_Year_ROR, tdflist[[3]]$Five_Year_ROR)

  cat("About to call IQRVALS in TDF\n")
  # finaltdf <- c(ifelse(tdfcounts == 0, "No users", sapply(tdfprorlist, iqrvals)))
  
  finaltdf <- sapply(tdfprorlist, iqrvals)
  
  dimnames(finaltdf) <- list(Rows = c("TDF IQR?", "Max", "Min", "Avg"), Cols = c("One-Year", "Three-Year", "Five-Year"))
  
  totaltdfpartsbyage1 <- partsinstrat(tdflist[[1]]$age2)
  tdf1stockchart <- stockchartvals(tdflist[[1]]$One_Year, tdflist[[1]]$age2)
  
  totaltdfpartsbyage3 <- partsinstrat(tdflist[[2]]$age2)
  tdf3stockchart <- stockchartvals(tdflist[[2]]$Three_Year_ROR, tdflist[[2]]$age2)
  
  totaltdfpartsbyage5 <- partsinstrat(tdflist[[3]]$age2)
  tdf5stockchart <- stockchartvals(tdflist[[3]]$Five_Year_ROR, tdflist[[3]]$age2)
  ########## End TDF Users ##########
  
  ########## Begin Exclude Users ##########
  
  ##### 7/16/14: Vectorized operation to save by-year MGD ACCTS data for analysis
  ##### This creates each by-year by-strategy data set and stores each in a single,
  ##### referenceable list object, which is LENGTH = 3
  # exclist <- list(sponsor[sponsor$PROR1 == "Exclude", ],
  #                sponsor[sponsor$PROR3 == "Exclude", ],
  #                sponsor[sponsor$PROR5 == "Exclude", ])
  
  # If all three lists in MGDLISTS have zero (0) records, then don't run the rest of this
  #finalexc <- "No Managed Account users for any annual PROR period"
  #totalexcpartsbyage1 <- "None"
  #totalexcpartsbyage3 <- "None"
  #totalexcpartsbyage5 <- "None"
  #exc1stockchart <- "No avg CHGD PROR"
  #exc3stockchart <- "No avg CHGD PROR"
  #exc5stockchart <- "No avg CHGD PROR"
  
  # How many participants are in each strategy?
  # This vector is LENGTH = 3
  #exccounts <- sapply(exclist, nrow)
  
  # Does the 1, 3 or 5 year PROR need to be trimmed due to outliers?
  # IQRVALS now returns the correct MEAN value by TRIMMING if IQR'd values are required
  # Make sure the strategy returns rows or don't run the IQRVALS function
  # This no-rows solution is inelegant but effective
  ##### 7/16/14: Single line vectorized combination to store the by-year MGD ACCT PRORs
  #excprorlist <- list(exclist[[1]]$One_Year, exclist[[2]]$Three_Year_ROR, exclist[[3]]$Five_Year_ROR)
  
  #cat("About to call IQRVALS in EXC\n")
  # finalexc <- c(ifelse(exccounts == 0, "No users", sapply(excprorlist, iqrvals)))
  #finalexc <- sapply(excprorlist, iqrvals)
  
  #dimnames(finalexc) <- list(Rows = c("Excluded IQR?", "Max", "Min", "Avg"), Cols = c("One-Year", "Three-Year", "Five-Year"))

  #totalexcpartsbyage1 <- partsinstrat(exclist[[1]]$age2)
  #exc1stockchart <- stockchartvals(exclist[[1]]$One_Year, exclist[[1]]$age2)
  
  #totalexcpartsbyage3 <- partsinstrat(exclist[[2]]$age2)
  #exc3stockchart <- stockchartvals(exclist[[2]]$Three_Year_ROR, exclist[[2]]$age2)
  
  #totalexcpartsbyage5 <- partsinstrat(exclist[[3]]$age2)
  #exc5stockchart <- stockchartvals(exclist[[3]]$Five_Year_ROR, exclist[[3]]$age2)  
  ########## End Exclude Users ##########
  
  ########## Begin Brokerage Users ##########
  
  ##### 7/16/14: Vectorized operation to save by-year MGD ACCTS data for analysis
  ##### This creates each by-year by-strategy data set and stores each in a single,
  ##### referenceable list object, which is LENGTH = 3
  brklist <- list(sponsor[sponsor$PROR1 == "Brokerage User", ],
                  sponsor[sponsor$PROR3 == "Brokerage User", ],
                  sponsor[sponsor$PROR5 == "Brokerage User", ])
  
  # How many participants are in each strategy?
  # This vector is LENGTH = 3
  brkcounts <- sapply(brklist, nrow)
  
  # Does the 1, 3 or 5 year PROR need to be trimmed due to outliers?
  # IQRVALS now returns the correct MEAN value by TRIMMING if IQR'd values are required
  # Make sure the strategy returns rows or don't run the IQRVALS function
  # This no-rows solution is inelegant but effective
  ##### 7/16/14: Single line vectorized combination to store the by-year MGD ACCT PRORs
  brkprorlist <- list(brklist[[1]]$One_Year, brklist[[2]]$Three_Year_ROR, brklist[[3]]$Five_Year_ROR)
  
  cat("About to call IQRVALS in BROK\n")
  # finalbrk <- c(ifelse(brkcounts == 0, "No users", sapply(brkprorlist, iqrvals)))
  finalbrk <- sapply(brkprorlist, iqrvals)
  
  dimnames(finalbrk) <- list(Rows = c("BROK IQR?", "Max", "Min", "Avg"), Cols = c("One-Year", "Three-Year", "Five-Year"))

  totalbrkpartsbyage1 <- partsinstrat(brklist[[1]]$age2)
  brk1stockchart <- stockchartvals(brklist[[1]]$One_Year, brklist[[1]]$age2)
  
  totalbrkpartsbyage3 <- partsinstrat(brklist[[2]]$age2)
  brk3stockchart <- stockchartvals(brklist[[2]]$Three_Year_ROR, brklist[[2]]$age2)
  
  totalbrkpartsbyage5 <- partsinstrat(brklist[[3]]$age2)
  brk5stockchart <- stockchartvals(brklist[[3]]$Five_Year_ROR, brklist[[3]]$age2)  
  ########## End Brokerage Users ##########
  
  ########## Begin Output ##########  
  finaloverallprortable <- as.table(cbind(ifelse(is.na(OneYrMeanPROR),"No available 1-year PROR", OneYrMeanPROR), 
                                          ifelse(is.na(ThreeYrMeanPROR),"No available 3-year PROR", ThreeYrMeanPROR), 
                                          ifelse(is.na(FiveYrMeanPROR),"No available 5-year PROR", FiveYrMeanPROR)))
  
  dimnames(finaloverallprortable) <- list("Overall PROR", Averages = c("1-Year", "3-Year", "5-Year"))
   
  # Create a TABLE to store and write the PROR Averages
  # finalprortable <- as.table(rbind(finaldiy, finalmgd, finalchg, finaltdf, finalexc, finalbrk))
  finalprortable <- as.table(rbind(finaldiy, finalmgd, finalchg, finaltdf, finalbrk))  
  # dimnames(finalprortable) <- list(Strategies = c("DIY", "Managed Accts", "Chgd Strats", "TDF", "Exclude", "Brokerage"),
  #                                 Averages = c("1-Year", "3-Year", "5-Year"))
  
  # Create a TABLE for the Strategy Counts
  # RBIND combines the rows into a single, formattable stack
  # finalstrategycounts <- as.table(rbind(diycounts, mgdcounts, chgcounts, tdfcounts, exccounts, brkcounts))
  finalstrategycounts <- as.table(rbind(diycounts, mgdcounts, chgcounts, tdfcounts, brkcounts))  
  dimnames(finalstrategycounts) <- list(Strategies = c("DIY", "Managed Accts", "Chgd Strats", "TDF", "Brokerage"), 
                                        Participants = c("1-Year", "3-Year", "5-Year"))
  
  # Write out the by-year, by-age, by-strategy participant counts
  byagestrategycount1 <- list(DIY1pct = totaldiypartsbyage1, MGD1pct = totalmgdpartsbyage1, CHG1pct = totalchgpartsbyage1, TDF1pct = totaltdfpartsbyage1, BROK1pct = totalbrkpartsbyage1)
  
  byagestrategycount3 <- list(DIY3pct = totaldiypartsbyage3, MGD3pct = totalmgdpartsbyage3, CHG3pct = totalchgpartsbyage3, TDF3pct = totaltdfpartsbyage3, BROK3pct = totalbrkpartsbyage3)
  
  byagestrategycount5 <- list(DIY5pct = totaldiypartsbyage5, MGD5pct = totalmgdpartsbyage5, CHG5pct = totalchgpartsbyage5, TDF5pct = totaltdfpartsbyage5, BROK5pct = totalbrkpartsbyage5)
  
  # Write out the by-year, by-age, by-strategy PRORs
  #byagestrategypror1 <- list(DIY1 = diy1stockchart, MGD1 = mgd1stockchart, CHG1 = chg1stockchart, TDF1 = tdf1stockchart, EXC1 = exc1stockchart, BROK1 = brk1stockchart)
  
  #byagestrategypror3 <- list(DIY3 = diy3stockchart, MGD3 = mgd3stockchart, CHG3 = chg3stockchart, TDF3 = tdf3stockchart, EXC3 = exc3stockchart, BROK3 = brk3stockchart)
  
  #byagestrategypror5 <- list(DIY5 = diy5stockchart, MGD5 = mgd5stockchart, CHG5 = chg5stockchart, TDF5 = tdf5stockchart, EXC5 = exc5stockchart, BROK5 = brk5stockchart)

  byagestrategypror1 <- list(DIY1 = diy1stockchart, MGD1 = mgd1stockchart, CHG1 = chg1stockchart, TDF1 = tdf1stockchart, BROK1 = brk1stockchart)
  
  byagestrategypror3 <- list(DIY3 = diy3stockchart, MGD3 = mgd3stockchart, CHG3 = chg3stockchart, TDF3 = tdf3stockchart, BROK3 = brk3stockchart)
  
  byagestrategypror5 <- list(DIY5 = diy5stockchart, MGD5 = mgd5stockchart, CHG5 = chg5stockchart, TDF5 = tdf5stockchart, BROK5 = brk5stockchart)
  
  
  # Write data out to CSV file
  # Build the file name including the Client Name using PASTE
  outfile <- paste("K:\\RP\\Product Organization\\Research\\2014 Research\\PRODUCT RESEARCH\\PROR STUDY\\AA JUNE 30 2014\\PROR IN R\\", as.character(sponsors[x]), ".csv", sep = "")

  ##### WRITE the tables to the data file, appending where required
  ##### TRICK: Undocumented col.names = NA ensures column headers in correct columns
  write.table(finalstrategycounts, file = outfile, quote = FALSE, sep = ",", col.names = NA)
  write.table(finaloverallprortable, file = outfile, quote = FALSE, sep = ",", col.names = NA, append = TRUE)
  write.table(finalprortable, file = outfile, quote = FALSE, sep = ",", col.names = NA, append = TRUE)
  write.table(byagestrategycount1, file = outfile, quote = FALSE, sep = ",", col.names = NA, append = TRUE)
  write.table(byagestrategycount3, file = outfile, quote = FALSE, sep = ",", col.names = NA, append = TRUE)
  write.table(byagestrategycount5, file = outfile, quote = FALSE, sep = ",", col.names = NA, append = TRUE)
  write.table(byagestrategypror1, file = outfile, quote = FALSE, sep = ",", col.names = NA, append = TRUE)
  write.table(byagestrategypror3, file = outfile, quote = FALSE, sep = ",", col.names = NA, append = TRUE)
  write.table(byagestrategypror5, file = outfile, quote = FALSE, sep = ",", col.names = NA, append = TRUE)
  
  ########## End Output ##########  
  
}
##### END for loop of all sponsors #####




########## Begin Basic Plots ##########

# Plot the selected plan participant EQUITY versus AGE graph
plot(testplan$AGE, testplan$EQTY_INV_PC, main = "Equity Exposure", xlab = "Age", ylab = "% in Equities", type = "p", col = "orange", font = 2, family = "sans")

########## End Basic Plots ##########

##### Begin Boxplots: Need to trim the outliers before plotting

boxplot(diy1$One_Year, main = "Boxplot for 1-year DIY PROR")
boxplot(diy3$Three_Year_ROR, main = "Boxplot for 3-year DIY PROR")
boxplot(diy5$Five_Year_ROR, main = "Boxplot for 5-year DIY PROR")

##### End boxplots

######### Begin Descriptive Statistics ##########


head(testplan)

tpsummary <- summary(testplan)





########## End Descriptive Statistics ##########

