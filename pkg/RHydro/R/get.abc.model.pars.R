# compute a random realisation of model a parameter set for the abc model
# this has to obey the constraint that a+b <= 1
get.abc.model.pars = function(mod.pars.range) {
  result = get.model.pars(mod.pars.range)
  while(result$a + result$b > 1) {
     result = get.model.pars(mod.pars.range)
  }
  return(result)
}

