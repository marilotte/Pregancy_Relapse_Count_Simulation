## ----setup, include=FALSE, cache=FALSE--------------------------------------------------
library(knitr)
opts_chunk$set(
  fig.align = 'center', 
  fig.show = 'asis', 
  eval = TRUE,
  fig.width = 6,
  fig.height = 6,
  message = FALSE,
  size = 'small',
  comment = '##',
  prompt = FALSE,
  echo = TRUE, # set to true for the vignette!
  results = 'hold',
  tidy = FALSE)

options(replace.assign = TRUE,
        width = 90
        # prompt="R> "
        )

## ----codeExample,echo=TRUE,eval=FALSE---------------------------------------------------
#  simrec(N, fu.min, fu.max, cens.prob = 0, dist.x = "binomial", par.x = 0,
#    beta.x = 0, dist.z = "gamma", par.z = 0, dist.rec, par.rec, pfree = 0,
#    dfree = 0)

## ----Examplesimrec----------------------------------------------------------------------
library(simrec)
### Example:
### A sample of 10 individuals

N <- 10

### with a binomially distributed covariate with a regression coefficient
### of beta=0.3, and a standard normally distributed covariate with a
### regression coefficient of beta=0.2,

dist.x <- c("binomial", "normal")
par.x <- list(0.5, c(0, 1))
beta.x <- c(0.3, 0.2)

### a gamma distributed frailty variable with variance 0.25

dist.z <- "gamma"
par.z <- 0.25

### and a Weibull-shaped baseline hazard with shape parameter lambda=1
### and scale parameter nu=2.

dist.rec <- "weibull"
par.rec <- c(1,2)

### Subjects are to be followed for two years with 20\% of the subjects
### being censored according to a uniformly distributed censoring time
### within [0,2] (in years).

fu.min <- 2
fu.max <- 2
cens.prob <- 0.2

### After each event a subject is not at risk for experiencing further events
### for a period of 30 days with a probability of 50\%.

dfree <- 30/365
pfree <- 0.5

simdata <- simrec(N, fu.min, fu.max, cens.prob, dist.x, par.x, beta.x,
                  dist.z, par.z, dist.rec, par.rec, pfree, dfree)
print(simdata[1:10,])
DT::datatable(simdata)

## ----codeExamplecomp,echo=TRUE,eval=FALSE-----------------------------------------------
#  simreccomp(N, fu.min, fu.max, cens.prob = 0, dist.x = "binomial", par.x = 0,
#             beta.xr = 0, beta.xc = 0, dist.zr = "gamma", par.zr = 0, a = NULL,
#             dist.zc = NULL, par.zc = NULL, dist.rec, par.rec,
#             dist.comp, par.comp, pfree = 0, dfree = 0)

## ----Examplesimreccomp------------------------------------------------------------------
library(simrec)
### Example:
### A sample of 10 individuals

N <- 10

### with a binomially distributed covariate and a standard normally distributed
### covariate with regression coefficients of beta.xr=0.3 and beta.xr=0.2,
### respectively, for the recurrent events,
### as well as regression coefficients of beta.xc=0.5 and beta.xc=0.25,
### respectively, for the competing event.

dist.x  <- c("binomial", "normal")
par.x <- list(0.5, c(0, 1))
beta.xr <- c(0.3, 0.2)
beta.xc <- c(0.5, 0.25)

### a gamma distributed frailty variable for the recurrent event with
### variance 0.25 and for the competing event with variance 0.3,

dist.zr <- "gamma"
par.zr <- 0.25

dist.zc <- "gamma"
par.zc <- 0.3

### alternatively the frailty variable for the competing event can be computed
### via a:
a <- 0.5

### Furthermore a Weibull-shaped baseline hazard for the recurrent event with
### shape parameter lambda=1 and scale parameter nu=2,

dist.rec <- "weibull"
par.rec <- c(1, 2)

### and a Weibull-shaped baseline hazard for the competing event with
### shape parameter lambda=1 and scale parameter nu=2

dist.comp <- "weibull"
par.comp <- c(1, 2)

### Subjects are to be followed for two years with 20% of the subjects
### being censored according to a uniformly distributed censoring time
### within [0,2] (in years).

fu.min <- 2
fu.max <- 2
cens.prob <- 0.2

### After each event a subject is not at risk for experiencing further events
### for a period of 30 days with a probability of 50%.

dfree <- 30/365
pfree <- 0.5

simdata1 <- simreccomp(N = N, fu.min = fu.min, fu.max = fu.max, cens.prob = cens.prob,
                       dist.x = dist.x, par.x = par.x, beta.xr = beta.xr,
                       beta.xc = beta.xc, dist.zr = dist.zr, par.zr = par.zr, a = a,
                       dist.rec = dist.rec, par.rec = par.rec, dist.comp = dist.comp,
                       par.comp = par.comp, pfree = pfree, dfree = dfree)
simdata2 <- simreccomp(N = N, fu.min = fu.min, fu.max = fu.max, cens.prob = cens.prob,
                       dist.x = dist.x, par.x = par.x, beta.xr = beta.xr,
                       beta.xc = beta.xc, dist.zr = dist.zr, par.zr = par.zr,
                       dist.zc = dist.zc, par.zc = par.zc, dist.rec = dist.rec,
                       par.rec = par.rec, dist.comp = dist.comp,
                       par.comp = par.comp, pfree = pfree, dfree = dfree)

print(simdata1[1:10, ])
print(simdata2[1:10, ])
DT::datatable(simdata1)
DT::datatable(simdata2)

## ---- echo = FALSE, out.width=600-------------------------------------------------------
knitr::include_graphics("tikzout_1.png")

## ---- echo = FALSE, out.width=600-------------------------------------------------------
knitr::include_graphics("tikzout_2.png")

## ----codeExampleint,echo=TRUE,eval=FALSE------------------------------------------------
#  simrecint(data, N, tR, tI)

## ----Examplesimrecint-------------------------------------------------------------------
### Example - see example for simrec
library(simrec)
N         <- 10
dist.x    <- c("binomial", "normal")
par.x     <- list(0.5, c(0,1))
beta.x    <- c(0.3, 0.2)
dist.z    <- "gamma"
par.z     <- 0.25
dist.rec  <- "weibull"
par.rec   <- c(1,2)
fu.min    <- 2
fu.max    <- 2
cens.prob <- 0.2

simdata <- simrec(N, fu.min, fu.max, cens.prob, dist.x, par.x, beta.x, dist.z,
                  par.z, dist.rec, par.rec)

### Now simulate for each patient a recruitment time in [0,tR=2]
### and cut data to the time of the interim analysis at tI=1:

simdataint <- simrecint(simdata, N = N, tR = 2, tI = 1)
print(simdataint)  # only run for small N!
DT::datatable(simdataint)

## ----codeExampleplot,echo=TRUE,eval=FALSE-----------------------------------------------
#  simrecPlot(simdata, id = "id", start = "start", stop = "stop", status = "status")
#  simreccompPlot(simdata, id = "id", start = "start", stop = "stop", status = "status")

## ----ExamplePlot------------------------------------------------------------------------
simrecPlot(simdata)
simreccompPlot(simdata1)

