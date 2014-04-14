#generate unit hydrograph according to linear storage cascade
unit.hydrograph.storage.cascade = function(n, k, delta_t)
{
  #determine required length of unit hydrograph to capture at least 99% of response
  h=array(0,100) #initial estimate on length of h
  for (i in 1:100)
  {
    j = 0:99 + (i-1)*100 #compute next 100 ordinates
    h  [j+1] = (j*delta_t)^(n-1)/ (k^n*gamma(n))*exp(-j*delta_t/k)

    cutoff=min(c(Inf,which(h/cumsum(h)<0.001))) #cutoff UH after 99% of volume
#    cutoff=min(c(Inf,which(cumsum(h)>0.99))) #cutoff UH after 99% of volume
    if (!is.finite(cutoff))
      next else
      {
        h=h[1:cutoff]
        h=h/sum(h) #re-normalize
        break
      }
  }
  if (!is.finite(cutoff))
  {
   h=NULL
   stop("Parameters of storage cascade result in too long unit hydrograph. Increase delta_t.")
  }
  return(h)
}

#apply (multiple) unit hydrographs to rainfall series
apply_uhg = function(rainfall, uhg_params, delta_t)
{
  if (length(uhg_params) == 2) uhg_params = matrix(c(uhg_params, a=1), ncol=3, dimnames=list(NULL,c("n","k","a")))
  
  if (length(uhg_params) %% 3 != 0) stop("uhg_params must be an two-element named vector or named three-column matrix")
  
  if (sum(uhg_params[,"a"]) != 1) stop("sum of uhg_params[,'a'] must be 1")
  
  n_uhg = nrow(uhg_params) #number of cascades (UHGs) to treat
  
  hydrograph=NULL
  for (i in 1:n_uhg)
  {
    cur_uhg = unit.hydrograph.storage.cascade(n=uhg_params[i,"n"], k=uhg_params[i,"k"], delta_t = delta_t)
    
    partial_hydrograph = convolve(rainfall, rev(cur_uhg), type = "o") #construct partial hydrograph
    
    if(length(partial_hydrograph) > length(hydrograph)) #prolong hydrograph vector, if necessary
      hydrograph=c(hydrograph, rep(0, length(partial_hydrograph) - length(hydrograph)))
    hydrograph[1:length(partial_hydrograph)] = hydrograph[1:length(partial_hydrograph)] + uhg_params[i,"a"] * partial_hydrograph  #add weighted fraction of this unit hydrograph to total
    
  }
  return(hydrograph)
}
