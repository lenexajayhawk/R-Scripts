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




# PROR calcs function
prorcalcs <- function(stratlist, sponsor) {
  

}

##### End Functions #####


########## Begin Data Manipulation ##########
# Open a dialogue box to select the data to use
# Don't let R define strings as factors; convert to factors later if necessary
prords <- read.csv(file.choose(), stringsAsFactors = FALSE)


##### Begin ATTACH #####
# Put the PRORDS Data Frame in the search path to simplify variable references
attach(prords)
##### End ATTACH #####

########## End Data Manipulation ##########


##### Begin Descriptive Statistics #####

# Put the plan sponsor names in a separate vector
sponsors <- unique(SPONSOR_NAME)

# Store strategies from MAIN data set
stratlist <- c(PROR1, PROR3, PROR5)

# Pare down the strategies to a final vector
stratlist <- unique(stratlist)

# Writing this like a OOP program where this FOR loop = the MAIN of a Java or C++ program
# the catalyst for running through all of the sponsors
for(x in seq(1:length(sponsors))) {

  cat("x =", x, "and sponsor name =", sponsors[x],"\n")
  sponsor <- prords[SPONSOR_NAME == sponsors[x], ]
  
  # Need the age2 column to be a factor now to simplify the mean PROR by age group
  sponsor$age2 <- as.factor(sponsor$age2)
  
  # Initialize count variables each sponsor
  diycounts <- mgdcounts <- tdfcounts <- chgcounts <- brkcounts <- exccounts <- 0;
  
  # What's the sponsor overall 1, 3 and 5 year PROR?
  OneYrMeanPROR <- mean(sponsor$One_Year, na.rm = TRUE)
  ThreeYrMeanPROR <- mean(sponsor$Three_Year_ROR, na.rm = TRUE)
  FiveYrMeanPROR <- mean(sponsor$Five_Year_ROR, na.rm = TRUE)
  
  for(i in 1:length(stratlist)) {
    # Store the data for the current STRATLIST and STRATLIST ITEM
    cat("Stratlist =", stratlist[i], "\n")
    calclist <- list(sponsor[sponsor$PROR1 == stratlist[i], ],
                     sponsor[sponsor$PROR3 == stratlist[i], ],
                     sponsor[sponsor$PROR5 == stratlist[i], ])
    
    # Initialize some variables used later for output
    finalstratct <- "No users for any annual PROR period"
    totalstratpartsbyage1 <- "None"
    totalstratpartsbyage3 <- "None"
    totalstratpartsbyage5 <- "None"
    strat1stockchart <- "No avg PROR"
    strat3stockchart <- "No avg PROR"
    strat5stockchart <- "No avg PROR"
    
    # How many participants are in each strategy?
    stratcounts <- sapply(calclist, nrow)
    
    cat("Strategy counts sum =", stratcounts, "\n")
    
    if(sum(stratcounts) > 0) {
      
      # Does the 1, 3 or 5 year PROR need to be trimmed due to outliers?
      # IQRVALS now returns the correct MEAN value by TRIMMING if IQR'd values are required
      ##### 7/16/14: Single line vectorized combination to store the by-year MGD ACCT PRORs
      calcprorlist <- list(calclist[[1]]$One_Year, 
                           calclist[[2]]$Three_Year_ROR, 
                           calclist[[3]]$Five_Year_ROR)
      
      finalstrat <- sapply(calcprorlist, iqrvals)
      
      dimnames(finalstrat) <- list(Rows = c("IQR?", "Max", "Min", "Avg"), Cols = c("One-Year", "Three-Year", "Five-Year"))
      
      # Build the BY-AGE tables
      # Use TAPPLY and TABLE to produce the results against the existing DIYLIST list
      # This is crude; convert all of these into FUNCTION calls with TABLE return values
      ##### Pull all of the 1-year PROR participants
      
      totalstratpartsbyage1 <- partsinstrat(calclist[[1]]$age2)
      strat1stockchart <- stockchartvals(calclist[[1]]$One_Year, calclist[[1]]$age2)
      
      totalstratpartsbyage3 <- partsinstrat(calclist[[2]]$age2)
      strat3stockchart <- stockchartvals(calclist[[2]]$Three_Year_ROR, calclist[[2]]$age2)
      
      totalstratpartsbyage5 <- partsinstrat(calclist[[3]]$age2)
      strat5stockchart <- stockchartvals(calclist[[3]]$Five_Year_ROR, calclist[[3]]$age2)
    }
    
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

