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


setMethod('calibrate', signature(object = "HM"),
    function(object, method = "sce", objectiveFunction = NULL, ...){
# Here we have to choose between using calibData and formula
# Trying first with formula
  if (is.function(objectiveFunction)) {
    objfunc = objectiveFunction
  } else if (is.null(objectiveFunction) | is.character(objectiveFunction)) {
    model = gsub("HM", "", class(object))
    if (existsMethod("objectiveFunction", model)) {
      objfunc = getMethod("objectiveFunction", model)
    } else {
      objfunc = try(get(paste0("objective.", model)), silent = TRUE)
      if (is(objfunc, "try-error")) {
        objfunc = function(object, parameters, gof = nashsut) {
          object = try(RHydro(object, parameters))
          object = try(predict(object))
          if (is(object, "try-error")) return(1e9)
          prediction = predictions(object)
          observations = observations(object)
          temporal = temporalData(observations)
          dependent = control(result)$dependent
          return(1-gof(temporalData(prediction)[[1]], temporal[,dependent]))
        }
      }
    }
  }
  if (method == "sce") sceua(objfunc, object, ...)
}
)






