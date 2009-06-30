get.stations <- function(object, 
              data.class=c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"),
              data.types=get.data.types(object, data.class=data.class),
              runs=1:get.runCount(object) ){
           stations <- applyToHydroTS(x=object,
                          FUN=function(hydroTS){
                               if(hydroTS@type %in% data.types){ 
                                     hydroTS@location.name
                               }
                          },
                          data.class=data.class,
                          runs=runs)
           stations <-  unique(stations)
           if(is.null(stations)){
              return(stations)
           }
           return(stations[order(stations)])
}

