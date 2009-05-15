
setClass("HydroModelParameters",
         representation(parameters= "data.frame",
                        modelID = "character"),
         prototype = prototype(parameters = data.frame(),
                               modelID = character())
         )

setAs("data.frame", "HydroModelParameters",
      function(from) new("HydroModelParameters", parameters <- from))

setAs("matrix", "HydroModelParameters",
      function(from) new("HydroModelParameters", parameters <- as.data.frame(from)))

setAs("numeric", "HydroModelParameters",
      function(from) new("HydroModelParameters",
                         parameters = as.data.frame(t(from))))

setAs("HydroModelParameters", "data.frame", function(from) from@parameters)
setAs("HydroModelParameters", "matrix", function(from) as.matrix(from@parameters))

print.HydroModelParameters <- function(x) {
  print(cat("Model: ",x@modelID))
  print(summary(x@parameters))
  invisible(x)
}


setMethod("show", "HydroModelParameters", function(object) print.HydroModelParameters(object))


