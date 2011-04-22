
# code to test the topmodel implementation in RHydro
# WB 2010-03-13 - ...

library(RHydro)
data(huagrahuma)

source("r-hydro/pkg/RHydro/R/topmodel.R")
source("r-hydro/pkg/RHydro/R/class.HydroTopmodelParameters.R")

topidx = huagrahuma$topidx
delay = huagrahuma$delay
params <- huagrahuma$parameters[1:9]
data <- huagrahuma$inputs

#### SINGLE RUN ####

## 1. return Qsim and NS

test <- topmodel(params, data, delay, topidx, pm=c("NS"))

###### FROM HERE: change names arguments #######

## 2. return Qsim

test <- topmodel(params, data, delay, topidx)
test
plot(test$Q)

## 3. return verbose

test <- topmodel(params, data, delay, topidx, verbose = TRUE)
plot(test)

## 4. return all

test <- topmodel(params, data, delay, topidx, pm = "NS", verbose = TRUE)
str(test)
plot(test$simulations$Q)

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

test <- topmodel(parameters, data, delay, topidx, return.simulations = F, pm=c("NS"))
str(test)


## 2. return discharge

test <- topmodel(parameters, data, delay, topidx)
str(test)
test$Q[1:10,]

## 3. return everything

test <- topmodel(parameters, data, delay, topidx, pm = c("NS"), verbose=T)
str(test)
