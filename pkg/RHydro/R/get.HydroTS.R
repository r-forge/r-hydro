get.HydroTS <- function(object, 
              data.class=c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"),
              the.data.types=data.types(object, data.class=data.class)
              ){
           stopifnot(class(object)=="HydroModelRun") 
           data.class <- match.arg(data.class, several.ok=TRUE)
           ret <- list()
           for(theData.class in data.class){
                theList <- slot(object, theData.class)
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

