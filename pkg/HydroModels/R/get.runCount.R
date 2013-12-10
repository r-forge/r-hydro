get.runCount <- function(object){
           stopifnot(class(object)=="HydroRun")
           return(max(object@metadata$run.ID))
}
