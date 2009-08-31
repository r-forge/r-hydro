
## new class structure HydroRun
## to replace HydroModelRun
##
## some suggested conventions:
##
## - GIS is a list that consists of different spatial data (point, line, polygon, grid)
##   but we need to figure out how we structure it
##
## - for now everything is kept in one zoo object but we may have to experiment with that
##
## - we need to think about the structure of the metadata.
##   See current structure in prototype as a suggestion

setClass("HydroRun",
         representation = representation(parameters="HydroModelParameters",
                                         ts = "zoo",
                                         metadata = "data.frame",
                                         GIS = "list",
                                         performanceMeasures="data.frame",
                                         modelSupportData="list",
                                         call="call"),
 ##        validity =  validityHydroRun,
         prototype = prototype(parameters = new("HydroModelParameters"),
                               ts = zoo(),
                               metadata = data.frame(ID = numeric(),
                                                     GIS_ID = numeric(),
                                                     type = factor(levels=c("flux","state")),
                                                     name = factor(),
                                                     flux = numeric(),
                                                     origin = factor(levels=c("simulated","measured")),
                                                     dimensions = character()),
                               GIS = list(),
                               performanceMeasures=data.frame(),
                               modelSupportData = list(),
                               call = new("call")
         )    
)

setMethod("print",
    signature(x = "HydroRun"),
    function (x, ...) 
    {
      cat("Model ID: ",x@parameters@modelID,"\n")
      cat("\n")
      cat("Number of model runs: ", max(metadata$run),"\n")
      cat("Number of parameters: ", dim(x@parameters@parameters)[2],"\n")
      cat("Parameter names: ", names(x@parameters),"\n")
      cat("\n")
      cat("Modelled fluxes: ", unique(x@metadata$names[x@metadata$origin == "simulated" && x@metadata$type == "flux"],"\n"))
      cat("Modelled states: ", unique(x@metadata$names[x@metadata$origin == "simulated" && x@metadata$type == "state"],"\n"))
      cat("Measured fluxes: ", unique(x@metadata$names[x@metadata$origin == "measured" && x@metadata$type == "flux"],"\n"))
      cat("Measured states: ", unique(x@metadata$names[x@metadata$origin == "measured" && x@metadata$type == "state"],"\n"))
      cat("\n")
      cat("Calculated performance measures: ", names(x@performanceMeasures),"\n")
      cat("Model Support Data: ", names(x@modelSupportData),"\n")
      cat("Call: ")
      print(x@call)
    }
)

setMethod("summary",
    signature(object = "HydroRun"),
    function (object, ...) 
    {
      print(object, ...)
    }
)

setMethod("show",
    signature(object = "HydroRun"),
    function (object) 
    {
      print(object)
    }
)

"$.HydroRun" <- function(object, name = c("Qsim","Qobs","pm","performance")) {
  subset <- match.arg(name)
  if(subset == "pm" || subset == "performance") return(object@performanceMeasures)
  if(subset == "Qsim") return(object@ts[,object@metadata$origin == "simulated" && object@metadata$name == "discharge"])
  if(subset == "Qobs") return(object@ts[,object@metadata$origin == "measured" && object@metadata$name == "discharge"])
}


