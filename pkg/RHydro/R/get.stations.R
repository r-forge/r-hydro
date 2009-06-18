get.stations <- function(object, 
              data.class=c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"),
              data.types=get.data.types(object, data.class=data.class),
              runs=1:get.runCount(object) ){
           stations <- applyToHydroTS(x=object,
                          FUN=function(hydroTS){
                               if(hydroTS@type %in% data.types){ 
                                     dimnames(hydroTS@magnitude)[[2]]
                               }
                          },
                          data.class=data.class,
                          runs=runs)
           stations <-  unique(stations)
           return(stations[order(stations)])
}

