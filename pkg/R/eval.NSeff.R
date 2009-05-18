NSeff <- function(Qobs,Qsim) {

  ## Qobs should be class that can be coerced to numeric (e.g., HydroTS)

  Qobs <- as(Qobs, "numeric")
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
