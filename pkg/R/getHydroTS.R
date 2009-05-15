getHydroTS <- function(object, 
              kind=c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"),
              the.data.types=data.types(x, kind=kind)
              ){
           stopifnot(class(object)=="HydroModelRun") 
           kind <- match.arg(kind, several.ok=TRUE)
           ret <- list()
           for(theKind in kind){
                theList <- slot(object, theKind)
                for(hydroTS in theList){
                    if(!is.null(hydroTS)){
                        if(hydroTS@type %in% the.data.types){
                            ret <- append(ret, hydroTS)
                        }
                    }
                }
           }
           return(ret)
 
}

