# This function calculates 10 performance and streamflow indices
# inputs:
# Po = observed precipitation [mm/timestep]
# Qo = observed streamflow    [mm/timestep]
# Qs = simulated streamflow   [mm/timestep]
# Qb = simulated base flow    [mm/timestep]
perfindices <- function(Po,Qo,Qs,Qb){
  
  t <- fdc(Qs,lQ.thr=0.66,hQ.thr=0.33)
  theRes <- ccf(Qo,Qs, plot=FALSE)

  lagtime <- theRes$lag[min(which(theRes$acf==max(theRes$acf)))] # lagtime (from tiger) - it should tend to zero
  meanerr <- mean(Qs - Qo, na.rm = TRUE)                         # mean error - it should tend to zero
  meanaoe <- MAOE(Qo,Qs)                                         # mean absolute ordinal error (from qualV) - it should tend to zero
  nsef_hf <- 1-EF(Qo,Qs)                                         # Complement to 1 of Nash-Sutcliffe efficiency for high flows - it should tend to zero (from qualV)
  nsef_lf <- 1-EF(log(Qo),log(Qs))                               # Complement to 1 of Nash-Sutcliffe efficiency for low flows - it should tend to zero  (from qualV)
  #prmse  <- RMSE(Qo,Qs)                                          # Root mean square error (from qualV) - it should tend to zero
  rrcoeff <- sum(Qs)/sum(Po)                                     # Rainfall-Runoff coefficient                                            
  bfindex <- sum(Qb)/sum(Qs)                                     # Baseflow Index
  slopfdc <- fdc_slope(Qs, 0.33, 0.66)                               # Slope of flow duration curve
  stelast <- sel(Po,Qs)                                          # Streamflow Elasticity
  diffhpc <- hpc(Qo)-hpc(Qs)                                      # Difference of High Pulse Count (observed - simulated) - it should tend to zero
  
  return( list("lagtime"=lagtime,
               "meanerr"=meanerr,
               "meanaoe"=meanaoe,
               "nsef_hf"=nsef_hf,
               "nsef_lf"=nsef_lf,
               "rrcoeff"=rrcoeff,
               "bfindex"=bfindex,
               "slopfdc"=slopfdc,
               "stelast"=stelast,
               "diffhpc"=diffhpc) )
}
