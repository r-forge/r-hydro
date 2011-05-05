
library(RHydro)
data(huagrahuma)

source("r-hydro/pkg/RHydro/R/class.HydroModel.R")
source("r-hydro/pkg/RHydro/R/HydroModel.R")

min <- c(1E-4, -2, 0, 0, 0, 0, 100, 0, 0)
max <- c(2.5E-4,3,0.1,0.2,0.1,3,2500,10,5)

params <- as(list(runif, n = 9, min = min, max = max), "HydroModelParameters")
resample(params, n = 100)

parameters <- huagrahuma$parameters[1:9]

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
data <- huagrahuma$inputs
topidx = huagrahuma$topidx
delay = huagrahuma$delay
model <- HydroModel("topmodel", parameters, data,
                    delay = huagrahuma$delay, topidx = huagrahuma$topidx)

predictions <- predict(model)

