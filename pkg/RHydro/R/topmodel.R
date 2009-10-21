topmodel <- function(parameters,
                     inputs,
                     topidx,
                     delay,
                     performance = c("NS"),
                     return.simulations = TRUE,
                     verbose=FALSE) {

  ## check some arguments and convert if necessary

  if(missing(performance)) performance <- NULL else performance <- match.arg(performance, several.ok=TRUE)
  parameters <- as(parameters, "HydroTopmodelParameters")

  if(return.simulations && verbose) v <- 6 else v <- 1

  ## check inputs and convert them to zoo

  inputs <- zoo(inputs)

  if(!("P" %in% names(inputs) && "ETp" %in% names(inputs))) {
    stop("Inputs should contain members P and ETp") }
  
  ## number of timesteps
  
  ntimesteps <- length(inputs$P)

  ## if performance measures are requested, Q should be part of input

  if(!is.null(performance) && is.null(inputs$Q))
    stop("If performance measures are requested, observed discharge (Q) must present in input")

  if(!is.null(inputs$Q)) {
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

  returnObject <- new("HydroRun")
  
  ## Format the results as they are returned from the C function
  ## and put them in the right slot of the return object
  
  if(return.simulations) {
    result <- matrix(results, ncol=v * iterations)
    ## prepare the column names
    names <- c("Q","qo","qs","S","fex","Ea")
    colnames <- rep(names[1:v],iterations)
    ## rearrange
    colnames(result) <- as.vector(t(matrix(colnames,ncol=iterations)))
    ## make zoo
    result <- zoo(result, order.by=index)
    returnObject@ts <- merge(inputs,result)
  } else returnObject@performanceMeasures <- data.frame(NS = results)

  ## build the metadata and add them to the return object


  

  return(returnObject)

}
