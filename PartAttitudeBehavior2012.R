# Principle Component Analysis of 2012 Participant Attitudes and Behavior study
# Working with cleaned up original data in 2012 Research folder saved as CSV for easier importing
##### BEGIN DATA MUNGING #####
# This data is trimmed to exclude all non-questions; the original file is PAB2012_orig.csv
pab.orig <- read.csv("c:\\r\\data\\PAB2012_orig.csv", header = TRUE)
pab <- read.csv("c:\\r\\data\\PAB2012_trim.csv", header = TRUE)

pab.work <- pab

# Trim the unnecessary data
str(pab.work)

# Alter some question scoring from 5 = Not Sure to 3 = Neutral to match other questions
# Cut all prioritization of financial issues questions because added late to survey
# Alter some questions scoring missing a Neutral option from 4, 3, 2, 1 to 5, 4, 2, 1
# Question 22 change scoring from 3, 2, 1, 4, 5 to 5, 4, 2, 3, 1
# Q35 4, 3, 2, 1, 5, 6 change scoring to 6, 5, 4, 3, 2, 1
# Question Scales
# All section 4Qs change from 4, 3, 2, 1, 5 to 5, 4, 2, 1, 3
# 4a do.not.read.all: reverse to POSITIVE
# 4b not.interested.fin.plan: reverse to POSITIVE
# 4j turn.over.expert: reverse to POSITIVE
reverse <- function(x, scale) {
  (scale + 1) - x
}

rescore <- function(x, scale, notsure) {
  if(scale == 5 & notsure == 5) {
    ifelse(x == 4, 5,
           ifelse(x == 3, 4,
                  ifelse(x == notsure, 3, x)))
    return(x)
  }
  
  if(scale == 6 & notsure == 5) {
    ifelse(x == 4, 6,
           ifelse(x == 3, 5,
                  ifelse(x == 2, 4,
                         ifelse(x == 1, 3,
                                ifelse(x == 5, 1, 2)))))
    return(x)
  }
}

# Update all Q4 answers
pab$do.not.read.all <- reverse(rescore(pab$do.not.read.all, max(pab$do.not.read.all), 5), max(pab$do.not.read.all))
# pab$do.not.read.all <- rescore(pab$do.not.read.all, max(pab$do.not.read.all), 5)
# pab$do.not.read.all <- reverse(pab$do.not.read.all, max(pab$do.not.read.all))
pab$not.interested.fin.plan <- reverse(rescore(pab$not.interested.fin.plan, max(pab$not.interested.fin.plan), 5), max(pab$not.interested.fin.plan))
pab$not.interested.fin.plan <- reverse(pab$not.interested.fin.plan, max(pab$not.interested.fin.plan))
pab$enough.talent <- rescore(pab$enough.talent, max(pab$enough.talent), 5)
pab$behind.schedule <- rescore(pab$behind.schedule, max(pab$behind.schedule), 5)
pab$willing.but.unsure <- rescore(pab$willing.but.unsure, max(pab$willing.but.unsure), 5)
pab$easy.button <- rescore(pab$easy.button, max(pab$easy.button), 5)
pab$cannot.absorb.all <- rescore(pab$cannot.absorb.all, max(pab$cannot.absorb.all), 5)
pab$like.detailed.advice <- rescore(pab$like.detailed.advice, max(pab$like.detailed.advice), 5)
pab$turn.over.expert <- rescore(pab$turn.over.expert, max(pab$turn.over.expert), 5)
pab$emp.decide.rate.investments <- rescore(pab$emp.decide.rate.investments,max(pab$emp.decide.rate.investments), 5)

# Update all Q7 answers
pab$spend.ten.ins <- rescore(pab$spend.ten.ins, max(pab$spend.ten.ins), 5)
pab$annuity.interest <- rescore(pab$annuity.interest, max(pab$spend.ten.ins), 5)
pab$confident.savings.last <- rescore(pab$confident.savings.last, max(pab$confident.savings.last), 5)
pab$too.far.to.think.about <- rescore(pab$too.far.to.think.about, max(pab$too.far.to.think.about), 5)
pab$no.idea.how.much.need <- rescore(pab$no.idea.how.much.need, max(pab$no.idea.how.much.need), 5)

# Update all Q19 answers
pab$tools.amount.save <- rescore(pab$tools.amount.save, max(pab$tools.amount.save), 5)
pab$tools.which.invs <- rescore(pab$tools.which.invs, max(pab$tools.which.invs), 5)
pab$tools.allocation <- rescore(pab$tools.allocation, max(pab$tools.allocation), 5)
pab$tools.on.track <- rescore(pab$tools.on.track, max(pab$tools.on.track), 5)
pab$tools.projection <- rescore(pab$tools.projection, max(pab$tools.projection), 5)

# Update all Q22 answers
pab$review.invs <- rescore(pab$review.invs, max(pab$review.invs), 5)
pab$rebalance.invs <- rescore(pab$rebalance.invs, max(pab$rebalance.invs), 5)
pab$inv.new.fund <- rescore(pab$inv.new.fund, max(pab$inv.new.fund), 5)
pab$chg.contrib.alloc <- rescore(pab$chg.contrib.alloc, max(pab$chg.contrib.alloc), 5)
pab$increase.contrib <- rescore(pab$increase.contrib, max(pab$increase.contrib), 5)
pab$decrease.contrib <- rescore(pab$decrease.contrib, max(pab$decrease.contrib), 5)

# Update all Q32 answers
pab$lineup.three.simpler <- rescore(pab$lineup.three.simpler, max(pab$lineup.three.simpler), 5)
pab$lineup.three.allocation.focus <- rescore(pab$lineup.three.allocation.focus, max(pab$lineup.three.allocation.focus), 5)
pab$lineup.three.reduce.confusion <- rescore(pab$lineup.three.reduce.confusion, max(pab$lineup.three.reduce.confusion), 5)
pab$lineup.three.reduce.confusion <- rescore(pab$lineup.three.reduce.confusion, max(pab$lineup.three.reduce.confusion), 5)

# Update all Q33 answers
pab$lineup.18.more.likely.like <- rescore(pab$lineup.18.more.likely.like, max(pab$lineup.18.more.likely.like), 5)
pab$lineup.18.best.fit <- rescore(pab$lineup.18.best.fit, max(pab$lineup.18.best.fit), 5)
pab$lineup.18.more.choice <- rescore(pab$lineup.18.more.choice, max(pab$lineup.18.more.choice), 5)

# Update all Q35 answers, originally 4, 3, 2, 1, 5, 6; change to 6, 5, 4, 3, 1, 2
pab$personal.mtg.helpful.deferral <- rescore(pab$personal.mtg.helpful.deferral, max(pab$personal.mtg.helpful.deferral), 6)
pab$personal.mtg.helpful.allocation <- rescore(pab$personal.mtg.helpful.allocation, max(pab$personal.mtg.helpful.allocation), 6)

# Update all Q36 answers
pab$trust.employer.select.plan <- rescore(pab$trust.employer.select.plan, max(pab$trust.employer.select.plan), 5)
pab$trust.provider.recommend.educ <- rescore(pab$trust.provider.recommend.educ, max(pab$trust.provider.recommend.educ), 5)
pab$trust.employer.select.lineup <- rescore(pab$trust.employer.select.lineup, max(pab$trust.employer.select.lineup), 5)

# Nuke the worry at work questions b/c of N/As
pab <- pab[ , -c(19:22)]

str(pab)

# Trim out CONFIDENT.SAVINGS.LAST and WEIGHT
pab.trim <- pab[ , -c(12, 70)]

summary(pab.trim)
##### END DATA MUNGING #####

##### BEGIN PRINCIPLE COMPONENT ANALYSIS #####
correls <- round(cor(pab.trim), 2) # Correlation table on the trimmed data

pab.pca <- prcomp(pab.trim, scale = FALSE)

summary(pab.pca)

# What's the linear combo for rotation 1:8?
rot18 <- pab.pca$rotation[ , c(1:16)]
rot18

pca.center <- pab.pca$center
pca.scale <- pab.pca$scale

# hm <- as.matrix(pab[ , -c(13, 39)])
# head(drop(scale(hm, center = pca.center, scale = pca.scale) %*% pab.pca$rotation[ , c(1:8)]))

head(predict(pab.pca)[, c(1:16)])

cor(pab$confident.savings.last, pab.pca$x[ , c(1:16)])

plot(pab.pca, type = "l")

biplot(pab.pca, col = c("gray", "black"))

cor(pab$confident.savings.last, pab.pca$x[ , 1])

plot(pab$confident.savings.last)
plot(pab$confident.savings.last, pab.pca$x[ , 1])

##### END PRINCIPLE COMPONENT ANALYSIS #####

##### BEGIN K-MEANS CLUSTERING ON PARTICIPANTS #####
part.att.beh.clusters <- kmeans(x = pab, centers = 4)

part.att.beh.clusters$centers
part.att.beh.clusters$size

pab.orig$pabcluster <- part.att.beh.clusters$cluster

# The initial kmeans algorithm cannot handle WEIGHTS; this one can
library(weightedKmeans)
pab.clusters.ewkm <- ewkm(x = pab, k = 4, lambda = pab$weight)

pab.clusters.ewkm$centers
pab.clusters.ewkm$size

pab.orig$ewkm.cluster <- pab.clusters.ewkm$cluster

table(pab.orig$ewkm.cluster == pab.orig$pabcluster) # 546 changed versus 463 stayed the same

##### END K-MEANS CLUSTERING ON PARTICIPANTS #####

##### BEGIN K-MEANS CLUSTERING ON ROL COMMENTS #####
# Import the 2013 survey results
library(foreign)
part.2012 <- as.data.frame(read.spss("K:\\RP\\Product Organization\\Research\\2012 Research\\Boston Research Group\\2012\\Participant_2012 SPSS.sav", use.value.labels = TRUE))











##### BEGIN EXAMPLE PCA on HEPTATHLON RESULTS #####
# PCA on Heptathlon results
data("heptathlon", package = "HSAUR")

# Score all seven events the same way where large values = good; change running times!
heptathlon$hurdles <- max(heptathlon$hurdles) - heptathlon$hurdles # Subtract the competitor's time from the SLOWEST time
heptathlon$run200m <- max(heptathlon$run200m) - heptathlon$run200m
heptathlon$run800m <- max(heptathlon$run800m) - heptathlon$run800m

round(cor(heptathlon[ , -8]), 2) # or ...-8])

score <- which(colnames(heptathlon) == "score")
plot(heptathlon[ , -8])

heptathlon.pca <- prcomp(heptathlon[ , -8], scale = TRUE)
heptathlon.pca

summary(heptathlon.pca)

# What's the linear combo for the PC1?
a1 <- heptathlon.pca$rotation[ , 1]
a1

hep.center <- heptathlon.pca$center
hep.scale <- heptathlon.pca$scale

hm <- as.matrix(heptathlon[ , -8])
drop(scale(hm, center = hep.center, scale = hep.scale) %*% heptathlon.pca$rotation[ , 1]) # which is the same as...
predict(heptathlon.pca)[ , 1]

cor(heptathlon$score, heptathlon.pca$x[ , 1]) # -.991

plot(heptathlon.pca, type = "l")

# BIPLOT of the first two components
biplot(heptathlon.pca, col = c("gray", "black"))

# Plot the scores versus the first PC
plot(heptathlon$score, heptathlon.pca$x[ , 1])

##### END EXAMPLE PCA on HEPTATHLON RESULTS #####

##### BEGIN PCA ON STATEMENTS VERSUS ENOUGH TALENT #####
# Pull the data about statements and confidence into a separate data set
stmt.talent <- pab.work[ , c(3, 52:62)]

round(cor(stmt.talent[ , -1]), 2)

plot(stmt.talent[ , -1])

stmt.talent.pca <- prcomp(stmt.talent[ , -1])

stmt.talent.pca

summary(stmt.talent.pca)

rotations <- stmt.talent.pca$rotation[ , c(1:3)]
rotations

cor(stmt.talent$enough.talent, stmt.talent.pca$x[ , c(1:3)]) # Very little correlation between STMTS and ENOUGH TALENT


