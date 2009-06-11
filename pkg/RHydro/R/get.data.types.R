get.data.types <- function(object, 
              data.class=c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates")){
           stopifnot(class(object)=="HydroModelRun") 
           data.class <- match.arg(data.class, several.ok=TRUE)
           types <- c()
           for(theData.class in data.class){
                theList <- slot(object, theData.class)
                for(hydroTS in theList){
                    if(!is.null(hydroTS))
                        types <- append(types,hydroTS@type)
                }
           }
           types <-  unique(types)
           return(types[order(types)])
 
}

