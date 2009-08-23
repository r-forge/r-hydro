##setGeneric("NSeff", function(object) { standardGeneric("NSeff") })

NSeff <- function(object,Qsim) {

  ## in the generic function the first arguments should represent
  ## observed discharge and coercible to numeric
  Qobs <- as(object, "numeric")
  Qsim <- as(Qsim, "numeric")

  if(length(Qobs) != length(Qsim))
    stop("Time series should have the same length")
  
  ## remove NA's:  
  Qsim <- Qsim[!is.na(Qobs)]
  Qobs <- Qobs[!is.na(Qobs)]  
  Qobs <- Qobs[!is.na(Qsim)]
  Qsim <- Qsim[!is.na(Qsim)]
  if(length(Qobs) == 0 || length(Qsim) == 0) return(NA)
    
  ## calculate efficiency
  NS <- 1 - ( sum((Qobs - Qsim)^2) / sum((Qobs - mean(Qobs))^2) )
  return(NS)
}

NSeff.HydroModelRun <- function(object) {
  if(!is.null(object@performanceMeasure$NS)) return(object@performanceMeasure$NS)
  ## TODO
  return()
}

setMethod("NSeff", signature(object = "HydroModelRun", Qsim = "missing"), NSeff.HydroModelRun)
