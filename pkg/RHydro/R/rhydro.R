
## construct an rhydro object ready for simulation

rhydro <- function(model, parameters, data, ...){
  new("RHydro",
      ## todo: make a function that gets the right Hydro*Parameters object here
      parameters=as(parameters, "HydroModelParameters"),
      data = try.xts(data),
      model = model,
      dots = as.list(substitute(list(...)))[-1])
}









