topmodel <- function(parameters,
                     inputs,
                     data,
                     performance = c("NS"),
                     return.simulations = TRUE,
                     verbose = FALSE) {

  ## sort out the requested peformance measures
  perf.NS <- 0
  if(missing(performance)) {
    performance <- NULL
  } else {
    performance <- match.arg(performance, several.ok=TRUE)
    if("NS" %in% performance) perf.NS <- 1
  }
    
  parameters <- as(parameters, "HydroTopmodelParameters")
 
  v <- 0
  if(return.simulations) v <- 1
  if(return.simulations && verbose) v <- 6

  ## check whether inputs can be converted to xts
  ## this means that they are real time series (i.e. with a constant deltat)
  ## then convert them to regular zoo series

  inputs <- try.xts(inputs, error = FALSE)
  inputs <- as.zooreg(inputs)
  index <- index(inputs)

  deltat <- deltat(inputs) / 60 / 60

  if(!("P" %in% names(inputs) && "ETp" %in% names(inputs))) {
    stop("Inputs should contain members P and ETp") }
  
  ## number of timesteps
  ntimesteps <- length(inputs$P)

  ## if performance measures are requested, Q should be part of input
  if(!is.null(performance) && is.null(inputs$Q))
    stop("If performance measures are requested, observed discharge (Q) must present in input")

  ## format Q
  if(!is.null(performance)) {
    Q2 <- as(inputs$Q, "numeric")
    if(min(Q2, na.rm=T) < 0)
      stop("Q should not contain negative values")
    Q2[is.na(Q2)] <- -1
    if(length(Q2) != ntimesteps) # probably redundant
      stop("Q should have the same length as P and ET0")
  } else Q2 <- -9999

  ## number of iterations
  iterations <- dim(parameters@parameters)[1]

  ## run the model
  result <- .C("topmodel",
               PACKAGE = "RHydro",
               as.double(t(cbind(as(parameters, "matrix"), deltat))),
               as.double(as.matrix(data$topidx)),
               as.double(as.matrix(data$delay)),
               as.double(as(inputs$P, "numeric")),
               as.double(as(inputs$ETp, "numeric")),
               as.double(Q2),
               as.integer(length(as.double(as.matrix(data$topidx)))/2),
               as.integer(ntimesteps),
               as.integer(iterations),
               as.integer(length(data$delay[,1])),
               as.integer(c(v, perf.NS)), # what to return?
               perf.NS = double(perf.NS * iterations),
               result = double(v * ntimesteps * iterations))

  ## Format the results
  reval <- NULL

  if(return.simulations) {
    retval <- aperm(array(result$result,c(ntimesteps,iterations,v)),c(1,3,2))
    retval <- matrix(retval, nrow=ntimesteps)
    ## prepare the column names
    colnames(retval) <- rep(c("Q","Qo","Qs","Qi", "Qie","ETa")[1:v],iterations)
    retval <- zoo(retval, order.by=index)
    if(perf.NS) retval <- list(simulations = retval, NS = result$perf.NS)
  } else if(perf.NS) retval <- result$perf.NS
  
  return(retval)
}
