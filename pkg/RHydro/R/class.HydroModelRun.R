validityHydroModelRun <- function(object){
     toRet <- c()
     #ToDo use slot(object, theData.class) e.g. get.data.types
          
     #Check for same number of runs
     if(length(object@measuredStates$runs) != length(object@measuredFluxes$runs)  ||
        length(object@measuredStates$runs) != length(object@modelledFluxes$runs)  ||
        length(object@measuredStates$runs) != length(object@parameters@parameters) ||
        length(object@measuredStates$runs) != length(object@modelledStates$runs))
        toRet <- "The slots 'measuredStates$runs, measuredFluxes$runs, modelledFluxes$runs, modelledStates$runs, and parameters@parameters' need the same number of entries (length())."
     
     #Check for data types in slots
     for(slot in c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates")){
         for(bla in c("run", "shared")){
              
         browser()
         #check for generated and recorded

         #check for HydroState/HydroFlux
         if(any(sapply(slot(object, slot)[[bla]], FUN=function(x){sapply(x,class)})!="HydroState"))
            toRet <- c(toRet, paste("Slot '",slot,"$",bla,"measuredStates' must be a list of lists of HydroStates-Objects", sep="")) 
         }
     }
     #ToDo Check for consistency between list symbols and data types
}

setClass("HydroModelRun",
	representation = representation(parameters="HydroModelParameters",
                                modelledFluxes="list",
				modelledStates="list",
				measuredFluxes="list",
				measuredStates="list",
				performanceMeasures="data.frame",
				modelSupportData="list",
				call="character"),
       validity =  validityHydroModelRun
)


setMethod("print",
    signature(x = "HydroModelRun"),
    function (x, ...) 
    {
      cat("Model ID: ",x@parameters@modelID,"\n")
      cat("\n")
      cat("Number of model runs: ", dim(x@parameters@parameters)[1],"\n")
      cat("Number of parameters: ", dim(x@parameters@parameters)[2],"\n")
      cat("Parameter names: ", names(x@parameters),"\n")
      cat("\n")
      cat("Modelled fluxes: ",
          if(length(x@modelledFluxes$runs) > 0) { names(x@modelledFluxes$runs[[1]]) },
          names(x@modelledFluxes$shared),"\n")
      cat("Modelled states: ",
          if(length(x@modelledStates$runs) > 0) { names(x@modelledStates$runs[[1]]) },
          names(x@modelledStates$shared),"\n")
      cat("Measured fluxes: ",
          if(length(x@measuredFluxes$runs) > 0) { names(x@measuredFluxes$runs[[1]]) },
          names(x@measuredFluxes$shared),"\n")
      cat("Measured states: ",
          if(length(x@measuredStates$runs) > 0) { names(x@measuredStates$runs[[1]]) },
          names(x@measuredStates$shared),"\n")
      cat("\n")
      cat("Calculated performance measures: ", names(x@performanceMeasures),"\n")
      cat("Model Support Data: ", names(x@modelSupportData),"\n")
      cat("Call: ", x@call,"\n")
    }
)

setMethod("summary",
    signature(object = "HydroModelRun"),
    function (object, ...) 
    {
      print(object, ...)
    }
)

setMethod("show",
    signature(object = "HydroModelRun"),
    function (object) 
    {
      print(object)
    }
)


setMethod("plot",
    signature(x = "HydroModelRun"),
    function (x, y, 
              hydro.plot.type=c("rainfall-runoff", "by.data.type", "by.station", "balance"),
              data.class=c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"),
              data.types=get.data.types(x, data.class=data.class),
              stations=get.stations(x, data.class=data.class),
              balance.types=unique(unlist(strsplit(rhydro.data.types$balance.type, ", *"))),
              legend.position="right",
              runs=1:get.runCount(x),
              ...) 
    {
        hydro.plot.type <- match.arg(hydro.plot.type, several.ok=TRUE)
        data.class <- match.arg(data.class, several.ok=TRUE)
            #oldpar <- par(ask=TRUE)
            if("rainfall-runoff" %in% hydro.plot.type){
                rain <- get.HydroTS(object, data.class=c("modelledFluxes"), data.types="precipitation", stations=stations, runs=runs)
                q.model <- get.HydroTS(object, data.class=c("modelledFluxes"), data.types="discharge", stations=stations, runs=runs)
                q.measured <- get.HydroTS(object, data.class=c("measuredFluxes"), data.types="discharge", stations=stations, runs=runs)
                for(run in runs){
                    for(station in get.stations(object,
                            data.class=c("measuredFluxes"), 
                            data.types="discharge")){

                            sel.rain <- dimnames(rain[[run]]@magnitude)[[2]] %in% station
                            sel.q.model <- dimnames(q.model[[run]]@magnitude)[[2]] %in% station
                            sel.q.measured <- dimnames(q.measured[[run]]@magnitude)[[2]] %in% station
                            plot.rainfall.runoff(rain[[run]]@magnitude[,sel.rain],
                                 q.model[[run]]@magnitude[,sel.q.model], 
                                 q.measured[[run]]@magnitude[,sel.q.measured],
                                 main=paste("Station:", station, "Run:", run),
                                 q.units=q.model[[run]]@units,
                                 p.units=rain[[run]]@units
                                 )
                    }
                }
            }
            if("by.data.type" %in% hydro.plot.type){
                 applyToHydroTS(object,
                       FUN=function(hydroTS){
                            if(hydroTS@type %in% data.types){
                                 select <- dimnames(hydroTS@magnitude)[[2]] %in% stations
                                 plot(hydroTS@magnitude[,select], main=paste(hydroTS@type, "Run:", run),...)
                            }
                            return(c())
                       },
                       data.class=data.class,
                       runs=runs)
            }
            if("by.station" %in% hydro.plot.type){
              for(the.station in stations){
                allTS <- get.HydroTS(object, stations=the.station, 
                                     data.class=data.class, 
                                     data.types=data.types,
                                     runs=runs)
                #Rearrange zoo objects
                new.zoos <- NULL
                col.names <- list()
                for(hydroTS in allTS){
                     if(NCOL(hydroTS@magnitude)>0){
                         if(is.null(new.zoos[[hydroTS@units]])){
                              new.zoos[[hydroTS@units]] <-  hydroTS@magnitude
                              col.names[[hydroTS@units]] <- hydroTS@type
                         } else {
                              new.zoos[[hydroTS@units]] <- merge(new.zoos[[hydroTS@units]], hydroTS@magnitude)
                              col.names[[hydroTS@units]] <- c(col.names[[hydroTS@units]],hydroTS@type)
                         }
                     }
                }
                #Plot zoo objects by units
                for(unit in names(new.zoos)){
                   if(length(col.names[[unit]])>1){
                       dimnames(new.zoos[[unit]])[[2]] <- col.names[[unit]]
                       plot(new.zoos[[unit]], plot.type="single", ylab=unit, col=1:length(col.names[[unit]]),main=the.station,...)
                       legend(legend.position, col.names[[unit]],col=1:length(col.names[[unit]]))
                   } else {
                       plot(new.zoos[[unit]], plot.type="single", ylab=unit, col=1:length(col.names[[unit]]),main=paste(col.names[[unit]], "at", the.station),...)
                   }
                }
              }
            }
            if("balance" %in% hydro.plot.type){
                #loop through balance types
                for(balance.type in balance.types){
                    #what data.types occur in this balance?
                    b.data.types <- rhydro.data.types$data.type[rhydro.data.types$balance.type==balance.type]
                    #loop through runs and stations
                    for(run in runs){
                       if(identical(stations,get.stations(x, data.class=data.class))){
                             stations=get.stations(x, data.class="modelledFluxes",  data.types=b.data.types)
                       }
                       for(station in stations){
                            #get flux data
                            allTS <- get.HydroTS(object, data.class="modelledFluxes",
                                 data.types=b.data.types,
                                 station=station,
                                 runs=run)
                            
                            for(ts in allTS){
                                #calc plot range
                                y.range <- c(0,
                                   max(sapply(allTS, FUN=function(x){sum(x@magnitude, na.rm=TRUE)}))
                                   )
                                
                                #ToDo get better x-range
                                #bla <-  lapply(allTS, FUN=function(x){as.POSIXlt(max(index(x@magnitude)), na.rm=TRUE)})
                                #as.POSIXct(sapply(allTS, FUN=function(x){max(index(x@magnitude), na.rm=TRUE)}), origin="1970-01-01", tz="GMT")
                                #bla2 <- bla[[1]]
                                #for(i in bla){
                                #   bla2 <- rbind(bla2, i)
                                #}
                                x.range <- lapply(allTS, FUN=function(x){range(index(x@magnitude), na.rm=TRUE)})[[1]]
                                plot(x.range,y.range, type="n", xlab="time", ylab=allTS[[1]]@units)
                                #build sums for flux data
                                if(NCOL(ts@magnitude)==0){
                                   warning(paste("No data available for station",station,"run",run," and data type", ts@type))
                                } else {
                                   if(any(is.na(ts@magnitude))){
                                       warning(paste("dropping NA data while calculating cumulative sum for station",station,"run",run," and data type", ts@type))
                                       ts@magnitude <- ts@magnitude[!is.na(ts@magnitude)]

                                   }
                                   the.sum <- cumsum(ts@magnitude)
                                }
                                #plot flux data by station and run
                                browser()
                            }
                            #store total flux change (end sum) (with direction)
                            
                            #get state data
                            #plot state data (on different axis?)
                            #store total state change
                       }
                    }
                }

            }
            #par(oldpar)

    }
)

