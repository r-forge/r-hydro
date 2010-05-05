topmodel <- function(parameters,
                     inputs,
                     topidx,
                     delay,
                     performance = c("NS"),
                     ## return.simulations = TRUE,
                     verbose=FALSE) {

  ## check some arguments and convert if necessary
  
  if(missing(performance)) { performance <- NULL
    } else performance <- match.arg(performance, several.ok=TRUE)
  
  parameters <- as(parameters, "HydroTopmodelParameters")

  if(is.null(performance)) { return.simulations = TRUE
    }else return.simulations = FALSE
  
  if(return.simulations && verbose) v <- 6 else v <- 1

  ## check whether inputs can be converted to xts
  ## this means that they are real time series (i.e. with a constant deltat)
  ## then convert them to regular zoo series

  inputs <- try.xts(inputs, error = FALSE)
  inputs <- as.zooreg(inputs)

  deltat <- deltat(inputs) / 60 / 60

  if(!("P" %in% names(inputs) && "ETp" %in% names(inputs))) {
    stop("Inputs should contain members P and ETp") }
  
  ## number of timesteps
  
  ntimesteps <- length(inputs$P)

  ## if performance measures are requested, Q should be part of input

  if(!is.null(performance) && is.null(inputs$Q))
    stop("If performance measures are requested, observed discharge (Q) must present in input")

  if(!is.null(performance)) {
    Q2 <- as(inputs$Q, "numeric")
    if(min(Q2, na.rm=T) < 0)
      stop("Q should not contain negative values")
    Q2[is.na(Q2)] <- -1
    if(length(Q2) != ntimesteps)
      stop("Q should have the same length as P and ET0")
  } else Q2 <- -9999

  ## get time index
  index <- index(inputs)

  ## number of iterations
  iterations <- dim(parameters@parameters)[1]

  ## length of the returned result
  lengthResult <- ifelse(return.simulations, ntimesteps * iterations * v,
                                             iterations)

  ## running the model...
  
  result <- .C("topmodel",
               PACKAGE = "RHydro",
               as.double(t(cbind(as(parameters, "matrix"), deltat))),
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

  returnObject <- new("HydroRun")
  
  ## Format the results as they are returned from the C function
  ## and put them in the right slot of the return object
  
  if(return.simulations) {
    result <- aperm(array(result,c(ntimesteps,iterations,v)),c(1,3,2))
    result <- matrix(result, nrow=ntimesteps)
    ## prepare the column names
    names <- c("Q","qo","qs","S","fex","Ea")
    colnames(result) <- rep(names[1:v],iterations)
    ## make zoo
    #result <- zoo(result, order.by=index)
  }

  ## build the metadata and add them to the return object

  type <- factor(c("flux","flux","flux","state","flux","flux"))
  dims <- factor(c("m/timestep","m/timestep","m/timestep",
                   "m","m/timestep","m/timestep"))
  flux <- c(1,1,1,0,1,1)

  ## 1. metadata input
  
  metadata_i <- data.frame(ID = NA,
                           param.ID = NA,
                           GIS.ID = NA,
                           type = factor(c("flux")),
                           name = names(inputs),
                           flux = NA,
                           origin = factor(c("measured")),
                           dimensions = "m/timestep")
  
  ## 2. metadata simulations

  if(return.simulations) {
    
    param.ID <- 1:iterations
    if(v > 1) param.ID <- as.vector(matrix(rep(param.ID, v), byrow=T, nrow=v))
                                    
    metadata_s <- data.frame(ID = NA,
                             param.ID = param.ID,
                             GIS.ID = NA,
                             type = rep(type[1:v],iterations),
                             name = colnames(result),
                             flux = rep(flux[1:v],iterations),
                             origin = factor(c("simulated")),
                             dimensions = rep(dims[1:v],iterations))
  } else metadata_s <- NULL

  ## 3. combine both
  
  returnObject@metadata = rbind(metadata_i,metadata_s)

  if(return.simulations) {
    returnObject@ts <- zoo(cbind(as.matrix(inputs), result), order.by=index)
  } else returnObject@performanceMeasures <- data.frame(NS = result)
  
  returnObject@call = match.call()
  returnObject@parameters = parameters
  
  return(returnObject)

}
