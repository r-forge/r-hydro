# Wrapper for the external hbv in Fortran (Flib.f03)
hbv = function (pars, init=NULL, prec, temp=NULL, delta_t=1, unithg=NULL) {
  # Checks
  if (any(is.na(prec))) { # stop("NA not allowed in input vector.")  
    return(rep(NA,length(prec)))
  } else {
  
  #for storages, use these default values if not specified from outside
    if (is.null(init) | (length(init)==0)) init=0
    if (is.na(init['snow'])) init['snow']=0
    if (is.na(init['sm']))   init['sm']  =200
    if (is.na(init['suz']))  init['suz'] =0
    if (is.na(init['slz']))  init['slz'] =0
 
        
    if (is.na(pars['corr']))  pars['corr'] =1
    if (is.na(pars['beta']))  pars['beta'] =0.2
    if (is.na(pars['fc']))  pars['fc'] =200
    if (is.na(pars['etpmean']))  pars['etpmean'] =5
    if (is.na(pars['tmean']))  pars['tmean'] =10.
    if (is.na(pars['cfmax']))  pars['cfmax'] =2.4
    if (is.na(pars['tt']))  pars['tt'] =0

    if (is.na(pars['lp']))  pars['lp'] =0.1
    if (is.na(pars['k_perc']))  pars['k_perc'] =0.1
    if (is.na(pars['luz']))  pars['luz'] =0.1
    if (is.na(pars['minsm']))  pars['minsm'] =0.1
		pars['minsm']= min(pars['minsm'], pars['fc'])  #residual water content must be below field capacity
    if (is.na(pars['k0']))  pars['k0'] =0.1
    if (is.na(pars['k1']))  pars['k1'] =0.1
    if (is.na(pars['k2']))  pars['k2'] =0.1
    
    if (is.null(temp))  temp = rep(pars['tmean'],length(prec))
 
    if (!is.null(unithg))  #custom specifivcation of unit hydrograph 
    {
      pars['maxbas'] = length(unithg)
    } else
    if (is.na(sum(pars[c('n','k')])))           #if no parameters for linear storage cascade given, fall back to triangular hydrograph
    {
         if (is.na(pars['maxbas']))  pars['maxbas'] =1 
          else
          pars['maxbas'] = round(pars['maxbas'])
         unithg = rep(0,pars['maxbas']) #triangular UH will be generated internally
    } else                      #parameters for linear storage cascade given, override maxbas
    {
      unithg = unit.hydrograph.storage.cascade(pars["n"],pars["k"],delta_t)
      if (length(unithg)==0) stop("Parameters of storage cascade result in too long unit hydrograph.")
      pars['maxbas'] = length(unithg)
    }
    
    # Call the fortran subroutine
    out= .Fortran("hbv",    
      p         = as.double(prec),
      t         = as.double(temp),
      vect_len  = as.integer(length(prec)),
      snow      = as.double(init['snow']),
      sm        = as.double(init['sm']),
      suz       = as.double(init['suz']),
      slz       = as.double(init['slz']),
      cfmax     = as.double(pars['cfmax']),
      tt        = as.double(pars['tt']),
      fc        = as.double(pars['fc']),
      minsm     = as.double(pars['minsm']),
      beta      = as.double(pars['beta']),
      lp        = as.double(pars['lp']),
      corr      = as.double(pars['corr']),
      k_perc    = as.double(pars['k_perc']),
      k0        = as.double(pars['k0']),
      luz       = as.double(pars['luz']),
      k1        = as.double(pars['k1']),
      k2        = as.double(pars['k2']),
      maxbas    = as.integer(pars['maxbas']),
      etpmean   = as.double(pars['etpmean']),
      tmean     = as.double(pars['tmean']),
      unithg    = as.double(unithg),
      delta_t   = as.double(delta_t),
      Q         = rep(as.double(0),length(prec))   
    )
    return(list(q=out$Q, snow = out$snow, sm=out$sm, suz=out$suz, slz=out$slz))
  }
}

