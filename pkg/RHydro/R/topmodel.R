topmodel <- function(parameters,
                     inputs,
                     topidx,
                     delay,
                     noS4 = FALSE,
                     performance = c("NS"),
                     return.simulations = TRUE,
                     verbose=FALSE) {

  ## check some arguments and convert if necessary

  if(missing(performance)) performance <- NULL else performance <- match.arg(performance, several.ok=TRUE)
  parameters <- as(parameters, "HydroTopmodelParameters")

  if(return.simulations && verbose) v <- 6 else v <- 1

  ## check inputs and convert them to HydroFlux

  if(!is(inputs,"list")) stop("Inputs should be a list")
  if(is.null(inputs$P) || is.null(inputs$ETp))
    stop("Inputs should contain members P and ETp")

  for(ts in names(inputs)){
    inputs[[ts]] <- as(inputs[[ts]], "HydroFlux")
    inputs[[ts]]@TSorigin <- "recorded"
  }
  
  ## if performance measures are requested, Q should be part of input

  if(!is.null(performance) && is.null(inputs$Q))
    stop("If performance measures are requested, observed discharge (Q) must present in input")

  ## check input length

  ntimesteps <- length(inputs$P)

  if(length(inputs$ETp) != ntimesteps)
    stop("Prec and ET0 should have the same length")
  
  if(!return.simulations) {
    Q2 <- as(inputs$Q, "numeric")
    if(any(Q2[!is.na(Q2)]<0))
      stop("Q should not contain negative values")
    Q2[is.na(Q2)] <- -1
    if(length(Q2) != ntimesteps)
      stop("Q should have the same length as P and ET0")
  } else Q2 <- -9999
  
  direction <- zoo(rep(1,ntimesteps))

  ## get time index
  index <- index(inputs$P@magnitude)

  ## number of iterations
  iterations <- dim(parameters@parameters)[1]

  ## length of the returned result
  lengthResult <- ifelse(return.simulations, ntimesteps * iterations * v, iterations)

  ## running the model...
  
  result <- .C("topmodel",
               PACKAGE = "RHydro",
               as.double(t(as(parameters, "matrix"))),
               as.double(as.matrix(topidx)),
               as.double(as.matrix(delay)),
               as.double(as(inputs$P, "numeric")),
               as.double(as(inputs$ETp, "numeric")),
               as.double(Q2),
               as.integer(length(as.double(as.matrix(topidx)))/2),
               as.integer(ntimesteps),
               as.integer(iterations),
               as.integer(length(delay[,1])),
               as.integer(v),
               result = double(lengthResult))$result

  ## building the object to return

  if(noS4) {
    if(v == 6) {
      result <- matrix(result,ncol=6)
      result <- list(Q  = matrix(result[,1], ncol=iterations),
                     qo = matrix(result[,2], ncol=iterations),
                     qs = matrix(result[,3], ncol=iterations),
                     S  = matrix(result[,4], ncol=iterations),
                     fex= matrix(result[,5], ncol=iterations),
                     Ea = matrix(result[,6], ncol=iterations)
                     )
    } else if(return.simulations && (iterations > 1)) result <- matrix(result, ncol= iterations)
    return(result)
  }

     
  ## First, construct the list of fluxes and states...

  modelledFluxes <- list(runs = list(), shared = list())
  modelledStates <- list(runs = list(), shared = list())
  measuredFluxes <- list(runs = list(), shared = inputs)
  measuredStates <- list(runs = list(), shared = list())
  
  ## Format the results as they are returned from the C function
  ## and add them to modelledFluxes and modelledStates
  
  if(return.simulations) {
    
    result <- matrix(result, ncol=v)
    
    Q   = as.data.frame(matrix(result[,1], ncol=iterations))
    if(v == 6) {
      Qos = as.data.frame(matrix(result[,2], ncol=iterations))
      Qb  = as.data.frame(matrix(result[,3], ncol=iterations))
      S   = as.data.frame(matrix(result[,4], ncol=iterations))
      Qoi = as.data.frame(matrix(result[,5], ncol=iterations))
      ETa = as.data.frame(matrix(result[,6], ncol=iterations))
    }

    for(i in 1:iterations) {
      
      modelledFluxes$runs[[i]] <- list()

      modelledFluxes$runs[[i]][["Q"]] = new("HydroFlux",
                                magnitude = zoo(Q[,i],index),
                                TSorigin = "generated",
                                location.name="unknown",
                                coordinate = SpatialPoints(data.frame(x=0,y=0)),
                                units = "mm",
                                direction = direction)

      if(verbose) {
        modelledFluxes$runs[[i]][["Qb"]] = new("HydroFlux",
                                  magnitude = zoo(Qb[,i],index),
                                  TSorigin = "generated",
                                  location.name="unknown",
                                  coordinate = SpatialPoints(data.frame(x=0,y=0)),
                                  units = "mm",
                                  direction = direction)

        modelledFluxes$runs[[i]][["Qos"]] = new("HydroFlux",
                                  magnitude = zoo(Qos[,i],index),
                                  TSorigin = "generated",
                                  location.name="unknown",
                                  coordinate = SpatialPoints(data.frame(x=0,y=0)),
                                  units = "mm",
                                  direction = direction)

        modelledFluxes$runs[[i]][["Qoi"]] = new("HydroFlux",
                                  magnitude = zoo(Qoi[,i],index),
                                  TSorigin = "generated",
                                  location.name="unknown",
                                  coordinate = SpatialPoints(data.frame(x=0,y=0)),
                                  units = "mm",
                                  direction = direction)

        modelledFluxes$runs[[i]][["ETa"]] = new("HydroFlux",
                                  magnitude = zoo(ETa[,i],index),
                                  TSorigin = "generated",
                                  location.name="unknown",
                                  coordinate = SpatialPoints(data.frame(x=0,y=0)),
                                  units = "mm",
                                  direction = direction)
    
        modelledStates$runs[[i]][["Ss"]] = new("HydroState",
                                  magnitude = zoo(S[,i],index),
                                  TSorigin = "generated",
                                  location.name="unknown",
                                  coordinate = SpatialPoints(data.frame(x=0,y=0)),
                                  units = "mm")
      } else modelledStates$runs[[i]] <- list()
      
      measuredStates$runs[[i]] <- list()
      measuredFluxes$runs[[i]] <- list()
    }

    performance <- data.frame()
    
  } else {                                  # no return of simulations
    performance <- data.frame(NS = result)
    for(i in 1:iterations){
      modelledFluxes$runs[[i]] <- list()
      modelledStates$runs[[i]] <- list()
      measuredStates$runs[[i]] <- list()
      measuredFluxes$runs[[i]] <- list()
    }
  }

  modelledFluxes <- listSymbols2Types(modelledFluxes)
  modelledStates <- listSymbols2Types(modelledStates)
  measuredFluxes <- listSymbols2Types(measuredFluxes)
  measuredStates <- listSymbols2Types(measuredStates)

  result <- new("HydroModelRun",
                parameters          = parameters,
                modelledFluxes      = modelledFluxes,
                modelledStates      = modelledStates,
                measuredFluxes      = measuredFluxes,
                measuredStates      = measuredStates,
                performanceMeasures = performance,
                modelSupportData    = list(topidx = topidx, delay = delay),
                call                = match.call())

  if(return.simulations && !is.null(performance)) {}

  return(result)

}
