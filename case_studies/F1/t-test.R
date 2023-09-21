################################################################################
# Basics in Statistics
#
# April  2015, S. Schwab (sandra.schwab@unige.ch or sandra.schwab@uzh.ch)
################################################################################

#############################
# Unpaired t-test
#############################

# Import (open) dataRate.txt

# path to file directly, e.g.
# dataRate <- read.delim("C:/Users/Sasa/Desktop/StatZH/Examples/dataCat.txt")

# or set working directory to where file is and load file
# setwd("~/Dropbox/Teaching/UZ/2015/102 Methoden und Anwendungen/Lectures/12 t-test")
dataRate <- read.delim("dataRate.txt")

attach(dataRate)

# Info
summary(dataRate)

hist(SyllDur)
hist(SyllDur[Gender=="Male"])
hist(SyllDur[Gender=="Female"])

# Means by Gender
tapply(SyllDur, Gender, mean, na.rm=TRUE)

# sd by Gender
tapply(SyllDur, Gender, sd, na.rm=TRUE)


#Boxplot
boxplot(SyllDur~Gender, xlab="Gender", ylab="Syllabic duration (ms)")

# Test normal distribution in  noth  groups (H0 = normal distribution)
shapiro.test(SyllDur[Gender=="Male"])
shapiro.test(SyllDur[Gender=="Female"])

# Test variance in both groups
var.test(SyllDur~Gender)

# Unpaired t-test
t.test(SyllDur~Gender, var.equal = TRUE)

detach(dataRate)



#############################
# Paired t-Test
#############################

# Import (open) dataAph.txt
dataAph <- read.delim("dataAph.txt")

attach(dataAph)

# Info
summary(dataAph)
hist(Before)
hist(After)
hist(Diff)
mean(Before)
mean(After)
sd(Before)
sd(After)

#Boxplot
boxplot(Before, After, names=c("Before", "After"), xlab="Session", ylab="Reaction time (ms)")

# Test the normal distribution of the difference (H0 = normal distribution)
shapiro.test(Diff)

# Test the variance of the two groups
var.test(Before, After)

# Paired t-test
t.test(Before, After, var.equal = TRUE, paired=TRUE)


detach(dataAph)
