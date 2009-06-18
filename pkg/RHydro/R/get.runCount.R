get.runCount <- function(object){
           stopifnot(class(object)=="HydroModelRun") 
           return(length(object@measuredStates$runs))
}
