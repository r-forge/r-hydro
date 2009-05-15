data.types <- function(object, 
              kind=c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates")){
           stopifnot(class(object)=="HydroModelRun") 
           kind <- match.arg(kind, several.ok=TRUE)
           types <- c()
           for(theKind in kind){
                theList <- slot(object, theKind)
                for(hydroTS in theList){
                    if(!is.null(hydroTS))
                        types <- append(types,hydroTS@type)
                }
           }
           types <-  unique(types)
           return(types[order(types)])
 
}

