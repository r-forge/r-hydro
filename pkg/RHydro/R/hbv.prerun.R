#calls HBV-model with given parameters and repeats the pre-run-phase, until the storages change less than a specified percentage
hbv.prerun=function(init=NULL, prec, max_pre_runs=20, storage_tolerance=0.1, prerun_length=(365*24*60/5), verbose=TRUE,...)
{
  #max_pre_runs=20                                 #max number (years) of pre-run to achieve storage equilibrium (abortion criteria for pre-run phase)
  #storage_tolerance=0.1                          # max allowed relative difference in output volume between successive pre-runs (abortion criteria for pre-run phase)
  #prerun_length=(365*24*60/5)            #number of timesteps to use for the pre-run phase
#  delta_t=1/24/12 #temporal resolution of 5 min
  
  if (length(prec) < prerun_length) stop("Rainfall input too short to run prerun_length for warming-up.")

  if (is.null(init)) init["snow"]=100
  init = init[c("snow", "sm", "suz", "slz")]
  names(init) = c("snow", "sm", "suz", "slz")
  init[is.na(init)] = 100 #set non-initialized storages to 100

  prerun_rain=prec[1:prerun_length] #use first year as warm-up phase
  

  # pre-run-phase
  for (i in 1:max_pre_runs) #do pre-runs till equilibrium
  {
    if (verbose) cat(paste("Pre-run iteration",i,"(of max",max_pre_runs,")\n"))

    storage_before= init
    tt=hbv(prec=prerun_rain, init=c(init, 'Q'=NULL),...)

    init=c(snow=tt$snow, sm=tt$sm, suz=tt$suz, slz=tt$slz)
 
    storage_after= init
    rel_storage_change= abs(storage_after-storage_before)/pmax(0.0001,storage_before)
    if (all(rel_storage_change <= storage_tolerance))    #check if storage changes are below tolerance limit
    {
      required_pre_runs=i
      if (verbose) cat(paste(" small relative storage change (",mean(storage_before),"->",mean(storage_after),":",mean(rel_storage_change),"<",storage_tolerance,"), accepted as starting condition...\n"))
      break
    }   else
    if (verbose) cat(paste(" large relative storage change (",mean(storage_before),"->",mean(storage_after),":",mean(rel_storage_change),">",storage_tolerance,"), starting next iteration...\n"))
  }
  
  
  #actual simulation
  tt=hbv(prec=prec, init=c(init, 'Q'=NULL),...)
  if (verbose) cat(paste("Finished actual simulation...\n"))
  return(c(tt,n_preruns=i))
}

