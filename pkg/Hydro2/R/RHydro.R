
# This creates a generic validate function, so that the developers of a hydrologic
# model just have to add the method.



RHydro = function(object, newval, model, Parameters, ...) {
  dots = list(...)
  if (length(dots) > 1 & !missing(newval)) stop("you cannot provide arguments both through newval and ellipsis argument (...)")  
  if (missing(newval)) newval = dots
  if ("Parameters" %in% names(newval) & !missing(Parameters))stop("you cannot provide arguments both through newval and Parameters")  
  if (!missing(model) && !missing(Parameters)) {
    opar = Parameters
    Parameters = list()
    Parameters[[model]] = opar 
  } 
  if ("Parameters" %in% names(newval)) {
    Parameters = newval$Parameters
    newval = newval[-which(names(newval) == "Parameters")]
    if (!missing(model)) {
      Parameters = list(Parameters)
      names(Parameters) = model
    }
    if (is.list(Parameters)) {
      for (ip in 1:length(Parameters)) {
        lpar = Parameters[[ip]]
        pnames = slotNames("HMPar")
        names(lpar) = match.arg(names(lpar), pnames)
        Parameters[[ip]] = do.call("HMPar", lpar)
      }
    } else stop(paste("Expecting Parameters as list, got", class(Parameters)))
  } else Parameters = list()
  if ("Dots" %in% names(newval)) {
    Dots = newval$Dots
    newval = newval[-which(names(newval) =="Dots")]
  } else Dots = list()
  if ("control" %in% names(newval)) {
    control = newval$control
    newval = newval[-which(names(newval) == "control")]
  } else control = list()
  if ("Obs" %in% names(newval) || "Pred" %in% names(newval)) {
    if ("Obs" %in% names(newval)) Obs = do.call("HMData", newval$Obs) else Obs = NULL
    if ("Pred" %in% names(newval)) {
      Pred = list(do.call("HMData", newval$Pred[[1]]))
      names(Pred)[1] = names(newval$Pred)[1]
    } else Pred = list()
  } else {    # The elements of Obs are given separately, no Pred
    Obs = do.call("HMData", newval)
    Pred = list()
  }
  
  if (missing(object) || is.null(object)) {
    object = HM(Obs = Obs, Pred = Pred, Parameters = Parameters, Dots = Dots, control = control)
  } else {
    if (length(Parameters) > 0) object@Parameters = updateParameters(object@Parameters, Parameters)
    if (!is.null(Obs)) object@Obs = updateHMData(HMobs(object), Obs)
    if (!is.null(Pred)) object@Pred[[names(Pred)]] = updateHMData(HMobs(object), Pred[[1]])
    if (length(control) > 0) object@control = modifyList(object@control, control)   
    if (length(Dots) > 0) object@Dots = modifyList(object@Dots, Dots)   
  }
  if (length(Parameters) > 0) {
    for (ip in 1:length(Parameters)) {
      mod = names(Parameters)[ip]
      valfun = paste0("validate.", mod)
      stopifnot(do.call(valfun, list(object)))
    }
  }
  object  
}


