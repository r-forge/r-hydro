get.HydroTS <- function(object, 
              data.class=c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"),
              data.types=get.data.types(object, data.class=data.class),
              stations=get.stations(object, data.class=data.class),
              runs = 1:get.runCount(object),
              x.range = NULL
              ){
           return(applyToHydroTS(x=object,
                          data.class=data.class,
                          runs=runs, by.runs=TRUE,
                          FUN=function(hydroTS){
                               if(hydroTS@type %in% data.types){ 
                                   selection <- hydroTS@location.name %in% stations
                                   if(any(selection)){
                                       hydroTS@magnitude <- hydroTS@magnitude[,selection]
                                       if(!is.null(x.range)){
                                           hydroTS@magnitude <- window(hydroTS@magnitude, start = x.range[1], end=x.range[2]) 
                                       }
                                       hydroTS@coordinate <- hydroTS@coordinate[selection]
                                       hydroTS@location.name <- hydroTS@location.name[selection]
                                       return(hydroTS)
                                   } else {
                                       #no location match
                                       return(NULL)
                                   }
                               }
                          }
                          )
             )

}

