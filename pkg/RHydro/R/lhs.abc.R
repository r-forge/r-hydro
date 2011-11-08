# samples parameter sets from parameter space by latin hypercube sampling
# but now we are normalising a and b if their sum is larger than 1
lhs.abc = function(mod.pars.range,n) {
  # for the abc model, we produce double the parameter sets we need because we have to discard so many
  par.sets = randomLHS(n=n, k=length(mod.pars.range))
  for(i in 1:n) {
    if(par.sets[i,1]+par.sets[i,2]>1) {
      a_new = par.sets[i,1]/(par.sets[i,1]+par.sets[i,2])
      b_new = par.sets[i,2]/(par.sets[i,1]+par.sets[i,2])
      par.sets[i,1]=a_new
      par.sets[i,2]=b_new
    }
  }
  colnames(par.sets) = names(mod.pars.range)
  return(par.sets)
}

