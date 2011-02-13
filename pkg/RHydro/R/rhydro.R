
## construct an rhydro object ready for simulation

rhydro <- function(model, parameters, observations, supportdata){
  new("RHydro", observations = observations, supportdata = supportdata,
  model = model)
}





