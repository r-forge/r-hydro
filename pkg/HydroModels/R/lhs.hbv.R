# samples parameter sets from parameter space by latin hypercube sampling
lhs.hbv = function(mod.pars.range,n) {
  no.pars = length(mod.pars.range)
  par.sets = randomLHS(n=n, k=no.pars)
  # transform parameters from [0,1] to actual value range                             
  for(i in 1:no.pars) {
    par.sets[,i] = mod.pars.range[[i]][1] + (mod.pars.range[[i]][2]-mod.pars.range[[i]][1]) * par.sets[,i]
  }
  colnames(par.sets) = names(mod.pars.range)
  return(par.sets)
}

