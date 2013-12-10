# samples parameter sets from parameter space by latin hypercube sampling
lhs = function(mod.pars.range,n) {
  no.pars = length(mod.pars.range)
  par.sets = randomLHS(n=n, k=no.pars)
  # transform parameters from [0,1] to actual value range                             
  #...
  return(par.sets)
}

