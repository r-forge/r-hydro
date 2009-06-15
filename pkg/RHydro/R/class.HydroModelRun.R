setClass("HydroModelRun",
	representation = representation(parameters="list",
                                modelledFluxes="list",
				modelledStates="list",
				measuredFluxes="list",
				measuredStates="list",
				performanceMeasures="data.frame",
				modelSupportData="list",
				call="character"),
       validity =  function(object){
         toRet <- c()
         #Check for 'all' element which is shared data for all runs
         #ToDo use slot(object, theData.class) e.g. get.data.types
         has.all.measuredStates <- !is.null(object@measuredStates[["all"]])
         has.all.modelledStates <- !is.null(object@modelledStates[["all"]])
         has.all.measuredFluxes <- !is.null(object@measuredFluxes[["all"]])
         has.all.modelledFluxes <- !is.null(object@modelledFluxes[["all"]])
              
         #Check for same number of runs
         if(length(object@measuredStates) - has.all.measuredStates!= length(object@measuredFluxes)  - has.all.measuredFluxes||
            length(object@measuredStates)  - has.all.measuredStates!= length(object@modelledFluxes)  - has.all.modelledFluxes||
            length(object@measuredStates)  - has.all.measuredStates!= length(object@parameters) ||
            length(object@measuredStates)  - has.all.measuredStates!= length(object@modelledStates) - has.all.modelledStates)
            toRet <- "The slots 'measuredStates, measuredFluxes, modelledFluxes, modelledStates, and parameters' need the same number of entries. 'parameters' has one entry less if the other slots include an 'all' entry in the list."
         
         #Check for data types in slots
         if(any(sapply(object@measuredStates, FUN=function(x){sapply(x,class)})!="HydroState"))
            toRet <- c(toRet, "Slot 'measuredStates' must be a list of lists of HydroStates-Objects") 
         if(any(sapply(object@modelledStates, FUN=function(x){sapply(x,class)})!="HydroState"))
            toRet <- c(toRet, "Slot 'modelledStates' must be a list of lists of HydroStates-Objects") 
         if(any(sapply(object@measuredFluxes, FUN=function(x){sapply(x,class)})!="HydroFlux"))
            toRet <- c(toRet, "Slot 'measuredFluxes' must be a list of lists of HydroFlux-Objects") 
         if(any(sapply(object@modelledFluxes, FUN=function(x){sapply(x,class)})!="HydroFlux"))
            toRet <- c(toRet, "Slot 'modelledFluxes' must be a list of lists of HydroFlux-Objects") 
         if(any(sapply(object@parameters, class)!="HydroWasimParameters"))
            toRet <- c(toRet, "Slot 'parameters' must be a list HydroWasimParameters-Objects") 
    }
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
              plot.type=c("rainfall-runoff", "by.data.type", "by.station", "balance"),
              data.class=c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"),
              data.types=get.data.types(x, data.class=data.class),
              stations=get.stations(x, data.class=data.class),
              legend.position="right",
              runs=1:get.runCount(x),
              ...) 
    {
        plot.type <- match.arg(plot.type, several.ok=TRUE)
        data.class <- match.arg(data.class, several.ok=TRUE)
        for(run in runs){
            #oldpar <- par(ask=TRUE)
            if("rainfall-runoff" %in% plot.type){
                warning("Need a definition for the rainfall-runoff method here")
            }
            if("by.data.type" %in% plot.type){
                for(theData.class in data.class){
                    theList <- slot(object, theData.class)[[run]]
                    for(hydroTS in theList){
                        if(!is.null(hydroTS)){
                            if(hydroTS@type %in% data.types){
                                 select <- dimnames(hydroTS@magnitude)[[2]] %in% stations
                                 plot(hydroTS[,select], main=hydroTS@type,...)
                            }
                        }
                    }
                }
            }
            if("by.station" %in% plot.type){
              for(the.station in stations){
                new.zoos <- NULL
                col.names <- list()
                for(theData.class in data.class){
                    theList <- slot(object, theData.class)[[run]]
                    for(hydroTS in theList){
                        if(!is.null(hydroTS)){
                            if(hydroTS@type %in% data.types){
                                 select <- dimnames(hydroTS@magnitude)[[2]] %in% the.station
                                 if(any(select)){
                                     if(is.null(new.zoos[[hydroTS@units]])){
                                          new.zoos[[hydroTS@units]] <-  hydroTS@magnitude[,select]
                                          col.names[[hydroTS@units]] <- hydroTS@type
                                     } else {
                                          new.zoos[[hydroTS@units]] <- merge(new.zoos[[hydroTS@units]], hydroTS@magnitude[,select])
                                          col.names[[hydroTS@units]] <- c(col.names[[hydroTS@units]],hydroTS@type)
                                     }
                                 }
                            }
                        }
                    }
                }
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
            if("balance" %in% plot.type){
                warning("Need a definition for the balance method here")
            }
            #par(oldpar)

        }
    }
)

