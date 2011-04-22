
## This is a class that is very close to HydroRun
## but includes everything to run the model, such that generic
## functions such as simulate() become easy to implement
## This class is similar to the hydromad object of the eponymous package


setOldClass("xts")

validityRHydro <- function(object) {return()}

setClass("HydroModel",
         representation = representation(parameters="HydroModelParameters",
                                         data = "xts",
                                         simulations = "list",
                                         metadata = "data.frame",
                                         performance = "list",
                                         model = "character",
                                         dots = "list"),
         validity =  validityRHydro,
         prototype = prototype(parameters = new("HydroModelParameters"),
                               data = xts(),
                               simulations = list(),
                               metadata = data.frame(),
                               performance = list(),
                               model = character()
         )    
)

## methods to implement: 

## see predict.lm for arguments that need to be implemented.
## TODO: - weights
##       - select variable

setMethod("predict",
          signature(object = "HydroModel"),
          function (object, newdata = NULL, all = FALSE, probs = c(0.05,0.95))
          {
            ## perhaps convert next line to update() call?
            if(!is.null(newdata)) object@data <- try.xts(newdata)
            ## figure out whether we need to run the model again:
            if(!is.null(newdata) | (length(object@simulations) == 0)) {
              sim <- do.call(object@model,
                             c(list(object@parameters, object@data), model@dots))
              object@simulations <- sim
            }
            
            if(all) return(object@simulations)
            ret <- list()
            for(var in names(object@simulations)) {
              if(is.null(dim(object@simulations[[var]]))) {
                ret[[var]] <- object@simulations[[var]]
              } else { quants <-  apply(object@simulations[[var]],1,
                                        "quantile", probs = probs, drop=F)
                       if(!is.null(dim(quants))) quants <- t(quants)
                       ret[[var]] <- xts(quants,
                                         order.by = index(object@simulations[[var]]))
                     }
            }
            return(ret)
          }
)



## this formulation works for S3 generics:

print.HydroModel <- function (x, ...) {
  ##cat("Model ID: ",x@parameters@modelID,"\n")
  cat("Model: ", x@model, "\n")
  cat("Number of model runs: ", nrow(x@parameters@parameters),"\n")
  cat("Number of parameters: ", ncol(x@parameters@parameters),"\n")
  cat("Parameter names: ", names(x@parameters),"\n")
  cat("\n")
  cat("Data: ", names(x@data) ,"\n")
  cat("Simulations: ", names(x@simulations),"\n")
  cat("\n")
  cat("Calculated performance measures: ", names(x@performance),"\n")
}

setMethod("summary", "HydroModel", function(object) print.HydroModel(object))
setMethod("show", "HydroModel", function(object) print.HydroModel(object))


