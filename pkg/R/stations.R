stations <- function(object, 
              kind=c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates")){
           stopifnot(class(object)=="HydroModelRun") 
           kind <- match.arg(kind, several.ok=TRUE)
           stations <- c()
           for(theKind in kind){
                theList <- slot(object, theKind)
                for(hydroTS in theList){
                    if(!is.null(hydroTS)){
                        theNames <-  dimnames(hydroTS@magnitude)[[2]]
                        stations <- append(stations,theNames)
                    }
                }
           }
           stations <-  unique(stations)
           return(stations[order(stations)])
 
}

