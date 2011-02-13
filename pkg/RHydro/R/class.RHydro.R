
## This is a class that is very close to HydroRun
## but includes everything to run the model, such that generic
## functions such as simulate() become easy
## This class is similar to the hydromad object of the eponymous package
## 

setOldClass("xts")

validityRHydro <- function(object) {return()}

setClass("RHydro",
         representation = representation(parameters="HydroModelParameters",
                                         observations = "list",
                                         simulations = "list",
                                         metadata = "data.frame",
                                         performance = "data.frame",
                                         supportdata="list",
                                         model = "character"),
         validity =  validityRHydro,
         prototype = prototype(parameters = new("HydroModelParameters"),
                               observations = list(),
                               simulations = list(),
                               metadata = data.frame(),
                               performance = data.frame(),
                               supportdata = list(),
                               model = character()
         )    
)

setMethod("simulate",
          signature(object = "RHydro"),
          function (object) 
          {
	    stop("ToDo: Not implemented")
          }
)
