## ----margins------------------------------------------------------------------
library("margins")
x <- lm(mpg ~ cyl * hp + wt, data = mtcars)
(m <- margins(x))
summary(m)

## ----margins_summary----------------------------------------------------------
margins_summary(x)

## ----marginsplot--------------------------------------------------------------
plot(m)

## ---- echo = FALSE, results = 'hide'--------------------------------------------------------------
options(width = 100)

## -------------------------------------------------------------------------------------------------
library("margins")

## -------------------------------------------------------------------------------------------------
x <- lm(mpg ~ cyl + hp * wt, data = mtcars)

## -------------------------------------------------------------------------------------------------
margins(x)

## -------------------------------------------------------------------------------------------------
summary(margins(x, variables = "hp"))

## -------------------------------------------------------------------------------------------------
x <- glm(am ~ cyl + hp * wt, data = mtcars, family = binomial)
margins(x, type = "response") # the default
margins(x, type = "link")

## ---- results = "hold"----------------------------------------------------------------------------
x <- lm(mpg ~ cyl + wt + hp * am, data = mtcars)
margins(x, at = list(am = 0:1))

## ---- results = "hold"----------------------------------------------------------------------------
margins(x, at = list(am = 0:1, hp = fivenum(mtcars$hp)))

## ---- results = "hold"----------------------------------------------------------------------------
x <- lm(mpg ~ wt + I(wt^2), data = mtcars)
summary(x)

## ---- results = "hold"----------------------------------------------------------------------------
margins(x, at = list(wt = fivenum(mtcars$wt)))

## -------------------------------------------------------------------------------------------------
cplot(x, "wt", what = "prediction", main = "Predicted Fuel Economy, Given Weight")
cplot(x, "wt", what = "effect", main = "Average Marginal Effect of Weight")

## -------------------------------------------------------------------------------------------------
x <- lm(mpg ~ factor(cyl) * hp + wt, data = mtcars)
margins(x)

## -------------------------------------------------------------------------------------------------
x <- lm(mpg ~ factor(cyl) * am + hp + wt, data = mtcars)
# automatic vehicles
margins(x, data = mtcars[mtcars$am == 0, ])

# manual vehicles
margins(x, data = mtcars[mtcars$am == 1, ])

## -------------------------------------------------------------------------------------------------
m <- margins(x)
split(m, m$am)

## ---- results = "hold"----------------------------------------------------------------------------
x <- lm(mpg ~ cyl + wt * am, data = mtcars)
cplot(x, "cyl")
cplot(x, "wt")

## -------------------------------------------------------------------------------------------------
margins(x, at = list(am = 0:1))

## -------------------------------------------------------------------------------------------------
persp(x, "cyl", "wt")

## -------------------------------------------------------------------------------------------------
persp(x, "cyl", "wt", theta = c(0, 90))

## -------------------------------------------------------------------------------------------------
image(x, "cyl", "wt")

## -------------------------------------------------------------------------------------------------
summary(lm(mpg ~ drat:wt, data = mtcars))
summary(lm(mpg ~ drat * wt, data = mtcars))

## -------------------------------------------------------------------------------------------------
x1 <- lm(mpg ~ drat * wt * am, data = mtcars)
summary(margins(x1))

## -------------------------------------------------------------------------------------------------
margins(x1, at = list(drat = range(mtcars$drat)))

## -------------------------------------------------------------------------------------------------
wts <- prediction::seq_range(mtcars$wt, 10)
m1 <- margins(x1, at = list(wt = wts, drat = range(mtcars$drat), am = 0:1))
nrow(m1)/nrow(mtcars)

## ---- fig.height=4, fig.width=8-------------------------------------------------------------------
cplot(x1, x = "wt", dx = "drat", what = "effect", 
      data = mtcars[mtcars[["am"]] == 0,], 
      col = "red", se.type = "shade",
      xlim = range(mtcars[["wt"]]), ylim = c(-20, 20), 
      main = "AME of Axle Ratio on Fuel Economy")
cplot(x1, x = "wt", dx = "drat", what = "effect", 
      data = mtcars[mtcars[["am"]] == 1,], 
      col = "blue", se.type = "shade", 
      draw = "add")

## ---- fig.height=4, fig.width=8-------------------------------------------------------------------
x1b <- lm(mpg ~ am * wt + am * I(wt^2), data = mtcars)
cplot(x1b, x = "wt", dx = "wt", what = "effect", 
      data = mtcars[mtcars[["am"]] == 0,], 
      col = "red", se.type = "shade",
      xlim = range(mtcars[["wt"]]), ylim = c(-20, 20), 
      main = "AME of Weight on Fuel Economy")
cplot(x1b, x = "wt", dx = "wt", what = "effect", 
      data = mtcars[mtcars[["am"]] == 1,], 
      col = "blue", se.type = "shade", 
      draw = "add")

## -------------------------------------------------------------------------------------------------
x2 <- lm(mpg ~ hp * wt, data = mtcars)
margins(x2)

## -------------------------------------------------------------------------------------------------
persp(x2, "wt", "hp", theta = c(45, 135, 225, 315), what = "effect")

## -------------------------------------------------------------------------------------------------
summary(x2)

## -------------------------------------------------------------------------------------------------
persp(x2, "hp", "wt", theta = c(45, 135, 225, 315), what = "effect")

## -------------------------------------------------------------------------------------------------
x1 <- lm(mpg ~ drat * wt * am, data = mtcars)
cdat <- cplot(x1, "wt", draw = FALSE)
head(cdat)

## ---- fig.height=4, fig.width=8-------------------------------------------------------------------
library("ggplot2")
ggplot(cdat, aes(x = xvals)) + 
  geom_line(aes(y = yvals)) +
  geom_line(aes(y = upper), linetype = 2) +
  geom_line(aes(y = lower), linetype = 2) +
  geom_hline(yintercept = 0) +
  ggtitle("Predicted Fuel Economy (mpg) by Weight") +
  xlab("Weight (1000 lbs)") + ylab("Predicted Value")

## ---- fig.height=4, fig.width=8-------------------------------------------------------------------
cdat <- cplot(x1, "wt", "drat", what = "effect", draw = FALSE)
ggplot(cdat, aes(x = xvals)) + 
  geom_line(aes(y = yvals)) +
  geom_line(aes(y = upper), linetype = 2) +
  geom_line(aes(y = lower), linetype = 2) +
  geom_hline(yintercept = 0) +
  ggtitle("AME of Axle Ratio on Fuel Economy (mpg) by Weight") +
  xlab("Weight (1000 lbs)") + ylab("AME of Axle Ratio")

## -------------------------------------------------------------------------------------------------
utils::data(Pima.te, package = "MASS")
head(Pima.te)

## -------------------------------------------------------------------------------------------------
summary(g1 <- glm(type ~ age * skin, data = Pima.te, family = binomial))

## -------------------------------------------------------------------------------------------------
margins(g1)

## -------------------------------------------------------------------------------------------------
cplot(g1, "age")

## -------------------------------------------------------------------------------------------------
persp(g1, theta = c(45, 135, 225, 315), what = "prediction")

## -------------------------------------------------------------------------------------------------
persp(g1, theta = c(45, 135, 225, 315), what = "effect")

## ---- echo = FALSE, fig.width=8, fig.height=4-----------------------------------------------------
g2 <- glm(type ~ age + skin, data = Pima.te, family = binomial)
persp(g2, theta = c(45, 135, 225, 315), what = "prediction")
persp(g2, theta = c(45, 135, 225, 315), what = "effect")

