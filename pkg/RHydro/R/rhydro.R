
## construct an rhydro object ready for simulation

rhydro <- function(parameters, data, supportdata = NULL, model,
                   performance = NULL, ...){
  new("RHydro",
      ## todo: make a function that gets the right Hydro*Parameters object here
      parameters=as("HydroModelParameters",parameters)
      data = data,
      supportdata = supportdata,
      model = model,
      performance = performance,
      options = list(...))
}





