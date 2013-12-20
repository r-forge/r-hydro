
validate.topmodel = function(object) {
  parameters = as(HMparameters(object, "topmodel"), "list")$parameters
  # Probably not necessary to check these
  #    pnames = names(HMdots)
  #    nnames = match.arg(pnames,
  #        c("topidx", "delay", "pm", "return.simulations", "verbose"), several.ok = TRUE)
  #    names(HMdots) = nnames
  ## check that number of parameters is correct
  if(dim(parameters)[1] !=9)
    return(paste("Incorrect number of parameters. Found", length(parameters), "out of 9"))
  ## check for negative initial subsurface flow
  if(any(parameters[1,] < 0))
    return("Initial subsurface flow should not be negative")
  ## check for negative or extremely low streamflow velocity
  if(any(parameters[7,] < 50))
    return("Stream flow velocity should not be smaller than 50m/h")
  ##
  ## Check that there is temporal data, and that it is a zoo-object
  tempData = HMtemporalData(HMobs(object))
  # Extract the topmodel relevant element from the temporal data
  tempData = tempData$data
  if (!is(tempData, "zoo"))
    return(paste("wrong class of temporal data with name data, zoo is needed, was given",
                 class(tempData)))
  ## Everything ok, returning TRUE
  return(TRUE)
}


