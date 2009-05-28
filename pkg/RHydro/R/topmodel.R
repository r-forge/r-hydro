topmodel <- function(parameters, inputs, topidx, delay, verbose = F) {
  
  ## check parameters by converting them to HydroTopmodelParameters

  parameters <- as(parameters, "HydroTopmodelParameters")

  ## check inputs

  if(!is(inputs,"list")) stop("Inputs should be a list")
  if(is.null(inputs$prec) || is.null(inputs$PET))
    stop("Inputs should contain members prec and PET")

  ## if Qobs is given we return NS
  
  if(is.null(inputs$Qobs)) {NS <- F} else {NS <- T}

  ## check input length
  
  prec <- as.vector(inputs$prec)
  PET  <- as.vector(inputs$PET)
  if(length(PET) != length(prec))
     stop("Prec and PET should have the same length")
     
  if(NS) {
    Qobs <- as.vector(inputs$Qobs)
    if(any(Qobs[!is.na(Qobs)]<0))
      stop("Qobs should not contain negative values")
    Qobs[is.na(Qobs)] <- -1
    if(length(Qobs) != length(prec))
      stop("Qobs should have the same length as prec and PET")
  } else Qobs <- -9999

  ## get time index

  if(is(inputs$prec,"HydroTS")) {
    index <- index(inputs$prec@magnitude)
  } else if(is(inputs$prec,"zoo")) {
    index <- index(inputs$prec)
  } else index <- index(prec)
  
  ## deal with verbosity:

  if(verbose && !NS) v <- 6 else v = 1

  ## number of iterations

  iterations <- dim(parameters)[1]

  ## length of the returned result

  if(NS) lengthResult <- length(prec)
  else   lengthResult <- length(prec) * iterations * v

  ## running the model...

  result <- .C("topmodel",
               PACKAGE = "RHydro",
               as.double(t(as(parameters, "matrix"))),
               as.double(as.matrix(topidx)),
               as.double(as.matrix(delay)),
               as.double(prec),
               as.double(PET),
               as.double(Qobs),
               as.integer(length(as.double(as.matrix(topidx)))/2),
               as.integer(length(prec)),
               as.integer(iterations),
               as.integer(length(delay[,1])),
               as.integer(v),
               result = double(lengthResult))$result

  ## formatting the results
  
  if(!NS && v == 6) {
    fluxes <- matrix(result,ncol=6)
    fluxes <- list(
                   Q  = zoo(matrix(result[,1], ncol=iterations), index),
                   qo = zoo(matrix(result[,2], ncol=iterations), index),
                   qs = zoo(matrix(result[,3], ncol=iterations), index),
                   fex= zoo(matrix(result[,5], ncol=iterations), index),
                   Ea = zoo(matrix(result[,6], ncol=iterations), index)
                   )
    states <- list(S  = zoo(matrix(result[,4], ncol=iterations), index))
    performance <- NULL
  }
  if(!NS && v == 1) {
    fluxes <- list(Q = zoo(matrix(result, ncol= iterations), index))
    states <- NULL
    performance <- NULL
  }
  if(NS) {
    fluxes <- NULL
    states <- NULL
    performance <- data.frame(NS = result)
  }

  result <- new("HydroModelRun",
                parameters          = parameters,
                modelledFluxes      = fluxes,
                modelledStates      = states,
                measuredFluxes      = inputs,
                performanceMeasures = performance,
                modelSupportData    = list(topidx, delay),
                call                = "topmodel")
  
  return(result)

}
