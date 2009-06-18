applyToHydroTS <- function(x, FUN,
              data.class=c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"),
              runs = 1:get.runCount(x), by.runs=FALSE, as.list=FALSE
              ){
           stopifnot(class(x)=="HydroModelRun") 
           data.class <- match.arg(data.class, several.ok=TRUE)
           if(as.list){
               toRet <- list()
           } else {
               toRet <- c()
           }
           if(by.runs & length(runs)>1){
                for(run in runs){
                    toRet[[run]] <- list()
                }
           }
           for(theData.class in data.class){
                allRuns <- slot(x, theData.class)
                for(run in runs){
                    theList <- allRuns$runs[[run]]
                    for(hydroTS in theList){
                        if(!is.null(hydroTS))
                                if(by.runs & length(runs)>1){
                                   toRet[[run]] <- append(toRet[[run]], FUN(hydroTS))
                                } else {
                                   toRet <- append(toRet, FUN(hydroTS))
                                }
 
                    }
                }
                theList <- allRuns$shared
                for(hydroTS in theList){
                    if(!is.null(hydroTS))
                            if(by.runs & length(runs)>1){
                               for(run in runs){
                                   toRet[[run]] <- append(toRet[[run]], FUN(hydroTS))
                               }
                            } else {
                               toRet <- append(toRet, FUN(hydroTS))
                            }
                        toRet <- append(toRet,FUN(hydroTS))
                }
           }
      return(toRet)
}
