
library(HydroModels)
data(huagrahuma)
attach(huagrahuma)
options(error = recover)
#HMObject = RHydro("topmodel", Temporal = list(data = inputs),
#    Parameters = as.list(parameters[1:9]), Dots = list(top = topidx, del = delay))
HMObject = RHydro("topmodel", Temporal = list(data = inputs),
    Parameters = list(param = parameters[1:9], top = topidx, del = delay))

options(error = recover)
#debug(HydroModels:::.topmodel)
res = topmodel(HMObject)
res2 = predict(HMObject)


#################
if (FALSE) {
  res$Q2 = res$Q
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
  save(inputs, parameters, topidx, delay, file = "c:/users/jon/work/R-Forge/RHydro/pkg/HydroModels/huagrahuma2")
}


inputs$Q = res$Q2
HMObject = RHydro("topmodel", Temporal = list(data = inputs),
    Parameters = list(param = parameters[1:9], top = topidx, del = delay),
    control = list(dependent = "Q"))

data(huagrahuma2)
HMObject = RHydro("topmodel", Temporal = list(data = inputs),
    Parameters = list(param = parameters[1:9], top = topidx, del = delay))
res2 = predict(HMObject)
HMobjectiveFunction(res2$Q, HMObject@Temporal@data$Q)
