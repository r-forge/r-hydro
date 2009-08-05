get.runCount <- function(object){
           stopifnot(class(object)=="HydroModelRun")
           return(dim(object@parameters@parameters)[1])
}
