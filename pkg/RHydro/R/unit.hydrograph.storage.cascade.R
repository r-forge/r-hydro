#generate unit hydrograph according to linear storage cascade
unit.hydrograph.storage.cascade = function(n,k,delta_t)
{
  #determine required length of unit hydrograph to capture at least 99% of response
  h=array(0,100)
  for (i in 1:100)
  {
    j = 1:100 + (i-1)*100
    h[1:100 + (i-1)*100] = ((j-0.5)*delta_t)^(n-1)/ (k^n*gamma(n))*exp(-(j-0.5)*delta_t/k)

    cutoff=min(c(Inf,which(h/cumsum(h)<0.01))) #cutoff UH after 99% of volume
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
   #stop("Parameters of storage cascade result in too long unit hydrograph.")
  }
  return(h)
}

