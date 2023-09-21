Linear regression example: income vs. happiness
================
Steve Moran
(20 March, 2023)

- [Overvierw](#overvierw)
- [Load the data](#load-the-data)
- [Define your hypothesis](#define-your-hypothesis)
- [Choose a statistical test](#choose-a-statistical-test)
- [Check your model assumptions](#check-your-model-assumptions)
  - [1. Independence](#1-independence)
  - [2. Normality](#2-normality)
  - [3. Linearity](#3-linearity)
  - [4. Homoscedasticity (aka homogeneity of
    variance)](#4-homoscedasticity-aka-homogeneity-of-variance)
- [Perform the linear regression
  analysis](#perform-the-linear-regression-analysis)
- [Check for homoscedasticity](#check-for-homoscedasticity)

------------------------------------------------------------------------

Load the libraries.

``` r
library(tidyverse)
library(knitr)
```

------------------------------------------------------------------------

# Overvierw

This example from:

- <https://www.scribbr.com/statistics/simple-linear-regression/>

> > > Bevans, R. (2022, November 15). Simple Linear Regression \| An
> > > Easy Introduction & Examples. Scribbr. Retrieved March 20, 2023,
> > > from
> > > <https://www.scribbr.com/statistics/simple-linear-regression/>

The data below are from this example and the dataset includes an
**imaginary sample**:

> > > The first dataset contains observations about income (in a range
> > > of \$15k to \$75k) and happiness (rated on a scale of 1 to 10) in
> > > an imaginary sample of 500 people. The income values are divided
> > > by 10,000 to make the income data match the scale of the happiness
> > > scores (so a value of \$2 represents \$20,000, \$3 is \$30,000,
> > > etc.)

However, published researched on this topic in general includes, for
example:

- <https://www.pnas.org/doi/pdf/10.1073/pnas.2016976118>

> > > What is the relationship between money and well-being? Research
> > > distinguishes between two forms of well-being: people’s feelings
> > > during the moments of life (experienced well-being) and people’s
> > > evaluation of their lives when they pause and reflect (evaluative
> > > well-being). Drawing on 1,725,994 experience-sampling reports from
> > > 33,391 employed US adults, the present results show that both
> > > experienced and evaluative well-being increased linearly with
> > > log(income), with an equally steep slope for higher earners as for
> > > lower earners. There was no evidence for an experienced well-being
> > > plateau above \$75,000/y, contrary to some influential past
> > > research. There was also no evidence of an income threshold at
> > > which experienced and evaluative well-being diverged, sug- gesting
> > > that higher incomes are associated with both feeling bet- ter
> > > day-to-day and being more satisfied with life overall.

With data available here:

- <https://osf.io/cfnbv>

# Load the data

Let’s load the data.

``` r
df <- read_csv('data/income.data.csv')
```

And have a look at it.

``` r
head(df) %>% 
  kable()
```

|  …1 |   income | happiness |
|----:|---------:|----------:|
|   1 | 3.862647 |  2.314489 |
|   2 | 4.979381 |  3.433490 |
|   3 | 4.923957 |  4.599373 |
|   4 | 3.214372 |  2.791114 |
|   5 | 7.196409 |  5.596398 |
|   6 | 3.729643 |  2.458556 |

What are the variables for:

- income?
- happiness?

How do we get an overall summary statistic of each?

``` r
summary(df)
```

    ##       ...1           income        happiness    
    ##  Min.   :  1.0   Min.   :1.506   Min.   :0.266  
    ##  1st Qu.:125.2   1st Qu.:3.006   1st Qu.:2.266  
    ##  Median :249.5   Median :4.424   Median :3.473  
    ##  Mean   :249.5   Mean   :4.467   Mean   :3.393  
    ##  3rd Qu.:373.8   3rd Qu.:5.992   3rd Qu.:4.503  
    ##  Max.   :498.0   Max.   :7.482   Max.   :6.863

# Define your hypothesis

Recall any hypothesis testing follows these steps, broadly speaking:

1.  Choose a significance level (α)
2.  Formulate a null hypothesis, H0
3.  Formulate an alternative hypothesis, H1
4.  Gather data, calculate a test statistic, e.g. T or F
5.  Determine the probability (p-value) of obtaining T or F “or a more
    extreme value” under H0
6.  If p ≤ α, reject H0

And the basic process is:

- Set up a hypothesis, and assume that it is true.
- Gather data from some real-world experiment that is relevant to the
  hypothesis.
- Make a determination about the hypothesis, based on the idea of “how
  likely is our data given the hypothesis?”

Let’s go through an example.

------------------------------------------------------------------------

First, let’s set up our hypothesis regarding income vs happiness of the
df.

- H0:
- H1:

We have data already, let’s look at what data types that we have. And
here’s its structure:

``` r
str(df)
```

    ## spc_tbl_ [498 × 3] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
    ##  $ ...1     : num [1:498] 1 2 3 4 5 6 7 8 9 10 ...
    ##  $ income   : num [1:498] 3.86 4.98 4.92 3.21 7.2 ...
    ##  $ happiness: num [1:498] 2.31 3.43 4.6 2.79 5.6 ...
    ##  - attr(*, "spec")=
    ##   .. cols(
    ##   ..   ...1 = col_double(),
    ##   ..   income = col_double(),
    ##   ..   happiness = col_double()
    ##   .. )
    ##  - attr(*, "problems")=<externalptr>

Recall our discussion on [data types in
statistics](https://github.com/bambooforest/IntroDataScience/tree/main/3_data#data-types-in-statistics).

# Choose a statistical test

What kind of statistical test can we use to test if there’s a
relationship between these two variables?

Recall that the independent variable (predictor variable) is the
variable that is being manipulated, so that we can observe if there is
an effect on the dependent variable (outcome variable).

- Independent variable(s) – Predictor variable(s)
- Dependent variable(s) – Outcome/Output variable(s)

One way to look at that relationship is to **plot the input** on the
x-axis and the output on the y-axis in a scatter plot.

``` r
ggplot(df, aes(income, happiness)) +
  geom_point()
```

![](README_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

One way to test whether there is a relationship with two continuous data
points is to use [linear
regression](https://en.wikipedia.org/wiki/Linear_regression).

``` r
ggplot(df, aes(income, happiness)) +
  geom_point() +
  geom_smooth(method='lm')
```

    ## `geom_smooth()` using formula = 'y ~ x'

![](README_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

# Check your model assumptions

But hold on. Just because we see a pattern does not necessarily mean
it’s there. We have to be careful of statistical bias. How can we
control for bias?

Like other statistical tests, **you will have to know the (four) main
assumptions** for linear regression, i.e.:

- [Independence](https://en.wikipedia.org/wiki/Independence_(probability_theory))
  of observations (aka no
  [autocorrelation](https://en.wikipedia.org/wiki/Autocorrelation))
- [Normality](https://en.wikipedia.org/wiki/Normal_distribution)
- [Linearity](https://en.wikipedia.org/wiki/Linear_regression)
- [Homoscedasticity](https://en.wikipedia.org/wiki/Homoscedasticity_and_heteroscedasticity)
  (aka homogeneity of variance)

Two events are **independent** if the occurrence of one event does not
affect the chances of the occurrence of the other event.

We test for **normality** to see whether a set of data is distributed in
a way that is consistent with a [normal
distribution](https://en.wikipedia.org/wiki/Normal_distribution), when
our statistical test requires that the data points are normally
distributed.

**Linearity** is demonstrated when the mean values of the outcome
variable (dependent variable) for each increment of the predictors
(independent variables) lies along a straight line.

**Homoscedasticity** (homogeneity of variances) is an assumption of
equal or similar variances in different groups being compared.

<!--
[Parametric statistical test](https://en.wikipedia.org/wiki/Parametric_statistics) assume that data points in the sample come from a population that can be modeled by a [probability distribution](https://en.wikipedia.org/wiki/Probability_distribution) (i.e., a mathematical function that describes the probabilities of occurrence of the outcomes in an experiment) and that has a fixed set of [statistical parameters](https://en.wikipedia.org/wiki/Statistical_parameter). This assumption is important because parametric statistical tests are sensitive to any dissimilarities and uneven variance in samples will bias and skew the results.
-->

Here is a good and simple overview of linear models:

- <https://www.scribbr.com/statistics/linear-regression-in-r/>

------------------------------------------------------------------------

## 1. Independence

For income and happiness, we only have one independent variable and one
dependent variable for each athlete, so we don’t need to test for any
hidden relationships among the variables. In other words, we have
independence of observations.

## 2. Normality

We need to check if the dependent variable is normally distributed. We
can quickly visualize it. Does it look normal?

``` r
hist(df$happiness)
```

![](README_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

Another way to look for normality is with a quantile-quantile plot (Q-Q
plot), which is a graphical tool to assess whether the data come from
some probability distribution. It is a scatter plot that plots two sets
of [quantiles](https://en.wikipedia.org/wiki/Quantile) against each
other. If for example, we have a relatively straight line, we may assume
that our data points come from a normal distribution.

``` r
qqnorm(df$income, pch = 1, frame = FALSE) # Create the Q-Qplot
qqline(df$income, col = "steelblue", lwd = 2) # Add a blue line for reference
```

![](README_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

## 3. Linearity

As we saw above, the data are linearly distributed. Here’s another way
to quickly visualize the x and y variables.

``` r
plot(happiness ~ income, data = df)
```

![](README_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

## 4. Homoscedasticity (aka homogeneity of variance)

This means that the prediction error doesn’t change significantly over
the range of prediction of the model. We can test this assumption later,
after fitting the linear model.

# Perform the linear regression analysis

So now we can do our linear regression and interpret the results.

``` r
lm <- lm(happiness ~ income, data = df)
summary(lm)
```

    ## 
    ## Call:
    ## lm(formula = happiness ~ income, data = df)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -2.02479 -0.48526  0.04078  0.45898  2.37805 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  0.20427    0.08884   2.299   0.0219 *  
    ## income       0.71383    0.01854  38.505   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.7181 on 496 degrees of freedom
    ## Multiple R-squared:  0.7493, Adjusted R-squared:  0.7488 
    ## F-statistic:  1483 on 1 and 496 DF,  p-value: < 2.2e-16

------------------------------------------------------------------------

Can we say there is a significant positive relationship between income
and happiness of these df (p-value \< 0.001).

------------------------------------------------------------------------

# Check for homoscedasticity

``` r
par(mfrow=c(2,2))
plot(lm)
```

![](README_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

``` r
par(mfrow=c(1,1))
```

Residuals are the unexplained variance. They are not exactly the same as
model error, but they are calculated from it, so seeing a bias in the
residuals would also indicate a bias in the error.

The most important thing to look for is that the red lines representing
the mean of the residuals are all basically horizontal and centered
around zero. This means there are no outliers or biases in the data that
would make a linear regression invalid.

In the Normal Q-Qplot in the top right, we can see that the real
residuals from our model form an almost perfectly one-to-one line with
the theoretical residuals from a perfect model.

Based on these residuals, we can say that our model meets the assumption
of homoscedasticity.

------------------------------------------------------------------------

Statistical tests are about interpreting data. If we want to interpret
our data with formal procedures and to make claims about the
distribution of our data or whether two data sets differ fundamentally
from each other, then we rely on hypothesis testing.
