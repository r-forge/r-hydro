get.HydroTS <- function(object, 
              data.class=c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"),
              data.types=get.data.types(object, data.class=data.class),
              stations=get.stations(object, data.class=data.class),
              runs = 1:get.runCount(object)
              ){
           return(applyToHydroTS(x=object,
                          data.class=data.class,
                          runs=runs, by.runs=TRUE,
                          FUN=function(hydroTS){
                               if(hydroTS@type %in% data.types){ 
                                   selection <- hydroTS@location.name %in% stations
                                   hydroTS@magnitude <- hydroTS@magnitude[,selection]
                                   #ToDo uncomment when WaSiM Stations for generated TS is activated.
                                   #hydroTS@coordinate <- hydroTS@coordinate[,selection]
                                   return(hydroTS)
                               }
                          }
                          )
             )

}

