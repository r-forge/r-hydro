if (!isGeneric("RHydro")) {
	setGeneric("RHydro", function(object, parameters, ...)
		standardGeneric("RHydro"))
}

# This is when the parameters of a HM object is updated
setMethod("RHydro", signature = c(object = "HM", parameters = "numeric"),
    function (object, parameters) {
      pnames = object@Parameters
      nnames = names(parameters)
      fnames = match.arg(nnames, pnames)
      HMParameters = parameters(object)
      object@Parameters[fnames] = parameters
      model = gsub("HM", "", class(object))
      if (existsMethod("validate", model)) stopifnot(validate(object))
      object = valfunc(object)
    }
)

if (!isGeneric("validate")) {
	setGeneric("validate", function(object)
		standardGeneric("validate"))
}



# object is character, i.e. model name
setMethod("RHydro", signature = "character",
  function(object, Parameters = NULL, ...) {
    model = object
    cname = paste0("HM",model)
# This could of course be messy if the model already exists as a class,
# and with different slots than HM. The alternative is to skip the inheritance
# and extract the model with gsub("HM", "", class(RHydroObject)
    if (!isClass(model)) setClass(model, contains = "VIRTUAL", where = .GlobalEnv) 
# Checking if the model has a validate function
    if (existsMethod("validate", model)) {
      setClass(cname, contains = c("HM", model), where = .GlobalEnv, validity = validate) 
    } else {
      print(paste("Could not find a validation function for", model))
      setClass(cname, contains = c("HM", model), where = .GlobalEnv)
    } 
    RHydroObject = new(cname, Obs = HMData(...), Parameters = Parameters)
  }
)





