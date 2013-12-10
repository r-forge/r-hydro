# compute a random realisation of model a parameter set
get.model.pars = function(mod.pars.range) {
  len = length(mod.pars.range)
  result = list()
  for (i in 1:len) {
    result[[i]] = runif(1,mod.pars.range[[i]][1],mod.pars.range[[i]][2])
  }
  names(result) = names(mod.pars.range)
  return(result)
}

