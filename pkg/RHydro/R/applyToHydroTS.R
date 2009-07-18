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
                    toRet <- processList(allRuns$runs[[run]], run=run, runs=runs, by.runs=by.runs, FUN=FUN, toRet=toRet)
                }
                toRet <- processList(allRuns$shared, shared=TRUE, run=NA, runs=runs, by.runs=by.runs, FUN=FUN, toRet=toRet)
           }
      return(toRet)
}
