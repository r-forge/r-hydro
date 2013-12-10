processList <- function(theList, shared=FALSE, run, runs, by.runs, FUN, toRet){
    for(hydroTSname in names(theList)){
        hydroTS <- theList[[hydroTSname]]
        if(!is.null(hydroTS))
                if(by.runs & length(runs)>1){
                   if(shared){
                       for(run in runs){
                           toRet[[run]] <- append(toRet[[run]], FUN(hydroTS))
                       }
                   } else {
                       toRet[[run]] <- append(toRet[[run]], FUN(hydroTS))
                   }
                } else {
                   toRet <- append(toRet, FUN(hydroTS))
                }

    }
    return(toRet)
}
