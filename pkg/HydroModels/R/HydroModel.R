
## construct a HydroModel object ready for simulation

HydroModel <- function(model, parameters, data, ...){
  new("HydroModel",
      ## todo: make a function that gets the right Hydro*Parameters object here
      parameters=as(parameters, "HydroModelParameters"),
      data = try.xts(data),
      model = model,
      dots = as.list(substitute(list(...)))[-1])
}









