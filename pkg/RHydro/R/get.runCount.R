
## this function may need to be redesigned. It is not good to rely
## on the length of object@measuredStates$runs.
## Models could keep this slot empty if no measuredStates are available
## (or do we consider this bad practice?)

get.runCount <- function(object){
           stopifnot(class(object)=="HydroModelRun")
           return(length(object@measuredStates$runs))
}
