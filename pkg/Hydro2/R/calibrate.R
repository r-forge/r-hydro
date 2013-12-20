if (!isGeneric("calibrate")) {
	setGeneric("calibrate", function(object, ...)
		standardGeneric("calibrate"))
}

if (!isGeneric("objectiveFunction")) {
	setGeneric("objectiveFunction", function(object,  ...)
		standardGeneric("objectiveFunction"))}


nashsut = function(sim, obs) {
  1-sum((sim-obs)^2, na.rm = TRUE)/sum((obs-mean(obs))^2, na.rm = TRUE)
}

# Default objective function, can use either NSE -efficiency,
# one of the criteria from gof (hydroGOF), or a function
HMObjectiveFunction = function(parameters, object, gof = "NSE") {
  object = try(RHydro(object, newval = list(calibrationParameters = parameters)))
  object = try(predict(object))
  if (is(object, "try-error")) return(1e9)
  predictions = HMpredictions(object)
  observations = HMobservations(object)
  temporal = HMtemporalData(observations)

# This covers the cases where
# Temporal has only one element with a dependent name in it
# Temporal has several elements, and the dependent column can be found as
# Temporal$dependent$dependent
  if (length(temporal) == 1) {
    temporal = temporal[[1]]
  } else if (length(temporal) > 1) {
    temporal = temporal[[dependent]]
  }
  dependent = HMcontrol(object)$dependent
# This is the standard method, using nashsut above
  if (is.character(gof) && gof == "NSE") gof = nashsut
# This is if the user/developer submits a gof-function, or using nashsut from above
  if (is.function(gof)) {
    return(1-gof(HMtemporalData(predictions)[[1]], temporal[,dependent]))
# And this is if the user/developer submits a character, describing which 
# gof-measure from the hydroGOF:::gof function to use
  } else if (is.character(gof)) {
    if (!require(hydroGOF)) 
      stop("cannot use criteria from hydroGOF:::gof, package is not installed")
    return(1-gof(temporalData(prediction)[[1]], temporal[,dependent])[gof])      
  } 
}

#HMObjectiveFunction(HMObject, parameters[1:9])


setMethod('calibrate', signature(object = "HM"),
    function(object, method = "sce", objectiveFunction = NULL, ...){
# Here we have to choose between using calibData and formula
# Trying first with formula
  objfunc = NULL
  if (is.function(objectiveFunction)) {
    objfunc = objectiveFunction
  } else if (!is.null(objectiveFunction) && isGeneric(objectiveFunction)) {
    model = gsub("HM", "", class(object))
    if (existsMethod("objectiveFunction", model)) {
      objfunc = getMethod("objectiveFunction", model)
    } 
  } else if (is.character(objectiveFunction)) {
    model = gsub("HM", "", class(object))
    objfunc = try(get(paste0("objective.", model)), silent = TRUE)
    if (is(objfunc, "try-error")) {
      objfunc = try(getFunction(objectiveFunction))
      if (is(objfunc, "try-error")) objfunc = NULL
    }
  }
  if (is.null(objfunc)) objfunc = HMObjectiveFunction
  if (method == "sce") {
    best = sceua(objfunc, HMparameters(object)$parameters, 
                 HMparameters(object)$parlower,
                 HMparameters(object)$parupper, object = object, ...)
     
  }
  object = RHydro(object, newval = list(calibrationParameters = best$par, 
                                        performance = best$value))
  predict(object)
}
)






