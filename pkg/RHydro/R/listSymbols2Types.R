listSymbols2Types <- function(theList){
   innerFUN <- function(sublist){
       ## get names for elements
       symbols <-  names(sublist)
       for(symbol in symbols){
            ## any matching symbol in rhydro.data.types?
            theMatch <- rhydro.data.types$symbol == symbol
            if(any(theMatch)){
                 ## do replacement
                 sublist[[symbol]]@type <- rhydro.data.types$data.type[theMatch]
                 ## check whether to set units
                 if(length(sublist[[symbol]]@units)==0){
                     sublist[[symbol]]@units <- rhydro.data.types$prefered.units[theMatch]
                     cat("Assuming", rhydro.data.types$prefered.units[theMatch], "as units for data type:", rhydro.data.types$data.type[theMatch],"\n")
                 }
            ## if not, set to unknown
            } else {
                 sublist[[symbol]]@type <- "unknown"
                 if(length(sublist[[symbol]]@units)==0){
                     sublist[[symbol]]@units <- "NA"  
                 }
                 warning(paste("Unknown RHydro - symbol '", symbol ,"'in rhydro.data.types$symbol", sep=""))
            }
       }
      
      return(sublist)
   }

   if(length(theList$shared)>0){
        theList$shared <- innerFUN(theList$shared)
   }
   for(run in seq(along = theList$runs)){
        #get names for elements
        theList$runs[[run]] <- innerFUN(theList$runs[[run]])    
   }
   return(theList)
}
