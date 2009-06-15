get.stations <- function(object, 
              data.class=c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"),
              runs=1:get.runCount(object) ){
           stopifnot(class(object)=="HydroModelRun") 
           data.class <- match.arg(data.class, several.ok=TRUE)
           stations <- c()
           for(theData.class in data.class){
                allRuns <- slot(object, theData.class)
                if(!is.null(allRuns[["all"]])){
                    runs2 <- c(runs,"all")
                } else {
                    runs2 <- runs
                }
                for(run in runs2){
                    theList <- allRuns[[run]]
                    for(hydroTS in theList){
                        if(!is.null(hydroTS)){
                            theNames <-  dimnames(hydroTS@magnitude)[[2]]
                            stations <- append(stations,theNames)
                        }
                    }
               }
           }
           stations <-  unique(stations)
           return(stations[order(stations)])
 
}

