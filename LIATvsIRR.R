##### LIAT versus IRR
# Working with the file shared with Van to determine differences

# LIBRARIES
library(data.table)
library(compute.es)

# Import the original data
liat.orig.df <- read.csv("c:\\r\\data\\LIAT DM ANALYSIS IT3.csv", stringsAsFactors = FALSE)
str(liat.orig.df)

# Convert the DATA FRAME into a DATA TABLE
dtLiatIRR <- data.table(liat.orig.df)
dtLiatIRR

# Add the AGE COHORT and GENERATIONS
dtLiatIRR[ , ageCohort := ifelse(AGE < 30, '20-29',
                              ifelse(AGE < 40, '30-39',
                                     ifelse(AGE < 50, '40-49',
                                            ifelse(AGE < 60, '50-59',
                                                   ifelse(AGE < 70, '60-69', '70+')))))]
# Turn into FACTORS and LEVEL ageCohort and generation
dtLiatIRR[ , generation := ifelse(AGE < 34, 'Millennial',
                               ifelse(AGE < 48, 'Gen X',
                                      ifelse(AGE < 58, 'Late Boomer', 'Early Boomer')))]
# Convert AGE COHORT and GENERATION into FACTORS
dtLiatIRR$generation <- factor(dtLiatIRR$generation, levels = c("Millennial", "Gen X", "Late Boomer", "Early Boomer"))
dtLiatIRR$ageCohort <- factor(dtLiatIRR$ageCohort, levels = c("20-29", "30-39", "40-49", "50-59", "60-69", "70+"))

# Pull out all the participants with FE IRR scores 34 points higher than LIAT IRR
dtFE34 <- dtLiatIRR[dtLiatIRR$DM.IRR - dtLiatIRR$LIAT.IRR >= .338, ]
summary(dtFE34)
aggregate(dtFE34, by = list(dtFE34$ageCohort), summary)

dtFE34AgeCohort <- dtFE34[ , list(LIATRetAge = mean(LIAT.RET.AGE), 
                                  FERetAge = mean(DM.RET.AGE),
                                  LIATOTTR = mean(LIAT.OTTR),
                                  DMOTTR = mean(DM.OTTR),
                                  LIATSSRE = mean(LIAT.SSRE),
                                  DMSSRE = mean(DM.SSRE),
                                  SAL = mean(SALARY),
                                  LIATIRR = mean(LIAT.IRR), 
                                  FEIRR = mean(DM.IRR)), 
                          by = "ageCohort"]
dtFE34AgeCohort

# What happens if we develop CLUSTERS?
dfFE34 <- as.data.frame(dtFE34)

# Cluster the data using KMEANS
nCenters <- 4

modelFE34 <- kmeans(x = dfFE34[ , c(3, 5, 7, 9, 11, 12:16)], centers = nCenters)

# names(modelFE34)

# modelFE34$cluster
modelFE34$centers
modelFE34$size

dtFE34$cluster <- modelFE34$cluster

dtFE34[ , list(n = mean(DM.IRR - LIAT.IRR)), by = "cluster"]

# Load the 6/30/14 IRR file
dfJune14IRR <- read.csv("c:\\r\\data\\IRR_Data_06302014.csv", stringsAsFactors = FALSE)

irrchg <- function(agecohort, IRR){
  # cat("Age Cohort = ", agecohort)
  if(agecohort == "20 - 29") {
    return(ifelse(IRR <= .2131, -0.836,
           ifelse(IRR <= 1.091, -0.5692,
                  ifelse(IRR <= 1.383, -0.495,
                         ifelse(IRR <= 1.455, -0.4256,
                                ifelse(IRR <= 1.765, -0.3774,2.168))))))
  }
  if(agecohort == "30 - 39") {
    return(ifelse(IRR <= .1206, -0.905,
           ifelse(IRR <= .8165, -0.5244,
                  ifelse(IRR <= 1.083, -0.4298,
                         ifelse(IRR <= 1.157, -0.3961,
                                ifelse(IRR <= 1.419, -0.3030,1.388))))))
  }
  if(agecohort == "40 - 49") {
    return(ifelse(IRR <= .06189, -0.895,
           ifelse(IRR <= .6187, -0.4058,
                  ifelse(IRR <= .8001, -0.3005,
                         ifelse(IRR <= .8588, -0.2941,
                                ifelse(IRR <= 1.046, -0.1787, 1.681))))))
  }
  if(agecohort == "50 - 59") {
    return(ifelse(IRR <= .05129, -0.8766,
           ifelse(IRR <= .5243, -0.2807,
                  ifelse(IRR <= .6879, -0.1916,
                         ifelse(IRR <= .7643, -0.2189,
                                ifelse(IRR <= .9488, -0.1215, 1.569))))))
  }
  if(agecohort == "60 - 69") {
    return(ifelse(IRR <= .04937, -0.8789,
           ifelse(IRR <= .439, -0.3557,
                  ifelse(IRR <= .5878, -0.2631,
                         ifelse(IRR <= .668, -0.2806,
                                ifelse(IRR <= .8083, -0.1768, 0.8874))))))
  }
  if(agecohort == "70+") {
    return(ifelse(IRR <= .186, -0.734,
           ifelse(IRR <= .5066, -0.3666,
                  ifelse(IRR <= .7388, -0.313,
                         ifelse(IRR <= .8916, -0.311,
                                ifelse(IRR <= 1.059, -0.2648, .671)))))) 
  }
  # Return statement?
}

dfJune14IRR$irrchg <- irrchg(dfJune14IRR$AGE_GROUP_NAM, dfJune14IRR$END_WRR)

dfJune14IRR$LIATchg <- for(ages in length(dfJune14IRR$AGE_GROUP_NAM)) irrchg(dfJune14IRR$AGE_GROUP_NAM)
LIATchg <- apply(dfJune14IRR[ , c("AGE_GROUP_NAM", "END_WRR")], 2, FUN = irrchg)

dfJune14IRR$agecohortval <- ifelse(dfJune14IRR$AGE_GROUP_NAM == "20 - 29", 1,
                                   ifelse(dfJune14IRR$AGE_GROUP_NAM == "30 - 39", 2,
                                          ifelse(dfJune14IRR$AGE_GROUP_NAM == "40 - 49", 3,
                                                 ifelse(dfJune14IRR$AGE_GROUP_NAM == "50 - 59", 4,
                                                        ifelse(dfJune14IRR$AGE_GROUP_NAM == "60 - 69", 5, 6)))))
# Marking each IRR change by a negative value, starting with the biggest change getting the largest negative number;
# The select few with INCREASING values receive a 1
dfJune14IRR$IRRval <- ifelse(dfJune14IRR$agecohortval == 1,
                             ifelse(dfJune14IRR$END_WRR <= .2131, -5,
                                    ifelse(dfJune14IRR$END_WRR <= 1.091, -4,
                                           ifelse(dfJune14IRR$END_WRR <= 1.383, -3,
                                                  ifelse(dfJune14IRR$END_WRR <= 1.455, -2,
                                                         ifelse(dfJune14IRR$END_WRR <= 1.765, -2, 1))))),
                             ifelse(dfJune14IRR$agecohortval == 2,
                                    ifelse(dfJune14IRR$END_WRR <= .1206, -5,
                                                  ifelse(dfJune14IRR$END_WRR <= .8165, -4,
                                                         ifelse(dfJune14IRR$END_WRR <= 1.083, -3,
                                                                ifelse(dfJune14IRR$END_WRR <= 1.157, -2,
                                                                       ifelse(dfJune14IRR$END_WRR <= 1.419, -2, 1))))),
                            ifelse(dfJune14IRR$agecohortval == 3,
                                   ifelse(dfJune14IRR$END_WRR <= .06189, -5,
                                          ifelse(dfJune14IRR$END_WRR <= .6187, -4,
                                                 ifelse(dfJune14IRR$END_WRR <= .8001, -3,
                                                        ifelse(dfJune14IRR$END_WRR <= .8588, -2,
                                                               ifelse(dfJune14IRR$END_WRR <= 1.046, -1, 1))))),
                                           
                             ifelse(dfJune14IRR$agecohortval == 4,
                                    ifelse(dfJune14IRR$END_WRR <= .05129, -5,
                                           ifelse(dfJune14IRR$END_WRR <= .5243, -4,
                                                  ifelse(dfJune14IRR$END_WRR <= .6879, -2,
                                                         ifelse(dfJune14IRR$END_WRR <= .7643, -3,
                                                                ifelse(dfJune14IRR$END_WRR <= .9488, -1, 1))))),
                            ifelse(dfJune14IRR$agecohortval == 5,
                                   ifelse(dfJune14IRR$END_WRR <= .04937, -5,
                                          ifelse(dfJune14IRR$END_WRR <= .439, -4,
                                                 ifelse(dfJune14IRR$END_WRR <= .5878, -2,
                                                        ifelse(dfJune14IRR$END_WRR <= .668, -3,
                                                               ifelse(dfJune14IRR$END_WRR <= .8083, -1, 1))))),
                            
                             ifelse(dfJune14IRR$END_WRR <= .186, -5,
                                    ifelse(dfJune14IRR$END_WRR <= .5066, -4,
                                           ifelse(dfJune14IRR$END_WRR <= .7388, -3,
                                                  ifelse(dfJune14IRR$END_WRR <= .8916, -2,
                                                         ifelse(dfJune14IRR$END_WRR <= 1.059, -1, 1)))))
                             )))))
dfJune14IRR$IRRval <- as.factor(dfJune14IRR$IRRval)









dtLiatIRR[ , list(n = mean(LIAT.IRR)), by = "LIAT.RET.AGE"]
dtLiatIRR[ , list(n = mean(DM.IRR)), by = "DM.RET.AGE"]

barplot(dtLiatIRR[, LIAT.IRR])
barplot(dtLiatIRR[, DM.IRR])

welch.irr <- t.test(dtLiatIRR[ , LIAT.IRR], dtLiatIRR[ , DM.IRR], paired = TRUE) # mu = 0; Projected 95% confidence interval difference .3342-.3421

# Determine where scores are significantly different
welch.irr <- t.test(dtLiatIRR[ , DM.IRR], dtLiatIRR[ , LIAT.IRR], mu = 33, paired = TRUE) # Projected 95% confidence interval difference .3342-.3421
welch.irr

summary(dtLiatIRR)

t.test(dtLiatIRR[ , LIAT.SSRE], dtLiatIRR[ , DM.SSRE], paired = TRUE) # CI of 1662.55-1704.59

# Cut the original data table down for a full CORRELATION

irr.corr <- cor(dtLiatIRR) # All the rows and columns 
cor(dtLiatIRR[ , AGE], dtLiatIRR[ , LIAT.IRR]) # -0.2452322
cor(dtLiatIRR[ , AGE], dtLiatIRR[ , DM.IRR])   # -0.4507063
cor(dtLiatIRR[ , SALARY], dtLiatIRR[ , LIAT.IRR]) # -0.2449953
cor(dtLiatIRR[ , SALARY], dtLiatIRR[ , DM.IRR]) # -0.1802569
cor(dtLiatIRR[ , TOTAL_DEF_PCT], dtLiatIRR[ , LIAT.IRR]) # 0.291701
cor(dtLiatIRR[ , TOTAL_DEF_PCT], dtLiatIRR[ , DM.IRR]) # 0.2230295
cor(dtLiatIRR[ , PRIMARY_BAL], dtLiatIRR[ , LIAT.IRR]) # 0.2873255
cor(dtLiatIRR[ , PRIMARY_BAL], dtLiatIRR[ , DM.IRR]) # 0.1164696

lm(dtLiatIRR[ , DM.IRR] ~ dtLiatIRR[ , SALARY])
summary(lm(dtLiatIRR[ , DM.IRR] ~ dtLiatIRR[ , AGE]))
summary(lm(dtLiatIRR[ , LIAT.IRR] ~ dtLiatIRR[ , AGE]))

summary(lm(dtLiatIRR[ , DM.IRR] ~ dtLiatIRR[ , TOTAL_DEF_PCT]))
lm(dtLiatIRR[ , DM.IRR] ~ ., data = dtLiatIRR)
summary(lm(DM.IRR ~ AGE + DM.RET.AGE + DM.SSRE + SALARY + PRIMARY_BAL + SECONDARY_BAL + TOTAL_DEF_PCT + EQUITY_PCT, data = dtLiatIRR))


plot(dtLiatIRR[ , AGE], dtLiatIRR[ , LIAT.IRR < 10], col = 'red')
points(dtLiatIRR[ , AGE], dtLiatIRR[ , DM.IRR < 10], col = 'blue')

nrow(dtLiatIRR[LIAT.IRR > DM.IRR, ]) / nrow(dtLiatIRR) #.03225041, or 3% of LIAT scores are higher than FE

dtLiat <- dtLiatIRR[LIAT.IRR > DM.IRR, ]
dtLiat

dtIRR <- dtLiatIRR[DM.IRR > LIAT.IRR, ]
summary(dtIRR)

summary(dtLiat)

##### T-TEST the two sets of data on IRR values
t.test(dtLiat$LIAT.IRR, dtLiat$DM.IRR, paired = TRUE) # CI LIAT IRR 7.6 to 8.9 pts > than FE, not significant
t.test(dtIRR$LIAT.IRR, dtIRR$DM.IRR, paired = TRUE) # CI FE IRR 34.8 to 35.6 pts > than LIAT, significant
# Effect size of difference where FE > LIAT
liat.es <- tes(welch.irr$statistic, nrow(dtLiatIRR[LIAT.IRR > DM.IRR, ]), nrow(dtLiatIRR[DM.IRR > LIAT.IRR, ]))
liat.es # Welch's D = -5.57, a MASSIVE Effect Size difference


dtLiat[ , ageCohort := ifelse(AGE < 30, '20-29',
                              ifelse(AGE < 40, '30-39',
                                     ifelse(AGE < 50, '40-49',
                                            ifelse(AGE < 60, '50-59',
                                                   ifelse(AGE < 70, '60-69', '70+')))))]
# Turn into FACTORS and LEVEL ageCohort and generation
dtLiat[ , generation := ifelse(AGE < 34, 'Millennial',
                              ifelse(AGE < 48, 'Gen X',
                                     ifelse(AGE < 58, 'Late Boomer', 'Early Boomer')))]

dtLiatAgeCohort <- dtLiat[ , list(LIATRetAge = mean(LIAT.RET.AGE), 
                                  FERetAge = mean(DM.RET.AGE),
                                  LIATOTTR = mean(LIAT.OTTR),
                                  DMOTTR = mean(DM.OTTR),
                                  LIATSSRE = mean(LIAT.SSRE),
                                  DMSSRE = mean(DM.SSRE),
                                  SAL = mean(SALARY),
                                  LIATIRR = mean(LIAT.IRR), 
                                  FEIRR = mean(DM.IRR)), 
                              by = "ageCohort"]
dtLiatAgeCohort

dtIRRAgeCohort <- dtLiat[ , list(n = mean(DM.IRR)), by = "ageCohort"]
dtIRRAgeCohort