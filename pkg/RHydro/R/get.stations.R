get.stations <- function(object, 
              data.class=c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates")){
           stopifnot(class(object)=="HydroModelRun") 
           data.class <- match.arg(data.class, several.ok=TRUE)
           stations <- c()
           for(theData.class in data.class){
                theList <- slot(object, theData.class)
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

