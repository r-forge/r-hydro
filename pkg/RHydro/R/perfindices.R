# This function calculates the lower and upper threshold of the flow duration curve
# code obtained modifying fdc.R from hydroTSM package
fdc <-function(x, ...) UseMethod("fdc")

fdc.default <- function (x,
                         lQ.thr=0.66,
                         hQ.thr=0.33,
                         log="y") {
  
  # Returns the position in the vector 'x' where the scalar 'Q' is located
  Qposition <- function(x, Q) {
    Q.dist  <- abs(x - Q)
    Q.index <- which.min( Q.dist )
    return(Q.index)
  } # end
  
  if (log == "y") {
    x.zero.index <- which(x==0)
    if (length(x.zero.index) > 0 ) {
      x <- x[-x.zero.index]
    } # IF end
  } # IF end
  
  x <- as.numeric(x)
  
  # Storing the original values
  x.old <- x
  
  # 1) Sort 'x' in drecreasing order. This is just for avoiding misleading
  #lines when using 'type="o"' for plotting
  x <- sort(x)
  
  # Index with the position of the original values
  ind <- match(x.old, x)
  
  # 2) Compute the length of 'x'
  n <- length(x)
  
  # 3) Creation of the output vector
  dc <- rep(NA, n)
  
  # 4) Exceedence Probability
  dc[1:n] <- sapply(1:n, function(j,y) {
    dc[j] <- length( which(y >= y[j]) )
  }, y = x)
  
  # Computing the probabilitites
  dc <- dc/n
  
  # Finding the flow values corresponding to the 'lQ.thr' and 'hQ.thr' pbb of excedence
  x.lQ <- x[Qposition(dc, lQ.thr)]
  x.hQ <- x[Qposition(dc, hQ.thr)]
  
  # Restoring the original positions
  dc <- dc[ind]
  
  qthresholds <- list("l"=x.lQ,"h"=x.hQ)
  
  return(qthresholds)
  
}

# this function calculates the Streamflow Elasticity
sel <- function(P,Q){
    
  l <- length(P)
  
  el <- rep(NA,l-1)
  
  for (i in 2:l) {
    dQ <- Q[i]-Q[i-1]
    dP <- P[i]-P[i-1]
    
    if (is.finite(dQ*Q[i]/dP/P[i])) el[i-1] <- dQ*Q[i]/dP/P[i]
  } 
  
  el1 <- el[which(el!="NA")] 
  results <- median(el1)
  
  return(results)
}

# This function calculates the High Pulse Count
diffhpc <- function(Qo,Qs){
  
  m <- 3*median(Qo)
  l <- length(Qo)
  
  count_o <- count_s <- 0
  
  for (i in 1:l) {
    if (Qo[i] > m) count_o <- count_o + 1
    if (is.na(Qs[i])==FALSE && Qs[i]>m) count_s <- count_s + 1
  }
  
  result <- count_o - count_s
  return(result)
}


# This function calculates 10 performance indices
# inputs:
# Po = observed precipitation [mm/timestep]
# Qo = observed streamflow    [mm/timestep]
# Qs = simulated streamflow   [mm/timestep]
# Qb = simulated base flow    [mm/timestep]
perfindices <- function(Po,Qo,Qs,Qb){
  
  t <- fdc(Qs,lQ.thr=0.66,hQ.thr=0.33)
  
  theRes <- ccf(Qo,Qs, plot=FALSE)
  plt    <- theRes$lag[min(which(theRes$acf==max(theRes$acf)))]      # lagtime (from tiger)
  pme    <- mean(Qs - Qo, na.rm = TRUE)                              # mean error
  pmaoe  <- MAOE(Qo,Qs)                                              # mean absolute ordinal error (from qualV)
  pns    <- 1-EF(Qo,Qs)                                              # Complement to 1 of Nash-Sutcliffe efficiency (from qualV)
  prmse  <- RMSE(Qo,Qs)                                              # Root mean square error (from qualV)
  
  prr     <- sum(Qs)/sum(Po)                                         # Rainfall-Runoff coefficient                                            
  pbfi    <- sum(Qb)/sum(Qs)                                         # Baseflow Index
  psfdc   <- (log(t$h)-log(t$l))/(0.66 - 0.33)                       # Slope of flow duration curve
  pse     <- sel(Po,Qs)                                              # Streamflow Elasticity
  phpc    <- diffhpc(Qo,Qs)                                          # Difference of High Pulse Count (observed - simulated)
  
  p <- list("plt"=plt,"pme"=pme,"pmaoe"=pmaoe,"pns"=pns,"prmse"=prmse,"prr"=prr,"pbfi"=pbfi,"psfdc"=psfdc,"pse"=pse,"phpc"=phpc)
  
  return(p)
}
