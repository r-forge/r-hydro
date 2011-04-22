
## This is a class that is very close to HydroRun
## but includes everything to run the model, such that generic
## functions such as simulate() become easy to implement
## This class is similar to the hydromad object of the eponymous package


setOldClass("xts")

validityRHydro <- function(object) {return()}

setClass("RHydro",
         representation = representation(parameters="HydroModelParameters",
                                         data = "xts",
                                         simulations = "list",
                                         metadata = "data.frame",
                                         performance = "data.frame",
                                         model = "character",
                                         dots = "list"),
         validity =  validityRHydro,
         prototype = prototype(parameters = new("HydroModelParameters"),
                               data = xts(),
                               simulations = list(),
                               metadata = data.frame(),
                               performance = data.frame(),
                               model = character()
         )    
)

setMethod("predict",
          signature(object = "RHydro"),
          function (object, ...) 
          {
            sims <- do.call(object@model, c(list(object@parameters, object@data),
                        model@dots), ...)
          }
)

## methods to implement: merge,

setMethod("print",
    signature(x = "RHydro"),
    function (x, ...) 
    {
      ##cat("Model ID: ",x@parameters@modelID,"\n")
      cat("\n")
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
)

setMethod("summary",
    signature(object = "RHydro"),
    function (object, ...) 
    {
      print(object, ...)
    }
)

setMethod("show",
    signature(object = "RHydro"),
    function (object) 
    {
      print(object)
    }
)



