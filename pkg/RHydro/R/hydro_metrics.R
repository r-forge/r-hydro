#hydrological metrics

runoff_coeff = function (rainfall, runoff) 
#compute runoff coefficient [-]
{
  
  #rainfall: rainfall in [L]/timestep  
  #runoff  : runoff   in [L]/timestep  
  
  common_length=min(length(rainfall), length(runoff))  
  
  return(sum(runoff[1:common_length])/sum(rainfall[1:common_length]))
}

time_of_conc = function (rainfall, runoff)
  #compute time of concentration [number of timesteps]
{
  #rainfall: rainfall in [L]/timestep  
  #runoff  : runoff   in [L]/timestep  
  
  common_length=min(length(rainfall), length(runoff))  
  
  #compute central moments (centre of gravity) for time series
  cg_rain   =  (1:common_length) %*% rainfall[1:common_length] / sum(rainfall[1:common_length])
  cg_runoff =  (1:common_length) %*% runoff  [1:common_length] / sum(runoff  [1:common_length])
  
  return(as.numeric(cg_runoff-cg_rain))
}


c_smooth = function (rainfall, runoff)
  #compute smoothing effect of catchment [-]
{
  #rainfall: rainfall in [L]/timestep  
  #runoff  : runoff   in [L]/timestep  
  
  common_length=min(length(rainfall), length(runoff))  
  
  #compute coefficients of variation for time series
  cv_rain   =  sd(rainfall[1:common_length]) / mean(rainfall[1:common_length])
  cv_runoff =  sd(runoff  [1:common_length]) / mean(runoff  [1:common_length])
  
  return(cv_runoff/cv_rain)
}



#calculate the lower and upper threshold of the flow duration curve
fdc <- function (x,
                 lQ.thr=0.66,
                 hQ.thr=0.33) {
  quants=quantile(x, probs=c(hQ.thr,lQ.thr)) #get percentiles of runoff
  return(list("l"=quants[1],"h"=quants[2]))
}

#slope of flow duration curve for given quantiles
fdc_slope <- function (runoff, lQ.thr=0.66, hQ.thr=0.33) {
  t= fdc(x=runoff, lQ.thr=lQ.thr, hQ.thr=hQ.thr)
  return(as.numeric((log(t$h)-log(t$l))/(lQ.thr-hQ.thr))) #as.numeric to strip the name-attribute
}



# calculate the Streamflow Elasticity
sel <- function(rainfall, runoff, agg_dt=1){
  
  common_length=min(length(rainfall), length(runoff))  
  Q=runoff  [1:common_length]  
  P=rainfall[1:common_length]
  
  
  if (agg_dt!=1) #do temporal aggragation
  {
    aggr_index=rep(1:(common_length %/% agg_dt +1), each=agg_dt)[1:common_length]
    Q=aggregate(x=Q, by=list(aggr_index), FUN=sum)$x
    P=aggregate(x=P, by=list(aggr_index), FUN=sum)$x
  } 
  
  #dQ=diff(Q)
  #dP=diff(P)
  # el = (dQ/mean(Q))  /  (dP/mean(P)) #Sankarasubramaniamet al.(2001), Sawicz et al, 2011: misleading
  el2 = (Q-mean(Q))/mean(Q)  / ( (P-mean(P))/mean(P)) #Chiew (2006), Fu et al. 2007: makes more sense 
  
  return(median(el2[is.finite(el2)]))
}

bfi = function(runoff, ...)
{
  return(sum(baseflow_sep(runoff,...))/sum(runoff))  #return baseflow index or...
}

baseflow_sep=function(runoff, method="DFM", parms=c(c=0.925, window_size=10, f_lowess=0.1))
#baseflow separation using various methods, base_flow index
{

  lr=length(runoff)
  if (method=="DFM") #baseflow separation; single-pass digital filter method 
  {
    cc=parms["c"]
    qd=array(runoff[1], lr) #direct runoff
    diff_runoff = diff(runoff)
     #fast implementation
      qd = c(runoff[1], filter(x = (1+cc)/2*diff_runoff, filter = cc, method = "recursive", init=runoff[1]))
    if (any(qd<0)) #any negative values? Do original implementation (slower)
      for(i in 2:lr)
  #      qd[i]=max(0, cc*qd[i-1]+(1+cc)/2*(runoff[i]-runoff[i-1]), na.rm=TRUE)
        qd[i] =max(0, cc*qd[i-1]+(1+cc)/2*diff_runoff[i-1], na.rm=TRUE)
     qb=runoff-qd
  }    

  if (method=="constant_slope") #baseflow separation; constant slope (Dingman 2002, p. 375) 
  {
    min_points=which(diff(sign(diff(runoff)))>0)+1 #find minimum points in time series
    #points(min_points, runoff[min_points])
    slope=parms["c_slope"]
    if (is.na(slope))
      slope=diff(range(runoff))/lr/2
    qb=runoff
    while(length(min_points)>0)
    {
      i=min_points[1]
      qb[i:lr]=runoff[i]+(0:(lr-i))*slope  #draw constant slope line
      tt=which(runoff < qb) #search for intersection with hydrograph
      if (any(tt))
      {
        intersect_i=min(tt)      #search for intersection with hydrograph
        qb[intersect_i:lr]=runoff[intersect_i:lr]
        min_points=min_points[min_points>=intersect_i]
      } else break
    }
    #lines(qb, col="blue")
  }    
  
  if (method=="RLSWM") #baseflow separation; rescaled lowess-smoothed window minima 
  {
    qb=array(0, lr)     #create array for base flow data
  
    window_size=parms["window_size"]  #time window to be used to derive baseflow
    f_lowess=parms["f_lowess"]
    
    for (i in 1:length(runoff))
    {
      recent_q=runoff[max(1,i-window_size):i]  #determine minimum in window
      qb[i]=min(recent_q)  
    }
    base_flow=lowess(qb,f=f_lowess)$y  #smooth minima
    
    ratio=qb/runoff 
    if (max(ratio)>1)
      qb=qb/max(ratio)   #rescale baseflow to ensure that baseflow is alway less than total flow
  }

  return(qb) #base flow time series
}

#rising limb density
rising_limb_density <- function(runoff){
  rising=diff(runoff)>0
  n_rl= sum(diff(which(rising))>1) #number of rising limbs
  t_r = sum(rising)                #number of timsteps with rising limbs
  return(n_rl/t_r)
}


hpc <- function(runoff){ #high pulse count (Clausen & Biggs, 2000 (FRE3) in Yadar et al 2007)
  
  
  high=runoff > 3*median(runoff)
  n_high= sum(diff(which(high))>1) #number high pulse events

  return(n_high/length(runoff)) 
}


q10 <- function(runoff){ #Flow exceeded 10% of the time divided by Q50 (Clausen & Biggs, 2000 )
  quants=quantile(x=runoff, probs=c(0.5,0.9))
  return(as.numeric(quants[2]/quants[1]))
}



fft_fit <- function (runoff, rainfall, doplot=FALSE) {
  #fit two-segmented linear regression into log-log-plot of FFT of time series
  
  if (!require(segmented)) stop("Function fft_fit needs package 'segmented', please install.")
  y_p=fft(scale(rainfall))
  y_q=fft(scale(runoff))
  
  len=length(y_p)
  freqs=(1:len)/len
  #  plot(log(freqs[1:(len/2)]),log(abs(y2[1:(len/2)])),type="l")
  
  
  dati<-data.frame(x=log(freqs[1:(len/2)]), y_p=log(abs(y_p[1:(len/2)])), y_q=log(abs(y_q[1:(len/2)])))
  #resample log-log plot to (coarser) equidistant resolution
  resamp_points=50
  dati$resamp=(ceiling( (dati$x-min(dati$x))/diff(range(dati$x))*resamp_points))
  #dati$resamp[1]=1 #assign first frequency to first bin, too
  resampled=aggregate(x=dati[-1,],by=list(bin=dati$resamp[-1]),FUN=mean)
  
  
  #find breakpoints
  lm_p<-lm(y_p~x,data=resampled)
  lm_q<-lm(y_q~x,data=resampled)
  
  o_p<-segmented(lm_p,seg.Z=~x,psi=list(x=mean(resampled$x)),
                 control=seg.control(display=FALSE))
  o_q<-segmented(lm_q,seg.Z=~x,psi=list(x=mean(resampled$x)),
                 control=seg.control(display=FALSE))
  
  if (doplot)
  {
    plot(dati$x[-1], dati$y_p[-1],type="l", xlab="log(freq)", ylab="power")
    lines(dati$x,dati$y_q,type="l", col="grey")
    
    points(resampled$x, resampled$y_p, col="red")
    points(resampled$x, resampled$y_q, col="blue")
    
    lines(resampled$x,predict(o_p), col="red")
    lines(resampled$x,predict(o_q), col="blue")
    legend("bottomleft",legend=c("rain","fit(rain)","runoff","fit(runoff)"), lty=1, col=c("black","red","grey","blue"))
  }
  return(cbind(p=c(slopes_p=slope(o_p)$x[,"Est."], breakp=o_p$psi[,"Est."]),
               q=c(slopes_p=slope(o_q)$x[,"Est."], breakp=o_q$psi[,"Est."])))
}


filter_ratio=function(runoff, rainfall, doplot=FALSE) #ratio of frequency recession constants
{
  rr=fft_fit(runoff=runoff, rainfall=rainfall, doplot=doplot)
  return(filter_ratio=rr[2,"p"]/rr[2,"q"])
}





