

library(HydroModels2)
data(huagrahuma)
attach(huagrahuma)
options(error = recover)
#HMObject = RHydro("topmodel", Temporal = list(data = inputs),
#    Parameters = as.list(parameters[1:9]), Dots = list(top = topidx, del = delay))
HMObject = RHydro(model = "topmodel", newval = list(Obs = list(Temporal = list(data = inputs)),
    Parameters = list(param = data.frame(parameters = parameters[1:9])), Dots = list(top = topidx, del = delay)))

HMObject1 = RHydro(model = "topmodel", newval = list(Obs = list(Temporal = list(data = inputs)),
    Parameters = list(param = data.frame(parameters = parameters[1:9])), Dots = list(top = topidx, del = delay)))

HMObject2 = RHydro(model = "topmodel", Obs = list(Temporal = list(data = inputs)),
    Parameters = list(param = data.frame(parameters = parameters[1:9])), Dots = list( top = topidx, del = delay))

# Parameters lost
HMObject3 = RHydro(model = "topmodel", Temporal = list(data = inputs),
    Parameters = list(param = data.frame(parameters[1:9])), Dots = list(top = topidx, del = delay))



all.equal(HMObject, HMObject1)
all.equal(HMObject2, HMObject3)

res = topmodel(HMObject)
res2 = predict(HMObject)
str(res)
all.equal(res, res2)

# Modification/slot replacement
HMObject = RHydro(HMObject, newval = list(Obs = list(Temporal = list(data = inputs[1:9999,])),
                  Pred = list(newmodel = list(Temporal = 
                                                list(predictions = res@Pred[[1]]@Temporal[[1]][1:9999,])))))
str(HMObject)

#################
if (FALSE) {
  res = predictions(res)
  res = temporalData(res)
  res = res$predictions
  res = cbind(res, res)
  names(res) = c("Q", "Q2")
  odiff = as.numeric(res$Q2[1])/as.numeric(res$Q[1])
  rans = runif(10000)
  for (i in 2:length(res$Q)) {
    ndiff = 2*(1-rans[i])
    mdiff = (5*odiff + ndiff)/6
    res$Q2[i] = res$Q2[i]*mdiff
    odiff = mdiff
    if (i %%100 ==0) print(i)
  }
  inputs$Q = res$Q2
  save(inputs, parameters, topidx, delay, file = "c:/users/jon/work/R-Forge/RHydro/pkg/HydroModels/data/huagrahuma2.rda")
}

if (FALSE) {
  setwd("c:/jonWork/RForge/RHydro/pkg")
  require(devtools)
  install("Hydro")
  require(devtools)
  install("HydroModels")
 }


require(HydroModels2)
data(huagrahuma2)
HMObject = RHydro(model = "topmodel", Temporal = list(data = inputs),
    Parameters = list(param = data.frame(parameters = parameters[1:9])), Dots = list(top = topidx, del = delay),
    control = list(dependent = "Q"))
res2 = predict(HMObject)
Hydro:::nashsut(res2@Pred@Temporal$predictions, HMObject@Obs@Temporal$data$Q)
Hydro:::nashsut(HMtemporalData(HMpredictions(res2))$predictions,
                HMtemporalData(HMobservations(HMObject))$data$Q)
HMObjectiveFunction(parameters[1:9], HMObject)
parameters = parameters[1:9]*2
HMObjectiveFunction(parameters[1:9], HMObject)
parlower = parameters*(ifelse(parameters < 0, 4, 0.25))
parupper = parameters*(ifelse(parameters < 0, 0.25, 4))

HMObject = RHydro("topmodel", Temporal = list(data = inputs),
                  Parameters = list(parameters = parameters[1:9], parlower = parlower[1:9], 
                                    parupper = parupper[1:9],  top = topidx, del = delay),
                  control = list(dependent = "Q"))
options(error = recover)
predict(HMObject)
HMCalib = calibrate(HMObject)



