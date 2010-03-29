
# code to test the topmodel implementation in RHydro
# WB 2010-03-13 - ...

library(RHydro)
data(huagrahuma)
attach(huagrahuma)

source("/Users/wouter/rhydro/pkg/RHydro/R/topmodel.R")
source("/Users/wouter/rhydro/pkg/RHydro/R/class.HydroTopmodelParameters.R")

#### SINGLE RUN ####

## 1. return NS

test <- topmodel(parameters, inputs, topidx, delay, performance=c("NS"))
test$pm

## 2. return discharge

test <- topmodel(parameters, inputs, topidx, delay)
test
plot(test$Qsim)

## 3. return verbose

test <- topmodel(parameters, inputs, topidx, delay, verbose = TRUE)
test

#### MULTIPLE RUN ####

runs <- 100

qs0   <- runif(runs, min = 0.0001, max = 0.00025)
lnTe  <- runif(runs, min = -2, max = 3)
m     <- runif(runs, min = 0, max = 0.1)
Sr0   <- runif(runs, min = 0, max = 0.2)
Srmax <- runif(runs, min = 0, max = 0.1)
td    <- runif(runs, min = 0, max = 3)
vr    <- runif(runs, min = 100, max = 2500)
k0    <- runif(runs, min = 0, max = 10)
CD    <- runif(runs, min = 0, max = 5)

parameters <- cbind(qs0, lnTe, m, Sr0, Srmax, td, vr, k0, CD)

## 1. return NS

test <- topmodel(parameters, inputs, topidx, delay, performance=c("NS"))
test$pm


## 2. return discharge

test <- topmodel(parameters, inputs, topidx, delay)
test
test$Qsim[1:10,]

## 3. return verbose

test <- topmodel(parameters, inputs, topidx, delay, verbose=T)
test$Qsim[1:10,]
