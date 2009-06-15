get.HydroTS <- function(object, 
              data.class=c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"),
              the.data.types=data.types(object, data.class=data.class),
              runs = 1:get.runCount(object)
              ){
           stopifnot(class(object)=="HydroModelRun") 
           data.class <- match.arg(data.class, several.ok=TRUE)
           ret <- list()
           if(length(runs)>1){
                for(run in runs){
                    ret[[run]] <- list()
                }
           }
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
                            if(hydroTS@type %in% the.data.types){
                                if(length(runs)>1){
                                   ret[[run]] <- append(ret[[run]], hydroTS)
                                } else {
                                   ret <- append(ret, hydroTS)
                                }
                            }
                        }
                    }
               }
           }
           return(ret)
 
}

