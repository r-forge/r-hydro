if (!isGeneric("RHydro")) {
	setGeneric("RHydro", function(object, newval, ...)
		standardGeneric("RHydro"))
}

# newval is used for updating the HM object. 
# Updating of Obs or Pred (i.e., adding elements to the slots) is not 
# yet implemented.
setMethod("RHydro", signature = c(object = "HM", newval = "list"),
    function (object, newval, ...) {
      
      if ("Parameters" %in% names(newval)) {
        Parameters = newval$Parameters
        pnames = object@Parameters
        nnames = names(Parameters)
        fnames = match.arg(nnames, pnames)
        object@Parameters[fnames] = Parameters
      }
      if ("calibrationParameters" %in% names(newval)) {
        object@Parameters$parameters = newval$calibrationParameters
      }

      for (islot in slotNames("HM")) {
        if (islot == "Parameters") next
        if (islot %in% names(newval)) {
          HMD = slot(object, islot)
          newdata = newval[[islot]]
          if (inherits(HMD, "HMData") | islot %in% c("Obs", "Pred")) {
            HMD = do.call("HMData", newdata)
            if (is.null(HMD)) HMD = HMData(Spatial = list())
            for (slotName in names(newdata)) {
              slot(HMD, slotName) = newdata[[slotName]]
            }
          } else {
            HMD = newdata
          }
          slot(object, islot) = HMD
        }
      }
      stopifnot(validate(object))
      object
    }
)


# This creates a generic validate function, so that the developers of a hydrologic
# model just have to add the method.
if (!isGeneric("validate")) {
	setGeneric("validate", function(object)
		standardGeneric("validate"))
}


# Alterantive ways of calling RHydro with signature Character (second argument is list in all cases)
# RHydro("topmodel", Parameters = list(), Obs = list(), Pred = list(), ...)
# RHydro("topmodel", newval = list(Parameters = list(), Obs = list(), Pred = list(), ...))
# RHydro("topmodel", Parameters = list(), Temporal = list(), Spatial = list(), ...)

# object is character, i.e. model name
setMethod("RHydro", signature = "character",
  function(object, newval, ...) {

# This function creates an object of class HMmodel, where model is the 
# name of the model to be used. This could of course be messy if the model 
# already exists as a class,
# and with different slots than HM. The alternative is to skip the inheritance
# and extract the model with gsub("HM", "", class(RHydroObject)
# On the other hand it will then be more tricky to dispatch the methods
# in the hydroModel package.    
    if (!missing(newval)) {
      dots = newval
    } else {
      dots = list(...)
    }
    if ("Parameters" %in% names(dots)) {
      Parameters = dots$Parameters
      dots = dots[-which(names(dots) == "Parameters")]
    } else Parameters = list()
    if ("control" %in% names(dots)) {
      control = dots$control
      dots = dots[-which(names(dots) == "control")]
    } else control = list()
    if ("Obs" %in% names(dots)) {
      Obs = do.call("HMData", dots$Obs)
      if ("Pred" %in% names(dots)) {
        Pred = do.call("HMData", dots$Pred)
      } else Pred = NULL
    } else {    # The elements of Obs are given separately
      Obs = do.call("HMData", dots)
      Pred = NULL
    }
    model = object
    cname = paste0("HM",model)    
    if (!isClass(model)) setClass(model, contains = "VIRTUAL", where = .GlobalEnv) 
# Checking if the model has a validate function
    if (existsMethod("validate", model)) {
      setClass(cname, contains = c("HM", model), where = .GlobalEnv, validity = validate) 
    } else {
      print(paste("Could not find a validation function for", model))
      setClass(cname, contains = c("HM", model), where = .GlobalEnv)
    } 
    RHydroObject = new(cname, Obs = Obs, Pred = Pred, Parameters = Parameters, control = control)
  }
)





