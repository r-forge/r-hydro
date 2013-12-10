abc = function (pars, init, prec, R.implementation=FALSE) {
# hydrological model no 1: the abc-model (acc. Vogel and Sankarasubramanian, WRR, 2003)
  if(R.implementation){
# naive implementation in R (slow)
	  len = length(prec)
	  # get model parameters
	  a = as.numeric(pars['a'])
	  b = as.numeric(pars['b'])
	  c = as.numeric(pars['c'])
	  if((a+b)>1) stop('Implausible model parameters.')
	  # initialise model
	  G0 = as.numeric(init['G'])
	  P  = prec
	  # These are our model equations (Q: stream flow, G: base flow)
	  # Q[t] = (1-a-b) * P[t] + c * G[t-1]
	  # G[t] = (1-c) * G[t-1] + a * P[t]
	  # Rekursionsvorschrift für Gt: Gt = G0*(1-c)^t + Summe_von_i=1_bis_t_über(a*Pi*(1-c)^(n-t))
	#  # die Zeitreihe für G wird um einen Zeitindex nach "rechts" verschoben (also G[1]=G0)
	#  # auf diese Weise kann dann Q ohne Schleife berechnet werden  
	  G = rep(0,len)
	  Q = rep(0,len)
	  for(t in 1:len) {
	    G[t] = (1-c)*G0 + a*P[t]
	    Q[t] = (1-a-b)*P[t] + c*G0
	    G0   = G[t]
	  }  
	  return(Q)
  } else {
      # Wrapper for the external abcmodel in Fortran (Flib.f03)
	  # Checks
	  if (any(is.na(prec))) { #stop("NA not allowed in input vector.")  
	    return(rep(NA,length(prec)))
	  } else {  
	    #for storages, use these default values if not specified from outside
	    if (length(init)==0) init=0
	    if (is.na(init['G'])) init['G']=0
	 
	    # Call the fortran subroutine
	    out= .Fortran("abcmodel",
	      vect      = as.double(prec),
	      vect_len  = as.integer(length(prec)),
	      G0        = as.double(init['G']),
	      a         = as.double(pars['a']),
	      b         = as.double(pars['b']),
	      c         = as.double(pars['c']),
	      Q         = rep(as.double(0),length(prec))
	    )
	    return(list(q=out$Q, G = out$G0))
	  }
  }
}

