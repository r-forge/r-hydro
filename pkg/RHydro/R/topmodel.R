topmodel <- function(parameters,
                     inputs,
                     topidx,
                     delay,
                     noS4 = FALSE,
                     output=c("Q","Qb","Qos","Qoi","ETa","Ss","NS"),
                     verbose=FALSE) {

  ## check parameters by converting them to HydroTopmodelParameters

  parameters <- as(parameters, "HydroTopmodelParameters")

  ## check inputs and convert them to HydroFlux

  input <- as(inputs, HydroFlux)

  if(!is(inputs,"list")) stop("Inputs should be a list")
  if(is.null(inputs$P) || is.null(inputs$ETp))
    stop("Inputs should contain members P and ETp")

  for(ts in names(inputs)){
    inputs[[ts]] <- as(inputs[[ts]], "HydroFlux")
    inputs[[ts]]@TSorigin <- "recorded"
  }
 
  ## check what we should return:

  returnOnlyNS <- FALSE
  returnQ  <- FALSE
  v = 1;

  if("NS" %in% output) returnOnlyNS <- TRUE
  if("Q" %in% output)  returnQ  <- TRUE
  if(("Qb" %in% output) || ("Qos" %in% output) || ("Qoi" %in% output) || ("ETa" %in% output) || verbose) v = 6
  if(("NS" %in% output) && !returnQ && !(v == 6)) returnOnlyNS <- TRUE
  
  ## if NS is requested, Q should be part of input

  if(("NS" %in% output) && !(Q %in% input)) stop("If NS is requested, observed discharge (Q) must present in input")

  ## check input length
  
  P <- as.vector(inputs$P)
  ETp  <- as.vector(inputs$ETp)
  if(length(ETp) != length(P))
    stop("Prec and ET0 should have the same length")
  
  if(returnOnlyNS) {
    Q2 <- as.vector(inputs$Q)
    if(any(Q2[!is.na(Q2)]<0))
      stop("Q should not contain negative values")
    Q2[is.na(Q2)] <- -1
    if(length(Q2) != length(P))
      stop("Q should have the same length as P and ET0")
  } else Q2 <- -9999
  
  direction <- zoo(rep(1,length(P)))

  ## get time index
 
  index <- index(inputs$P@magnitude)

  ## number of iterations

  iterations <- dim(parameters@parameters)[1]

  ## length of the returned result

  if(returnNS) { lengthResult <- iterations
               } else { lengthResult <- length(P) * iterations * v }

  ## running the model...

  result <- .C("topmodel",
               PACKAGE = "RHydro",
               as.double(t(as(parameters, "matrix"))),
               as.double(as.matrix(topidx)),
               as.double(as.matrix(delay)),
               as.double(as.numeric(inputs$P)),
               as.double(as.numeric(inputs$ETp)),
               as.double(Q2),
               as.integer(length(as.double(as.matrix(topidx)))/2),
               as.integer(length(P)),
               as.integer(iterations),
               as.integer(length(delay[,1])),
               as.integer(v),
               result = double(lengthResult))$result

  ## building the object to return

  if(noS4) {
    if(v == 6) {
      result <- matrix(result,ncol=6)
      result <- list(
                     Q  = matrix(result[,1], ncol=iterations),
                     qo = matrix(result[,2], ncol=iterations),
                     qs = matrix(result[,3], ncol=iterations),
                     S  = matrix(result[,4], ncol=iterations),
                     fex= matrix(result[,5], ncol=iterations),
                     Ea = matrix(result[,6], ncol=iterations)
                     )
    }
    
    if((Qobs == -9999) && (iterations > 1) && (v == 1)) result <- matrix(result, ncol= iterations)
    return(result)
  }

     
  ## First, construct the list of fluxes and states...

  modelledFluxes <- list(runs = list(), shared = list())
  modelledStates <- list(runs = list(), shared = list())
  measuredFluxes <- list(runs = list(), shared = inputs)
  measuredStates <- list(runs = list(), shared = list())
  
  ## Format the results as they are returned from the C function
  ## and add them to modelledFluxes and modelledStates
  
  if(!returnOnlyNS) {
    
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

      if(verbose || ("Q" %in% output)) {
        modelledFluxes$runs[[i]][["Q"]] = new("HydroFlux",
                                  magnitude = zoo(Q[,i],index),
                                  TSorigin = "generated",
                                  location.name="unknown",
                                  coordinate = SpatialPoints(data.frame(x=0,y=0)),
                                  units = "mm",
                                  direction = direction)
      }

      if(verbose || ("Qb" %in% output)) {
        modelledFluxes$runs[[i]][["Qb"]] = new("HydroFlux",
                                  magnitude = zoo(Qb[,i],index),
                                  TSorigin = "generated",
                                  location.name="unknown",
                                  coordinate = SpatialPoints(data.frame(x=0,y=0)),
                                  units = "mm",
                                  direction = direction)
      }

      if(verbose || ("Qos" %in% output)) {
        modelledFluxes$runs[[i]][["Qos"]] = new("HydroFlux",
                                  magnitude = zoo(Qos[,i],index),
                                  TSorigin = "generated",
                                  location.name="unknown",
                                  coordinate = SpatialPoints(data.frame(x=0,y=0)),
                                  units = "mm",
                                  direction = direction)
      }

     if(verbose || ("Qoi" %in% output)) {
        modelledFluxes$runs[[i]][["Qoi"]] = new("HydroFlux",
                                  magnitude = zoo(Qoi[,i],index),
                                  TSorigin = "generated",
                                  location.name="unknown",
                                  coordinate = SpatialPoints(data.frame(x=0,y=0)),
                                  units = "mm",
                                  direction = direction)
      }

     if(verbose || ("ETa" %in% output)) {
        modelledFluxes$runs[[i]][["Qoi"]] = new("HydroFlux",
                                  magnitude = zoo(ETa[,i],index),
                                  TSorigin = "generated",
                                  location.name="unknown",
                                  coordinate = SpatialPoints(data.frame(x=0,y=0)),
                                  units = "mm",
                                  direction = direction)
      }

      if(verbose || ("Ss" %in% output)) {      
        modelledStates$runs[[i]] <- list(Ss = new("HydroState",
                                           magnitude = zoo(S[,i],index),
                                           TSorigin = "generated",
                                           location.name="unknown",
                                           coordinate = SpatialPoints(data.frame(x=0,y=0)),
                                           units = "mm"))
      }
      
      measuredStates$runs[[i]] <- list()
      measuredFluxes$runs[[i]] <- list()
    }

    performance <- data.frame()
  }
  
  if(returnOnlyNS) {
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

  if(!returnOnlyNS && ("NS" %in% output)) NSeff(result)

  return(result)

}
