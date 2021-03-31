## -------------------------------------------------------------------------------------------------
library("margins")
options(width = 100)

## -------------------------------------------------------------------------------------------------
library("margins")
x <- lm(mpg ~ cyl + hp + wt, data = mtcars)
summary(margins(x))

## -------------------------------------------------------------------------------------------------
x <- lm(mpg ~ cyl + hp * wt, data = mtcars)
summary(margins(x))

## -------------------------------------------------------------------------------------------------
x <- lm(mpg ~ factor(cyl) + hp + wt, data = mtcars)
summary(margins(x))

## -------------------------------------------------------------------------------------------------
x <- lm(mpg ~ cyl + hp + I(hp^2) + wt, data = mtcars)
summary(margins(x))

## -------------------------------------------------------------------------------------------------
x <- lm(mpg ~ cyl + I(hp^2) + wt, data = mtcars)
summary(margins(x))

## -------------------------------------------------------------------------------------------------
x <- glm(am ~ cyl + hp + wt, data = mtcars, family = binomial)
# AME
summary(margins(x, type = "response"))
# AME and MEM equivalent on "link" scale
summary(margins(x, type = "link"))

## -------------------------------------------------------------------------------------------------
x <- glm(am ~ factor(cyl) + hp + wt, data = mtcars, family = binomial)
# Log-odds
summary(margins(x, type = "link"))
# Probability with continuous factors
summary(margins(x, type = "response"))

## -------------------------------------------------------------------------------------------------
x <- glm(am ~ cyl + hp * wt, data = mtcars, family = binomial)
# AME
summary(margins(x, type = "response"))
# AME and MEM equivalent on "link" scale
summary(margins(x, type = "link"))

## -------------------------------------------------------------------------------------------------
x <- glm(am ~ cyl + hp * wt, data = mtcars, family = binomial(link="probit"))
# AME (log-odds)
summary(margins(x, type = "link"))
# AME (probability)
summary(margins(x, type = "response"))

## -------------------------------------------------------------------------------------------------
x <- glm(carb ~ cyl + hp * wt, data = mtcars, family = poisson)
# AME (linear/link)
summary(margins(x, type = "link"))
# AME (probability)
summary(margins(x, type = "response"))

