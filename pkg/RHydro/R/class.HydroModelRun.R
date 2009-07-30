validityHydroModelRun <- function(object){
     toRet <- c()
     #Check for same number of runs
     num.pars <- NROW(object@parameters@parameters)
     for(slot in c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates")){
          if(length(slot(object, slot)$runs) != num.pars)
            toRet <- paste("The slot ",slot,"$runs needs the same number of entries as numbers of parameters stored in the object.", sep="")
     }
          
     
     #Check for data types in slots
     for(slot in c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates")){
         for(bla in c("runs", "shared")){
              

             #check for HydroState/HydroFlux
             if(length(grep("Flux", slot))>0){
                 expected.type <- "HydroFlux"
             } else {
                 expected.type <- "HydroState"
             }
             if(length(grep("model", slot))>0){
                 expected.origin <- "generated"
             } else {
                 expected.origin <- "recorded"
             }
             if(length(slot(object, slot)[[bla]]) > 0){
                 classes <- sapply(slot(object, slot)[[bla]], FUN=function(x){if(bla=="shared"){class(x)} else { if(length(x)>0)sapply(x,class)}})
                 
                 empty <- sapply(classes, is.null)
                 check <- classes !=expected.type && !empty
                 if(any(check)){
                    toRet <- c(toRet, paste("Slot '",slot,"$",bla,"' must be a list of lists of ",expected.type,"-Objects", sep=""))
             #check for generated and recorded
                 } else  {
                     innerfun <- function(x){x@TSorigin}
                     if(any(sapply(slot(object, slot)[[bla]], FUN=function(x){if(bla=="shared"){innerfun(x)} else {sapply(x,FUN=innerfun)}})!=expected.origin && !empty))
                        toRet <- c(toRet, paste("Slot '",slot,"$",bla,"' must be a list of lists of ",expected.origin," Objects (object@TSorigin)", sep="")) 
                 }
             }
             
         }
     }
     #check that all data-types are not empty string
     my.data.types <- applyToHydroTS(x=object,
                          FUN=function(hydroTS){if(length(hydroTS@type)==0){ "emptyType"} else hydroTS@type}
     )
     if(any(my.data.types=="emptyType")) toRet <- c(toRet, "type-slot is an empty string for some TS-Objects" )
     my.units <- applyToHydroTS(x=object,
                          FUN=function(hydroTS){if(length(hydroTS@units)==0){ "no units"} else hydroTS@units}
     )
     if(any(my.units=="no units")) toRet <- c(toRet, "units-slot is an empty string for some TS-Objects" )
     #Check for consistency between list symbols and data types
     msg <- applyToHydroTS(x=object, FUN=function(hydroTS){
          symbol <- get("hydroTSname", envir=parent.frame())
          type <- hydroTS@type
          expected.symbol <-  rhydro.data.types$symbol[rhydro.data.types$data.type == type]
          if(length(expected.symbol)!=0){
              if(symbol != expected.symbol){
                  return(paste("Symbol of HydroTS with type", type, "is", symbol, "however, expected symbol (according to rhydro.data.types) is", expected.symbol))
              }
          }
     })
    if(!is.null(msg)){
         toRet <- c(toRet, msg)
    }
    if(length(toRet)!=0){
       return(toRet)
    } else {
       return(TRUE)
    }

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

setMethod("validity.check",
    signature(object = "HydroModelRun"),
    function (object) {
           applyToHydroTS(object, FUN=validity.check)
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
              balance.types=unique(unlist(getBalanceTypes.rhydro.data.types())),
              legend.position="right",
              runs=1:get.runCount(x),
              ...) 
    {
        hydro.plot.type <- match.arg(hydro.plot.type, several.ok=TRUE)
        data.class <- match.arg(data.class, several.ok=TRUE)
        to.ret <- list()
            #oldpar <- par(ask=TRUE)
            if("rainfall-runoff" %in% hydro.plot.type){
                skip.plot=FALSE
                rain <- get.HydroTS(x, data.class=c("modelledFluxes"), data.types="precipitation", stations=stations, runs=runs)
                if(is.null(rain)){
                    rain <- get.HydroTS(x, data.class=c("measuredFluxes"), data.types="precipitation", stations=stations, runs=runs)
                    if(is.null(rain)){
                       warning("no rainfall data avialable for rainfall runoff plot")
                       skip.plot=TRUE
                    }
                    warning("no modelled precipitation available for rainfall runoff model - using measured values instead")
                }
                q.model <- get.HydroTS(x, data.class=c("modelledFluxes"), data.types="discharge", stations=stations, runs=runs)
                if(is.null(q.model)){
                   warning("no modelled discharge data avialable for rainfall runoff plot")
                   skip.plot=TRUE
                }
                
                q.measured <- get.HydroTS(x, data.class=c("measuredFluxes"), data.types="discharge", stations=stations, runs=runs)
                if(!skip.plot){
                    for(run in runs){
                        for(station in get.stations(x,
                                data.class=c("measuredFluxes"), 
                                data.types="discharge")){

                                sel.rain <- rain[[run]]@location.name %in% station
                                q.model.sel <- NULL
                                q.units <- ""
                                sel.q.model <- q.model[[run]]@location.name %in% station
                                q.model.sel <- q.model[[run]]@magnitude[,sel.q.model]
                                q.units <- q.model[[run]]@units
                                q.measured.sel <- NULL
                                if(!is.null(q.measured)){
                                    sel.q.measured <- q.measured[[run]]@location.name %in% station
                                    q.measured.sel <- q.measured[[run]]@magnitude[,sel.q.measured]
                                }
                                plot_rainfall.runoff(rain[[run]]@magnitude[,sel.rain],
                                     q.model.sel, 
                                     q.measured.sel,
                                     main=paste("Station:", station, "Run:", run),
                                     q.units=q.units,
                                     p.units=rain[[run]]@units
                                     )
                        }
                    }
                }
            }
            if("by.data.type" %in% hydro.plot.type){
                 applyToHydroTS(x,
                       FUN=function(hydroTS){
                            if(hydroTS@type %in% data.types){
                                 run <- get("run", envir=parent.frame())
                                 select <- hydroTS@location.name %in% stations
                                 plot(hydroTS@magnitude[,select], main=paste(hydroTS@type, "Run:", run), ylab=hydroTS@type, ...)
                            }
                            return(c())
                       },
                       data.class=data.class,
                       runs=runs)
            }
            if("by.station" %in% hydro.plot.type){
              for(the.station in stations){
                allTS <- get.HydroTS(x, stations=the.station, 
                                     data.class=data.class, 
                                     data.types=data.types,
                                     runs=runs)
                #Rearrange zoo objects
                new.zoos <- list()
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
                       legend(legend.position, col.names[[unit]],col=1:length(col.names[[unit]]), lty=1)
                   } else {
                       plot(new.zoos[[unit]], plot.type="single", ylab=unit, col=1:length(col.names[[unit]]),main=paste(col.names[[unit]], "at", the.station),...)
                   }
                }
              }
            }
            if("balance" %in% hydro.plot.type){
                #loop through balance types
                for(class in c("measured", "modelled")){
                        d.class <- paste(class,"Fluxes", sep="")
                        to.ret[[class]] <- list()
                    for(balance.type in balance.types){
                        #what data.types occur in this balance?
                        to.ret[[class]][[balance.type]] <- list()
                        balance.type.list <- getBalanceTypes.rhydro.data.types()
                        balance.type.hit <- sapply(balance.type.list, FUN <- function(x){ any(balance.type %in% x)})
                        #extract colors
                        b.data.types <- rhydro.data.types$data.type[balance.type.hit]
                        b.type.color <- getBalanceColor.rhydro.data.types(data.type = b.data.types, balance.type=balance.type)
                        if(identical(stations,get.stations(x, data.class=data.class))){
                             stations=get.stations(x, data.class=d.class,  data.types=b.data.types)
                        }
                        #loop through runs and stations
                        for(run in runs){
                           to.ret[[class]][[balance.type]][[run]] <- list()
                           summary.data.state <- data.frame(name=c(), change=c())
                           for(station in stations){
                                #calc plot range
                                rangeTS <- get.HydroTS(x,
                                         data.types=b.data.types,
                                         station=station,
                                         runs=run)
                                if(!is.null(rangeTS)){
                                    #first determine common x-range
                                    x.range.list <- lapply(rangeTS, FUN=function(x){range(index(x@magnitude), na.rm=TRUE)})
                                    the.min <- x.range.list[[1]][1]
                                    the.max <- x.range.list[[1]][2]
                                    for(listEntry in 2:length(x.range.list)){
                                        if(the.min <x.range.list[[listEntry]][1])
                                            the.min <- x.range.list[[listEntry]][1]
                                        if(the.max >x.range.list[[listEntry]][2])
                                            the.min <- x.range.list[[listEntry]][2]
                                    }
                                    x.range <- c(the.min,the.max)
                                    #calculate y range for correct x-range
                                    rangeTSa <- get.HydroTS(x,
                                         data.class=c("measuredFluxes","modelledFluxes"),
                                         data.types=b.data.types,
                                         station=station,
                                         runs=run, x.range=x.range)
                                    
                                    y.range <- NULL
                                    if(!is.null(rangeTSa)){
                                    y.range <- c(0,
                                       max(sapply(rangeTSa, FUN=function(x){sum(x@magnitude, na.rm=TRUE)}))
                                       )
                                    }
                                    rangeTSa <- get.HydroTS(x,
                                         data.class=c("measuredStates","modelledStates"),
                                         data.types=b.data.types,
                                         station=station,
                                         runs=run, x.range=x.range)
                                    if(!is.null(rangeTSa)){
                                        state.max <- max(sapply(rangeTSa,FUN=function(x){max(x@magnitude,na.rm=TRUE)}))
                                        state.min <- min(sapply(rangeTSa,FUN=function(x){min(x@magnitude,na.rm=TRUE)}))
                                        if(is.null(y.range)){
                                            y.range <- c(state.min,state.max)
                                        } else {
                                            if(state.max > y.range[2])
                                                 y.range[2] <- state.max
                                            if(state.min < y.range[1])
                                                 y.range[1] <- state.min
                                        }
                                    }
                                    if(is.null(y.range)) stop(paste("no data to plot for run", run,"station",station, "balance.type", balance.type))
                                    plot(x.range,y.range, type="n", xlab="time", ylab= rangeTS[[1]]@units, main=paste(balance.type," (",class, ") at station ", station, " for run ", run, sep=""))
                                }
                                #get flux data
                                d.class <- paste(class,"Fluxes", sep="")
                                allTS <- get.HydroTS(x, data.class=d.class,
                                     data.types=b.data.types,
                                     station=station,
                                     runs=run, x.range=x.range)
                                summary.data.flux <- matrix(nrow=length(allTS), ncol=3) 
                                dimnames(summary.data.flux)[[2]] <- c("name","change","direction")
                                
                                ts.nr <- 1

                                for(ts in allTS){
                                    #build sums for flux data
                                    if(NCOL(ts@magnitude)==0){
                                       warning(paste("No data available for station",station,"run",run," and data type", ts@type))
                                    } else {
                                       nas <- is.na(ts@magnitude)
                                       if(any(nas)){
                                           warning(paste("setting NA data to 0 while calculating cumulative sum for station",station,"run",run," and data type", ts@type))
                                           ts@magnitude[nas] <- 0

                                       }
                                       the.sum <- cumsum(ts@magnitude)
                                       the.sum[nas] <- NA
                                        #plot flux data by station and run
                                        col <- b.type.color[ts@type == b.data.types]
                                        lines(index(ts@magnitude), the.sum, col=col)
                                        summary.data.flux[ts.nr,] <- c(ts@type, max(the.sum, na.rm=TRUE), ts@direction)
                                        ts.nr <- ts.nr + 1
                                        #store total flux change (end sum) (with direction)
                                    }
                                }
                                
                                #get state data
                                d.class <- paste(class,"States", sep="")
                                allTS <- get.HydroTS(x, data.class=d.class,
                                     data.types=b.data.types,
                                     station=station,
                                     runs=run, x.range=x.range)
                                
                                summary.data.state <- matrix(nrow=length(allTS), ncol=2) 
                                dimnames(summary.data.state)[[2]] <- c("name","change")
                                ts.nr <- 1
                                for(ts in allTS){
                                    #build changes for state data
                                    if(NCOL(ts@magnitude)==0){
                                       warning(paste("No data available for station",station,"run",run," and data type", ts@type))
                                    } else {
                                        #plot state data (on different axis?)
                                        col <- b.type.color[ts@type == b.data.types]
                                        lines(index(ts@magnitude), ts@magnitude, col=col)
                                        change <- as.numeric(ts@magnitude[length(ts@magnitude)]) - as.numeric(ts@magnitude[1])
                                        #store total state change
                                        summary.data.state[ts.nr,] <-  c(ts@type, change)
                                        ts.nr <- ts.nr + 1
                                    }
                                }
                               #create list with summary data
                               to.ret[[class]][[balance.type]][[run]][[station]]  <- list(flux=summary.data.flux, state=summary.data.state)
                               legend.entries <- c(summary.data.flux[,1], summary.data.state[,1])
                               legend.entries <- legend.entries[!is.na(legend.entries)]
                               legend.col <- sapply(legend.entries, FUN=function(x){b.type.color[x==b.data.types]})
                               if(length(legend.entries >0)){
                                   legend("topleft", cex=0.5, legend.entries, col=legend.col, lty=1, inset=0.05) 
                               }
                           }
                       }
                    }
                }

            }
 
            #par(oldpar)
            return(to.ret)

    }
)

