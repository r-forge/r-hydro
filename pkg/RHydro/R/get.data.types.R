get.data.types <- function(object, 
              data.class=c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"),
            runs = 1:get.runCount(object)
            ){
           types <- applyToHydroTS(x=object,
                          FUN=function(hydroTS){hydroTS@type},
                          data.class=data.class,
                          runs=runs)
           types <-  unique(types)
           return(types[order(types)])
 
}

