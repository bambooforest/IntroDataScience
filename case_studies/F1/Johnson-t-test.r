#################################
# Basic stats from Johnson 2008 #
#################################

# set working directory
setwd()

# an example from Johnson 2008 - Cherokee VOT data
vot01 <- c(84, 82, 72, 193, 129, 77, 72, 81, 45, 74, 102, 77, 187, 79, 86, 59, 74, 63, 75, 70, 106, 54, 49, 56, 58, 97)
vot71 = c(67, 127, 79, 150, 53, 65, 75, 109, 109, 126, 129, 119, 104, 153, 124, 107, 181, 166)


# get mean and standard deviation
mean(vot01)
sd(vot01)
mean(vot71)
sd(vot71)
summary(vot01)
summary(vot71)


# plot histograms and show actual and theoretical frequency distributions
hist(vot01,freq=FALSE)
plot(function(x)dnorm(x,mean=84.654,sd=36.088), 40, 200, add=TRUE)

hist(vot71,freq=FALSE)
plot(function(x)dnorm(x,mean=113.5,sd=35.928), 40, 200, add=TRUE)

# remove the outliers (although typically you shouldn't in a study)
mean(vot01[vot01<180])
sd(vot01[vot01<180])


# make q-q plots to determine if data sets are normally distributed
vot71.qq = qqnorm(vot71)$x
qqline(vot71)

vot01.qq = qqnorm(vot01)$x
qqline(vot01)

# compute the correlation (the "r" number)
cor(vot71,vot71.qq)
cor(vot01,vot01.qq)

# skewed distribution - plot it with mode, median and mean
plot(function(x)df(x,5,100),0,4,main="Measures of central tendency")
lines(x=c(0.6,0.6), y=c(0,df(0.6,5,100)))
skew.data <- rf(10000,5,100)
lines(
x=c(mean(skew.data), mean(skew.data)),
y=c(0,df(mean(skew.data), 5, 100))
)
lines(
x=c(median(skew.data), median(skew.data)),
y=c(0,df(median(skew.data), 5, 100))
)
text(1,0.75,labels="mode")
text(1.3,0.67,labels="median")
text(1.35,0.6,labels="mean")

sum((mean(skew.data)-skew.data)^2)
sum((median(skew.data)-skew.data)^2)

# measures of dispersion
range(vot01)
range(vot71)

# Histogram and Q-Q plot of some sample rating data
par(mfrow=c(1,2))
hist(data, freq=F)
plot(function(x)dnorm(x,mean=mean(data),sd=sd(data)),1,4,add=T)
qqnorm(data)
qqline(data)

# calculate the probability of a rating value less than 1.5
pnorm(1.5,mean=mean(data),sd=sd(data))
pnorm(3.5,mean=mean(data),sd=sd(data), lower.tail=F)


# Johnson 2008:56 -- t-test
# estimate how many observations you need to make in order to detect differences btwn means of any specified magnitude alpha and beta error probabilities controleld

power.t.test(power=0.8,sig.level=0.05,delta=5,sd=36.1,type="one.sample", alternative="one.sided")

# Johnson 2008:60 - correaltion
f1data = read.delim("F1_data.txt", sep="\t")
f1data$female
f1data$male

# table() creates a frequency list of the elements of a vector or factor creates a frequency list of the elements of a vector or factor
table(f1data)
summary(f1data)

attach(f1data)
plot(female,male)
lines(x=c(mean(female), mean(female)),y=c(200,900),lty=2)
lines(x=c(200,1100),y=c(mean(male), mean(male)), lty=2)
cov(female,male)
cor(female,male)

# calculate the slope of the regression line
cor(male,female)
sd(male)
sd(female)
B = cor(male,female)*(sd(male)/sd(female))
A = mean(male) - B*mean(female)

# lm() - calculates a linear model in which we try to predict one variable from another variable
# male as a function of female
# residuals (yi-y^i)
summary(lm(male~female))

reg <- lm(male~female)
abline(reg, col="red")


# predict the male F1 value from the female F1
# male F1 = 0.736 * female F1 + 47.6
# contingency.table <- table(male, female)



# Johnson 2008:72 - preparing the Cherokee data
vot = read.delim("cherokeeVOT.txt", sep="\t")
vot
attach(vot)
# summary shows problem because "year" is intended to be a nominal variable - R read it as continuous
summary(vot)
# needs to be treated as a factor 
vot$year <- factor(vot$year)
summary(vot)
vot$fyear < factor(vot$year)

# vot must be attached for this shortcut
mean(VOT[year=="1971"])
sd(VOT[year=="2001"])
mean(VOT[year=="1971"])
sd(VOT[year=="2001"])

# boxplot - good way to see central tendency
boxplot(VOT~year,data=vot,col="lightgrey", ylab="Voice Onset Time (ms)")


# t-tests

# Johnson 2008:77 - t-test contrasting Cherokee VOT in 1971 and 2001 with equal variance
# all VOT for the variable "year" is equal to a specified year: VOT[year=="1971"] VOT[year=="2001"]
# specify that the variance is equal: var.equal=T
# expect that the VOT to be greater in 1971 than 2001 - the hypothesis that there is an impact of English on Cherokee: alternative="greater"
t.test(VOT[year=="1971"], VOT[year=="2001"], var.equal=T, alternative="greater")

# Johnson 2008:78 - t-test contrasting Cherokee VOT in 1971 and 2001 with unequal variance
# In formula notation, the "dependent variable" or the "criterion variable" appears on the left ofthe tilde(~) and the "independent variables" or the "predictive factors" appear on the right side of the tilde.
# Because year only has two levels in this data set (1971 and 2001) we can use this notation to describe the desired t-test.
# The conclusion is the same
t.test(VOT ~ year, alternative="greater")

# Johnson 2008:82 - t-test contrasting Cherokee VOT in 1971 and 2001 with unequal variance
t.test(female, male, alternative="greater", var.equal=T)
t.test(female, male, paired=T, alternative="greater")



# Cherokee VOT data
vot01 <- c(84, 82, 72, 193, 129, 77, 72, 81, 45, 74, 102, 77, 187, 79, 86, 59, 74, 63, 75, 70, 106, 54, 49, 56, 58, 97)
vot71 = c(67, 127, 79, 150, 53, 65, 75, 109, 109, 126, 129, 119, 104, 153, 124, 107, 181, 166)

# mean and standard deviation of 2001 data
mean(vot01)
sd(vot01)

# null hypothesis: H0: mu=100 - "no difference" between mean of 2001 and mean value 100
# probability density function of t with 25 degrees of freedom shows that only 2% of all t-values in the distribution are less than -2.16 - probability value says that if we assume that mu=100, it is pretty unlikely (2 times in 10) that we would draw a sample that has an mean of 84.7. the more likley conclusion that we should draw is that the population mean is less than 100

t.test(vot01, mu=100, alternative="less")












