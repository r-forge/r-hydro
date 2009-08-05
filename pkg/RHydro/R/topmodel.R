topmodel <- function(parameters, inputs, topidx, delay, verbose = FALSE) {
  
  ## check parameters by converting them to HydroTopmodelParameters

  parameters <- as(parameters, "HydroTopmodelParameters")

  ## check inputs

  if(!is(inputs,"list")) stop("Inputs should be a list")
  if(is.null(inputs$P) || is.null(inputs$ETp))
    stop("Inputs should contain members P and ETp")

  ## if Q is given we return NS
  
  if(is.null(inputs$Q)) {NS <- FALSE} else {NS <- TRUE}

  ## check input length
  
  P <- as.vector(inputs$P)
  ETp  <- as.vector(inputs$ETp)
  if(length(ETp) != length(P))
    stop("Prec and ET0 should have the same length")
  
  if(NS) {
    Q <- as.vector(inputs$Q)
    if(any(Q[!is.na(Q)]<0))
      stop("Q should not contain negative values")
    Q[is.na(Q)] <- -1
    if(length(Q) != length(P))
      stop("Q should have the same length as P and ET0")
  } else Q <- -9999
  
  direction <- zoo(rep(1,length(P)))

  ## get time index

  if(is(inputs$P,"HydroTS")) {
    index <- index(inputs$P@magnitude)
  } else if(is(inputs$P,"zoo")) {
    index <- index(inputs$P)
  } else index <- index(P)
  
  ## deal with verbosity:

  if(verbose && !NS) v <- 6 else v = 1

  ## number of iterations

  iterations <- dim(parameters@parameters)[1]

  ## length of the returned result

  if(NS) { lengthResult <- iterations
         } else { lengthResult <- length(P) * iterations * v }

  ## running the model...

  result <- .C("topmodel",
               PACKAGE = "RHydro",
               as.double(t(as(parameters, "matrix"))),
               as.double(as.matrix(topidx)),
               as.double(as.matrix(delay)),
               as.double(P),
               as.double(ETp),
               as.double(Q),
               as.integer(length(as.double(as.matrix(topidx)))/2),
               as.integer(length(P)),
               as.integer(iterations),
               as.integer(length(delay[,1])),
               as.integer(v),
               result = double(lengthResult))$result

  ## building the object to return

  ## First, construct the list of fluxes and states...

  modelledFluxes <- list(runs = list(), shared = list())
  modelledStates <- list(runs = list(), shared = list())
  
  ## convert inputs to HydroFlux

  for(ts in names(inputs)){
    inputs[[ts]] <- as(inputs[[ts]], "HydroFlux")
    inputs[[ts]]@TSorigin <- "recorded"
  }

  measuredFluxes <- list(runs = list(), shared = inputs)
  measuredStates <- list(runs = list(), shared = list())
  
  ## Format the results as they are returned from the C function
  ## and add them to modelledFluxes and modelledStates
  
  if(!NS && v == 6) {
    
    result <- matrix(result,ncol=6)
    
    Q   = as.data.frame(matrix(result[,1], ncol=iterations))
    Qos = as.data.frame(matrix(result[,2], ncol=iterations))
    Qb  = as.data.frame(matrix(result[,3], ncol=iterations))
    S   = as.data.frame(matrix(result[,4], ncol=iterations))
    Qoi = as.data.frame(matrix(result[,5], ncol=iterations))
    ETa = as.data.frame(matrix(result[,6], ncol=iterations))

    for(i in 1:iterations){
      modelledFluxes$runs[[i]] <- list(Q = new("HydroFlux",
                                         magnitude = zoo(Q[,i],index),
                                         TSorigin = "generated",
                                         location.name="unknown",
                                         coordinate = SpatialPoints(data.frame(x=0,y=0)),
                                         direction = direction),
                                       Qb = new("HydroFlux",
                                         magnitude = zoo(Qb[,i],index),
                                         TSorigin = "generated",
                                         location.name="unknown",
                                         coordinate = SpatialPoints(data.frame(x=0,y=0)),
                                         direction = direction),
                                       Qos = new("HydroFlux",
                                         magnitude = zoo(Qos[,i],index),
                                         TSorigin = "generated",
                                         location.name="unknown",
                                         coordinate = SpatialPoints(data.frame(x=0,y=0)),
                                         direction = direction),
                                       Qoi = new("HydroFlux",
                                         magnitude = zoo(Qoi[,i],index),
                                         TSorigin = "generated",
                                         location.name="unknown",
                                         coordinate = SpatialPoints(data.frame(x=0,y=0)),
                                         direction = direction),
                                       ETa = new("HydroFlux",
                                         magnitude = zoo(ETa[,i],index),
                                         TSorigin = "generated",
                                         location.name="unknown",
                                         coordinate = SpatialPoints(data.frame(x=0,y=0)),
                                         direction = direction))
      modelledStates$runs[[i]] <- list(S = zoo(S[,i],index))
      measuredStates$runs[[i]] <- list()
      measuredFluxes$runs[[i]] <- list()
    }

    performance <- data.frame()
  }

  
  if(!NS && v == 1) {

    Q <- as.data.frame(matrix(result, ncol=iterations), index)
      
    for(i in 1:iterations){
      modelledFluxes$runs[[i]] <- list(Q = new("HydroFlux",
                                         magnitude = zoo(Q[,i],index),
                                         TSorigin = "generated",
                                         location.name="unknown",
                                         coordinate = SpatialPoints(data.frame(x=0,y=0)),
                                         direction = direction))
      modelledStates$runs[[i]] <- list()
      measuredStates$runs[[i]] <- list()
      measuredFluxes$runs[[i]] <- list()      
    }
    performance <- data.frame()
  }
  
  if(NS) {
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
                parameters          = as(parameters, "HydroTopmodelParameters"),
                modelledFluxes      = modelledFluxes,
                modelledStates      = modelledStates,
                measuredFluxes      = measuredFluxes,
                measuredStates      = measuredStates,
                performanceMeasures = performance,
                modelSupportData    = list(topidx = topidx, delay = delay),
                call                = "topmodel")
  
  return(result)

}
