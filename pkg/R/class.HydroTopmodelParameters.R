
setClass("HydroTopmodelParameters",
         contains = "HydroModelParameters",
         prototype = prototype(parameters = data.frame(Q0 = double(0),
                                                       lnTe = double(0),
                                                       m = double(0),
                                                       D0 = double(0),
                                                       Dmax = double(0),
                                                       td = double(0),
                                                       v = double(0),
                                                       Ks = double(0),
                                                       CD = double(0),
                                                       dt = double(0)),
                               modelID = "Topmodel"),
         validity = function(object) {
           ## check that number of parameters is correct
           if(dim(object)[2] !=10)
             return("Incorrect number of parameters")
           ## check for negative initial subsurface flow
           if(length(object@parameters[,"Q0"] < 0) > 0)
             return("Initial subsurface flow should not be negative")
           ## check for negative or extremely low streamflow velocity
           if(length(object@parameters[,"v"] < 50) > 0)
             return("Stream flow velocity should not be negative")
           return(TRUE)
         }
         )

setAs("numeric", "HydroTopmodelParameters",
      function(from) {
        from <- as(from,"HydroModelParameters")
        from <- new(from,"HydroTopmodelParameters")
        from@modelID <- "Topmodel"
        colnames(from@parameters) <- c("Q0","lnTe","m","D0","Dmax","td","v","Ks","CD","dt")
      }
      )

setAs("matrix", "HydroTopmodelParameters",
      function(from) {
        from <- as(from,"HydroModelParameters")
        from <- new(from,"HydroTopmodelParameters")
        from@modelID <- "Topmodel"
        colnames(from@parameters) <- c("Q0","lnTe","m","D0","Dmax","td","v","Ks","CD","dt")
      }
      )

setAs("HydroModelParameters", "HydroTopmodelParameters",
      function(from) {
        from <- new(from,"HydroTopmodelParameters")
        from@modelID <- "Topmodel"
        colnames(from@parameters) <- c("Q0","lnTe","m","D0","Dmax","td","v","Ks","CD","dt")
      }
      )

setAs("HydroModelParameters", "data.frame", function(from) from@parameters)
setAs("HydroModelParameters", "matrix", function(from) as.matrix(from@parameters))

setMethod("print",
          signature(x = "HydroTopmodelParameters"),
          function(x, ...) {
            cat("Initial subsurface flow\n")
            summary(x@parameters[1,])
            cat("log of the areal average of saturated transmissivity\n")
            summary(x@parameters[2,])
            cat("m\n")
            summary(x@parameters[3,])
            cat("Initial root zone storage deficit\n")
            summary(x@parameters[4,])
            cat("Maximum root zone storage deficit\n")
            summary(x@parameters[5,])
            cat("Unsaturated zone time delay\n")
            summary(x@parameters[6,])
            cat("channel flow\n")
            summary(x@parameters[7,])
            cat("Surface hydraulic conductivity\n")
            summary(x@parameters[8,])
            cat("capillary drive\n")
            summary(x@parameters[9,])
            cat("time step\n")
            summary(x@parameters[10,])
            invisible(x)
          }
)

setMethod("show",
          signature(object = "HydroTopmodelParameters"),
          function(object) print(object)
)

setMethod("plot",
          signature(x = "HydroTopmodelParameters"),
          function(x,y, ...) plot(x@parameters, ...)
)
