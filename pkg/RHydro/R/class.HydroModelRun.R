setClass("HydroModelRun",
	representation = representation(parameters="HydroModelParameters",
                                modelledFluxes="list",
				modelledStates="list",
				measuredFluxes="list",
				measuredStates="list",
				performanceMeasures="data.frame",
				modelSupportData="list",
				call="character")
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
      cat("Modelled fluxes: ", names(x@modelledFluxes),"\n")
      cat("Modelled states: ", names(x@modelledStates),"\n")
      cat("Measured Fluxes: ", names(x@measuredFluxes),"\n")
      cat("Measured States: ", names(x@measuredStates),"\n")
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


setMethod("plot",
    signature(x = "HydroModelRun"),
    function (x, y, 
              plot.type=c("rainfall-runoff", "by.data.type", "by.station", "balance"),
              data.class=c("modelledFluxes", "modelledStates", "measuredFluxes", "measuredStates"),
              the.data.types=data.types(x, data.class=data.class),
              the.stations=stations(x, data.class=data.class),
              legend.position="right",
              ...) 
    {
        plot.type <- match.arg(plot.type, several.ok=TRUE)
        data.class <- match.arg(data.class, several.ok=TRUE)
        #oldpar <- par(ask=TRUE)
        if("rainfall-runoff" %in% plot.type){
            warning("Need a definition for the rainfall-runoff method here")
        }
        if("by.data.type" %in% plot.type){
            for(theData.class in data.class){
                theList <- slot(object, theData.class)
                for(hydroTS in theList){
                    if(!is.null(hydroTS)){
                        if(hydroTS@type %in% the.data.types){
                             select <- dimnames(hydroTS@magnitude)[[2]] %in% the.stations
                             plot(hydroTS[,select], main=hydroTS@type,...)
                        }
                    }
                }
            }
        }
        if("by.station" %in% plot.type){
          for(the.station in the.stations){
            new.zoos <- NULL
            col.names <- list()
            for(theData.class in data.class){
                theList <- slot(object, theData.class)
                for(hydroTS in theList){
                    if(!is.null(hydroTS)){
                        if(hydroTS@type %in% the.data.types){
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
)

