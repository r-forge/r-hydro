
#validate.topmodel = function(object) {
setMethod("validate", signature = "topmodel",
   function(object) {
    parameters = HMparameters(object)
    pnames = names(parameters)
    nnames = match.arg(pnames, 
      c("topidx", "parameters", "delay", "pm", "return.simulations", "verbose"), several.ok = TRUE)
    names(parameters) = nnames
    parameters = parameters$parameters
# Probably not necessary to check these
#    pnames = names(HMdots)
#    nnames = match.arg(pnames,
#        c("topidx", "delay", "pm", "return.simulations", "verbose"), several.ok = TRUE)
#    names(HMdots) = nnames
    ## check that number of parameters is correct
    if(length(parameters) !=9)
      return(paste("Incorrect number of parameters. Found", length(parameters), "out of 9"))
    ## check for negative initial subsurface flow
    if(any(parameters[1] < 0))
      return("Initial subsurface flow should not be negative")
    ## check for negative or extremely low streamflow velocity
    if(any(parameters[7] < 50))
      return("Stream flow velocity should not be smaller than 50m/h")
    ##
    ## Check that there is temporal data, and that it is a zoo-object
    tempData = HMtemporalData(HMobservations(object))
    if (!length(tempData) == 1) return(paste("too many temporal data elements, 1 needed, was given ", length(tempData)))
    if (!is(tempData[[1]], "zoo"))
      return(paste("wrong class of temporal data, zoo is needed, was given",
        class(HMtemporalData(HMobservations(object)))))
    ## Everything ok, returning TRUE
    return(TRUE)
  }
)

